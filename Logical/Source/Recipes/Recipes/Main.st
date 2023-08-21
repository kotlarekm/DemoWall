//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 18.08.2023
// Description: Task resposible for interaction with recipes.
//***********************************************************************

PROGRAM _INIT
	
	gSelectedParameters;
	
	// MpRecipeXml init
	MpRecipeXml_0.MpLink := ADR(gRecipeXml);
	MpRecipeXml_0.Enable := TRUE;
	MpRecipeXml_0.DeviceName := ADR('HDD');
	MpRecipeXml_0.FileName := ADR(RecipeName);
	MpRecipeXml_0();
	
	// MpRecipeRegPar init
	MpRecipeRegPar_0.MpLink := ADR(gRecipeXml);
	MpRecipeRegPar_0.PVName := ADR('gSelectedParameters');
	MpRecipeRegPar_0.Enable := TRUE;
	MpRecipeRegPar_0();
	
	// MpFileManagerUI init
	MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	MpFileManagerUI_0.UISetup := MpFileManagerUISetup_0;
	
	MpFileManagerUIConnect_0.DeviceList.DeviceNames[0] := 'HDD';
	MpFileManagerUIConnect_0.DeviceList.SelectedIndex := 0;
	MpFileManagerUIConnect_0.File.Filter := '*.xml';
	
	MpFileManagerUI_0.UIConnect := ADR(MpFileManagerUIConnect_0);
	MpFileManagerUI_0.Enable := TRUE;
	MpFileManagerUI_0();
	
END_PROGRAM

PROGRAM _CYCLIC
	
	// Recipes loading
	IF WaitingForLoad THEN
		IF NOT(MpRecipeXml_0.CommandBusy) THEN
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
	
	// Updates
	MpRecipeXml_0();
	MpRecipeRegPar_0();
	MpFileManagerUIConnect_0.File.Refresh := TRUE;
	UpdateRecipesList(ADR(MpFileManagerUIConnect_0), ADR(RecipesList));
	MpFileManagerUI_0();
	
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpRecipeXml_0.Enable := FALSE;
	MpRecipeXml_0();
	
	MpRecipeRegPar_0.Enable := FALSE;
	MpRecipeRegPar_0();
	
	MpFileManagerUI_0.Enable := FALSE;
	MpFileManagerUI_0();
	
END_PROGRAM

