// Function for updating the list of Recipe names based on file names in the Recipes folder

FUNCTION UpdateRecipesList
	FOR Index := 0 TO 49 DO
		// Reading file names list 
		FileName := MpFileManagerUIConnectRef.File.List.Items[Index].Name;
		// Deleting file extension
		RecipesListRef[Index] := LEFT(FileName, FIND(FileName, '.') - 1);
	END_FOR;
	
	UpdateRecipesList := TRUE;
END_FUNCTION
