
TYPE
	CommadsType : 	STRUCT 
		TurnOnMixer1 : BOOL;
		TurnOnMixer2 : BOOL;
		OpenTank1Valve : BOOL := FALSE;
		OpenTank2Valve : BOOL := FALSE;
		OpenTank3LeftValve : UINT := 0;
		OpenTank3RightValve : UINT := 0;
		OpenTank3MainValve : BOOL := FALSE;
		Start : BOOL;
		Stop : BOOL;
		TurnOnHeater : BOOL := FALSE;
		TurnOnFan : BOOL := FALSE;
	END_STRUCT;
	ParametersType : 	STRUCT 
		ObjectType : ObjectType;
		Tank3MaxAllowedPressure : INT;
		Tank3MaxAllowedTemp : SINT;
		Tank3LeftValveOpeningLvl : UINT := 0;
		Tank3RightValveOpeningLvl : UINT;
		MixingTime : UDINT;
		Mixer2On : UINT;
		Mixer1On : UINT;
		Tank3TargetFluidLvl : REAL;
		Tank2TargetFluidLvl : REAL;
		Tank1TargetFluidLvl : REAL;
		Tank3MaxAllowedFluidLvl : INT;
		Tank2MaxAllowedFluidLvl : INT;
		Tank1MaxAllowedFluidLvl : INT;
		Mixer1MaxAllowedVelocity : INT;
		Mixer2MaxAllowedVelocity : INT;
		Tank3TargetTemp : REAL := 33.3;
		Tank3TargetPressure : REAL;
		InertialTermTimeConstant : REAL;
		InertialTermGain : REAL;
	END_STRUCT;
	ObjectType : 	STRUCT 
		Mode : UINT;
	END_STRUCT;
	StatusType : 	STRUCT 
		IsMixer1On : UINT;
		IsMixer2On : UINT;
		Tank1FluidLvl : REAL;
		Tank2FluidLvl : REAL;
		Tank3FluidLvl : REAL;
		Tank1Pressure : REAL;
		Tank2Pressure : REAL;
		Tank3Pressure : REAL;
		Tank1Temp : INT;
		Tank2Temp : INT;
		Tank3Temp : INT;
		Step : STEP_ENUM;
	END_STRUCT;
	TanksType : 	STRUCT 
		Commands : CommadsType;
		Parameters : ParametersType;
		Status : StatusType;
	END_STRUCT;
	STEP_ENUM : 
		(
		START,
		FILLING_TANKS_1_AND_2,
		FILLING_TANK_3,
		MIXING,
		END
		);
END_TYPE
