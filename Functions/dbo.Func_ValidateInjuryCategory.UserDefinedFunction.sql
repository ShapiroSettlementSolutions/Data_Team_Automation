USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateInjuryCategory]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_ValidateInjuryCategory] (@InjuryCategory NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
	
	Declare @InjuryCatgory_Result Nvarchar(255)

	Select @InjuryCatgory_Result = 
		Case 
			 WHEN @InjuryCategory IS NULL THEN NULL
			 WHEN @InjuryCategory LIKE '' THEN NULL
			 WHEN @InjuryCategory LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(@InjuryCategory,',', ''))
			 Else
			 [dbo].[CleanAndTrimString](@InjuryCategory)
			 END
    
    RETURN @InjuryCatgory_Result

END;
GO
