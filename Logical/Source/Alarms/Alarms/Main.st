//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 21.08.2023
// Description: Task responsible for handling alarms.
//***********************************************************************

PROGRAM _INIT

	TON_LED_ON.PT := TON_PT;
	TON_LED_OFF.PT := TON_PT;
	
	// MpAlarmXCore init
	MpAlarmXCore_0.MpLink := ADR(gAlarmXCore);
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXCore_0();
	
	// MpAlarmXHistory init
	MpAlarmXHistory_0.MpLink := ADR(gAlarmXHistory);
	MpAlarmXHistory_0.DeviceName := ADR('PLC');
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXHistory_0();
	 

END_PROGRAM

PROGRAM _CYCLIC
	 
	// Updates
	MpAlarmXCore_0();
	MpAlarmXHistory_0();
	
	IF ClearHistory THEN
		MpAlarmXClearHistory(gAlarmXHistory);
	  	ClearHistory := FALSE;
	END_IF;
	 
	// Reset button
	doReset := diReset;
	
	// Reset LED
	IF NOT(gDriveStop) AND NOT(diEStopNotPressed) THEN
		doResetRedLED := TRUE;
		TON_LED_OFF_FirstCounting := FALSE;
		
	ELSIF NOT(gDriveStop) AND diEStopNotPressed THEN
		doResetRedLED := FALSE;
		IF NOT(TON_LED_OFF_FirstCounting) THEN
			TON_LED_OFF_FirstCounting := TRUE;
			TON_LED_OFF.IN := 1;
		END_IF
		IF TON_LED_OFF.Q THEN
			TON_LED_ON.IN := 1;
			TON_LED_OFF.IN := 0;
			doResetOrangeLED := TRUE;
		END_IF;
		IF TON_LED_ON.Q THEN
			TON_LED_ON.IN := 0;
			TON_LED_OFF.IN := 1;
			doResetOrangeLED := FALSE;
		END_IF;
		
	ELSE 
		TON_LED_ON.IN := 0;
		TON_LED_OFF.IN := 0;
		doResetRedLED := FALSE;
		doResetOrangeLED := FALSE;
	END_IF
		
	TON_LED_ON();
	TON_LED_OFF();
	
	
	// Alarm E-stop
	IF NOT(diEStopNotPressed) THEN
		MpAlarmXSet(gAlarmXCore, 'E-stop');
	END_IF
	
	IF diEStopNotPressed THEN
		MpAlarmXReset(gAlarmXCore, 'E-stop');
	END_IF
	
	// Set style to navigation button in top content
	IF MpAlarmXCore_0.ActiveAlarms >= 1 THEN
		AlarmIsActive := 1;//red style
		AlarmButtonVisible := 1;
	ELSIF MpAlarmXCore_0.ActiveAlarms = 0 AND MpAlarmXCore_0.PendingAlarms >= 1 THEN
		AlarmIsActive := 2;//orange style
		AlarmButtonVisible := 1;
	ELSE
		AlarmIsActive := 0;//anvisible
	END_IF;
	
	
END_PROGRAM

PROGRAM _EXIT
	
	MpAlarmXCore_0.Enable := FALSE;
	MpAlarmXCore_0();
	
	MpAlarmXHistory_0.Enable := FALSE;
	MpAlarmXHistory_0();
	 
END_PROGRAM

