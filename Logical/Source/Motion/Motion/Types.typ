
TYPE
	StepEnum : 
		( (*Automatic mode step enumerator*)
		STEP_INIT, (*Waiting for turn ON command*)
		STEP_POWER_ON, (*Waiting for power ON status*)
		STEP_MOVE_VELOCITY, (*Waiting for in velocity status*)
		STEP_POWER_OFF, (*Waiting for power OFF status*)
		STEP_RUNNING (*Waiting for power OFF command*)
		);
	CouplingEnum : 
		( (*Manual mode coupling enumerator*)
		NO_COUPLING, (*No coupling*)
		GEAR_COUPLING, (*Gear coupling*)
		CAM_COUPLING (*Cam coupling*)
		);
END_TYPE
