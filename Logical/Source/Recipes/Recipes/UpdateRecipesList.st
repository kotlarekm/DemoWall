//*********************************************************************** 
// Copyright: B&R Industrial Automation GmbH 
// Author: B&R
// Created: 18.08.2023
// Description: Function for updating the list of Recipe names based on file names in the Recipes folder.
//***********************************************************************

FUNCTION UpdateRecipesList
	FOR Index := 0 TO 49 DO
		IF Index >=  MpFileManagerUIConnectRef.File.PathInfo.FileCount THEN
			RecipesListRef[Index] := '';
			DropDownBoxNamesCollectionRef[Index] := '';
		ELSE
			// Reading file names list 
			FileName := MpFileManagerUIConnectRef.File.List.Items[Index].Name;
			// Deleting file extension
			RecipesListRef[Index] := LEFT(FileName, FIND(FileName, '.') - 1);
			brsitoa(Index, ADR(IndexStr));
			DropDownBoxNamesCollectionRef[Index] := CONCAT('{"value":"', CONCAT(IndexStr, CONCAT('", "text":"', CONCAT(RecipesListRef[Index], '"}'))));
		END_IF;
	END_FOR;
	
	UpdateRecipesList := TRUE;
END_FUNCTION

// {'value':'a', 'text':'Monday'}
