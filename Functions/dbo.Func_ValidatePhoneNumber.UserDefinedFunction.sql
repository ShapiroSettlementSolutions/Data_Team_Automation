USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidatePhoneNumber]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_ValidatePhoneNumber](@PhoneNumber NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @Phone_Result NVARCHAR(255);

    SELECT @Phone_Result = 
        CASE 
            WHEN @PhoneNumber LIKE '%[a-z]%' THEN NULL  -- Check for any alphabets in the phone number
            WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([dbo].[CleanAndTrimString](@PhoneNumber), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')) = 10
            THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([dbo].[CleanAndTrimString](@PhoneNumber), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), 1, 3) + ') ' +
                 SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([dbo].[CleanAndTrimString](@PhoneNumber), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), 4, 3) + '-' +
                 SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([dbo].[CleanAndTrimString](@PhoneNumber), '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''), 7, 4)
            ELSE NULL
        END;

    RETURN @Phone_Result;
END;

GO
