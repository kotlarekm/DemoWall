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

	MpAxisBasic_0.Enable := TRUE;
	MpAxisBasic_0.MpLink := ADR(gMixer_1);
	MpAxisBasic_0.Parameters := ADR(MpAxisBasicParameters_0);
	MpAxisBasic_0();
	
	MpAxisBasic_1.Enable := TRUE;
	MpAxisBasic_1.MpLink := ADR(gMixer_2);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicParameters_1);
	MpAxisBasic_1();
	
	MpAxisCoupling_0.Enable := TRUE;
	MpAxisCoupling_0.MpLink := ADR(gMixer_1);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_2);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCoupling_0();
END_PROGRAM

PROGRAM _CYCLIC
	MpAxisBasic_0.MpLink := ADR(gMixer_1);
	MpAxisBasic_0.Parameters := ADR(MpAxisBasicParameters_0);
	MpAxisBasic_0();
	
	MpAxisBasic_1.MpLink := ADR(gMixer_2);
	MpAxisBasic_1.Parameters := ADR(MpAxisBasicParameters_1);
	MpAxisBasic_1();
	
	MpAxisCoupling_0.MpLink := ADR(gMixer_1);
	MpAxisCoupling_0.MpLinkMaster := ADR(gMixer_2);
	MpAxisCoupling_0.Parameters := ADR(MpAxisCouplingParameters);
	MpAxisCouplingParameters.Cam.ID := CamID;
	MpAxisCoupling_0();
	
	CASE StepMixer1 OF
		STEP_INIT:
			IF gTanks.Commands.TurnOnMixer1 THEN
				StepMixer1 := STEP_POWER_ON;
			END_IF
			
		STEP_POWER_ON:
			MpAxisBasic_0.Power := TRUE;
			IF MpAxisBasic_0.PowerOn THEN
				StepMixer1 := STEP_MOVE_VELOCITY;
			END_IF;
			
		STEP_MOVE_VELOCITY:
			MpAxisBasic_0.MoveVelocity := TRUE;
			IF MpAxisBasic_0.InVelocity THEN
				StepMixer1 := STEP_RUNNING;
			END_IF;
			
		STEP_RUNNING:
			gTanks.Status.IsMixer1On := TRUE;
			IF CamCoupling THEN
				MpAxisBasic_0.MoveVelocity := FALSE;
			END_IF;
			IF NOT gTanks.Commands.TurnOnMixer1 THEN
				StepMixer1 := STEP_POWER_OFF;
			END_IF;
			
		STEP_POWER_OFF:
			MpAxisBasic_0.MoveVelocity := FALSE;
			MpAxisBasic_0.Power := FALSE;
			IF NOT MpAxisBasic_0.InVelocity AND NOT MpAxisBasic_0.PowerOn THEN
				gTanks.Status.IsMixer1On := FALSE;
				StepMixer1:= STEP_INIT;
			END_IF;
	END_CASE;
	 
	CASE StepMixer2 OF
		STEP_INIT:
			IF gTanks.Commands.TurnOnMixer2 THEN
				StepMixer2 := STEP_POWER_ON;
			END_IF
			
		STEP_POWER_ON:
			MpAxisBasic_1.Power := TRUE;
			IF MpAxisBasic_1.PowerOn THEN
				StepMixer2 := STEP_MOVE_VELOCITY;
			END_IF;
			
		STEP_MOVE_VELOCITY:
			MpAxisBasic_1.MoveVelocity := TRUE;
			IF MpAxisBasic_1.InVelocity THEN
				StepMixer2 := STEP_RUNNING;
			END_IF;
			
		STEP_RUNNING:
			gTanks.Status.IsMixer2On := TRUE;
			IF NOT gTanks.Commands.TurnOnMixer2 THEN
				StepMixer2 := STEP_POWER_OFF;
			END_IF;
			
		STEP_POWER_OFF:
			MpAxisBasic_1.MoveVelocity := FALSE;
			MpAxisBasic_1.Power := FALSE;
			IF NOT MpAxisBasic_1.InVelocity AND NOT MpAxisBasic_1.PowerOn THEN
				gTanks.Status.IsMixer2On := FALSE;
				StepMixer2:= STEP_INIT;
			END_IF;
	END_CASE;
	
	CASE CouplingMode OF
		NO_COUPLING:
			IF GearCoupling AND StepMixer1 = STEP_RUNNING THEN
				MpAxisCoupling_0.Gear := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingMode := GEAR_COUPLING;
				END_IF;
			ELSIF CamCoupling AND StepMixer1 = STEP_RUNNING AND NOT MpAxisBasic_0.InVelocity THEN
				MpAxisCoupling_0.Cam := TRUE;
				IF MpAxisCoupling_0.InSync THEN
					CouplingMode := CAM_COUPLING;
				END_IF
			END_IF;	
			
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
	MpAxisBasic_0.Enable := FALSE;
	MpAxisBasic_0();
	
	MpAxisBasic_1.Enable := FALSE;
	MpAxisBasic_1();
	
	MpAxisCoupling_0.Enable := FALSE; 
	MpAxisCoupling_0();
END_PROGRAM


