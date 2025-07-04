USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Intake_Parse_Ingestion_Date]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Intake_Parse_Ingestion_Date] (@irid int,@input NVARCHAR(MAX))
RETURNS @Result TABLE (
	IRID INT,
    IngestionDate1 NVARCHAR(10),
    IngestionDate2 NVARCHAR(10),
    IngestionDate3 NVARCHAR(10)
)
AS
BEGIN
    -- Clean the input and replace delimiters with a single delimiter
    DECLARE @cleanedInput NVARCHAR(MAX);
    SET @cleanedInput = REPLACE(REPLACE(REPLACE(REPLACE(@input, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' '), ';', ' ');
    SET @cleanedInput = REPLACE(@cleanedInput, ',', ' ');
    SET @cleanedInput = REPLACE(@cleanedInput, ' and ', ' ');
    SET @cleanedInput = REPLACE(@cleanedInput, '/', '-');
    SET @cleanedInput = REPLACE(@cleanedInput, '  ', ' ');
	SET @cleanedInput = CONVERT(VARCHAR(10),@cleanedInput,101)
    -- Temporary table to hold split values
    DECLARE @Dates TABLE (
        DateValue NVARCHAR(50)
    );

    -- Insert split values into the temporary table, removing duplicates
    INSERT INTO @Dates (DateValue)
    SELECT DISTINCT 
        LTRIM(RTRIM(value)) AS DateValue -- Apply LTRIM and RTRIM here
    FROM STRING_SPLIT(@cleanedInput, ' ')
    WHERE LTRIM(RTRIM(value)) <> ''; -- Apply LTRIM and RTRIM here to remove any empty values resulting from splitting

    -- Common Table Expression to calculate row numbers in ascending order
    WITH NumberedDates AS (
        SELECT 
            DateValue,
            ROW_NUMBER() OVER (ORDER BY TRY_CONVERT(DATE, DateValue, 101) ASC) AS RowNum
        FROM @Dates
        WHERE DateValue IS NOT NULL -- Only include valid date formats
    )

    -- Insert the results into the return table with converted dates and formatted
    INSERT INTO @Result (IRID,IngestionDate1, IngestionDate2, IngestionDate3)
    SELECT 
		@irid AS IRID,
		MAX(Case When RowNum = 1 THEN CONVERT(VARCHAR(10),DateValue,101) END) AS IngestionDate1,
		MAX(Case When RowNum = 2 THEN CONVERT(VARCHAR(10),DateValue,101) END) AS IngestionDate2,
		MAX(Case When RowNum = 3 THEN CONVERT(VARCHAR(10),DateValue,101) END) AS IngestionDate3
        /*
		ISNULL(MAX(CASE WHEN RowNum = 1 THEN FORMAT(TRY_CONVERT(DATE, DateValue, 101), 'MM/dd/yyyy') END), NULL) AS IngestionDate1,
        ISNULL(MAX(CASE WHEN RowNum = 2 THEN FORMAT(TRY_CONVERT(DATE, DateValue, 101), 'MM/dd/yyyy') END), NULL) AS IngestionDate2,
        ISNULL(MAX(CASE WHEN RowNum = 3 THEN FORMAT(TRY_CONVERT(DATE, DateValue, 101), 'MM/dd/yyyy') END), NULL) AS IngestionDate3
		*/
    FROM NumberedDates;

    RETURN;
END;




GO
