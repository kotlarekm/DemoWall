FUNCTION UpdateRecipesList
	FOR Index := 0 TO 49 DO
		FileName := MpFileManagerUIConnectRef.File.List.Items[Index].Name;
		RecipesListRef[Index] := LEFT(FileName, FIND(FileName, '.') - 1);
	END_FOR;
	
	UpdateRecipesList := TRUE;
END_FUNCTION
