
TYPE
	CommadsType : 	STRUCT 
		TurnOnMixer1 : BOOL := FALSE;
		TurnOnMixer2 : BOOL := FALSE;
		OpenTank1Valve : BOOL := FALSE;
		OpenTank2Valve : BOOL := FALSE;
		OpenTank3LeftValve : UINT := 0;
		OpenTank3RightValve : UINT := 0;
		OpenTank3MainValve : BOOL := FALSE;
	END_STRUCT;
	ObjectParamteresType : 	STRUCT 
		Tank3MaxAllowedPressure : INT;
		Tank3MaxAllowedTemp : SINT;
		Tank3LeftValveOpeningLvl : UINT := 0;
		Tank3RightValveOpeningLvl : UINT := 0;
		MixingTime : TIME := T#0s;
		Mixer2On : BOOL := FALSE;
		Mixer1On : BOOL := FALSE;
		Tank3TargetFluidLvl : REAL;
		Tank2TargetFluidLvl : REAL;
		Tank1TargetFluidLvl : REAL;
		Tank3MaxAllowedFluidLvl : REAL;
		Tank2MaxAllowedFluidLvl : REAL;
		Tank1MaxAllowedFluidLvl : REAL;
	END_STRUCT;
	StatusType : 	STRUCT 
		IsMixer1On : BOOL;
		IsMixer2On : BOOL;
		Tank1FluidLvl : REAL;
		Tank2FluidLvl : REAL;
		Tank3FluidLvl : REAL;
		Tank1Pressure : REAL;
		Tank2Pressure : REAL;
		Tank3Pressure : REAL;
		Tank1Temp : INT;
		Tank2Temp : INT;
		Tank3Temp : INT;
	END_STRUCT;
	TanksType : 	STRUCT 
		Commands : CommadsType;
		ObjectParameters : ObjectParamteresType;
		Status : StatusType;
	END_STRUCT;
END_TYPE
