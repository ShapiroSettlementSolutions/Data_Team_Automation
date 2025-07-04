USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_PersonPostTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[Func_Get_PersonPostTable]()
RETURNS TABLE
AS
RETURN
	
	SELECT Id, SSN, FirstName, LastName, DOB, DOD, Address1, Address2, City, State, Zipcode, PhoneNumber, EmailAddress
	from S3Reporting.dbo.persons p
    where (SSN in (SELECT SSN from Intake_Clean) or OtherIdentifier in (Select ITIN from Intake_Clean))  or p.Address2 like '%Unique%'
GO
