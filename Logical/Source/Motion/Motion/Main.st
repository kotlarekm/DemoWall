//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT
	// Primary axis (Mixer1) init
	MpAxisBasic_Primary.Enable := TRUE;
	MpAxisBasic_Primary.MpLink := ADR(gMixer_1);
	MpAxisBasic_Primary.Parameters := ADR(MpAxisBasicParameters_Primary);
	MpAxisBasic_Primary();
	// Secondary axis (Mixer2) init
	MpAxisBasic_Secondary.Enable := TRUE;
	MpAxisBasic_Secondary.MpLink := ADR(gMixer_2);
	MpAxisBasic_Secondary.Parameters := ADR(MpAxisBasicParameters_Secondary);
	MpAxisBasic_Secondary();
	// MpAxisBasic_P3
	MpAxisBasic_P3.Enable := TRUE;
	MpAxisBasic_P3.MpLink := ADR(gAxis_P3);
	MpAxisBasic_P3.Parameters := ADR(MpAxisBasicParameters_P3);
	MpAxisBasic_P3();
	// Axis coupling init
	MpAxisCoupling_0.Enable := TRUE;
	MpAxisCoupling_0.MpLink := ADR(gMixer_2);
	MpAxisCoupling_0.MpLinkMaster := ADR(gAxis_P3);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
	//
	MC_ReadStatus_0.Enable := TRUE;
	MC_ReadStatus_0.Axis := ADR(gMixer_1);
	MC_ReadStatus_0();
END_PROGRAM

