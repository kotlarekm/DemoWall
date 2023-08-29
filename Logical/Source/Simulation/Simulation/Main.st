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

	IF Manual THEN
	
		gTanks.Commands.Start := FALSE;
		IF gTanks.Commands.OpenTank1Valve AND gTanks.Status.Tank1FluidLvl < MAX_TANK_CAPACITY THEN
			IF NOT TON_1.IN THEN 
				TON_1(IN := TRUE, PT := T#50ms);
			END_IF
 
			IF TON_1.Q THEN
				gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
				Tank1Save := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
				TON_1(IN := FALSE);  
			END_IF
		END_IF
 
		TON_1();
 
		IF gTanks.Commands.OpenTank2Valve AND gTanks.Status.Tank2FluidLvl < MAX_TANK_CAPACITY THEN
			IF NOT TON_2.IN THEN 
				TON_2(IN := TRUE, PT := T#50ms);
			END_IF
 
			IF TON_2.Q THEN
				gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
				Tank2Save := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
				TON_2(IN := FALSE);  
			END_IF
		END_IF
 
		TON_2();
 
		IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND gTanks.Status.Tank1FluidLvl > 0 AND gTanks.Status.Tank3FluidLvl < MAX_TANK_CAPACITY THEN
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
				gTanks.Status.Tank1FluidLvl := 0;
			END_IF
		END_IF
 
		TON_3();
 
		IF UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) AND gTanks.Status.Tank2FluidLvl > 0 AND gTanks.Status.Tank3FluidLvl < MAX_TANK_CAPACITY THEN
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
				gTanks.Status.Tank2FluidLvl := 0;
			END_IF
		END_IF
 
		TON_4();
 
		IF gTanks.Commands.OpenTank3MainValve AND gTanks.Status.Tank3FluidLvl > 0 THEN
			IF NOT TON_5.IN THEN 
				TON_5(IN := TRUE, PT := T#50ms);
			END_IF
 
			IF TON_5.Q THEN
				gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - POURED_WATER_TO_TANK;
				TON_5(IN := FALSE);  
			END_IF
			
			IF gTanks.Status.Tank3FluidLvl < 0 THEN
				gTanks.Status.Tank3FluidLvl := 0;
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

		IF Tank1Save > 0 AND Tank3LeftValveSave THEN
			ProgressBarWaterManual := TRUE;
		END_IF
		
		IF Tank2Save > 0 AND Tank3RightValveSave THEN
			ProgressBarPaintManual := TRUE;
		END_IF
		
		IF gTanks.Commands.OpenTank3LeftValve > 0 THEN
			Tank3LeftValveSave := TRUE;
		END_IF
		
		IF gTanks.Commands.OpenTank3RightValve > 0 THEN
			Tank3RightValveSave := TRUE;
		END_IF
		
		IF Tank1Save > 0 
			AND Tank2Save > 0
			AND Tank3LeftValveSave 
			AND Tank3RightValveSave THEN
			ProgressBarNotMixedManual := TRUE;
			ProgressBarPaintManual := FALSE;
			ProgressBarWaterManual := FALSE;
		ELSE
			ProgressBarNotMixedManual := FALSE;
		END_IF
		
		IF gTanks.Status.Tank1FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank1Save := 0;
			ProgressBarWaterManual := FALSE;
			ProgressBarNotMixedManual := FALSE;
			Tank3LeftValveSave := FALSE;
			MixerCheck := FALSE;
		END_IF
		
		IF gTanks.Status.Tank2FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank2Save := 0;
			ProgressBarPaintManual := FALSE;
			ProgressBarNotMixedManual := FALSE;
			Tank3RightValveSave := FALSE;
			MixerCheck := FALSE;
		END_IF
		
		IF gTanks.Status.Tank1FluidLvl = 0 AND gTanks.Status.Tank2FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank1Save := 0;
			Tank2Save := 0;
			ProgressBarNotMixedManual := FALSE;
			ProgressBarPaintManual := FALSE;
			ProgressBarWaterManual := FALSE;
			Tank3LeftValveSave := FALSE;
			Tank3RightValveSave := FALSE;
			MixerCheck := FALSE;
		END_IF
		
		IF gTanks.Status.Tank3FluidLvl = 0 THEN
			gTanks.Commands.OpenTank3MainValve := FALSE;
			Tank3LeftValveSave := FALSE;
			Tank3RightValveSave := FALSE;
		END_IF
		
		IF gTanks.Status.Tank1FluidLvl = 0 THEN
			gTanks.Commands.OpenTank3LeftValve := 0;
		END_IF
		
		IF gTanks.Status.Tank2FluidLvl = 0 THEN
			gTanks.Commands.OpenTank3RightValve := 0;
		END_IF

		IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) THEN
			TanksValvesCheck := TRUE;
		ELSE
			TanksValvesCheck := FALSE;
		END_IF

		IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) 
			AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) 
			AND Tank3RightValveSave
			AND Tank3LeftValveSave  THEN
			MixerCheck := TRUE;
		END_IF
	END_IF
	
	IF Auto THEN
		
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
	
		LValveCheck := FALSE;
		RValveCheck := FALSE;
	
		IF gTanks.Parameters.Tank2TargetFluidLvl > 0 AND gTanks.Parameters.Tank1TargetFluidLvl = 0 THEN
			LValveCheck := TRUE;
		END_IF
	
		IF gTanks.Parameters.Tank1TargetFluidLvl > 0 AND gTanks.Parameters.Tank2TargetFluidLvl = 0 THEN
			RValveCheck := TRUE;
		END_IF
	
		IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) THEN
			MixerCheck := TRUE;
		END_IF
		
		IF gTanks.Status.Tank3FluidLvl = 0 
			OR gTanks.Commands.Start 
			OR UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND RValveCheck
			OR UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND LValveCheck THEN
			MixerCheck := FALSE;
		END_IF
	END_IF
END_PROGRAM
 
PROGRAM _EXIT
 
		END_PROGRAM