//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT
	MpAxisBasic_0.Enable := TRUE;
	MpAxisBasic_0.MpLink := ADR(gMixer_1);
	MpAxisBasic_0.Parameters := ADR(MpAxisBasicParameters);
	MpAxisBasic_0();
	
	MpAxisBasic_1.Enable := TRUE;
	MpAxisBasic_1.MpLink := ADR(gMixer_2);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicParameters_1);
	MpAxisBasic_1();
	
	MpAxisCoupling_0.Enable := TRUE;
	MpAxisCoupling_0.MpLink := ADR(gMixer_2);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_1);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
	
END_PROGRAM

PROGRAM _CYCLIC
	MpAxisBasic_0.MpLink := ADR(gMixer_1);
	MpAxisBasic_0.Parameters := ADR(MpAxisBasicParameters);
	MpAxisBasic_0();
	
	MpAxisBasic_1.MpLink := ADR(gMixer_2);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicParameters_1);
	MpAxisBasic_1();
	
	MpAxisCoupling_0.MpLink := ADR(gMixer_2);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_1);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
	
	CASE StepMixer1 OF
		STEP_INIT:
			IF gTanks.Commands.TurnOnMikser1 THEN
				StepMixer1 := STEP_POWER_ON;
			END_IF
		STEP_POWER_ON:
			MpAxisBasic_0.Power := TRUE;
			IF MpAxisBasic_0.PowerOn THEN
				StepMixer1 := STEP_MOVE;
			END_IF;
		STEP_MOVE:
			MpAxisBasic_0.MoveVelocity := TRUE;
			IF NOT gTanks.Commands.TurnOnMikser1 THEN
				StepMixer1 := STEP_POWER_OFF;
			END_IF;
		STEP_POWER_OFF:
			MpAxisBasic_0.MoveVelocity := FALSE;
			MpAxisBasic_0.Power := FALSE;
			IF NOT MpAxisBasic_0.InVelocity AND NOT MpAxisBasic_0.PowerOn THEN
				StepMixer1:= STEP_INIT;
			END_IF;
	END_CASE;
	 
	CASE StepMixer2 OF
		STEP_INIT:
			IF gTanks.Commands.TurnOnMikser2 THEN
				StepMixer2 := STEP_POWER_ON;
			END_IF
		STEP_POWER_ON:
			MpAxisBasic_1.Power := TRUE;
			IF MpAxisBasic_1.PowerOn THEN
				StepMixer2 := STEP_MOVE;
			END_IF;
		STEP_MOVE:
			MpAxisBasic_1.MoveVelocity := TRUE;
			IF NOT gTanks.Commands.TurnOnMikser2 THEN
				StepMixer2 := STEP_POWER_OFF;
			END_IF;
		STEP_POWER_OFF:
			MpAxisBasic_1.MoveVelocity := FALSE;
			MpAxisBasic_1.Power := FALSE;
			IF NOT MpAxisBasic_1.InVelocity AND NOT MpAxisBasic_1.PowerOn THEN
				StepMixer2:= STEP_INIT;
			END_IF;
	END_CASE;
	
	CASE CouplingType OF
		NO_COUPLING:
			IF GearCoupling THEN
				MpAxisCoupling_0.Gear := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingType := GEAR_COUPLING;
				END_IF;
			ELSIF CamCoupling THEN
				CouplingType := CAM_COUPLING;
			END_IF;	
		GEAR_COUPLING:
			IF NOT GearCoupling THEN
				MpAxisCoupling_0.Gear := FALSE;
				gTanks.Commands.TurnOnMikser2 := FALSE;
				CouplingType := NO_COUPLING;
			END_IF;
		CAM_COUPLING:
	END_CASE;
END_PROGRAM

PROGRAM _EXIT
	MpAxisBasic_0.Enable := FALSE;
	MpAxisBasic_0();
	
	MpAxisBasic_1.Enable := FALSE;
	MpAxisBasic_1();
	
	MpAxisCoupling_0.Enable := FALSE;
	MpAxisCoupling_0();
END_PROGRAM

