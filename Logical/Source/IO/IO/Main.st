//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 24.08.2023
// Description: Task responsible for handling inputs and outputs.
//***********************************************************************

PROGRAM _INIT
	
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
	
	
	// Initialization of the edge detecting block
	R_TRIG_RoundButton1(CLK := diRoundButton1);
	R_TRIG_RoundButton2(CLK := diRoundButton2);
	R_TRIG_RoundButton3(CLK := diRoundButton3);
	R_TRIG_RoundButton4(CLK := diRoundButton4);
	R_TRIG_RoundButton5(CLK := diRoundButton5);
	
	// Activation of the function block depending on the pressed button
	IF R_TRIG_RoundButton1.Q THEN
		ChangeButtonColor_0(ButtonNumber := 1);
	ELSIF R_TRIG_RoundButton2.Q THEN
		ChangeButtonColor_0(ButtonNumber := 2);
	ELSIF R_TRIG_RoundButton3.Q THEN
		ChangeButtonColor_0(ButtonNumber := 3);
	ELSIF R_TRIG_RoundButton4.Q THEN
		ChangeButtonColor_0(ButtonNumber := 4);
	ELSIF R_TRIG_RoundButton5.Q THEN
		ChangeButtonColor_0(ButtonNumber := 5);
	END_IF
	
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

