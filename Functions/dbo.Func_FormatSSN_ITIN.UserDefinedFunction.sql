USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_FormatSSN_ITIN]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =========================================================
-- Author:		Viral Panchal
-- Create date: 07/19/2024
-- Description:	Format & Validate the SSN and ITIN

--	Date			Name			Description
--	10-22-2024		Amber Desai		Removed Table Name from function
-- =========================================================
CREATE FUNCTION [dbo].[Func_FormatSSN_ITIN] (@SSN NVARCHAR(255))
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @SSN_Result NVARCHAR(15);

    SET @SSN = TRIM (Replace(REPLACE(@SSN, '-', ''),' ',''));
    IF (LEN(@SSN) = 9 AND @SSN NOT LIKE '%[^0-9]%')
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
                                 ELSE
                                     NULL
                             END
    END
    ELSE
    BEGIN
        SET @SSN_Result = NULL;
    END
    RETURN @SSN_Result

END
GO
