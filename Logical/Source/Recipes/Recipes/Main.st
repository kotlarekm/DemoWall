//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 18.08.2023
// Description: Task resposible for interaction with recipes.
//***********************************************************************

PROGRAM _INIT
	
	gTanks.Parameters;
	
	// USB init
	UsbNodeListGet_0.enable := TRUE;
	UsbNodeListGet_0.bufferSize := SIZEOF(NodeIdList);
	UsbNodeListGet_0.pBuffer := ADR(NodeIdList);
	UsbNodeListGet_0.filterInterfaceClass := 0;
	UsbNodeListGet_0.filterInterfaceSubClass := 0;
	UsbNodeListGet_0();
	
	// MpFileManagerUI init
	MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	MpFileManagerUI_0.UISetup := MpFileManagerUISetup_0;
	
	MpFileManagerUIConnect_0.DeviceList.DeviceNames[0] := 'USER';
	MpFileManagerUIConnect_0.DeviceList.DeviceNames[1] := 'USB1';
	MpFileManagerUIConnect_0.DeviceList.DeviceNames[2] := 'USB2';
	MpFileManagerUIConnect_0.DeviceList.SelectedIndex := 1;
	MpFileManagerUIConnect_0.File.Filter := '*.xml';
	MpFileManagerUIConnect_0.File.Refresh := TRUE;
	
	MpFileManagerUI_0.UIConnect := ADR(MpFileManagerUIConnect_0);
	MpFileManagerUI_0.Enable := TRUE;
	MpFileManagerUI_0();
	
	// MpRecipeXml init
	MpRecipeXml_0.MpLink := ADR(gRecipeXml);
	MpRecipeXml_0.Enable := TRUE;
	MpRecipeXml_0.DeviceName := ADR(MpFileManagerUIConnect_0.DeviceList.DeviceNames[MpFileManagerUIConnect_0.DeviceList.SelectedIndex]);
	MpRecipeXml_0.FileName := ADR(RecipeName);
	MpRecipeXml_0();
	
	// MpRecipeRegPar init
	MpRecipeRegPar_0.MpLink := ADR(gRecipeXml);
	MpRecipeRegPar_0.PVName := ADR('Recipes:ParametersToLoad');
	MpRecipeRegPar_0.Enable := TRUE;
	MpRecipeRegPar_0();
	
	// Initializing displayed parameters as default parameters
	ParametersToLoad := DefaultParameters;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	// Errors
	IF MpRecipeRegPar_0.Error THEN
		// some actions
		
		MpRecipeRegPar_0.ErrorReset := TRUE;
	ELSE
		MpRecipeRegPar_0.ErrorReset := FALSE;
	END_IF;
	
	IF MpFileManagerUI_0.Error THEN
		// some actions
		
		MpFileManagerUI_0.ErrorReset := TRUE;
	ELSE
		MpFileManagerUI_0.ErrorReset := FALSE;
	END_IF;
	
	IF MpRecipeXml_0.Error THEN
		// some actions
		
		MpRecipeXml_0.ErrorReset := TRUE;
	ELSE
		MpRecipeXml_0.ErrorReset := FALSE;
	END_IF;
	
	// Loading default parameters
	IF SetDefaultParams THEN
		ParametersToLoad := DefaultParameters;
	  	SetDefaultParams := FALSE;
	END_IF;
	
	// Applying parameters to real object and confirming heating cooling or heating mode
	IF ApplyParameters THEN
		gTanks.Parameters := ParametersToLoad;
		ConfirmingHeatCoolOrHeat := TRUE;
		
	  	ApplyParameters := FALSE;
	END_IF;
	
	// Checking if usb devices are aveliable
	IF UsbNodeListGet_0.allNodes >= 1 THEN
	  	USB1Aveliable := TRUE;
	ELSE
		USB1Aveliable := FALSE;
	END_IF
	
	IF UsbNodeListGet_0.allNodes >= 2 THEN
		USB2Aveliable := TRUE;
	ELSE
		USB2Aveliable := FALSE;
	END_IF;
	
	// Updating selected file
	MpFileManagerUIConnect_0.File.List.Items[SelectedRecipeIndex].IsSelected := TRUE;
	
	// Checking if new recipe has been selected
	IF NewRecipeSelected AND MpFileManagerUIConnect_0.Status = mpFILE_UI_STATUS_IDLE AND NOT(MpRecipeXml_0.CommandBusy) THEN
		NewRecipeSelected := FALSE;
		UpdateRecipesList(ADR(MpFileManagerUIConnect_0), ADR(RecipesList), ADR(DropDownBoxNamesCollection));
		RecipeName := RecipesList[SelectedRecipeIndex];
		WaitingForLoad := TRUE;
	END_IF;
	
	// Checking if device name has been change due to drive unplug
	IF NOT(PreviousNumberOfUSBDevices = UsbNodeListGet_0.allNodes) THEN
		DeviceChenged := TRUE;
		PreviousNumberOfUSBDevices := UsbNodeListGet_0.allNodes;
		MpFileManagerUIConnect_0.DeviceList.SelectedIndex := 0;
	END_IF;
	
	// Data device change
	IF DeviceChenged AND MpFileManagerUIConnect_0.Status = mpFILE_UI_STATUS_IDLE THEN
		DeviceChenged := FALSE;
		MpRecipeXml_0.DeviceName := ADR(MpFileManagerUIConnect_0.DeviceList.DeviceNames[MpFileManagerUIConnect_0.DeviceList.SelectedIndex]);
		MpFileManagerUIConnect_0.File.Refresh := TRUE;
		NewRecipeSelected := TRUE;
	END_IF;
	
	// Recipes loading
	IF WaitingForLoad THEN
		IF NOT(MpRecipeXml_0.CommandBusy) AND MpFileManagerUIConnect_0.Status = mpFILE_UI_STATUS_IDLE THEN
			MpRecipeXml_0.Load := TRUE;
			WaitingForLoad := FALSE;
		END_IF;
	ELSIF MpRecipeXml_0.Active THEN
		MpRecipeXml_0.Load := FALSE;
	END_IF;
	
	// Recipes saving
	IF WaitingForSave THEN
		IF NOT(MpRecipeXml_0.CommandBusy) THEN
			MpRecipeXml_0.Save := TRUE;
			WaitingForSave := FALSE;
		END_IF;
	ELSIF MpRecipeXml_0.CommandDone THEN
		MpRecipeXml_0.Save := FALSE;
	END_IF;
	
	// File deleting
	IF WaitingForDelete AND MpFileManagerUIConnect_0.Status = mpFILE_UI_STATUS_IDLE THEN
		MpFileManagerUIConnect_0.File.Delete := TRUE;
		WaitingForDelete := FALSE;
	// File list refresh
	ELSIF MpFileManagerUIConnect_0.Status = mpFILE_UI_STATUS_IDLE THEN
		MpFileManagerUIConnect_0.File.Refresh := TRUE;
		UpdateRecipesList(ADR(MpFileManagerUIConnect_0), ADR(RecipesList), ADR(DropDownBoxNamesCollection));
	END_IF;
	
	// FB Updates
	MpFileManagerUI_0();
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	UsbNodeListGet_0();
	
	 
END_PROGRAM

PROGRAM _EXIT
	
	// FB exit actions
	MpRecipeXml_0.Enable := FALSE;
	MpRecipeXml_0();
	
	MpRecipeRegPar_0.Enable := FALSE;
	MpRecipeRegPar_0();
	
	MpFileManagerUI_0.Enable := FALSE;
	MpFileManagerUI_0();
	
	UsbNodeListGet_0.enable := FALSE;
	UsbNodeListGet_0();
	
END_PROGRAM

