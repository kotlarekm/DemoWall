//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 29.08.2023
// Description: Task resposible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	// MTBasicsPT1 init
	MTBasicsPT1_0.Enable := TRUE;
	MTBasicsPT1_0();
	
END_PROGRAM

PROGRAM _CYCLIC
	
	// Gain / TimeConstant / In / Out
	MTBasicsPT1_0.Gain := gTanks.Parameters.InertialTermGain;
	MTBasicsPT1_0.TimeConstant := gTanks.Parameters.InertialTermTimeConstant;
	MTBasicsPT1_0.In := gTanks.Parameters.Tank3TargetPressure;
	gTanks.Status.Tank3Pressure := MTBasicsPT1_0.Out;
	MTBasicsPT1_0.Update := TRUE;
	MTBasicsPT1_0();
	
END_PROGRAM

PROGRAM _EXIT
	
	MTBasicsPT1_0.Enable := FALSE;
	MTBasicsPT1_0();
	
END_PROGRAM

