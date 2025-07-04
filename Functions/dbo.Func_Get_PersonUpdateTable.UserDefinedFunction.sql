USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_PersonUpdateTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Amber Desai
-- Create date: 07/16/2024
-- Description:	Generate Person Update Table
-- =============================================
CREATE FUNCTION [dbo].[Func_Get_PersonUpdateTable] ()
RETURNS TABLE
AS
RETURN

(

    SELECT ic.Id [UniqueId],
           ic.PersonId [Id],
           --ic.CaseId [ExistInCase],
		   CASE
			   WHEN [dbo].[Func_ValidateFirstName](p.Prefix) is null then
                   ic.Prefix
               WHEN [dbo].[Func_ValidateFirstName](p.Prefix) != ic.Prefix then
                   ic.Prefix
				Else NULL
			END AS 'Prefix',
           CASE
			   WHEN [dbo].[Func_ValidateFirstName](p.FirstName) is null then
                   ic.FirstName
               WHEN [dbo].[Func_ValidateFirstName](p.FirstName) != ic.FirstName then
                   ic.FirstName 
				Else NULL

           END AS 'FirstName',

		   CASE
			   WHEN [dbo].[Func_ValidateFirstName](p.MiddleName) is null then
                   ic.MiddleName
               WHEN [dbo].[Func_ValidateFirstName](p.MiddleName) != ic.MiddleName then
                   ic.MiddleName
				Else NULL
			END AS 'MiddleName',

           CASE
			    WHEN [dbo].[Func_ValidateLastName](p.LastName) is null then
                   ic.LastName 	
               WHEN [dbo].[Func_ValidateLastName](p.LastName) != ic.LastName then
                   ic.LastName
				Else NULL	
           END AS 'LastName',

		   CASE
			   WHEN [dbo].[Func_ValidateFirstName](p.Suffix) is null then
                   ic.Suffix
               WHEN [dbo].[Func_ValidateFirstName](p.Suffix) != ic.Suffix then
                   ic.Suffix
				Else NULL
			END AS 'Suffix',

           CASE
		       WHEN [dbo].[Func_ValidateSSN](p.SSN, p.OtherIdentifier) is null then
                   ic.SSN
               WHEN [dbo].[Func_ValidateSSN](p.SSN, p.OtherIdentifier) != ic.SSN then
                   ic.SSN
				   Else NULL
           END AS 'SSN',
           CASE
		       WHEN [dbo].[Func_ValidateITIN](p.SSN, p.OtherIdentifier) Is null then
                   ic.ITIN
               WHEN [dbo].[Func_ValidateITIN](p.SSN, p.OtherIdentifier) != ic.ITIN then
                   ic.ITIN
				   Else NULL
           END AS 'OtherIdentifier',
           CASE
		       WHEN [dbo].[Func_ValidateDOB](p.DOB) is null then
                   ic.DOB
               WHEN [dbo].[Func_ValidateDOB](p.DOB) != ic.DOB then
                   ic.DOB
				  -- Else ''
           END AS 'DOB',
           CASE
		       WHEN [dbo].[Func_ValidateDOD](p.DOD, p.DOB) is null then
                   ic.DOD
               WHEN [dbo].[Func_ValidateDOD](p.DOD, p.DOB) != ic.DOD then
                   ic.DOD
				 --  Else ''
           END AS 'DOD',
           CASE
		       WHEN [dbo].[Func_ValidateGender](p.Gender) is null then
                   ic.Gender
               WHEN [dbo].[Func_ValidateGender](p.Gender) != ic.Gender then
                   ic.Gender
				   Else NULL
           END AS 'Gender',

           CASE
		       WHEN [dbo].[Func_ValidateAddress](p.Address1, p.Address2) Is null then
                   ic.Address1
			   When P.address2 like '%Unique%' then NULL	
               WHEN [dbo].[Func_ValidateAddress](p.Address1, p.Address2) != ic.Address1 then
                   ic.Address1
			   Else NULL
           END AS 'Address1',

           CASE
		       WHEN [dbo].[Func_ValidateCity](p.City) is null then
                   ic.City
               WHEN [dbo].[Func_ValidateCity](p.City) != ic.City then
                   ic.City
			   Else NULL		
           END AS 'City',

           CASE
		       WHEN [dbo].[Func_ValidateState](p.State) is null then
                   ic.State
               WHEN [dbo].[Func_ValidateState](p.State) != ic.State then
                   ic.State
			   Else NULL		
           END AS 'State',

           CASE
		       WHEN [dbo].[Func_ValidateZipcode](p.Zipcode) is null then
                   ic.Zipcode
               WHEN [dbo].[Func_ValidateZipcode](p.Zipcode) != ic.Zipcode then
                   ic.Zipcode
			   Else NULL	
           END AS 'Zipcode',

           CASE
		       WHEN [dbo].[Func_ValidatePhoneNumber](p.PhoneNumber) is null then
                   ic.PhoneNumber
               WHEN [dbo].[Func_ValidatePhoneNumber](p.PhoneNumber) != ic.PhoneNumber then
                   ic.PhoneNumber
				   Else NULL
           END AS 'PhoneNumber',

           CASE
		       WHEN [dbo].[Func_ValidateEmailAddress](p.EmailAddress) is null then
                   ic.EmailAddress
               WHEN [dbo].[Func_ValidateEmailAddress](p.EmailAddress) != ic.EmailAddress then
                   ic.EmailAddress
				   Else NULL
           END AS 'EmailAddress'

    FROM Intake_Clean ic WITH (NOLOCK)
        JOIN S3reporting.dbo.persons p
            on ic.PersonId = p.Id
        /*JOIN S3Reporting.dbo.clients c WITH (NOLOCK)
            on p.Id = c.PersonId*/
)








GO
