//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task responsible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	gTanks;
	
	// Controller init
	MpTempController_0.MpLink := ADR(gTempController_0);
	MpTempController_0.Parameters := ADR(MpTempControllerParType_0);
	MpTempController_0.Enable := TRUE;
	MpTempController_0();
	
	// PWM blocks init
	MTBasicsPWMFan.DutyCycle := 0;
	MTBasicsPWMFan.Enable := TRUE;
	MTBasicsPWMFan.Period := 0.005;
	MTBasicsPWMFan.MinPulseWidth := 0.002;
	MTBasicsPWMFan();
	
	MTBasicsPWMHeater.DutyCycle := 0;
	MTBasicsPWMHeater.Enable := TRUE;
	MTBasicsPWMHeater.Period := 0.005;
	MTBasicsPWMHeater();
	
	// Displayed parameters init using parameters from regulator
	MpTempControllerParType_1 := MpTempControllerParType_0;
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	// Value assignment
	TurnOnHeater := gTanks.Commands.TurnOnHeater;
	TurnOnFan := gTanks.Commands.TurnOnFan;
	gTanks.Status.Tank3Temp := Tank3Temp;
	
	// Temp measurement
	TempInReal := INT_TO_REAL(gTanks.Status.Tank3Temp) / IntToRealScaller;
	
	IF gDriveStop THEN
		
		MTBasicsPWMFan.Enable := TRUE;
		MTBasicsPWMHeater.Enable := TRUE;
		
		// Temp control widgets
		TempControlWidgetsEnable := TRUE;
		
		// Auto-tuning
		IF AutoTune THEN
		
			MpTempController_0.Control := FALSE;
			MpTempController_0.ActualTemperature := TempInReal;
			MpTempController_0.SetTemperature := gTanks.Parameters.Tank3TargetTemp;
			MTBasicsPWMFan.DutyCycle := MpTempController_0.CoolValue;
			MTBasicsPWMHeater.DutyCycle := MpTempController_0.HeatValue;
			MpTempController_0.Tune := TRUE;
			InfoLabelIndex := 2;
	
			// Checking if tunig is done
			IF MpTempController_0.TuningDone THEN
				MpTempController_0.Tune := FALSE;
				AutoTune := FALSE;
				ShowTuningDoneDialog := TRUE;
				
				// Applying parameters to controller
				CASE MpTempControllerParType_0.Tuning.Mode OF
					mpTEMP_TUNING_MODE_HEAT:
						
						MpTempControllerParType_0.PID.Heat := MpTempController_0.Info.Tuning.PIDParameters.Heat;
						MpTempControllerParType_0.Profile.Heat := MpTempController_0.Info.Tuning.ProfileParameters.Heat;
						
					mpTEMP_TUNING_MODE_HEAT_COOL:
						
						MpTempControllerParType_0.PID := MpTempController_0.Info.Tuning.PIDParameters;
						MpTempControllerParType_0.Profile.Cool := MpTempController_0.Info.Tuning.ProfileParameters.Cool;
						MpTempControllerParType_0.Profile.Heat := MpTempController_0.Info.Tuning.ProfileParameters.Heat;
						
					mpTEMP_TUNING_MODE_OSC_HEAT:
						
						MpTempControllerParType_0.PID.Heat := MpTempController_0.Info.Tuning.PIDParameters.Heat;
						MpTempControllerParType_0.Profile.Heat := MpTempController_0.Info.Tuning.ProfileParameters.Heat;
						
					mpTEMP_TUNING_MODE_OSC_HEAT_COOL:
						
						MpTempControllerParType_0.PID := MpTempController_0.Info.Tuning.PIDParameters;
						MpTempControllerParType_0.Profile.Cool := MpTempController_0.Info.Tuning.ProfileParameters.Cool;
						MpTempControllerParType_0.Profile.Heat := MpTempController_0.Info.Tuning.ProfileParameters.Heat;
						
					mpTEMP_TUNING_MODE_OSC_COOL:
					
						MpTempControllerParType_0.PID.Cool := MpTempController_0.Info.Tuning.PIDParameters.Cool;
						MpTempControllerParType_0.Profile.Cool := MpTempController_0.Info.Tuning.ProfileParameters.Cool;
					
				END_CASE;

				MpTempControllerParType_1 := MpTempControllerParType_0;
				MpTempController_0.Update := TRUE;
				
			END_IF;
	
			// Manual mode
		ELSIF ManualON THEN
		
			MpTempController_0.Control := FALSE;
			MpTempController_0.Tune := FALSE;
			InfoLabelIndex := 1;
			
			// Fan PWM
			MTBasicsPWMFan.DutyCycle := FanPWMDuty;
		
			// Heater PWM
			MTBasicsPWMHeater.DutyCycle := HeaterPWMDuty;
	
			// Auto mode
		ELSE
		
			MpTempController_0.Control := TRUE;
			MpTempController_0.Tune := FALSE;
			InfoLabelIndex := 0;
		
			// Prameters and outputs update
			MpTempController_0.ActualTemperature := TempInReal;
			MpTempController_0.SetTemperature := gTanks.Parameters.Tank3TargetTemp;
			MTBasicsPWMHeater.DutyCycle := MpTempController_0.HeatValue;
			MTBasicsPWMFan.DutyCycle := MpTempController_0.CoolValue;
		
		END_IF;
		
	// Emergency button pressed
	ELSE
		gTanks.Commands.TurnOnFan := FALSE;
		gTanks.Commands.TurnOnHeater := FALSE;
		HeaterPWMDuty := 0;
		FanPWMDuty := 0;
		MpTempController_0.Tune := FALSE;
		MpTempController_0.Control := FALSE;
		ManualON := FALSE;
		AutoTune := FALSE;
		MTBasicsPWMFan.Enable := FALSE;
		MTBasicsPWMHeater.Enable := FALSE;
		InfoLabelIndex := 3;
		
		// Temp control widgets
		TempControlWidgetsEnable := FALSE;
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
	
	// Controller update done
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
	
	// PWM update
	IF MTBasicsPWMHeater.UpdateDone THEN
		MTBasicsPWMHeater.Update := TRUE;
	ELSE
		MTBasicsPWMHeater.Update := FALSE;
	END_IF;
	
	IF MTBasicsPWMFan.UpdateDone THEN
		MTBasicsPWMFan.Update := TRUE;
	ELSE
		MTBasicsPWMFan.Update := FALSE;
	END_IF;
	
	// Outputs update
	gTanks.Commands.TurnOnFan := MTBasicsPWMFan.Out;
	gTanks.Commands.TurnOnHeater := MTBasicsPWMHeater.Out;
	
	// FB updates
	MpTempController_0();
	MTBasicsPWMFan();
	MTBasicsPWMHeater();
	 
END_PROGRAM

PROGRAM _EXIT
	
	// FB exit actions
	MpTempController_0.Enable := FALSE;
	MpTempController_0();
	
	MTBasicsPWMFan.Enable := FALSE;
	MTBasicsPWMFan();
	
	MTBasicsPWMHeater.Enable := FALSE;
	MTBasicsPWMHeater();
	 
END_PROGRAM

