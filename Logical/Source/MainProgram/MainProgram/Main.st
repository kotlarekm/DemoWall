//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT

	gSelectedParameters;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	IF Stop THEN
		Step := START;
		gTanks.Commands.OpenTank1Valve := FALSE;
		gTanks.Commands.OpenTank2Valve := FALSE;
		gTanks.Commands.OpenTank3LeftValve := FALSE;
		gTanks.Commands.OpenTank3RightValve := FALSE;
	END_IF;
	
	CASE Step OF
		
		START:
			IF Start THEN
				gTanks.Commands.OpenTank1Valve := TRUE;
				gTanks.Commands.OpenTank2Valve := TRUE;
				Start := FALSE;
				Step := FILLING_TANKS_1_AND_2;
			END_IF;
			
		FILLING_TANKS_1_AND_2:
			IF gTanks.ObjectParameters.Tank1FluidLvl >= gSelectedParameters.Tank1TargetFluidLvl THEN
				gTanks.Commands.OpenTank1Valve := FALSE;
			END_IF;
	
			IF gTanks.ObjectParameters.Tank2FluidLvl >= gSelectedParameters.Tank2TargetFluidLvl THEN
				gTanks.Commands.OpenTank2Valve := FALSE;
			END_IF;
			
			IF NOT(gTanks.Commands.OpenTank1Valve) AND NOT(gTanks.Commands.OpenTank2Valve) THEN
				Step := FILLING_TANK_3;
			END_IF;
			
		FILLING_TANK_3:
			gTanks.Commands.OpenTank3LeftValve := gSelectedParameters.Tank3LeftValveOpeningLvl;
			gTanks.Commands.OpenTank3RightValve := gSelectedParameters.Tank3RightValveOpeningLvl;
			
			IF gTanks.ObjectParameters.Tank3FluidLvl >= gSelectedParameters.Tank3TargetFluidLvl 
				AND NOT(gSelectedParameters.Mixer1On) AND NOT(gSelectedParameters.Mixer2On) THEN
				gTanks.Commands.OpenTank3LeftValve := 0;
				gTanks.Commands.OpenTank3RightValve := 0;
				Step := END;
			END_IF;
			
			IF gTanks.ObjectParameters.Tank3FluidLvl >= gSelectedParameters.Tank3TargetFluidLvl
				AND gSelectedParameters.Mixer1On AND gSelectedParameters.Mixer2On THEN
				Step := MIXING;
			END_IF
			
		MIXING:
			gTanks.Commands.TurnOnMixer1 := TRUE;
			gTanks.Commands.TurnOnMixer2 := TRUE;
			TON_0.IN := TRUE;
			TON_0(PT := gSelectedParameters.MixingTime);
			IF TON_0.Q THEN
				gTanks.Commands.TurnOnMixer1 := FALSE;
				gTanks.Commands.TurnOnMixer2 := FALSE;
				gSelectedParameters.Mixer1On := FALSE;
				gSelectedParameters.Mixer2On := FALSE;
				TON_0.IN := FALSE;
				Step := END;
			END_IF
			
		END:
			gTanks.Commands.OpenTank3MainValve := TRUE;
			
			IF gTanks.ObjectParameters.Tank3FluidLvl = 0 THEN
				gTanks.Commands.OpenTank3MainValve := FALSE;
				Step := START;
			END_IF;
		
	END_CASE;

END_PROGRAM

PROGRAM _EXIT

END_PROGRAM

