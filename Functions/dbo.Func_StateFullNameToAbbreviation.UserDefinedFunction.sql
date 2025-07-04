USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_StateFullNameToAbbreviation]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Amber Desai>
-- Create date: <07/14/2024>
-- Description:	<US States Abbreviations>
-- =============================================
CREATE FUNCTION [dbo].[Func_StateFullNameToAbbreviation] (@StateName VARCHAR(50))
RETURNS CHAR(2)
AS
BEGIN
    DECLARE @Abbreviation CHAR(2);

    SET @Abbreviation = CASE UPPER(@StateName)
        WHEN 'ALABAMA' THEN 'AL'
        WHEN 'ALASKA' THEN 'AK'
        WHEN 'ARIZONA' THEN 'AZ'
        WHEN 'ARKANSAS' THEN 'AR'
        WHEN 'CALIFORNIA' THEN 'CA'
        WHEN 'COLORADO' THEN 'CO'
        WHEN 'CONNECTICUT' THEN 'CT'
        WHEN 'DELAWARE' THEN 'DE'
        WHEN 'FLORIDA' THEN 'FL'
        WHEN 'GEORGIA' THEN 'GA'
        WHEN 'HAWAII' THEN 'HI'
        WHEN 'IDAHO' THEN 'ID'
        WHEN 'ILLINOIS' THEN 'IL'
        WHEN 'INDIANA' THEN 'IN'
        WHEN 'IOWA' THEN 'IA'
        WHEN 'KANSAS' THEN 'KS'
        WHEN 'KENTUCKY' THEN 'KY'
        WHEN 'LOUISIANA' THEN 'LA'
        WHEN 'MAINE' THEN 'ME'
        WHEN 'MARYLAND' THEN 'MD'
        WHEN 'MASSACHUSETTS' THEN 'MA'
        WHEN 'MICHIGAN' THEN 'MI'
        WHEN 'MINNESOTA' THEN 'MN'
        WHEN 'MISSISSIPPI' THEN 'MS'
        WHEN 'MISSOURI' THEN 'MO'
        WHEN 'MONTANA' THEN 'MT'
        WHEN 'NEBRASKA' THEN 'NE'
        WHEN 'NEVADA' THEN 'NV'
        WHEN 'NEW HAMPSHIRE' THEN 'NH'
        WHEN 'NEW JERSEY' THEN 'NJ'
        WHEN 'NEW MEXICO' THEN 'NM'
        WHEN 'NEW YORK' THEN 'NY'
        WHEN 'NORTH CAROLINA' THEN 'NC'
        WHEN 'NORTH DAKOTA' THEN 'ND'
        WHEN 'OHIO' THEN 'OH'
        WHEN 'OKLAHOMA' THEN 'OK'
        WHEN 'OREGON' THEN 'OR'
        WHEN 'PENNSYLVANIA' THEN 'PA'
        WHEN 'RHODE ISLAND' THEN 'RI'
        WHEN 'SOUTH CAROLINA' THEN 'SC'
        WHEN 'SOUTH DAKOTA' THEN 'SD'
        WHEN 'TENNESSEE' THEN 'TN'
        WHEN 'TEXAS' THEN 'TX'
        WHEN 'UTAH' THEN 'UT'
        WHEN 'VERMONT' THEN 'VT'
        WHEN 'VIRGINIA' THEN 'VA'
        WHEN 'WASHINGTON' THEN 'WA'
        WHEN 'WEST VIRGINIA' THEN 'WV'
        WHEN 'WISCONSIN' THEN 'WI'
        WHEN 'WYOMING' THEN 'WY'
        ELSE NULL
    END;

    RETURN @Abbreviation;
END;


GO
