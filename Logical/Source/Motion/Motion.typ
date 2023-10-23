
TYPE
	Mixer1OutputsType : 	STRUCT 
		PowerOn : BOOL;
		MoveActive : BOOL;
		MoveDone : BOOL;
		Error : BOOL;
		UpdateDone : BOOL;
		InVelocity : BOOL;
		InPosition : BOOL;
		Stopped : BOOL;
		Velocity : REAL;
		Position : REAL;
	END_STRUCT;
	Mixer1InputsType : 	STRUCT 
		MoveVelocity : BOOL;
		MoveAdditive : BOOL;
		MoveAbsolute : BOOL;
		Update : BOOL;
	END_STRUCT;
	Mixer1ParametersType : 	STRUCT 
		Velocity : REAL;
		Distance : REAL;
		Position : REAL;
		Acceleration : REAL;
		Deceleration : REAL;
		Direction : INT;
		Stop_Deceleration : REAL;
	END_STRUCT;
END_TYPE
