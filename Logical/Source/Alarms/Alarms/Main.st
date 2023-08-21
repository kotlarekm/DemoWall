//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT
	(* Insert code here *)
	TON_LED_ON.PT := T#30ms;
	TON_LED_OFF.PT := T#30ms;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	 
	IF NOT(diDriveStop) AND NOT(diEStopNotPressed) THEN
		diResetRedLED := TRUE;
		
	ELSIF NOT(diDriveStop) AND diEStopNotPressed THEN
		diResetRedLED := FALSE;
		TON_LED_ON.IN := 1;
		IF TON_LED_ON.Q THEN
			TON_LED_ON.IN := 0;
			TON_LED_OFF.IN := 1;
			diResetOrangeLED := TRUE;
		END_IF;
		IF TON_LED_OFF.Q THEN
			TON_LED_ON.IN := 1;
			TON_LED_OFF.IN := 0;
			diResetOrangeLED := FALSE;
		END_IF;
		
	ELSE 
		TON_LED_ON.IN := 0;
		TON_LED_OFF.IN := 0;
		diResetRedLED := FALSE;
		diResetOrangeLED := FALSE;
	END_IF
		
	TON_LED_ON();
	TON_LED_OFF();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

