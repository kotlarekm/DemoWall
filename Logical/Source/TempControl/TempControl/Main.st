//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 25.08.2023
// Description: Task responsible for temperature control.
//***********************************************************************

PROGRAM _INIT
	
	gTanks;
	
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
		MpTempControllerConfigType_0.SystemParameters.Heat.Gain := 1.3742317;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant1 := 299.400116;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant2 := 16.139101;
		MpTempControllerConfigType_0.SystemParameters.Heat.DelayTime := 8;
		
		IF ConfirmingHeatCoolOrHeat THEN
			MpTempControllerParType_0.PID.Heat.ProportionalGain := 15.2788744;
			MpTempControllerParType_0.PID.Heat.IntegrationTime := 768.8433;
			MpTempControllerParType_0.PID.Heat.DerivativeTime := 92.2612;
			MpTempControllerParType_0.PID.Heat.FilterTime := 9.22612;
			MpTempControllerParType_0.PID.Cool.ProportionalGain := 0;
			MpTempControllerParType_0.PID.Cool.IntegrationTime := 0;
			MpTempControllerParType_0.PID.Cool.DerivativeTime := 0;
			MpTempControllerParType_0.PID.Cool.FilterTime := 0;
			MpTempControllerParType_0.PID.IntegratorPreloading := -0.1297297;
			
			MpTempControllerConfig_0.Save := TRUE;
			MpTempControllerParType_1 := MpTempControllerParType_0;
			MpTempControllerConfig_0.Load := TRUE;
			MpTempController_0.Update := TRUE;
		END_IF
		IF MpTempControllerConfig_0.CommandDone THEN
			MpTempControllerConfig_0.Save := FALSE;
			MpTempControllerConfig_0.Load := FALSE;
			MpTempController_0.Update := FALSE;
			ConfirmingHeatCoolOrHeat := FALSE;
		END_IF
		MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_OSC_HEAT;
		NameOfMode := 'Oscilation Heat';
	ELSE
		MpTempControllerConfigType_0.Type := mpTEMP_ZONE_TYPE_HEAT_COOL;
		MpTempControllerConfigType_0.SystemParameters.Heat.Gain := 2.8;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant1 := 30;
		MpTempControllerConfigType_0.SystemParameters.Heat.TimeConstant2 := 2;
		MpTempControllerConfigType_0.SystemParameters.Heat.DelayTime := 1;
		MpTempControllerConfigType_0.SystemParameters.Cool.Gain := 2.8;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant1 := 30;
		MpTempControllerConfigType_0.SystemParameters.Cool.TimeConstant2 := 2;
		MpTempControllerConfigType_0.SystemParameters.Cool.DelayTime := 1;
		MpTempControllerConfigType_0.SystemParameters.Heat.DelayTime := 8;
		
		IF ConfirmingHeatCoolOrHeat THEN
			MpTempControllerParType_0.PID.Heat.ProportionalGain := 34.72473;
			MpTempControllerParType_0.PID.Heat.IntegrationTime := 164.504242;
			MpTempControllerParType_0.PID.Heat.DerivativeTime := 19.470509;
			MpTempControllerParType_0.PID.Heat.FilterTime := 1.97405088;
			MpTempControllerParType_0.PID.Cool.ProportionalGain :=  34.72473;
			MpTempControllerParType_0.PID.Cool.IntegrationTime :=  164.504242;
			MpTempControllerParType_0.PID.Cool.DerivativeTime := 19.470509;
			MpTempControllerParType_0.PID.Cool.FilterTime := 1.97405088;
			MpTempControllerParType_0.PID.IntegratorPreloading := -0.110810772;
			
			MpTempControllerConfig_0.Save := TRUE;
			MpTempControllerParType_1 := MpTempControllerParType_0;
			MpTempControllerConfig_0.Load := TRUE;
			MpTempController_0.Update := TRUE;
		END_IF
		IF MpTempControllerConfig_0.CommandDone THEN
			MpTempControllerConfig_0.Save := FALSE;
			MpTempControllerConfig_0.Load := FALSE;
			MpTempController_0.Update := FALSE;
			ConfirmingHeatCoolOrHeat := FALSE;
		END_IF
		MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_OSC_HEAT_COOL;
		NameOfMode := 'Oscilation Heat and Cool';
	END_IF;
	
//	CASE tryby OF
//		1:
//			MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_HEAT;
//		2:
//			MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_OSC_HEAT;
//		3:
//			MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_HEAT_COOL;
//		4:
//			MpTempTuningType_0.Mode := mpTEMP_TUNING_MODE_OSC_HEAT_COOL;
//	END_CASE;
	
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

