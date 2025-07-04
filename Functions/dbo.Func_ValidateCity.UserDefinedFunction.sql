USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateCity]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_ValidateCity] (@City NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @CleanedCity NVARCHAR(255);

    SELECT @CleanedCity = 
        CASE 
            WHEN @City IS NULL THEN NULL
            ELSE [dbo].[CleanAndTrimString](REPLACE((@City), ',', ''))
        END;

    RETURN @CleanedCity;
END;
GO
