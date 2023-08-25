//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 24.08.2023
// Description: Task responsible for handling inputs and outputs.
//***********************************************************************

PROGRAM _INIT
	
	 
END_PROGRAM

PROGRAM _CYCLIC
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
	
	// 
	aoDisplay1 := aiKnob1;
	aoDisplay2 := aiKnob2;
	
	//
	aoValueToDisplay1 := aiKnob1 * 9.8 / 32767;
	aoValueToDisplay2 := aiKnob2 * 10 / 32767;
END_PROGRAM

PROGRAM _EXIT
	
	 
END_PROGRAM

