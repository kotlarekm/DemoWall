//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task resposible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	// Controller init
	MpTempController_0.MpLink := ADR(gTempController_0);
	MpTempController_0.Parameters := ADR(MpTempControllerParType_0);
	MpTempController_0.Enable := TRUE;
	MpTempController_0.Control := TRUE;
	MpTempController_0();
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Prameters update
	MpTempController_0.ActualTemperature := INT_TO_REAL(gTanks.Status.Tank3Temp) / IntToRealScaller;
	MpTempController_0.SetTemperature := gTanks.ObjectParameters.Tank3TargetTemp;
	//gTanks.Commands.TurnOnHeater := MpTempController_0.Heat;
	//gTanks.Commands.TurnOnFan := MpTempController_0.Cool;
	
	IF NOT(MpTempController_0.Update) THEN
		MpTempController_0.Update := TRUE;
	ELSIF MpTempController_0.UpdateDone THEN
		MpTempController_0.Update := FALSE;
	END_IF;
	
	// FB updates
	MpTempController_0();
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpTempController_0.Enable := FALSE;
	MpTempController_0();
	 
END_PROGRAM

