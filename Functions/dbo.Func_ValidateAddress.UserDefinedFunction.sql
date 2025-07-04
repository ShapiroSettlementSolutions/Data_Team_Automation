USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateAddress]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_ValidateAddress] (@Address1 NVARCHAR(255), @Address2 nvarchar(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @CleanedAddress NVARCHAR(255);
    SELECT @CleanedAddress = 
        CASE 
            WHEN @Address1 IS NULL THEN NULL
            WHEN @Address1 LIKE ' ' OR @Address1 LIKE '' THEN NULL
			WHEN @Address2 IS NOT NULL OR @Address1 LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(CONCAT(TRIM(@Address1), ' ', TRIM(@Address2)), ',', ''))
            ELSE [dbo].[CleanAndTrimString](@Address1)
        END;

    RETURN @CleanedAddress;
END;

GO
