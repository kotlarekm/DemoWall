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
 
	IF gTanks.Commands.OpenTank1Valve AND gTanks.Status.Tank1FluidLvl < gTanks.ObjectParameters.Tank1TargetFluidLvl THEN
		IF NOT TON_1.IN THEN 
			TON_1(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_1.Q THEN
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + POURED_WATER_TO_TANK;
			TON_1(IN := FALSE);  
		END_IF
 
		WaterFixTank1 := gTanks.Status.Tank1FluidLvl - gTanks.ObjectParameters.Tank1TargetFluidLvl;
 
		IF gTanks.Status.Tank1FluidLvl > gTanks.ObjectParameters.Tank1TargetFluidLvl THEN
			gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl - WaterFixTank1;
		END_IF
 
		IF gTanks.Status.Tank1FluidLvl >= gTanks.ObjectParameters.Tank1TargetFluidLvl THEN
			gTanks.Commands.OpenTank1Valve := FALSE;
		END_IF
	END_IF
 
	TON_1();
 
	IF gTanks.Commands.OpenTank2Valve AND gTanks.Status.Tank2FluidLvl < gTanks.ObjectParameters.Tank2TargetFluidLvl THEN
		IF NOT TON_2.IN THEN 
			TON_2(IN := TRUE, PT := T#50ms);
		END_IF
 
		IF TON_2.Q THEN
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + POURED_WATER_TO_TANK;
			TON_2(IN := FALSE);  
		END_IF
 
		WaterFixTank2 := gTanks.Status.Tank2FluidLvl - gTanks.ObjectParameters.Tank2TargetFluidLvl;
 
		IF gTanks.Status.Tank2FluidLvl > gTanks.ObjectParameters.Tank2TargetFluidLvl THEN
			gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl - WaterFixTank2;
		END_IF
 
		IF gTanks.Status.Tank2FluidLvl >= gTanks.ObjectParameters.Tank2TargetFluidLvl THEN
			gTanks.Commands.OpenTank2Valve := FALSE;
		END_IF
	END_IF
 
	TON_2();
 
	IF UINT_TO_BOOL(gTanks.Commands.OpenTank3LeftValve) AND gTanks.Status.Tank3FluidLvl <= gTanks.ObjectParameters.Tank3TargetFluidLvl THEN
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
 
		IF gTanks.Status.Tank3FluidLvl >= gTanks.ObjectParameters.Tank3TargetFluidLvl OR gTanks.Status.Tank1FluidLvl <= 0  THEN
			gTanks.Commands.OpenTank3LeftValve := FALSE;
			gTanks.Commands.OpenTank1Valve := FALSE;
		END_IF
	END_IF
 
	IF gTanks.Status.Tank1FluidLvl > 0 
		AND gTanks.Status.Tank3FluidLvl > gTanks.ObjectParameters.Tank3TargetFluidLvl 
		AND gTanks.Commands.OpenTank3LeftValve = 0 THEN
		gTanks.Status.Tank1FluidLvl := gTanks.Status.Tank1FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.ObjectParameters.Tank3TargetFluidLvl);
		gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.ObjectParameters.Tank3TargetFluidLvl);
	END_IF
 
	TON_3();
 
	IF UINT_TO_BOOL(gTanks.Commands.OpenTank3RightValve) AND gTanks.Status.Tank3FluidLvl <= gTanks.ObjectParameters.Tank3TargetFluidLvl THEN
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
 
		IF gTanks.Status.Tank3FluidLvl >= gTanks.ObjectParameters.Tank3TargetFluidLvl OR gTanks.Status.Tank2FluidLvl <= 0 THEN
			gTanks.Commands.OpenTank3RightValve := FALSE;
			gTanks.Commands.OpenTank2Valve := FALSE;
		END_IF
	END_IF
 
	IF gTanks.Status.Tank2FluidLvl > 0 
		AND gTanks.Status.Tank3FluidLvl > gTanks.ObjectParameters.Tank3TargetFluidLvl 
		AND gTanks.Commands.OpenTank3RightValve = 0 THEN
		gTanks.Status.Tank2FluidLvl := gTanks.Status.Tank2FluidLvl + (gTanks.Status.Tank3FluidLvl - gTanks.ObjectParameters.Tank3TargetFluidLvl);
		gTanks.Status.Tank3FluidLvl := gTanks.Status.Tank3FluidLvl - (gTanks.Status.Tank3FluidLvl - gTanks.ObjectParameters.Tank3TargetFluidLvl);
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
 
END_PROGRAM
 
PROGRAM _EXIT
 
END_PROGRAM