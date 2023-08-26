 //*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT

	gTanks;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	gTanks.Status.Tank1Pressure := DENSITY_OF_LIQUID * GRAVITY * gTanks.Status.Tank1FluidLvl/LITERS_TO_CUBIC_METERS_SCALLER;
	gTanks.Status.Tank2Pressure := DENSITY_OF_LIQUID * GRAVITY * gTanks.Status.Tank2FluidLvl/LITERS_TO_CUBIC_METERS_SCALLER;
	gTanks.Status.Tank3Pressure := DENSITY_OF_LIQUID * GRAVITY * gTanks.Status.Tank3FluidLvl/LITERS_TO_CUBIC_METERS_SCALLER;
	gTanks.Status.IsMixer1On := gTanks.Commands.TurnOnMixer1;
	gTanks.Status.IsMixer2On := gTanks.Commands.TurnOnMixer2;
	
	IF gTanks.Commands.Stop THEN
		gTanks.Status.Step := START;
		gTanks.Commands.OpenTank1Valve := FALSE;
		gTanks.Commands.OpenTank2Valve := FALSE;
		gTanks.Commands.OpenTank3LeftValve := FALSE;
		gTanks.Commands.OpenTank3RightValve := FALSE;
	END_IF;
	
	CASE gTanks.Status.Step OF
		
		START:
			IF gTanks.Commands.Start THEN
				IF gTanks.Parameters.Tank1TargetFluidLvl > 0 THEN
					gTanks.Commands.OpenTank1Valve := TRUE;
				END_IF
				
				IF gTanks.Parameters.Tank2TargetFluidLvl > 0 THEN
					gTanks.Commands.OpenTank2Valve := TRUE;
				END_IF
				
				gTanks.Commands.Start := FALSE;
				gTanks.Status.Step := FILLING_TANKS_1_AND_2;
			END_IF;
			
		FILLING_TANKS_1_AND_2:
			IF gTanks.Status.Tank1FluidLvl >= gTanks.Parameters.Tank1TargetFluidLvl THEN
				gTanks.Commands.OpenTank1Valve := FALSE;
			END_IF;
	
			IF gTanks.Status.Tank2FluidLvl >= gTanks.Parameters.Tank2TargetFluidLvl THEN
				gTanks.Commands.OpenTank2Valve := FALSE;
			END_IF;
			
			IF NOT(gTanks.Commands.OpenTank1Valve) AND NOT(gTanks.Commands.OpenTank2Valve) THEN
				gTanks.Commands.OpenTank3LeftValve := gTanks.Parameters.Tank3LeftValveOpeningLvl;
				gTanks.Commands.OpenTank3RightValve := gTanks.Parameters.Tank3RightValveOpeningLvl;
				gTanks.Status.Step := FILLING_TANK_3;
			END_IF;
			
		FILLING_TANK_3:
			
			IF gTanks.Status.Tank3FluidLvl >= gTanks.Parameters.Tank3TargetFluidLvl 
				AND UINT_TO_BOOL(NOT(gTanks.Parameters.Mixer1On)) 
				AND UINT_TO_BOOL(NOT(gTanks.Parameters.Mixer2On)) THEN
				gTanks.Commands.OpenTank3LeftValve := 0;
				gTanks.Commands.OpenTank3RightValve := 0;
				gTanks.Status.Step := END;
			END_IF;
			
			IF gTanks.Status.Tank3FluidLvl >= gTanks.Parameters.Tank3TargetFluidLvl
				AND UINT_TO_BOOL(gTanks.Parameters.Mixer1On)
				AND UINT_TO_BOOL(gTanks.Parameters.Mixer2On) THEN
				gTanks.Status.Step := MIXING;
			END_IF
			
			IF gTanks.Parameters.Tank1TargetFluidLvl + gTanks.Parameters.Tank2TargetFluidLvl < gTanks.Parameters.Tank3TargetFluidLvl
				AND gTanks.Status.Tank1FluidLvl = 0 
				AND gTanks.Status.Tank2FluidLvl = 0 
				AND UINT_TO_BOOL(gTanks.Parameters.Mixer1On) 
				AND UINT_TO_BOOL(gTanks.Parameters.Mixer2On) THEN
				gTanks.Status.Step := MIXING;
			END_IF
			
			IF gTanks.Parameters.Tank1TargetFluidLvl + gTanks.Parameters.Tank2TargetFluidLvl < gTanks.Parameters.Tank3TargetFluidLvl
				AND gTanks.Status.Tank1FluidLvl = 0
				AND gTanks.Status.Tank2FluidLvl = 0
				AND NOT(UINT_TO_BOOL(gTanks.Parameters.Mixer1On))
				AND NOT(UINT_TO_BOOL(gTanks.Parameters.Mixer2On)) THEN
				gTanks.Status.Step := END;
			END_IF
			
		MIXING:
			gTanks.Commands.TurnOnMixer1 := TRUE;
			gTanks.Commands.TurnOnMixer2 := TRUE;

			IF NOT TON_0.IN THEN 
				TON_0.PT := UDINT_TO_TIME(gTanks.Parameters.MixingTime);
				TON_0.IN := TRUE; 
			END_IF

			IF TON_0.Q THEN
				gTanks.Commands.TurnOnMixer1 := FALSE;
				gTanks.Commands.TurnOnMixer2 := FALSE;
				TON_0(IN := FALSE);  
				gTanks.Status.Step := END;
			END_IF
			
			TON_0();
			
		END:
			gTanks.Commands.OpenTank3MainValve := TRUE;
			
			IF gTanks.Status.Tank3FluidLvl = 0 THEN
				gTanks.Commands.OpenTank3MainValve := FALSE;
				gTanks.Status.Step := START;
			END_IF;
		
	END_CASE;

	gTanks.ObjectParameters.Tank3MaxAllowedPressure;
	
END_PROGRAM

PROGRAM _EXIT

END_PROGRAM

