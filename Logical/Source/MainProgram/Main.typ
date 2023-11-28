
TYPE
	CommadsType : 	STRUCT 
		TurnOnMixer1 : BOOL; (*Turning on mixer 1*)
		TurnOnMixer2 : BOOL; (*Turning on mixer 2*)
		OpenTank1Valve : BOOL := FALSE; (*Opening tank 1 valve*)
		OpenTank2Valve : BOOL := FALSE; (*Opening tank 2 valve*)
		OpenTank3LeftValve : UINT := 0; (*Opening tank 3 left valve*)
		OpenTank3RightValve : UINT := 0; (*Opening tank 3 right valve*)
		OpenTank3MainValve : BOOL := FALSE; (*Opening tank 3 main valve*)
		Start : BOOL; (*Starting a program*)
		Stop : BOOL; (*Stopping a program*)
		TurnOnHeater : BOOL := FALSE; (*Turning on a heater*)
		TurnOnFan : BOOL := FALSE; (*Turning on a fan*)
		EStop : BOOL;
	END_STRUCT;
	ParametersType : 	STRUCT 
		ObjectType : ObjectType; (*Substructure of ParametersType*)
		Tank3MaxAllowedPressure : REAL := 9; (*Max allowed pressure for tank 3*)
		Tank3MaxAllowedTemp : REAL := 45; (*Max allowed temperature for tank 3*)
		Tank3LeftValveOpeningLvl : UINT; (*Opening level to set for tank 3 left valve*)
		Tank3RightValveOpeningLvl : UINT; (*Opening level to set for tank 3 right valve*)
		MixingTime : UDINT; (*Mixing time to set*)
		Mixer1On : UINT; (*Mixer 1 status to set*)
		Mixer2On : UINT; (*Mixer 2 status to set*)
		Tank3TargetFluidLvl : REAL; (*Tank 3 target fluid level to set*)
		Tank2TargetFluidLvl : REAL; (*Tank 2 target fluid level to set*)
		Tank1TargetFluidLvl : REAL; (*Tank 1 target fluid level to set*)
		Tank3MaxAllowedFluidLvl : INT := 9000; (*Tank 3 max allowed fluid level to set*)
		Tank2MaxAllowedFluidLvl : INT := 9000; (*Tank 2 max allowed fluid level to set*)
		Tank1MaxAllowedFluidLvl : INT := 9000; (*Tank 1 max allowed fluid level to set*)
		Mixer1MaxAllowedVelocity : INT := 720; (*Mixer 1 max allowed velocity to set*)
		Mixer2MaxAllowedVelocity : INT := 720; (*Mixer 2 max allowed velocity to set*)
		Tank3TargetTemp : REAL := 33.3; (*Tank 3 target temperature to set*)
		Tank3TargetPressure : REAL; (*Tank 3 target pressure to set*)
		InertialTermTimeConstant : REAL := 5; (*Time constant to set for intertial term*)
		InertialTermGain : REAL := 1; (*Gain to set for intertial term*)
		HeatCool : BOOL; (*Heating and cooling in automatic temperature control mode / if not - only heating*)
	END_STRUCT;
	ObjectType : 	STRUCT 
		Mode : UINT;
	END_STRUCT;
	StatusType : 	STRUCT 
		IsMixer1On : UINT; (*Checking if mixer 1 is on*)
		IsMixer2On : UINT; (*Checking if mixer 2 is on*)
		Tank1FluidLvl : REAL; (*Checking tank 1 fluid level*)
		Tank2FluidLvl : REAL; (*Checking tank 2 fluid level*)
		Tank3FluidLvl : REAL; (*Checking tank 3 fluid level*)
		Tank3Pressure : REAL; (*Checking tank 3 pressure*)
		Tank3Temp : INT; (*Checking tank 3 temperature*)
		Step : STEP_ENUM; (*Steps in main program*)
	END_STRUCT;
	TanksType : 	STRUCT 
		Commands : CommadsType;
		Parameters : ParametersType;
		Status : StatusType;
	END_STRUCT;
	STEP_ENUM : 
		(
		START, (*Starting a program*)
		FILLING_TANKS_1_AND_2, (*Filling tanks 1 and 2*)
		FILLING_TANK_3, (*Filling tank 3*)
		MIXING, (*Mixing *)
		END (*Ending a program*)
		);
END_TYPE
