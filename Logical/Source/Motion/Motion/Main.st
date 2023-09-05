//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT
	//Primary axis (Mixer1) init
	MpAxisBasic_Primary.Enable := TRUE;
	MpAxisBasic_Primary.MpLink := ADR(gMixer_1);
	MpAxisBasic_Primary.Parameters := ADR(MpAxisBasicParameters_Primary);
	MpAxisBasic_Primary.Simulate := TRUE;
	MpAxisBasic_Primary();
	//Secondary axis (Mixer2) init
	MpAxisBasic_Secondary.Enable := TRUE;
	MpAxisBasic_Secondary.MpLink := ADR(gMixer_2);
	MpAxisBasic_Secondary.Parameters := ADR(MpAxisBasicParameters_Secondary);
	MpAxisBasic_Secondary.Simulate := TRUE;
	MpAxisBasic_Secondary();
	//Axis coupling init
	MpAxisCoupling_0.Enable := TRUE;
	MpAxisCoupling_0.MpLink := ADR(gMixer_2);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_1);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
END_PROGRAM

PROGRAM _CYCLIC
	
	MpAxisBasic_Primary.MpLink := ADR(gMixer_1);
	MpAxisBasic_Primary.Parameters := ADR(MpAxisBasicParameters_Primary);
	MpAxisBasic_Primary();
	
	MpAxisBasic_Secondary.MpLink := ADR(gMixer_2);
	MpAxisBasic_Secondary.Parameters := ADR(MpAxisBasicParameters_Secondary);
	MpAxisBasic_Secondary();
	
	MpAxisCoupling_0.MpLink := ADR(gMixer_2);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_1);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
	
	//Mixer 1,2 status update
	gTanks.Status.IsMixer1On := BOOL_TO_UINT(MpAxisBasic_Primary.MoveActive);
	gTanks.Status.IsMixer2On := BOOL_TO_UINT(MpAxisBasic_Secondary.MoveActive);
	
	//Assigning slave axis parameters to coupling parameters
	MpAxisCouplingParameters.Gear.Acceleration := MpAxisBasicParameters_Secondary.Acceleration;
	MpAxisCouplingParameters.Gear.Deceleration := MpAxisBasicParameters_Secondary.Deceleration;
	
	//Assigning deceleration from axis parameters to stop deceleration
	MpAxisBasicParameters_Secondary.Stop.Deceleration := MpAxisBasicParameters_Secondary.Deceleration;
	MpAxisBasicParameters_Primary.Stop.Deceleration := MpAxisBasicParameters_Primary.Deceleration;
	
	//Power_on negative edge detection
	F_TRIG_0(CLK:=MpAxisBasic_Primary.PowerOn);
	F_TRIG_1(CLK:=MpAxisBasic_Secondary.PowerOn);
	
	//Resetting update commands
	IF MpAxisCoupling_0.UpdateDone THEN
		MpAxisCoupling_0.Update := FALSE;
	END_IF;
	IF MpAxisBasic_Primary.UpdateDone THEN
		MpAxisBasic_Primary.Update := FALSE;
	END_IF
	IF MpAxisBasic_Secondary.UpdateDone THEN
		MpAxisBasic_Secondary.Update := FALSE;
	END_IF
	//E-STOP
	IF NOT gDriveStop THEN
		MpAxisBasic_Primary.Power := FALSE;
		MpAxisBasic_Secondary.Power := FALSE;
		gTanks.Commands.TurnOnMixer1 := FALSE;
		gTanks.Commands.TurnOnMixer2 := FALSE;
		StepMixer1 := STEP_INIT;
		StepMixer2 := STEP_INIT;
		Manual := FALSE;
	END_IF;
	IF NOT Manual THEN
		//Primary axis (Mixer1) state machine
		CASE StepMixer1 OF
			STEP_INIT:
				MpAxisBasic_Primary.Power := FALSE;
				MpAxisBasic_Primary.MoveAdditive := FALSE;
				MpAxisBasic_Primary.MoveAbsolute := FALSE;
				MpAxisBasic_Primary.MoveVelocity := FALSE;
				IF gTanks.Commands.TurnOnMixer1 THEN
					StepMixer1 := STEP_POWER_ON;
				END_IF
				
			STEP_POWER_ON:
				MpAxisBasic_Primary.Power := TRUE;
				IF MpAxisBasic_Primary.PowerOn THEN
					StepMixer1 := STEP_MOVE_VELOCITY;
				END_IF;
				
			STEP_MOVE_VELOCITY:
				MpAxisBasic_Primary.MoveVelocity := TRUE;
				IF MpAxisBasic_Primary.InVelocity THEN
					StepMixer1 := STEP_RUNNING;
				END_IF;
				
			STEP_RUNNING:
				IF NOT gTanks.Commands.TurnOnMixer1 THEN
					StepMixer1 := STEP_POWER_OFF;
				END_IF;
				
			STEP_POWER_OFF:
				MpAxisBasic_Primary.MoveVelocity := FALSE;
				IF NOT MpAxisBasic_Primary.MoveActive THEN
					MpAxisBasic_Primary.Power := FALSE;
				END_IF;
				IF NOT MpAxisBasic_Primary.PowerOn THEN
					StepMixer1:= STEP_INIT;
				END_IF;
		END_CASE;
		//Secondary axis (Mixer2) state machine
		CASE StepMixer2 OF
			STEP_INIT:
				MpAxisBasic_Secondary.Power := FALSE;
				MpAxisBasic_Secondary.MoveVelocity := FALSE;
				MpAxisBasic_Secondary.MoveAbsolute := FALSE;
				MpAxisBasic_Secondary.MoveAdditive := FALSE;
				IF gTanks.Commands.TurnOnMixer2 THEN
					StepMixer2 := STEP_POWER_ON;
				END_IF
				
			STEP_POWER_ON:
				MpAxisBasic_Secondary.Power := TRUE;
				IF MpAxisBasic_Secondary.PowerOn THEN
					StepMixer2 := STEP_MOVE_VELOCITY;
				END_IF;
				
			STEP_MOVE_VELOCITY:
				MpAxisBasic_Secondary.MoveVelocity := TRUE;
				//Stopping slave axis for cam coupling
				IF CamCoupling THEN
					MpAxisBasic_Primary.MoveVelocity := FALSE;
				END_IF;
				IF MpAxisBasic_Secondary.InVelocity THEN
					StepMixer2 := STEP_RUNNING;
				END_IF;
				
			STEP_RUNNING:
				IF NOT gTanks.Commands.TurnOnMixer2 THEN
					StepMixer2 := STEP_POWER_OFF;
				END_IF;
				
			STEP_POWER_OFF:
				MpAxisBasic_Secondary.MoveVelocity := FALSE;
				IF NOT MpAxisBasic_Secondary.MoveActive THEN
					MpAxisBasic_Secondary.Power := FALSE;
				END_IF;
				IF NOT MpAxisBasic_Secondary.PowerOn THEN
					StepMixer2:= STEP_INIT;
				END_IF;
		END_CASE;
	END_IF
	//Resetting commands after stop or power off
	IF MpAxisBasic_Secondary.Stopped OR F_TRIG_1.Q THEN
		MpAxisBasic_Secondary.Stop := FALSE;
		MpAxisBasic_Secondary.MoveVelocity := FALSE;
		MpAxisBasic_Secondary.MoveAbsolute := FALSE;
		MpAxisBasic_Secondary.MoveAdditive := FALSE;
	END_IF
	IF MpAxisBasic_Primary.Stopped OR F_TRIG_0.Q THEN
		MpAxisBasic_Primary.Stop := FALSE;
		MpAxisBasic_Primary.MoveAdditive := FALSE;
		MpAxisBasic_Primary.MoveAbsolute := FALSE;
		MpAxisBasic_Primary.MoveVelocity := FALSE;
	END_IF;
	//Manual mode 
	IF Manual THEN
		StepMixer1 := STEP_INIT;
		StepMixer2 := STEP_INIT;
		gTanks.Commands.TurnOnMixer1 := FALSE;
		gTanks.Commands.TurnOnMixer2 := FALSE;
		//Manual mode MixerPrimary
		IF MpAxisBasic_Primary.InPosition THEN
			MpAxisBasic_Primary.MoveAdditive := FALSE;
			MpAxisBasic_Primary.MoveAbsolute := FALSE;
			MpAxisBasic_Primary.MoveVelocity := FALSE;
		END_IF
		IF NOT MpAxisBasic_Primary.Error THEN
			MpAxisBasic_Primary.ErrorReset := FALSE;
		END_IF;
		
		//Manual mode MixerSecondary
		IF MpAxisBasic_Secondary.InPosition THEN
			MpAxisBasic_Secondary.MoveAdditive := FALSE;
			MpAxisBasic_Secondary.MoveAbsolute := FALSE;
			MpAxisBasic_Secondary.MoveVelocity := FALSE;
		END_IF;
		//Resetting commands after stop or power off
		IF NOT MpAxisBasic_Secondary.Error THEN
			MpAxisBasic_Secondary.ErrorReset := FALSE;
		END_IF;
	END_IF
	
	//Selected Coupling Mode case
	CASE CouplingMode OF
		NO_COUPLING:
			//Gear coupling condition
			IF GearCoupling AND MpAxisBasic_Secondary.PowerOn THEN
				MpAxisCoupling_0.Gear := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingMode := GEAR_COUPLING;
					MpAxisBasic_Secondary.MoveVelocity := FALSE;
				END_IF;
				//Option to disable gear coupling before InSync status
			IF NOT MpAxisCoupling_0.InSync AND NOT GearCoupling THEN
					MpAxisCoupling_0.Gear := FALSE;
			END_IF;	
			//Cam coupling condition
			ELSIF CamCoupling AND MpAxisBasic_Secondary.PowerOn THEN
				//Stopping slave axis before coupling
				IF MpAxisBasic_Secondary.MoveActive THEN
					MpAxisBasic_Secondary.MoveVelocity := FALSE;
					MpAxisBasic_Secondary.MoveAbsolute := FALSE;
					MpAxisBasic_Secondary.MoveAdditive := FALSE;
				ELSE
					MpAxisCoupling_0.Cam := TRUE;
				END_IF
			END_IF
			//Checking if secondary axis is in sync and moving
			IF MpAxisCoupling_0.InSync AND MpAxisCoupling_0.Cam AND MpAxisBasic_Secondary.MoveActive THEN
				CouplingMode := CAM_COUPLING;
			END_IF
			//Option to disable cam coupling before in sync status
			IF NOT MpAxisCoupling_0.InSync AND NOT CamCoupling THEN
				MpAxisCoupling_0.Cam := FALSE;
			END_IF;	
		GEAR_COUPLING:
			IF NOT GearCoupling THEN
				MpAxisCoupling_0.Gear := FALSE;
				IF NOT MpAxisCoupling_0.InSync THEN
					gTanks.Commands.TurnOnMixer2 := FALSE;
					CouplingMode := NO_COUPLING;
				END_IF
			END_IF;
			
		CAM_COUPLING:
			IF NOT CamCoupling THEN
				MpAxisCoupling_0.Cam := FALSE;
				IF Manual AND MpAxisCoupling_0.InSync THEN
					MpAxisBasic_Secondary.Stop := TRUE;
				END_IF
				IF NOT MpAxisCoupling_0.InSync THEN
					gTanks.Commands.TurnOnMixer2 := FALSE;
					CouplingMode := NO_COUPLING;
				END_IF
			END_IF
	END_CASE;		
		
END_PROGRAM

PROGRAM _EXIT
	MpAxisBasic_Primary.Enable := FALSE;
	MpAxisBasic_Primary();
	
	MpAxisBasic_Secondary.Enable := FALSE;
	MpAxisBasic_Secondary();
	
	MpAxisCoupling_0.Enable := FALSE; 
	MpAxisCoupling_0();
END_PROGRAM