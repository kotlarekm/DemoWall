//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT

	MpAxisBasic_Primary.Enable := TRUE;
	MpAxisBasic_Primary.MpLink := ADR(gMixer_1);
	MpAxisBasic_Primary.Parameters := ADR(MpAxisBasicParameters_Primary);
	MpAxisBasic_Primary();
	
	MpAxisBasic_Secondary.Enable := TRUE;
	MpAxisBasic_Secondary.MpLink := ADR(gMixer_2);
	MpAxisBasic_Secondary.Parameters := ADR(MpAxisBasicParameters_Secondary);
	MpAxisBasic_Secondary();
	
	MpAxisCoupling_0.Enable := TRUE;
	MpAxisCoupling_0.MpLink := ADR(gMixer_1);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_2);
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
	
	MpAxisCoupling_0.MpLink := ADR(gMixer_1);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_2);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
	
	gTanks.Status.IsMixer1On := MpAxisBasic_Primary.MoveActive;
	gTanks.Status.IsMixer2On := MpAxisBasic_Secondary.MoveActive;
	
	CASE StepMixer1 OF
		STEP_INIT:
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
			IF CamCoupling THEN
				MpAxisBasic_Primary.MoveVelocity := FALSE;
			END_IF;
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
	 
	CASE StepMixer2 OF
		STEP_INIT:
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
	
	CASE CouplingMode OF
		NO_COUPLING:
			IF GearCoupling AND MpAxisBasic_Primary.PowerOn THEN
				MpAxisCoupling_0.Gear := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingMode := GEAR_COUPLING;
				END_IF;
			ELSIF CamCoupling AND MpAxisBasic_Primary.PowerOn AND NOT MpAxisBasic_Primary.MoveActive THEN
				MpAxisCoupling_0.Cam := TRUE;
			END_IF;	
			IF MpAxisCoupling_0.InSync AND MpAxisCoupling_0.Cam THEN
				CouplingMode := CAM_COUPLING;
			END_IF
		GEAR_COUPLING:
			IF NOT GearCoupling THEN
				MpAxisCoupling_0.Gear := FALSE;
				IF NOT MpAxisCoupling_0.InSync THEN
					gTanks.Commands.TurnOnMixer1 := FALSE;
					CouplingMode := NO_COUPLING;
				END_IF
			END_IF;
			
		CAM_COUPLING:
			IF NOT CamCoupling THEN
				MpAxisCoupling_0.Cam := FALSE;
				IF NOT MpAxisCoupling_0.InSync THEN
					gTanks.Commands.TurnOnMixer1 := FALSE;
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


