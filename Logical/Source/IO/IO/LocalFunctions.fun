
{REDUND_ERROR} FUNCTION_BLOCK ChangeButtonColor (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ButtonNumber : {REDUND_UNREPLICABLE} INT; (*Button number*)
	END_VAR
	VAR_OUTPUT
		RoundButton : ARRAY[1..5] OF RoundButton_Type; (*Array of round buttons*)
	END_VAR
END_FUNCTION_BLOCK
