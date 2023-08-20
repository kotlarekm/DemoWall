
{REDUND_ERROR} FUNCTION UpdateRecipesList : BOOL (* *) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		MpFileManagerUIConnectRef : REFERENCE TO MpFileManagerUIConnectType;
		RecipesListRef : REFERENCE TO ARRAY[0..49] OF STRING[255];
	END_VAR
	VAR
		Index : USINT := 0;
		FileName : STRING[255];
	END_VAR
END_FUNCTION
