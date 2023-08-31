//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task resposible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	gTanks;
	
	// Controller init
	MpTempController_0.MpLink := ADR(gTempController_0);
	MpTempController_0.Parameters := ADR(MpTempControllerParType_0);
	MpTempController_0.Enable := TRUE;
	MpTempController_0();
	
	// Displayed parameters init using parameters from regulator
	MpTempControllerParType_1 := MpTempControllerParType_0;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Temp measurement
	TempInReal := INT_TO_REAL(gTanks.Status.Tank3Temp) / IntToRealScaller;
	
	IF gDriveStop THEN
		// Auto-tuning
		IF AutoTune THEN
		
			MpTempController_0.Control := FALSE;
			MpTempController_0.ActualTemperature := TempInReal;
			MpTempController_0.SetTemperature := gTanks.Parameters.Tank3TargetTemp;
			gTanks.Commands.TurnOnFan := MpTempController_0.Cool;
			gTanks.Commands.TurnOnHeater := MpTempController_0.Heat;
			MpTempController_0.Tune := TRUE;
	
			// Checking if tunig is done
			IF MpTempController_0.TuningDone THEN
				MpTempController_0.Tune := FALSE;
				AutoTune := FALSE;
				// Applying parameters to controller
				MpTempControllerParType_0.PID := MpTempController_0.Info.Tuning.PIDParameters;
				MpTempControllerParType_0.Profile.Cool := MpTempController_0.Info.Tuning.ProfileParameters.Cool;
				MpTempControllerParType_0.Profile.Heat := MpTempController_0.Info.Tuning.ProfileParameters.Heat;
				MpTempControllerParType_1 := MpTempControllerParType_0;
				MpTempController_0.Update := TRUE;
			END_IF;
	
			// Manual mode
		ELSIF ManualON THEN
		
			MpTempController_0.Control := FALSE;
			MpTempController_0.Tune := FALSE;
		
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
	
			// Auto mode
		ELSE
		
			MTBasicsPWMFan.Enable := FALSE;
			MTBasicsPWMHeater.Enable := FALSE;
			MpTempController_0.Control := TRUE;
			MpTempController_0.Tune := FALSE;
		
			// Prameters and outputs update
			MpTempController_0.ActualTemperature := TempInReal;
			MpTempController_0.SetTemperature := gTanks.Parameters.Tank3TargetTemp;
			gTanks.Commands.TurnOnHeater := MpTempController_0.Heat;
			gTanks.Commands.TurnOnFan := MpTempController_0.Cool;
		
		END_IF;
	
		// Apply settings
		IF ApplySettings THEN
			ApplySettings := FALSE;
			MpTempControllerParType_0 := MpTempControllerParType_1;
			MpTempController_0.Update := TRUE;
		END_IF;
	
		// Restore settings
		IF RestoreSettings THEN
			RestoreSettings := FALSE;
			MpTempControllerParType_1 := MpTempControllerParType_0;
			MpTempController_0.Update := TRUE;
		END_IF;
	
		// Controller update
		IF MpTempController_0.UpdateDone THEN
			MpTempController_0.Update := FALSE;
		END_IF;
	
		// Checking errors
		IF MpTempController_0.Error THEN
			MpTempController_0.Control := FALSE;
			MpTempController_0.Tune := FALSE;
		
			// some actions
		
			MpTempController_0.ErrorReset := TRUE;
		ELSE
			MpTempController_0.ErrorReset := FALSE;
		END_IF;
		
	// Emergency button pressed
	ELSE
		gTanks.Commands.TurnOnFan := FALSE;
		gTanks.Commands.TurnOnHeater := FALSE;
		HeaterPWMDuty := 0;
		FanPWMDuty := 0;
		MpTempController_0.Tune := FALSE;
		MpTempController_0.Control := FALSE;
	END_IF;
	
	// FB updates
	MpTempController_0();
	MTBasicsPWMFan();
	MTBasicsPWMHeater();
	 
END_PROGRAM

PROGRAM _EXIT
	
	// FB exit actions
	MpTempController_0.Enable := FALSE;
	MpTempController_0();
	 
END_PROGRAM

