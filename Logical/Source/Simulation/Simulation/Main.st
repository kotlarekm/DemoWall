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
 
	IF gTanks.Commands.OpenTank1Valve AND gTanks.Status.Tank1FluidLvl < gTanks.Parameters.Tank1TargetFluidLvl THEN
		IF NOT TON_1.IN THEN 
			TON_1(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_1.Q THEN
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
			TON_1(IN := FALSE);  
		END_IF
 
		WaterFixTank1 := gTanks.Status.Tank1FluidLvl - gTanks.Parameters.Tank1TargetFluidLvl;
 
		IF gTanks.Status.Tank1FluidLvl > gTanks.Parameters.Tank1TargetFluidLvl THEN
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl - WaterFixTank1;
		END_IF
 
		IF gTanks.Status.Tank1FluidLvl >= gTanks.Parameters.Tank1TargetFluidLvl THEN
			gTanks.Commands.OpenTank1Valve := FALSE;
		END_IF
	END_IF
 
	TON_1();
 
	IF gTanks.Commands.OpenTank2Valve AND gTanks.Status.Tank2FluidLvl < gTanks.Parameters.Tank2TargetFluidLvl THEN
		IF NOT TON_2.IN THEN 
			TON_2(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_2.Q THEN
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
			TON_2(IN := FALSE);  
		END_IF
 
		WaterFixTank2 := gTanks.Status.Tank2FluidLvl - gTanks.Parameters.Tank2TargetFluidLvl;
 
		IF gTanks.Status.Tank2FluidLvl > gTanks.Parameters.Tank2TargetFluidLvl THEN
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl - WaterFixTank2;
		END_IF
 
		IF gTanks.Status.Tank2FluidLvl >= gTanks.Parameters.Tank2TargetFluidLvl THEN
			gTanks.Commands.OpenTank2Valve := FALSE;
		END_IF
	END_IF
 
	TON_2();
 
	IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND gTanks.Status.Tank3FluidLvl <= gTanks.Parameters.Tank3TargetFluidLvl THEN
		IF NOT TON_3.IN THEN 
			TON_3(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_3.Q THEN
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl + 
			(POURED_WATER_TO_TANK * gTanks.Commands.OpenTank3LeftValve/VALVE_CALCULATION_INPUT);
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl -
			(POURED_WATER_TO_TANK * gTanks.Commands.OpenTank3LeftValve/VALVE_CALCULATION_INPUT);
			TON_3(IN := FALSE);  
		END_IF
 
		IF gTanks.Status.Tank1FluidLvl < 0 THEN
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl + gTanks.Status.Tank1FluidLvl;
			gTanks.Status.Tank1FluidLvl := 0;
		END_IF
 
		IF gTanks.Status.Tank3FluidLvl >= gTanks.Parameters.Tank3TargetFluidLvl OR gTanks.Status.Tank1FluidLvl <= 0  THEN
			gTanks.Commands.OpenTank3LeftValve := FALSE;
			gTanks.Commands.OpenTank1Valve := FALSE;
		END_IF
	END_IF
 
	IF gTanks.Status.Tank1FluidLvl > 0 
		AND gTanks.Status.Tank3FluidLvl > gTanks.Parameters.Tank3TargetFluidLvl 
		AND gTanks.Commands.OpenTank3LeftValve = 0 THEN
		gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
		gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
	END_IF
 
	TON_3();
 
	IF UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) AND gTanks.Status.Tank3FluidLvl <= gTanks.Parameters.Tank3TargetFluidLvl THEN
		IF NOT TON_4.IN THEN 
			TON_4(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_4.Q THEN
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl + 
			(POURED_WATER_TO_TANK * gTanks.Commands.OpenTank3RightValve/VALVE_CALCULATION_INPUT);
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl -
			(POURED_WATER_TO_TANK * gTanks.Commands.OpenTank3RightValve/VALVE_CALCULATION_INPUT);
			TON_4(IN := FALSE);  
		END_IF
 
		IF gTanks.Status.Tank2FluidLvl < 0 THEN
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl + gTanks.Status.Tank2FluidLvl;
			gTanks.Status.Tank2FluidLvl := 0;
		END_IF
 
		IF gTanks.Status.Tank3FluidLvl >= gTanks.Parameters.Tank3TargetFluidLvl OR gTanks.Status.Tank2FluidLvl <= 0 THEN
			gTanks.Commands.OpenTank3RightValve := FALSE;
			gTanks.Commands.OpenTank2Valve := FALSE;
		END_IF
	END_IF
 
	IF gTanks.Status.Tank2FluidLvl > 0 
		AND gTanks.Status.Tank3FluidLvl > gTanks.Parameters.Tank3TargetFluidLvl 
		AND gTanks.Commands.OpenTank3RightValve = 0 THEN
		gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
		gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
	END_IF
 
	TON_4();
 
	IF gTanks.Commands.OpenTank3MainValve THEN
		IF NOT TON_5.IN THEN 
			TON_5(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_5.Q THEN
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - POURED_WATER_TO_TANK;
			TON_5(IN := FALSE);  
		END_IF
 
		IF gTanks.Status.Tank3FluidLvl <= 0 THEN
			gTanks.Status.Tank3FluidLvl := 0;
			gTanks.Commands.OpenTank3MainValve := FALSE;
		END_IF
	END_IF
 
	TON_5();
 
	IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) THEN
		IF NOT TON_6.IN THEN
			TON_6(IN := TRUE, PT := T#175ms);
		END_IF
		
		IF TON_6.Q THEN
			AnimationForMixer1 := AnimationForMixer1 + 1;
			TON_6.IN := FALSE;
			
			IF AnimationForMixer1 = 7 THEN
				AnimationForMixer1 := 1;
			END_IF
		END_IF
	ELSE
		AnimationForMixer1 := 0;
	END_IF
	
	IF UINT_TO_BOOL(gTanks.Status.IsMixer2On) THEN
		IF NOT TON_6.IN THEN
			TON_6(IN := TRUE, PT := T#175ms);
		END_IF
		
		IF TON_6.Q THEN
			AnimationForMixer2 := AnimationForMixer2 + 1;
			TON_6.IN := FALSE;
			
			IF AnimationForMixer2 = 7 THEN
				AnimationForMixer2 := 1;
			END_IF
		END_IF
	ELSE
		AnimationForMixer2 := 0;
	END_IF
	
	TON_6();
	
	IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) THEN
		TanksValvesCheck := TRUE;
	ELSE
		TanksValvesCheck := FALSE;
	END_IF
	
	LeftValveCheck := FALSE;
	RightValveCheck := FALSE;
	
	IF gTanks.Parameters.Tank2TargetFluidLvl > 0 AND gTanks.Parameters.Tank1TargetFluidLvl = 0 THEN
		LeftValveCheck := TRUE;
	END_IF
	
	IF gTanks.Parameters.Tank1TargetFluidLvl > 0 AND gTanks.Parameters.Tank2TargetFluidLvl = 0 THEN
		RightValveCheck := TRUE;
	END_IF
	
	IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) THEN
		MixerCheck := TRUE;
	END_IF
	
	IF gTanks.Commands.Start THEN
		MixerCheck := FALSE;
	END_IF
	
	IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND RightValveCheck THEN
		MixerCheck := FALSE;
	END_IF
	
	IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND LeftValveCheck THEN	
		MixerCheck := FALSE;
	END_IF
	
END_PROGRAM
 
PROGRAM _EXIT
 
		END_PROGRAM