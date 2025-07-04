USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateDescriptionOfInjury]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateDescriptionOfInjury] (@DescriptionOfInjury NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @DescriptionOfInjury_Result NVARCHAR(255);
    SELECT  @DescriptionOfInjury_Result = 
        CASE 
            WHEN @DescriptionOfInjury IS NULL THEN NULL
            WHEN @DescriptionOfInjury LIKE ' ' OR @DescriptionOfInjury LIKE '' THEN NULL
			WHEN @DescriptionOfInjury LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(@DescriptionOfInjury,',', ''))
            ELSE [dbo].[CleanAndTrimString](@DescriptionOfInjury)
        END;

    RETURN @DescriptionOfInjury_Result

END;
GO
