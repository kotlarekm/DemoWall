
(* TODO: Add your comment here *)
FUNCTION_BLOCK ChangeButtonColor
	
	// Button counter increment
	RoundButton[ButtonNumber].Counter := RoundButton[ButtonNumber].Counter + 1;
	IF RoundButton[ButtonNumber].Counter = 4 THEN
		RoundButton[ButtonNumber].Counter := 0;
	END_IF
		
	// Button color change depending on the counter
	IF RoundButton[ButtonNumber].Counter = 0 THEN
		RoundButton[ButtonNumber].doRedLED := 0;
		RoundButton[ButtonNumber].doYellowLED := 0;
		RoundButton[ButtonNumber].doGreenLED := 0;
	ELSIF RoundButton[ButtonNumber].Counter = 1 THEN
		RoundButton[ButtonNumber].doRedLED := 1;
		RoundButton[ButtonNumber].doYellowLED := 0;
		RoundButton[ButtonNumber].doGreenLED := 0;
	ELSIF RoundButton[ButtonNumber].Counter = 2 THEN
		RoundButton[ButtonNumber].doRedLED := 0;
		RoundButton[ButtonNumber].doYellowLED := 1;
		RoundButton[ButtonNumber].doGreenLED := 0;
	ELSIF RoundButton[ButtonNumber].Counter = 3 THEN
		RoundButton[ButtonNumber].doRedLED := 0;
		RoundButton[ButtonNumber].doYellowLED := 0;
		RoundButton[ButtonNumber].doGreenLED := 1;
	END_IF
END_FUNCTION_BLOCK