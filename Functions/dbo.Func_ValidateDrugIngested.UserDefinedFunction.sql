USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateDrugIngested]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateDrugIngested] (@DrugIngested NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @DrugIngested_Result NVARCHAR(255);
    SELECT  @DrugIngested_Result = 
        CASE 
            WHEN @DrugIngested IS NULL THEN NULL
            WHEN @DrugIngested LIKE '' THEN NULL
			WHEN @DrugIngested LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(@DrugIngested,',', ''))
            ELSE [dbo].[CleanAndTrimString](@DrugIngested)
        END;

    RETURN @DrugIngested_Result

END; 
GO
