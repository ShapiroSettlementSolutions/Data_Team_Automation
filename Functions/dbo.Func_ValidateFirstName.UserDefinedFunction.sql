USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateFirstName]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateFirstName] (@FirstName NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @FirstName_Result NVARCHAR(255);

    SELECT @FirstName_Result
        = CASE
              WHEN @FirstName LIKE '%(Deceased)%'
                   OR @FirstName LIKE '%(Estate Of)%' THEN
                  [dbo].[CleanAndTrimString](REPLACE(REPLACE(@FirstName, '(Deceased)', ''), '(Estate Of)', ''))
              WHEN @FirstName LIKE '%,%' THEN
                  [dbo].[CleanAndTrimString](REPLACE(@FirstName, ',', ''))
              ELSE
                  [dbo].[CleanAndTrimString](@FirstName)
          END;

    RETURN @FirstName_Result;
END;
GO