PROGRAM _CYCLIC
	
	MC_ReadStatus_0.Axis := ADR(gMixer_1);
	MC_ReadStatus_0();
	
	gMixer1Outputs;
	gMixer1Parameters;
	
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
	
	MpAxisBasic_P3.MpLink := ADR(gAxis_P3);
	MpAxisBasic_P3.Parameters := ADR(MpAxisBasicParameters_P3);
	MpAxisBasic_P3();
	
	// Mixer 1,2 status update
	gTanks.Status.IsMixer1On := BOOL_TO_UINT(gMixer1Outputs.MoveActive);
	gTanks.Status.IsMixer2On := BOOL_TO_UINT(MpAxisBasic_Secondary.MoveActive);
	
	// Assigning slave axis parameters to coupling parameters
	MpAxisCouplingParameters.Gear.Acceleration := MpAxisBasicParameters_Secondary.Acceleration;
	MpAxisCouplingParameters.Gear.Deceleration := MpAxisBasicParameters_Secondary.Deceleration;
	
	// Assigning deceleration from axis parameters to stop deceleration
	MpAxisBasicParameters_Secondary.Stop.Deceleration := MpAxisBasicParameters_Secondary.Deceleration;
	MpAxisBasicParameters_Primary.Stop.Deceleration := gMixer1Parameters.Deceleration;
	
	// Power_on negative edge detection
	F_TRIG_0(CLK:=gMixer1Outputs.PowerOn);
	F_TRIG_1(CLK:=MpAxisBasic_Secondary.PowerOn);
	F_TRIG_2(CLK:=MpAxisBasic_P3.PowerOn);
	
	// Resetting update commands
	IF MpAxisCoupling_0.UpdateDone THEN
		MpAxisCoupling_0.Update := FALSE;
	END_IF;
	IF gMixer1Outputs.UpdateDone THEN
		gMixer1Inputs.Update := FALSE;
	END_IF
	IF MpAxisBasic_Secondary.UpdateDone THEN
		MpAxisBasic_Secondary.Update := FALSE;
	END_IF
	IF MpAxisBasic_P3.UpdateDone THEN
		MpAxisBasic_P3.Update := FALSE;
	END_IF
	
	// Gear and cam ratio
	MpAxisCouplingParameters.Gear.RatioDenominator := REAL_TO_DINT(RatioDenominatorReal * 10);
	MpAxisCouplingParameters.Gear.RatioNumerator := REAL_TO_DINT(RatioNumeratorReal * 10);
	MpAxisCouplingParameters.Cam.MasterScaling := REAL_TO_DINT(RatioDenominatorReal * 36000);
	MpAxisCouplingParameters.Cam.SlaveScaling := REAL_TO_DINT(RatioNumeratorReal * 36000);
	
	// Correct display of velocity values on the visualization
	IF MpAxisBasic_Secondary.Power THEN
		MixerSecondaryVelocity := MpAxisBasic_Secondary.Velocity;
	ELSE
		MixerSecondaryVelocity := 0;
	END_IF
		
	IF MpAxisBasic_P3.Power THEN
		MixerP3Velocity := MpAxisBasic_P3.Velocity;
	ELSE
		MixerP3Velocity := 0;
	END_IF
	
	// 
	MpAxisBasicParameters_Primary.Velocity := gMixer1Parameters.Velocity;
	MpAxisBasicParameters_Primary.Distance := REAL_TO_LREAL(gMixer1Parameters.Distance);
	MpAxisBasicParameters_Primary.Position := REAL_TO_LREAL(gMixer1Parameters.Position);
	MpAxisBasicParameters_Primary.Acceleration := gMixer1Parameters.Acceleration;
	MpAxisBasicParameters_Primary.Deceleration := gMixer1Parameters.Deceleration;
	CASE gMixer1Parameters.Direction OF
		0:
			MpAxisBasicParameters_Primary.Direction := mcDIR_POSITIVE;
		1:
			MpAxisBasicParameters_Primary.Direction := mcDIR_NEGATIVE;
	END_CASE
	gMixer1Outputs.Position := LREAL_TO_REAL(MpAxisBasic_Primary.Position);
	
	// E-STOP
	IF NOT gDriveStop THEN
		MpAxisBasic_Primary.Power := FALSE;
		MpAxisBasic_Secondary.Power := FALSE;
		MpAxisBasic_P3.Power := FALSE;
		gTanks.Commands.TurnOnMixer1 := FALSE;
		gTanks.Commands.TurnOnMixer2 := FALSE;
		StepMixer1 := STEP_INIT;
		StepMixer2 := STEP_INIT;
		Manual := FALSE;
	END_IF;
	
	IF NOT Manual THEN
		MpAxisBasic_P3.Power := FALSE;
		// Primary axis (Mixer1) state machine
		CASE StepMixer1 OF
			STEP_INIT:
				MpAxisBasic_Primary.Power := FALSE;
				gMixer1Inputs.MoveAdditive := FALSE;
				gMixer1Inputs.MoveAbsolute := FALSE;
				gMixer1Inputs.MoveVelocity := FALSE;
				IF gTanks.Commands.TurnOnMixer1 THEN
					StepMixer1 := STEP_POWER_ON;
				END_IF
				
			STEP_POWER_ON:
				MpAxisBasic_Primary.Power := TRUE;
				IF gMixer1Outputs.PowerOn THEN
					StepMixer1 := STEP_MOVE_VELOCITY;
				END_IF;
				
			STEP_MOVE_VELOCITY:
				gMixer1Inputs.MoveVelocity := TRUE;
				IF gMixer1Outputs.InVelocity THEN
					StepMixer1 := STEP_RUNNING;
				END_IF;
				
			STEP_RUNNING:
				IF NOT gTanks.Commands.TurnOnMixer1 THEN
					StepMixer1 := STEP_POWER_OFF;
				END_IF;
				
			STEP_POWER_OFF:
				gMixer1Inputs.MoveVelocity := FALSE;
				IF NOT gMixer1Outputs.MoveActive THEN
					MpAxisBasic_Primary.Power := FALSE;
				END_IF;
				IF NOT gMixer1Outputs.PowerOn THEN
					StepMixer1:= STEP_INIT;
				END_IF;
		END_CASE;
		
		// Secondary axis (Mixer2) state machine
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
				// Stopping slave axis for cam coupling
				IF CamCoupling THEN
					gMixer1Inputs.MoveVelocity := FALSE;
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
	
	// Resetting commands after stop or power off
	IF gMixer1Outputs.Stopped OR F_TRIG_0.Q THEN
		MpAxisBasic_Primary.Stop := FALSE;
		gMixer1Inputs.MoveAdditive := FALSE;
		gMixer1Inputs.MoveAbsolute := FALSE;
		gMixer1Inputs.MoveVelocity := FALSE;
	END_IF;
	IF MpAxisBasic_Secondary.Stopped OR F_TRIG_1.Q THEN
		MpAxisBasic_Secondary.Stop := FALSE;
		MpAxisBasic_Secondary.MoveVelocity := FALSE;
		MpAxisBasic_Secondary.MoveAbsolute := FALSE;
		MpAxisBasic_Secondary.MoveAdditive := FALSE;
	END_IF
	IF MpAxisBasic_P3.Stopped OR F_TRIG_2.Q THEN
		MpAxisBasic_P3.Stop := FALSE;
		MpAxisBasic_P3.MoveAdditive := FALSE;
		MpAxisBasic_P3.MoveAbsolute := FALSE;
		MpAxisBasic_P3.MoveVelocity := FALSE;
	END_IF;
	
	// Manual mode 
	IF Manual THEN
		StepMixer1 := STEP_INIT;
		StepMixer2 := STEP_INIT;
		gTanks.Commands.TurnOnMixer1 := FALSE;
		gTanks.Commands.TurnOnMixer2 := FALSE;
		// Manual mode MixerPrimary
