
TYPE
	StepEnum : 
		( (*Automatic mode step enumerator*)
		STEP_INIT, (*Wait for power ON command*)
		STEP_POWER_ON, (*Wait for power ON status*)
		STEP_MOVE_VELOCITY, (*Wait for in  velocity status*)
		STEP_POWER_OFF, (*Wait for power OFF status*)
		STEP_RUNNING (*Wait for power OFF command*)
		);
	CouplingEnum : 
		( (*Manual mode coupling mode enumerator*)
		NO_COUPLING, (*Wait for coupling mode select*)
		GEAR_COUPLING, (*Wait for gear coupling OFF command*)
		CAM_COUPLING (*Wait for cam coupling OFF command*)
		);
END_TYPE
