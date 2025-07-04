USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetPersonUpdate_Talc]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Nishant Sharma>
-- Create date: <12-24-2024>
-- Description:	PersonUpdate_Talc
-- =============================================
CREATE FUNCTION [dbo].[Func_GetPersonUpdate_Talc] ()
RETURNS TABLE 
AS
RETURN 
(
Select
	ic.PersonId [PersonId],
    ic.SSN AS [SSN in Spreadsheet],
    p.SSN AS [SSN in LPM],
    CASE
		WHEN ic.SSN IS NULL and p.SSN IS NULL THEN 'TRUE'
        WHEN (ic.SSN != p.SSN) OR (ic.SSN IS NULL) OR (p.SSN IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'SSN_Match',

    ic.ITIN AS [ITIN in Spreadsheet],
    p.otheridentifier AS [ITIN in LPM],
    CASE
		WHEN ic.ITIN IS NULL and p.OtherIdentifier IS NULL THEN 'TRUE'
        WHEN (ic.ITIN != p.OtherIdentifier) OR (ic.ITIN IS NULL) OR (p.OtherIdentifier IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'ITIN_Match',

    ic.FirstName AS [FirstName in Spreadsheet],
    p.FirstName AS [FirstName in LPM],
    CASE
		WHEN ic.FirstName IS NULL and p.FirstName IS NULL THEN 'TRUE'
        WHEN (ic.FirstName != p.FirstName) OR (ic.FirstName IS NULL) OR (p.FirstName IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'FirstName_Match',

    ic.MiddleName AS [MiddleName in Spreadsheet],
    p.MiddleName AS [MiddleName in LPM],
    CASE
		WHEN ic.MiddleName IS NULL and p.MiddleName IS NULL THEN 'TRUE'
        WHEN (ic.MiddleName != p.MiddleName) OR (ic.MiddleName IS NULL) OR (p.MiddleName IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'MiddleName_Match',

    ic.LastName AS [LastName in Spreadsheet],
    p.LastName AS [LastName in LPM],
    CASE
		WHEN ic.LastName IS NULL and p.LastName IS NULL THEN 'TRUE'
        WHEN (ic.LastName != p.LastName) OR (ic.LastName IS NULL) OR (p.LastName IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'LastName_Match',

    ic.Suffix AS [Suffix in Spreadsheet],
    p.Suffix AS [Suffix in LPM],
    CASE
		WHEN ic.Suffix IS NULL and p.Suffix IS NULL THEN 'TRUE'
        WHEN (ic.Suffix != p.Suffix) OR (ic.Suffix IS NULL) OR (p.Suffix IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'Suffix_Match',

    ic.DOB AS [DOB in Spreadsheet],
    p.DOB AS [DOB in LPM],
    CASE
		WHEN ic.DOB IS NULL and p.DOB IS NULL THEN 'TRUE'
        WHEN (ic.DOB != p.DOB) OR (ic.DOB IS NULL) OR (p.DOB IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'DOB_Match',

    P.PrevDOB AS [PrevDOB],

    ic.Gender AS [Gender in Spreadsheet],
    p.Gender AS [Gender in LPM],
    CASE
		WHEN ic.Gender IS NULL and p.Gender IS NULL THEN 'TRUE'
        WHEN (ic.Gender != p.Gender) OR (ic.Gender IS NULL) OR (p.Gender IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'Gender_Match',

    ic.Address1 AS [Address1 in Spreadsheet],
    p.Address1 AS [Address1 in LPM],
    CASE
		WHEN ic.Address1 IS NULL and p.Address1 IS NULL THEN 'TRUE'
        WHEN (ic.Address1 != p.Address1) OR (ic.Address1 IS NULL) OR (p.Address1 IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'Address1_Match',

    ic.city AS [City in Spreadsheet],
    p.city AS [City in LPM],
    CASE
		WHEN ic.City IS NULL and p.City IS NULL THEN 'TRUE'
        WHEN (ic.city != p.city) OR (ic.city IS NULL) OR (p.city IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'City_Match',

    ic.state AS [State in Spreadsheet],
    p.state AS [State in LPM],
    CASE
		WHEN ic.State IS NULL and p.State IS NULL THEN 'TRUE'
        WHEN (ic.state != p.state) OR (ic.state IS NULL) OR (p.state IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'State_Match',

    ic.Zipcode AS [Zipcode in Spreadsheet],
    p.Zipcode AS [Zipcode in LPM],
    CASE
		WHEN ic.Zipcode IS NULL and p.Zipcode IS NULL THEN 'TRUE'
        WHEN (ic.Zipcode != p.Zipcode) OR (ic.Zipcode IS NULL) OR (p.Zipcode IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'Zipcode_Match',

    ic.PhoneNumber AS [PhoneNumber in Spreadsheet],
    p.PhoneNumber AS [PhoneNumber in LPM],
    CASE
		WHEN ic.PhoneNumber IS NULL and p.PhoneNumber IS NULL THEN 'TRUE'
        WHEN (ic.PhoneNumber != p.PhoneNumber) OR (ic.PhoneNumber IS NULL) OR (p.PhoneNumber IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'PhoneNumber_Match',

    ic.EmailAddress AS [Email in Spreadsheet],
    p.EmailAddress AS [Email in LPM],
    CASE
		WHEN ic.EmailAddress IS NULL and p.EmailAddress IS NULL THEN 'TRUE'
        WHEN (ic.EmailAddress != p.EmailAddress) OR (ic.EmailAddress IS NULL) OR (p.EmailAddress IS NULL) THEN 'FALSE'
        ELSE 'TRUE'
    END AS 'Email_Match'

FROM 
    Intake_Clean ic
JOIN
    S3reporting.dbo.persons p
    ON ic.PersonId = p.Id
)
GO
