//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task resposible for temperature control.
//***********************************************************************

// OSC PID parameters
// Heat / Cool
// ProportionalGain 32.50824
// Integrationtime 85.1532
// DerivativeTime 10.2183838
// FilterTime 1.02183843
// IntegratorPreloading -0.07599998

PROGRAM _INIT
	
	gTanks;
	
	// Controller init
	MpTempController_0.MpLink := ADR(gTempController_0);
	MpTempController_0.Parameters := ADR(MpTempControllerParType_0);
	MpTempController_0.Enable := TRUE;
	MpTempController_0();
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Temp measurement
	TempInReal := INT_TO_REAL(gTanks.Status.Tank3Temp) / IntToRealScaller;
	
	IF ManualON THEN
		
		MpTempController_0.Control := FALSE;
		
		// Fan PWM
		MTBasicsPWMFan.Enable := TRUE;
		IF UpdateFanPWM THEN
			MTBasicsPWMFan.Update := TRUE;
			MTBasicsPWMFan.DutyCycle := FanPWMDuty;
			IF MTBasicsPWMFan.UpdateDone THEN
				UpdateFanPWM := FALSE;
				MTBasicsPWMFan.Update := FALSE;
			END_IF;
		END_IF;
		gTanks.Commands.TurnOnFan := MTBasicsPWMFan.Out;
		
		// Heater PWM
		MTBasicsPWMHeater.Enable := TRUE;
		IF UpdateHeaterPWM THEN
			MTBasicsPWMHeater.Update := TRUE;
			MTBasicsPWMHeater.DutyCycle := HeaterPWMDuty;
			IF MTBasicsPWMHeater.UpdateDone THEN
				UpdateHeaterPWM := FALSE;
				MTBasicsPWMHeater.Update := FALSE;
			END_IF;
		END_IF
		gTanks.Commands.TurnOnHeater := MTBasicsPWMHeater.Out;
		
	ELSE
		
		MTBasicsPWMFan.Enable := FALSE;
		MTBasicsPWMHeater.Enable := FALSE;
		MpTempController_0.Control := TRUE;
		
		// Prameters and outputs update
		MpTempController_0.ActualTemperature := TempInReal;
		MpTempController_0.SetTemperature := gTanks.ObjectParameters.Tank3TargetTemp;
		gTanks.Commands.TurnOnHeater := MpTempController_0.Heat;
		gTanks.Commands.TurnOnFan := MpTempController_0.Cool;
		
	END_IF;
	
	MpTempController_0.ActualTemperature := TempInReal;
	MpTempController_0.SetTemperature := gTanks.ObjectParameters.Tank3TargetTemp;
	gTanks.Commands.TurnOnHeater := MpTempController_0.Heat;
	gTanks.Commands.TurnOnFan := MpTempController_0.Cool;
	
	// FB updates
	MpTempController_0();
	MTBasicsPWMFan();
	MTBasicsPWMHeater();
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpTempController_0.Enable := FALSE;
	MpTempController_0();
	 
END_PROGRAM

