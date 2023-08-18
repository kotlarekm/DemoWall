//*********************************************************************** 
// Copyright:
// Author:
// Created:
// Description:
//***********************************************************************

PROGRAM _INIT
	
	gSelectedParameters;
	
	// MpRecipeXml init
	MpRecipeXml_0.MpLink := ADR(gRecipeXml);
	MpRecipeXml_0.Enable := TRUE;
	MpRecipeXml_0.DeviceName := ADR('HDD');
	MpRecipeXml_0();
	
	// MpRecipeRegPar init
	MpRecipeRegPar_0.MpLink := ADR(gRecipeXml);
	MpRecipeRegPar_0.PVName := ADR('gSelectedParameters');
	MpRecipeRegPar_0.Enable := TRUE;
	MpRecipeRegPar_0();
	
END_PROGRAM

PROGRAM _CYCLIC
	
	// MpRecipeXml_0 update
	MpRecipeXml_0.FileName := ADR(FileName);
	MpRecipeXml_0();
	
	// MpRecipeRegPar_0 update
	MpRecipeRegPar_0();
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpRecipeXml_0.Enable := FALSE;
	MpRecipeXml_0();
	
	MpRecipeRegPar_0.Enable := FALSE;
	MpRecipeRegPar_0();
	
END_PROGRAM

