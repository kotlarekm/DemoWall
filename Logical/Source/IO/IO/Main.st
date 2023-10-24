//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 24.08.2023
// Description: Task responsible for handling inputs and outputs.
//***********************************************************************

PROGRAM _INIT
	TON_RoundButton1Vis.PT := TON_PT;
	TON_RoundButton2Vis.PT := TON_PT;
	TON_RoundButton3Vis.PT := TON_PT;
	TON_RoundButton4Vis.PT := TON_PT;
	TON_RoundButton5Vis.PT := TON_PT;
	TON_ResetButtonVis.PT := TON_PT_ResetButton;
END_PROGRAM

PROGRAM _CYCLIC
	// Value assignment
	TurnOnHeater;
	TurnOnFan;
	//gTanks.Status.Tank3Temp := Tank3Temp;
	
	// Handling inputs and outputs
	doLamp1 := diSwitch1;
	doLamp2 := diSwitch2;
	doLamp3 := diSwitch3;
	doLamp4 := diSwitch4;
	doLamp5 := diSwitch5;
	doLamp6 := diSwitch6;
	doLamp7 := diSwitch7;
	doLamp8 := diSwitch8;
	
	// Down button visibility
	diSwitch1Down := NOT(diSwitch1);
	diSwitch2Down := NOT(diSwitch2);
	diSwitch3Down := NOT(diSwitch3);
	diSwitch4Down := NOT(diSwitch4);
	diSwitch5Down := NOT(diSwitch5);
	diSwitch6Down := NOT(diSwitch6);
	diSwitch7Down := NOT(diSwitch7);
	diSwitch8Down := NOT(diSwitch8);
	
	// Giving a value to the output
	aoDisplay1 := aiKnob1;
	aoDisplay2 := aiKnob2;
	
	// Converting values to display
	aoValueToDisplay1 := aiKnob1 * DisplayMaxValue / KnobMaxValue;
	aoValueToDisplay2 := aiKnob2 * DisplayMaxValue / KnobMaxValue;
	
	// Round buttons lighting up after clicking in teh visualization and device
	IF RoundButton1Vis THEN
		TON_RoundButton1Vis.IN := TRUE;
	END_IF
	IF TON_RoundButton1Vis.Q THEN
		TON_RoundButton1Vis.IN := FALSE;
		RoundButton1Vis := FALSE;
	END_IF
	IF RoundButton2Vis THEN
		TON_RoundButton2Vis.IN := TRUE;
	END_IF
	IF TON_RoundButton2Vis.Q THEN
		TON_RoundButton2Vis.IN := FALSE;
		RoundButton2Vis := FALSE;
	END_IF
	IF RoundButton3Vis THEN
		TON_RoundButton3Vis.IN := TRUE;
	END_IF
	IF TON_RoundButton3Vis.Q THEN
		TON_RoundButton3Vis.IN := FALSE;
		RoundButton3Vis := FALSE;
	END_IF
	IF RoundButton4Vis THEN
		TON_RoundButton4Vis.IN := TRUE;
	END_IF
	IF TON_RoundButton4Vis.Q THEN
		TON_RoundButton4Vis.IN := FALSE;
		RoundButton4Vis := FALSE;
	END_IF
	IF RoundButton5Vis THEN
		TON_RoundButton5Vis.IN := TRUE;
	END_IF
	IF TON_RoundButton5Vis.Q THEN
		TON_RoundButton5Vis.IN := FALSE;
		RoundButton5Vis := FALSE;
	END_IF
	IF ResetButtonVis THEN
		TON_ResetButtonVis.IN := TRUE;
	END_IF
	IF TON_ResetButtonVis.Q THEN
		TON_ResetButtonVis.IN := FALSE;
		ResetButtonVis := FALSE;
	END_IF
	
	TON_RoundButton1Vis();
	TON_RoundButton2Vis();
	TON_RoundButton3Vis();
	TON_RoundButton4Vis();
	TON_RoundButton5Vis();
	TON_ResetButtonVis();
	
	R_TRIG_RoundButton1Vis(CLK := RoundButton1Vis);
	R_TRIG_RoundButton2Vis(CLK := RoundButton2Vis);
	R_TRIG_RoundButton3Vis(CLK := RoundButton3Vis);
	R_TRIG_RoundButton4Vis(CLK := RoundButton4Vis);
	R_TRIG_RoundButton5Vis(CLK := RoundButton5Vis);
	
	R_TRIG_RoundButton1(CLK := diRoundButton1);
	R_TRIG_RoundButton2(CLK := diRoundButton2);
	R_TRIG_RoundButton3(CLK := diRoundButton3);
	R_TRIG_RoundButton4(CLK := diRoundButton4);
	R_TRIG_RoundButton5(CLK := diRoundButton5);
	
	// Activation of the function block depending on the pressed button
	IF R_TRIG_RoundButton1.Q OR R_TRIG_RoundButton1Vis.Q THEN
		ChangeButtonColor_0(ButtonNumber := 1);
	ELSIF R_TRIG_RoundButton2.Q OR R_TRIG_RoundButton2Vis.Q THEN
		ChangeButtonColor_0(ButtonNumber := 2);
	ELSIF R_TRIG_RoundButton3.Q OR R_TRIG_RoundButton3Vis.Q THEN
		ChangeButtonColor_0(ButtonNumber := 3);
	ELSIF R_TRIG_RoundButton4.Q OR R_TRIG_RoundButton4Vis.Q THEN
		ChangeButtonColor_0(ButtonNumber := 4);
	ELSIF R_TRIG_RoundButton5.Q OR R_TRIG_RoundButton5Vis.Q THEN
		ChangeButtonColor_0(ButtonNumber := 5);
	END_IF
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

