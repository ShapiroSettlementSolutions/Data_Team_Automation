USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateDefendantName]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateDefendantName] (@DefendantName NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @DefendantName_Result NVARCHAR(255);
    SELECT  @DefendantName_Result = 
        CASE 
            WHEN @DefendantName IS NULL THEN NULL
            WHEN @DefendantName LIKE '' THEN NULL
			WHEN @DefendantName LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(@DefendantName,',', ''))
            ELSE [dbo].[CleanAndTrimString](@DefendantName)
        END;

    RETURN @DefendantName_Result

END;


GO
