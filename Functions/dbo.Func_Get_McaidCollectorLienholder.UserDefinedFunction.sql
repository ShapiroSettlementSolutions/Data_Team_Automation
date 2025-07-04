USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_McaidCollectorLienholder]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_McaidCollectorLienholder]()
RETURNS @ResultTable TABLE (
	UniqueId nvarchar(30),
	ClientId int,
    LienType NVARCHAR(20),
    SourceCollectorId NVARCHAR(10),
    SourceLienholderId NVARCHAR(10),
    SourceId CHAR(1)
)
AS
BEGIN
    -- Declare necessary variables
    DECLARE @LienType NVARCHAR(20);
    DECLARE @SourceId CHAR(1);

    -- Initialize constant values
    SET @LienType = 'Medicaid Lien - MT';
    SET @SourceId = '7';

    -- Insert data into the result table for each state
    INSERT INTO @ResultTable (UniqueId,ClientId, LienType, SourceCollectorId, SourceLienholderId, SourceId)
    SELECT
		Address2,
		ClientId,
        @LienType AS LienType,
        CASE 
            WHEN State IS NULL THEN '736'
            WHEN State = 'AK' THEN '11'
            WHEN State = 'AL' THEN '106'
            WHEN State = 'AR' THEN '106'
            WHEN State = 'AZ' THEN '106'
            WHEN State = 'CA' THEN '42'
            WHEN State = 'CO' THEN '50'
            WHEN State = 'CT' THEN '106'
            WHEN State = 'DC' THEN '297'
            WHEN State = 'DE' THEN '62'
            WHEN State = 'FL' THEN '106'
            WHEN State = 'GA' THEN '106'
            WHEN State = 'GU' THEN '625'
            WHEN State = 'HI' THEN '89'
            WHEN State = 'IA' THEN '106'
            WHEN State = 'ID' THEN '106'
            WHEN State = 'IL' THEN '119'
            WHEN State = 'IN' THEN '120'
            WHEN State = 'KS' THEN '106'
            WHEN State = 'KY' THEN '129'
            WHEN State = 'LA' THEN '622'
            WHEN State = 'MA' THEN '151'
            WHEN State = 'MD' THEN '106'
            WHEN State = 'ME' THEN '144'
            WHEN State = 'MI' THEN '166'
            WHEN State = 'MN' THEN '164'
            WHEN State = 'MO' THEN '167'
            WHEN State = 'MS' THEN '106'
            WHEN State = 'MT' THEN '173'
            WHEN State = 'NC' THEN '106'
            WHEN State = 'ND' THEN '210'
            WHEN State = 'NE' THEN '176'
            WHEN State = 'NH' THEN '179'
            WHEN State = 'NJ' THEN '106'
            WHEN State = 'NM' THEN '106'
            WHEN State = 'NV' THEN '106'
            WHEN State = 'NY' THEN '106'
            WHEN State = 'OH' THEN '106'
            WHEN State = 'OK' THEN '213'
            WHEN State = 'OR' THEN '216'
            WHEN State = 'PA' THEN '220'
            WHEN State = 'PR' THEN '378'
            WHEN State = 'RI' THEN '232'
            WHEN State = 'SC' THEN '2902'
            WHEN State = 'SD' THEN '260'
            WHEN State = 'TN' THEN '3291'
            WHEN State = 'TX' THEN '268'
            WHEN State = 'UT' THEN '291'
            WHEN State = 'VA' THEN '294'
            WHEN State = 'VI' THEN '620'
            WHEN State = 'VT' THEN '293'
            WHEN State = 'WA' THEN '295'
            WHEN State = 'WI' THEN '106'
            WHEN State = 'WV' THEN '106'
            WHEN State = 'WY' THEN '106'
            ELSE 'NULL' -- Default value for unknown states, if needed
        END AS SourceCollectorId,
        CASE 
            WHEN State IS NULL THEN '696'
            WHEN State = 'AK' THEN '1'
            WHEN State = 'AL' THEN '2'
            WHEN State = 'AR' THEN '3'
            WHEN State = 'AZ' THEN '130'
            WHEN State = 'CA' THEN '4'
            WHEN State = 'CO' THEN '6'
            WHEN State = 'CT' THEN '4546'
            WHEN State = 'DC' THEN '11'
            WHEN State = 'DE' THEN '14'
            WHEN State = 'FL' THEN '24'
            WHEN State = 'GA' THEN '29'
            WHEN State = 'GU' THEN '199'
            WHEN State = 'HI' THEN '31'
            WHEN State = 'IA' THEN '34'
            WHEN State = 'ID' THEN '38'
            WHEN State = 'IL' THEN '40'
            WHEN State = 'IN' THEN '46'
            WHEN State = 'KS' THEN '58'
            WHEN State = 'KY' THEN '59'
            WHEN State = 'LA' THEN '195'
            WHEN State = 'MA' THEN '64'
            WHEN State = 'MD' THEN '68'
            WHEN State = 'ME' THEN '70'
            WHEN State = 'MI' THEN '71'
            WHEN State = 'MN' THEN '100'
            WHEN State = 'MO' THEN '105'
            WHEN State = 'MS' THEN '109'
            WHEN State = 'MT' THEN '113'
            WHEN State = 'NC' THEN '115'
            WHEN State = 'ND' THEN '117'
            WHEN State = 'NE' THEN '119'
            WHEN State = 'NH' THEN '126'
            WHEN State = 'NJ' THEN '128'
            WHEN State = 'NM' THEN '7'
            WHEN State = 'NV' THEN '5'
            WHEN State = 'NY' THEN '194'
            WHEN State = 'OH' THEN '89'
            WHEN State = 'OK' THEN '1869'
            WHEN State = 'OR' THEN '94'
            WHEN State = 'PA' THEN '103'
            WHEN State = 'PR' THEN '104'
            WHEN State = 'RI' THEN '108'
            WHEN State = 'SC' THEN '110'
            WHEN State = 'SD' THEN '114'
            WHEN State = 'TN' THEN '116'
            WHEN State = 'TX' THEN '118'
            WHEN State = 'UT' THEN '132'
            WHEN State = 'VA' THEN '134'
            WHEN State = 'VI' THEN '135'
            WHEN State = 'VT' THEN '136'
            WHEN State = 'WA' THEN '137'
            WHEN State = 'WI' THEN '139'
            WHEN State = 'WV' THEN '140'
            WHEN State = 'WY' THEN '141'
            ELSE 'NULL' -- Default value for unknown states, if needed
        END AS SourceLienholderId,
        @SourceId AS SourceId
    FROM Intake_Clean ic;

    RETURN;
END;



GO
