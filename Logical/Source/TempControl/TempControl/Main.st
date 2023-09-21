//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task responsible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	gTanks;
	
	// MpTempControllerConfig init
	MpTempControllerConfig_0.MpLink := ADR(gTempController_0);
	MpTempControllerConfig_0.Configuration := ADR(MpTempControllerConfigType_0);
	MpTempControllerConfig_0.Enable := TRUE;
	MpTempControllerConfig_0();
	
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
	
	// Only heating
	IF NOT(gTanks.Parameters.HeatCool) THEN	
		MpTempControllerConfigType_0.Type := mpTEMP_ZONE_TYPE_HEAT;
		MpTempControllerConfigType_0.SystemParameters.Heat.Gain := 1.97903;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant1 := 415.2267;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant2 := 15.1164656;
		MpTempControllerConfigType_0.SystemParameters.Heat.DelayTime := 7;
		MpTempControllerConfigType_0.SystemParameters.Cool.Gain := 0;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant1 := 0;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant2 := 0;
		MpTempControllerConfigType_0.SystemParameters.Cool.DelayTime := 0;
		 
		CASE StepHeat OF
			STEP_WAIT:
				IF ConfirmingHeatCoolOrHeat OR NOT(FirstUpload) THEN
					MpTempControllerParType_0.PID.Heat.ProportionalGain := 15.23996;
					MpTempControllerParType_0.PID.Heat.IntegrationTime := 74.8946152;
					MpTempControllerParType_0.PID.Heat.DerivativeTime := 7.86393452;
					MpTempControllerParType_0.PID.Heat.FilterTime := 0.786393464;
					MpTempControllerParType_0.PID.Cool.ProportionalGain := 0;
					MpTempControllerParType_0.PID.Cool.IntegrationTime := 0;
					MpTempControllerParType_0.PID.Cool.DerivativeTime := 0;
					MpTempControllerParType_0.PID.Cool.FilterTime := 0;
					MpTempControllerParType_0.PID.IntegratorPreloading := 0;
					MpTempControllerParType_0.Profile.Heat.SlewRate := 0.185037389;
					MpTempControllerParType_0.Profile.Heat.FilterTime := 77.42902;
					MpTempControllerParType_0.Profile.Heat.DelayTime := 7;
					MpTempControllerParType_0.Profile.Heat.QuickStart :=  FALSE;
					MpTempControllerParType_0.Profile.Cool.SlewRate := 0.03187467;
					MpTempControllerParType_0.Profile.Cool.FilterTime := 15.1164656;
					MpTempControllerParType_0.Profile.Cool.DelayTime := 7;
					MpTempControllerParType_0.Profile.Cool.QuickStart := FALSE;
					StepHeat := STEP_SAVE;
				END_IF
			
			STEP_SAVE:
				ConfirmingHeatCoolOrHeat := FALSE;
				FirstUpload := TRUE;
				MpTempControllerConfig_0.Save := TRUE;
				MpTempControllerParType_1 := MpTempControllerParType_0;
				IF MpTempControllerConfig_0.CommandDone THEN
					MpTempControllerConfig_0.Save := FALSE;
					StepHeat := STEP_UPDATE;
				END_IF
			
			STEP_UPDATE:
				MpTempController_0.Update := TRUE;
				IF MpTempController_0.UpdateDone THEN
					MpTempController_0.Update := FALSE;
					StepHeat := STEP_WAIT;
				END_IF
		END_CASE
		MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_HEAT;
		NameOfMode := 'Oscilation Heat';
	
	ELSIF gTanks.Parameters.HeatCool THEN // Heating and cooling
		MpTempControllerConfigType_0.Type := mpTEMP_ZONE_TYPE_HEAT_COOL;
		MpTempControllerConfigType_0.SystemParameters.Heat.Gain := 1.95778942;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant1 := 396.665375;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant2 := 16.8905449;
		MpTempControllerConfigType_0.SystemParameters.Heat.DelayTime := 5;
		MpTempControllerConfigType_0.SystemParameters.Cool.Gain := 0.00042889435;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant1 := 1.86782444;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant2 := 0;
		MpTempControllerConfigType_0.SystemParameters.Cool.DelayTime := 13;
		
		CASE StepHeatCool OF
			STEP_WAIT:
				IF ConfirmingHeatCoolOrHeat OR NOT(FirstUpload) THEN
					MpTempControllerParType_0.PID.Heat.ProportionalGain := 40;
					MpTempControllerParType_0.PID.Heat.IntegrationTime := 250;
					MpTempControllerParType_0.PID.Heat.DerivativeTime := 25;
					MpTempControllerParType_0.PID.Heat.FilterTime := 2.5;
					MpTempControllerParType_0.PID.Cool.ProportionalGain :=  40;
					MpTempControllerParType_0.PID.Cool.IntegrationTime :=  250;
					MpTempControllerParType_0.PID.Cool.DerivativeTime := 25;
					MpTempControllerParType_0.PID.Cool.FilterTime := 2.5;
					MpTempControllerParType_0.PID.IntegratorPreloading := -0.117142811;
					MpTempControllerParType_0.Profile.Heat.SlewRate := 0.180146277;
					MpTempControllerParType_0.Profile.Heat.FilterTime := 80.4640656;
					MpTempControllerParType_0.Profile.Heat.DelayTime := 6;
					MpTempControllerParType_0.Profile.Heat.QuickStart :=  FALSE;
					MpTempControllerParType_0.Profile.Cool.SlewRate := 0.1221704;
					MpTempControllerParType_0.Profile.Cool.FilterTime := 81.8528748;
					MpTempControllerParType_0.Profile.Cool.DelayTime := 15;
					MpTempControllerParType_0.Profile.Cool.QuickStart := FALSE;
					StepHeatCool := STEP_SAVE;
				END_IF
						
			STEP_SAVE:
					ConfirmingHeatCoolOrHeat := FALSE;
					FirstUpload := TRUE;
					MpTempControllerConfig_0.Save := TRUE;
					MpTempControllerParType_1 := MpTempControllerParType_0;
					IF MpTempControllerConfig_0.CommandDone THEN
						MpTempControllerConfig_0.Save := FALSE;
						StepHeatCool := STEP_UPDATE;
					END_IF
		
			STEP_UPDATE:
				MpTempController_0.Update := TRUE;
				IF MpTempController_0.UpdateDone THEN
					MpTempController_0.Update := FALSE;
					StepHeatCool := STEP_WAIT;
				END_IF
		END_CASE
		//MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_HEAT_COOL;
		CASE tryby OF
			3:
				MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_HEAT_COOL;
			4:
				MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_OSC_HEAT_COOL;
		END_CASE;
		NameOfMode := 'Oscilation Heat and Cool';
	END_IF;
	
	MpTempControllerParType_0.Tuning := MpTempTuningType_0;
	
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
	MpTempControllerConfig_0();
	MpTempController_0();
	MTBasicsPWMFan();
	MTBasicsPWMHeater();
	 
END_PROGRAM

PROGRAM _EXIT
	
	// FB exit actions
	MpTempControllerConfig_0.Enable := FALSE;
	MpTempControllerConfig_0();
	
	MpTempController_0.Enable := FALSE;
	MpTempController_0();
	
	MTBasicsPWMFan.Enable := FALSE;
	MTBasicsPWMFan();
	
	MTBasicsPWMHeater.Enable := FALSE;
	MTBasicsPWMHeater();
	 
END_PROGRAM

