USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_CleanSSN_Mcaid]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================--
-- Author:		Viral Panchal
-- Create date: 07/19/2024
-- Description:	Format & Validate the SSN and ITIN

--	Date			Name			Description
--	11-20-2024		Ronak Vadher	Added to additional condition where SSN length is 7 or 8
-- ============================================================================================--


CREATE FUNCTION [dbo].[Fn_CleanSSN_Mcaid] (@SSN NVARCHAR(255))
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @SSN_Result NVARCHAR(15);

    -- Check if the SSN is 'No SSN'
    IF UPPER(@SSN) = 'NO SSN'
    BEGIN
        SET @SSN_Result = 'No SSN';
        RETURN @SSN_Result;
    END

    -- Clean the SSN (remove spaces and hyphens)
    SET @SSN = TRIM(REPLACE(REPLACE(@SSN, '-', ''), ' ', ''));

    -- Validate SSN format
    IF (
           (
               LEN(@SSN) = 9
               OR LEN(@SSN) = 8
               OR LEN(@SSN) = 7
           )
           AND @SSN NOT LIKE '%[^0-9]%' -- Only numeric characters
       )
    BEGIN
        SELECT @SSN_Result = CASE
                                 WHEN SUBSTRING(TRIM(@SSN), 1, 3) IN ( '000', '666', '999' ) THEN
                                     NULL
                                 WHEN TRIM(@SSN) LIKE '%x%' THEN
                                     NULL
                                 WHEN TRIM(@SSN) IN ( '123456789', '000000000' ) THEN
                                     NULL
                                 WHEN LEN(TRIM(@SSN)) IN ( 9 )
                                      AND (SUBSTRING(TRIM(@SSN), 6, 4) = '0000') THEN
                                     NULL
                                 WHEN LEN(TRIM(@SSN)) IN ( 9 )
                                      AND (SUBSTRING(TRIM(@SSN), 4, 2) = '00') THEN
                                     NULL
                                 WHEN LEN(@SSN) = 9
                                      AND @SSN NOT LIKE '%[^0-9]%' THEN
                                     STUFF(STUFF(@SSN, 6, 0, '-'), 4, 0, '-')
                                 WHEN LEN(@SSN) = 7 THEN
                                     STUFF(STUFF('00' + @SSN, 6, 0, '-'), 4, 0, '-')
                                 WHEN LEN(@SSN) = 8 THEN
                                     STUFF(STUFF('0' + @SSN, 6, 0, '-'), 4, 0, '-')
                                 ELSE
                                     NULL
                             END
    END
    ELSE
    BEGIN
        SET @SSN_Result = NULL;
    END

    RETURN @SSN_Result;
END
GO