//		IF gMixer1Outputs.InPosition THEN
//			Mixer1ReadyToMove := TRUE;
//		END_IF
		IF gMixer1Outputs.MoveDone THEN//Mixer1ReadyToMove THEN
			gMixer1Inputs.MoveAdditive := FALSE;
			gMixer1Inputs.MoveAbsolute := FALSE;
			gMixer1Inputs.MoveVelocity := FALSE;
			//IF NOT(gMixer1Outputs.MoveActive) THEN
			//	Mixer1ReadyToMove := FALSE;
			//END_IF
		END_IF
		IF NOT gMixer1Outputs.Error THEN
			MpAxisBasic_Primary.ErrorReset := FALSE;
		END_IF;
		
		// Manual mode MixerSecondary
		IF MpAxisBasic_Secondary.MoveDone THEN
			MpAxisBasic_Secondary.MoveAdditive := FALSE;
			MpAxisBasic_Secondary.MoveAbsolute := FALSE;
			MpAxisBasic_Secondary.MoveVelocity := FALSE;
		END_IF;
		// Resetting commands after stop or power off
		IF NOT MpAxisBasic_Secondary.Error THEN
			MpAxisBasic_Secondary.ErrorReset := FALSE;
		END_IF;
		
		// Manual mode P3 Mixer
		IF MpAxisBasic_P3.MoveDone THEN
			MpAxisBasic_P3.MoveAdditive := FALSE;
			MpAxisBasic_P3.MoveAbsolute := FALSE;
			MpAxisBasic_P3.MoveVelocity := FALSE;
		END_IF
		IF NOT MpAxisBasic_P3.Error THEN
			MpAxisBasic_P3.ErrorReset := FALSE;
		END_IF;
	END_IF
	
	// Selected Coupling Mode case
	CASE CouplingMode OF
		NO_COUPLING:
			// Gear coupling condition
			IF GearCoupling AND MpAxisBasic_Secondary.PowerOn THEN
				MpAxisCoupling_0.Gear := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingMode := GEAR_COUPLING;
					MpAxisBasic_Secondary.MoveVelocity := FALSE;
				END_IF;
				// Option to disable gear coupling before InSync status
			IF NOT MpAxisCoupling_0.InSync AND NOT GearCoupling THEN
					MpAxisCoupling_0.Gear := FALSE;
			END_IF;	
			// Cam coupling condition
			ELSIF CamCoupling AND MpAxisBasic_Secondary.PowerOn THEN
				// Stopping slave axis before coupling
				IF MpAxisBasic_Secondary.MoveActive THEN
					MpAxisBasic_Secondary.MoveVelocity := FALSE;
					MpAxisBasic_Secondary.MoveAbsolute := FALSE;
					MpAxisBasic_Secondary.MoveAdditive := FALSE;
				ELSE
					MpAxisCoupling_0.Cam := TRUE;
				END_IF
			END_IF
			// Checking if secondary axis is in sync and moving
			IF MpAxisCoupling_0.InSync AND MpAxisCoupling_0.Cam AND MpAxisBasic_Secondary.MoveActive THEN
				CouplingMode := CAM_COUPLING;
			END_IF
			// Option to disable cam coupling before in sync status
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
	
	MpAxisBasic_P3.Enable := FALSE;
	MpAxisBasic_P3();
	
	MC_ReadStatus_0.Enable := FALSE;
	MC_ReadStatus_0();
END_PROGRAM