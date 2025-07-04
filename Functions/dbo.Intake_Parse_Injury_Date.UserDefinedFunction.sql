USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Intake_Parse_Injury_Date]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Intake_Parse_Injury_Date] (@irid int,@dates NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
(
    WITH CleanDates AS
    (
        -- Handle removal of text inside parentheses and replace delimiters with semicolons
        SELECT 
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        CASE 
                                            -- Handle if parentheses are present
                                            WHEN CHARINDEX('(', @dates) > 0 AND CHARINDEX(')', @dates) > CHARINDEX('(', @dates)
                                            THEN SUBSTRING(@dates, 1, CHARINDEX('(', @dates) - 1) + 
                                                 SUBSTRING(@dates, CHARINDEX(')', @dates) + 1, LEN(@dates) - CHARINDEX(')', @dates))
                                            ELSE @dates
                                        END,
                                        ' and ', ';'
                                    ), 
                                    CHAR(9), ';'
                                ), 
                                CHAR(10), ';'
                            ), 
                            CHAR(13), ';'
                        ), 
                        ',', ';'
                    ), 
                    ' ', ';' -- Handle space as a delimiter
                ),
                '(', ''
            ) AS DateString
    ),
    SplitDates AS
    (
        SELECT DISTINCT
            LTRIM(RTRIM(value)) AS DateString
        FROM
            STRING_SPLIT((SELECT DateString FROM CleanDates), ';')
        WHERE
            LTRIM(RTRIM(value)) <> '' -- Remove empty values and ensure trimming
    ),
    TextAndDates AS
    (
        SELECT 
            DateString,
            CASE
                -- Handle valid dates in MM/DD/YYYY format (no single-digit months or days)
                WHEN LEN(DateString) = 10 
                     AND PATINDEX('%[0-1][0-9]/[0-3][0-9]/[0-9][0-9][0-9][0-9]%', DateString) > 0
                     AND ISDATE(DateString) = 1
                     AND SUBSTRING(DateString, 1, 2) LIKE '[0-1][0-9]'  -- Ensure MM is two digits
                     AND SUBSTRING(DateString, 4, 2) LIKE '[0-3][0-9]'  -- Ensure DD is two digits
                THEN CAST(DateString AS DATE)

				-- Handle valid dates in YYYY-MM-DD format (no single-digit months or days)
				WHEN LEN(DateString) = 10 
					 AND PATINDEX('%[0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]%', DateString) > 0
					 AND ISDATE(DateString) = 1
					 AND SUBSTRING(DateString, 1, 4) LIKE '[0-9][0-9][0-9][0-9]'  -- Ensure YYYY is four digits
					 AND SUBSTRING(DateString, 6, 2) LIKE '[0-1][0-9]'              -- Ensure MM is two digits
					 AND SUBSTRING(DateString, 9, 2) LIKE '[0-3][0-9]'              -- Ensure DD is two digits
				THEN CAST(DateString AS DATE)

                -- Handle valid dates in M/DD/YYYY format (single-digit months)
                WHEN LEN(DateString) = 9
                     AND PATINDEX('%[1-9]/[0-3][0-9]/[0-9][0-9][0-9][0-9]%', DateString) > 0
                     AND ISDATE(
                         RIGHT('0' + LEFT(DateString, CHARINDEX('/', DateString) - 1), 2) + '/' +
                         SUBSTRING(DateString, CHARINDEX('/', DateString) + 1, CHARINDEX('/', DateString, CHARINDEX('/', DateString) + 1) - CHARINDEX('/', DateString) - 1) + '/' +
                         RIGHT(DateString, 4)
                     ) = 1
                THEN CAST(
                    RIGHT('0' + LEFT(DateString, CHARINDEX('/', DateString) - 1), 2) + '/' +
                    SUBSTRING(DateString, CHARINDEX('/', DateString) + 1, CHARINDEX('/', DateString, CHARINDEX('/', DateString) + 1) - CHARINDEX('/', DateString) - 1) + '/' +
                    RIGHT(DateString, 4)
                    AS DATE
                )

                -- Handle valid dates in MM/D/YYYY format (single-digit days)
                WHEN LEN(DateString) = 9
                     AND PATINDEX('%[0-1][0-9]/[0-9]/[0-9][0-9][0-9][0-9]%', DateString) > 0
                     AND ISDATE(
                         LEFT(DateString, CHARINDEX('/', DateString) - 1) + '/' +
                         RIGHT('0' + SUBSTRING(DateString, CHARINDEX('/', DateString) + 1, CHARINDEX('/', DateString, CHARINDEX('/', DateString) + 1) - CHARINDEX('/', DateString) - 1), 2) + '/' +
                         RIGHT(DateString, 4)
                     ) = 1
                THEN CAST(
                    LEFT(DateString, CHARINDEX('/', DateString) - 1) + '/' +
                    RIGHT('0' + SUBSTRING(DateString, CHARINDEX('/', DateString) + 1, CHARINDEX('/', DateString, CHARINDEX('/', DateString) + 1) - CHARINDEX('/', DateString) - 1), 2) + '/' +
                    RIGHT(DateString, 4)
                    AS DATE
                )

                -- Handle valid dates in M/D/YYYY format (single-digit months or days)
                WHEN LEN(DateString) BETWEEN 8 AND 10 
                     AND PATINDEX('%[0-9]/[0-9]/[0-9][0-9][0-9][0-9]%', DateString) > 0
                     AND ISDATE(
                         CASE 
                             WHEN LEN(DateString) = 8 
                             THEN '0' + DateString
                             WHEN LEN(DateString) = 9 
                             THEN LEFT(DateString, 1) + '0' + SUBSTRING(DateString, 2, LEN(DateString) - 1)
                             ELSE DateString
                         END
                     ) = 1
                THEN CAST(
                    CASE 
                        WHEN LEN(DateString) = 8 
                        THEN '0' + DateString
                        WHEN LEN(DateString) = 9 
                        THEN LEFT(DateString, 1) + '0' + SUBSTRING(DateString, 2, LEN(DateString) - 1)
                        ELSE DateString
                    END
                    AS DATE
                )
                ELSE NULL
            END AS ParsedDate
        FROM 
            SplitDates
    ),
    ValidDates AS
    (
        SELECT 
            ParsedDate,
            ROW_NUMBER() OVER (ORDER BY ParsedDate ASC) AS RowNum
        FROM 
            TextAndDates
        WHERE 
            ParsedDate IS NOT NULL
    ),
    FormattedDates AS
    (
        SELECT
			FORMAT(ParsedDate, 'MM/dd/yyyy') AS FormattedDate,
            RowNum
        FROM
            ValidDates
        GROUP BY 
            ParsedDate, RowNum
        HAVING 
            COUNT(*) = 1 -- Ensure unique values
    )
    SELECT 
		@irid AS IRID,
		MAX(CASE WHEN RowNum = 1 THEN FormattedDate END) AS InjuryDate,
        MAX(CASE WHEN RowNum = 1 THEN FormattedDate END) AS Surgery1,
        MAX(CASE WHEN RowNum = 2 THEN FormattedDate END) AS Surgery2,
        MAX(CASE WHEN RowNum = 3 THEN FormattedDate END) AS Surgery3,
        MAX(CASE WHEN RowNum = 4 THEN FormattedDate END) AS Surgery4,
        MAX(CASE WHEN RowNum = 5 THEN FormattedDate END) AS Surgery5,
        MAX(CASE WHEN RowNum = 6 THEN FormattedDate END) AS Surgery6,
        MAX(CASE WHEN RowNum = 7 THEN FormattedDate END) AS Surgery7,
        MAX(CASE WHEN RowNum = 8 THEN FormattedDate END) AS Surgery8,
        MAX(CASE WHEN RowNum = 9 THEN FormattedDate END) AS Surgery9,
        MAX(CASE WHEN RowNum = 10 THEN FormattedDate END) AS Surgery10,
        MAX(CASE WHEN RowNum = 11 THEN FormattedDate END) AS Surgery11,
        MAX(CASE WHEN RowNum = 12 THEN FormattedDate END) AS Surgery12
        /*
		ISNULL(MAX(CASE WHEN RowNum = 1 THEN FormattedDate END), NULL) AS InjuryDate,
        ISNULL(MAX(CASE WHEN RowNum = 1 THEN FormattedDate END), NULL) AS Surgery1,
        ISNULL(MAX(CASE WHEN RowNum = 2 THEN FormattedDate END), NULL) AS Surgery2,
        ISNULL(MAX(CASE WHEN RowNum = 3 THEN FormattedDate END), NULL) AS Surgery3,
        ISNULL(MAX(CASE WHEN RowNum = 4 THEN FormattedDate END), NULL) AS Surgery4,
        ISNULL(MAX(CASE WHEN RowNum = 5 THEN FormattedDate END), NULL) AS Surgery5,
        ISNULL(MAX(CASE WHEN RowNum = 6 THEN FormattedDate END), NULL) AS Surgery6,
        ISNULL(MAX(CASE WHEN RowNum = 7 THEN FormattedDate END), NULL) AS Surgery7,
        ISNULL(MAX(CASE WHEN RowNum = 8 THEN FormattedDate END), NULL) AS Surgery8,
        ISNULL(MAX(CASE WHEN RowNum = 9 THEN FormattedDate END), NULL) AS Surgery9,
        ISNULL(MAX(CASE WHEN RowNum = 10 THEN FormattedDate END), NULL) AS Surgery10,
        ISNULL(MAX(CASE WHEN RowNum = 11 THEN FormattedDate END), NULL) AS Surgery11,
        ISNULL(MAX(CASE WHEN RowNum = 12 THEN FormattedDate END), NULL) AS Surgery12
		*/
    FROM 
        FormattedDates
);
GO
