
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
		Tank1FluidLvl : UINT;
		Tank2FluidLvl : UINT;
		Tank3FluidLvl : UINT;
		Tank1Pressure : INT;
		Tank2Pressure : INT;
		Tank3Pressure : INT;
		Tank1Temp : INT;
		Tank2Temp : INT;
		Tank3Temp : INT;
	END_STRUCT;
	SelectedParametersType : 	STRUCT 
		Tank3MaxAllowedPressure : INT;
		Tank3MaxAllowedTemp : SINT;
		Tank3LeftValveOpeningLvl : UINT := 0;
		Tank3RightValveOpeningLvl : UINT := 0;
		MixingTime : TIME := T#0s;
		Mixer2On : BOOL := FALSE;
		Mixer1On : BOOL := FALSE;
		Tank3TargetFluidLvl : UINT;
		Tank2TargetFluidLvl : UINT;
		Tank1TargetFluidLvl : UINT;
	END_STRUCT;
	StatusType : 	STRUCT 
		IsMikser1On : BOOL;
		IsMikser2On : BOOL;
	END_STRUCT;
	TanksType : 	STRUCT 
		Commands : CommadsType;
		ObjectParameters : ObjectParamteresType;
		Status : StatusType;
	END_STRUCT;
END_TYPE
