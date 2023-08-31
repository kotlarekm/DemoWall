
{REDUND_ERROR} FUNCTION UpdateRecipesList : BOOL (* *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		MpFileManagerUIConnectRef : REFERENCE TO MpFileManagerUIConnectType; (*Reference to MpFileManagerUIConnect type*)
		RecipesListRef : REFERENCE TO ARRAY[0..49] OF STRING[255]; (*Reference to list of recipe names*)
		DropDownBoxNamesCollectionRef : REFERENCE TO ARRAY[0..49] OF STRING[100]; (*Items collection containing names of recipes.*)
	END_VAR
	VAR
		Index : UINT := 0; (*Variable used in for loop to iterate through file and recipes names*)
		FileName : STRING[255]; (*String containing name of single currently considered file*)
		IndexStr : STRING[80]; (*Contains item index in string format*)
	END_VAR
END_FUNCTION
