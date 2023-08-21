//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 18.08.2023
// Description: Function for updating the list of Recipe names based on file names in the Recipes folder.
//***********************************************************************

FUNCTION UpdateRecipesList
	FOR Index := 0 TO 49 DO
		// Reading list of files names
		FileName := MpFileManagerUIConnectRef.File.List.Items[Index].Name;
		// Deleting files extensions
		RecipesListRef[Index] := LEFT(FileName, FIND(FileName, '.') - 1);
	END_FOR;
	
	UpdateRecipesList := TRUE;
END_FUNCTION
