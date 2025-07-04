USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_ClientPostTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================
-- Author:		<Nishant Sharma>
-- Description:	<Gets all ClientIds>
-- ================================================================================
CREATE FUNCTION [dbo].[Func_Get_ClientPostTable](@CaseId INT)
RETURNS @ResultTable TABLE 
(
    CaseId INT,
    ClientId INT,
    PersonId INT,
    FirstName NVARCHAR(255),
    LastName NVARCHAR(255),
    SSN NVARCHAR(255),
    ITIN NVARCHAR(255),
    DOB DATE,
    DOD DATE,
    PhoneNumber NVARCHAR(255),
    EmailAddress NVARCHAR(255)
)
AS
BEGIN
    IF (@CaseId != 9443)
    BEGIN
        INSERT INTO @ResultTable
        SELECT 
            c.caseid AS [CaseId], 
            c.Id AS [ClientId], 
            c.PersonId AS [PersonId], 
            c.FirstName AS [FirstName], 
            c.LastName AS [LastName], 
            c.SSN AS [SSN], 
            c.OtherIdentifier AS [ITIN], 
            c.DOB AS [DOB], 
            c.DOD AS [DOD], 
            c.PhoneNumber AS [PhoneNumber], 
            p.EmailAddress AS [EmailAddress]
        FROM 
            S3reporting.dbo.clients c
        JOIN 
            S3reporting.dbo.persons p 
            ON c.personid = p.id
        WHERE 
            C.CaseId IN (SELECT CaseId FROM Intake_Clean) 
            AND 
            (P.SSN IN (SELECT SSN FROM Intake_Clean) OR p.Address2 LIKE '%UNIQUE%');
    END
    ELSE
    BEGIN
        INSERT INTO @ResultTable
        SELECT 
            c.caseid AS [CaseId], 
            c.Id AS [ClientId], 
            c.PersonId AS [PersonId], 
            c.FirstName AS [FirstName], 
            c.LastName AS [LastName], 
            c.SSN AS [SSN], 
            c.OtherIdentifier AS [ITIN], 
            c.DOB AS [DOB], 
            c.DOD AS [DOD], 
            c.PhoneNumber AS [PhoneNumber], 
            p.EmailAddress AS [EmailAddress]
        FROM 
            S3Reporting.dbo.clients c
        JOIN 
            S3Reporting.dbo.persons p 
            ON c.personid = p.id
        WHERE 
            C.CaseId = 9443

    END

    RETURN;
END;
GO
