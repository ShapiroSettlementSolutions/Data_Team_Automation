USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateGender]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateGender] (@Gender NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @Gender_Result NVARCHAR(255);

    SELECT @Gender_Result = CASE
                                WHEN [dbo].[CleanAndTrimString](@Gender) = 'M'
                                     OR [dbo].[CleanAndTrimString](@Gender) = 'Male' THEN
                                    'Male'
                                WHEN [dbo].[CleanAndTrimString](@Gender) = 'F'
                                     OR [dbo].[CleanAndTrimString](@Gender) = 'Female' THEN
                                    'Female'
                                ELSE
                                    NULL
                            END;

    RETURN @Gender_Result;
END;
GO
