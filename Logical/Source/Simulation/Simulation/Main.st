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
 
	// Mode change to auto
	IF EDGEPOS(Auto) THEN
		gTanks.Status.Step := START;
		gTanks.Commands.OpenTank1Valve := FALSE;
		gTanks.Commands.OpenTank2Valve := FALSE;
		gTanks.Commands.OpenTank3LeftValve := 0;
		gTanks.Commands.OpenTank3MainValve := FALSE;
		gTanks.Commands.OpenTank3RightValve := 0;
		gTanks.Commands.TurnOnMixer1 := FALSE;
		gTanks.Commands.TurnOnMixer2 := FALSE;
	END_IF;
 
	// Main page control buttons
	IF NOT(gDriveStop) THEN
		ManualBtnEnable := FALSE;
		AutoBtnEnable := FALSE;
		StartBtnEnable := FALSE;
	ELSIF Manual THEN
		ManualBtnEnable := FALSE;
		AutoBtnEnable := TRUE;
		StartBtnEnable := FALSE;
	ELSE
		AutoBtnEnable := FALSE;
		ManualBtnEnable := TRUE;
		StartBtnEnable := TRUE;
	END_IF;
 
	IF gTanks.Commands.Start THEN
		AutoBtnEnable := FALSE;
		ManualBtnEnable := FALSE;
		StartBtnEnable := FALSE;
		NumericInputsEnable := FALSE;
	ELSE
		NumericInputsEnable := TRUE;
	END_IF;
 
	
	//Manual control
	IF Manual THEN
 
		//Tank 1 valve control
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
 
		//Tank 2 valve control
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
 
		//Tank 3 left valve control
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
 
		//Tank 3 right valve control
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
 
		//Tank 3 main valve control
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
 
		//Mixer animations for simulation
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
 
		//Progress bar colours - water
		IF Tank1Save > 0 AND Tank3LeftValveSave THEN
			ProgressBarWaterManual := TRUE;
		END_IF
 
		//Progress bar colours - paint
		IF Tank2Save > 0 AND Tank3RightValveSave THEN
			ProgressBarPaintManual := TRUE;
		END_IF
 
		// Progress bar colours - not mixed water and paint
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
 
		//Condition to remember action made on left valve
		IF gTanks.Commands.OpenTank3LeftValve > 0 THEN
			Tank3LeftValveSave := TRUE;
		END_IF
 
		//Condition to remember action made on right valve
		IF gTanks.Commands.OpenTank3RightValve > 0 THEN
			Tank3RightValveSave := TRUE;
		END_IF
 
		//Colours reset to prevent previous colours from being displayed
		IF gTanks.Status.Tank1FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank1Save := 0;
			ProgressBarWaterManual := FALSE;
			ProgressBarNotMixedManual := FALSE;
			Tank3LeftValveSave := FALSE;
		END_IF
 
		IF gTanks.Status.Tank2FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank2Save := 0;
			ProgressBarPaintManual := FALSE;
			ProgressBarNotMixedManual := FALSE;
			Tank3RightValveSave := FALSE;
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
			MixerCheck := FALSE;
			ProgressBarPaintManual := FALSE;
			ProgressBarWaterManual := FALSE;
		END_IF
 
		//Tank 3 left valve reset to prevent colours bugging by intolerable users
		IF gTanks.Status.Tank1FluidLvl = 0 THEN
			gTanks.Commands.OpenTank3LeftValve := 0;
		END_IF
 
		//Tank 3 right valve reset to prevent colours bugging by intolerable users
		IF gTanks.Status.Tank2FluidLvl = 0 THEN
			gTanks.Commands.OpenTank3RightValve := 0;
		END_IF
 
		//Überprüfung der beiden Ventile für den Fortschrittsbalken der Wasser-Leck-Verbindung
		IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) THEN
			TanksValvesCheck := TRUE;
		ELSE
			TanksValvesCheck := FALSE;
		END_IF
 
		//Checking mixers status to display mixed progress bar
		IF UINT_TO_BOOL(gTanks.Status.IsMixer1On)  
			AND Tank3RightValveSave
			AND Tank3LeftValveSave  
			OR UINT_TO_BOOL(gTanks.Status.IsMixer2On)
			AND Tank3RightValveSave
			AND Tank3LeftValveSave THEN
			MixerCheck := TRUE;
		END_IF
	END_IF
 
	//Auto control
	IF Auto THEN
		ProgressBarNotMixedManual := FALSE;
 
		//Tank 1 valve control
		IF gTanks.Commands.OpenTank1Valve AND gTanks.Status.Tank1FluidLvl < gTanks.Parameters.Tank1TargetFluidLvl THEN
			IF NOT TON_1.IN THEN 
				TON_1(IN := TRUE, PT := T#50ms);
			END_IF
 
			IF TON_1.Q THEN
				gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
				Tank1Save := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
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
 
		//Tank 2 valve control
		IF gTanks.Commands.OpenTank2Valve AND gTanks.Status.Tank2FluidLvl < gTanks.Parameters.Tank2TargetFluidLvl THEN
			IF NOT TON_2.IN THEN 
				TON_2(IN := TRUE, PT := T#50ms);
			END_IF
 
			IF TON_2.Q THEN
				gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
				Tank2Save := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
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
 
		//Tank 3 left valve control
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
			AND gTanks.Commands.OpenTank3LeftValve = 0 
			AND gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl < 50 THEN
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
		END_IF
 
		TON_3();
 
		//Tank 3 right valve control
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
			AND gTanks.Commands.OpenTank3RightValve = 0 
			AND gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl < 50 THEN
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
			gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.Parameters.Tank3TargetFluidLvl);
		END_IF
 
		TON_4();
 
		//Tank 3 main valve control
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
 
		//Animations for mixers
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
 
		//Überprüfung der beiden Ventile für den Fortschrittsbalken der Wasser-Leck-Verbindung
		IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) THEN
			TanksValvesCheck := TRUE;
		ELSE
			TanksValvesCheck := FALSE;
		END_IF
 
		//Condition to remember action made on left and rigtht valves
		LValveCheck := FALSE;
		RValveCheck := FALSE;
 
		IF gTanks.Parameters.Tank2TargetFluidLvl > 0 AND gTanks.Parameters.Tank1TargetFluidLvl = 0 THEN
			LValveCheck := TRUE;
		END_IF
 
		IF gTanks.Parameters.Tank1TargetFluidLvl > 0 AND gTanks.Parameters.Tank2TargetFluidLvl = 0 THEN
			RValveCheck := TRUE;
		END_IF
 
 
		//Mixed progress bar display
		IF UINT_TO_BOOL(gTanks.Status.IsMixer1On) OR UINT_TO_BOOL(gTanks.Status.IsMixer2On) THEN
			MixerCheck := TRUE;
		END_IF
 
		IF gTanks.Status.Tank1FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank1Save := 0;
		END_IF
 
		IF gTanks.Status.Tank2FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank2Save := 0;
		END_IF
 
		IF gTanks.Status.Tank1FluidLvl = 0 AND gTanks.Status.Tank2FluidLvl = 0 AND gTanks.Status.Tank3FluidLvl = 0 THEN
			Tank1Save := 0;
			Tank2Save := 0;
		END_IF
 
		IF gTanks.Commands.OpenTank3LeftValve > 0 THEN
			ProgressBarPaintManual := FALSE;
		END_IF
 
		IF gTanks.Commands.OpenTank3RightValve > 0 THEN
			ProgressBarWaterManual := FALSE;
		END_IF
		//Reset mixercheck for every start click
		IF gTanks.Status.Tank3FluidLvl = 0 
			OR UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND RValveCheck
			OR UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND RValveCheck
			OR UINT_TO_BOOL(gTanks.Status.IsMixer1On) AND LValveCheck
			OR UINT_TO_BOOL(gTanks.Status.IsMixer2On) AND LValveCheck THEN
			MixerCheck := FALSE;
			ProgressBarNotMixedManual := FALSE;
			ProgressBarPaintManual := FALSE;
			ProgressBarWaterManual := FALSE;
		END_IF
	END_IF
END_PROGRAM
 
PROGRAM _EXIT
 
END_PROGRAM