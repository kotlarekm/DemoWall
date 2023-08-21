//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 21.08.2023
// Description: Task resposible for handling alarms.
//***********************************************************************

PROGRAM _INIT
	
	// MpAlarmXCore init
	MpAlarmXCore_0.MpLink := ADR('gAlarmXCore');
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0();
	
	// MpAlarmXHistory init
	MpAlarmXHistory_0.MpLink := ADR('gAlarmXHistory');
	MpAlarmXHistory_0.DeviceName := ADR('HDD');
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXHistory_0();
	 
END_PROGRAM

	// Updates
	MpAlarmXCore_0();
	MpAlarmXHistory_0();

PROGRAM _CYCLIC
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpAlarmXCore_0.Enable := FALSE;
	MpAlarmXCore_0();
	
	MpAlarmXHistory_0.Enable := FALSE;
	MpAlarmXHistory_0();
	 
END_PROGRAM

