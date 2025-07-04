USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_PersonUploadTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_PersonUploadTable] ()
RETURNS TABLE
AS
RETURN
(
    select ic.Id [Unique],
		   Prefix,	
           FirstName,
		   MiddleName,
           LastName,
		   Suffix,
           SSN,
           ITIN [OtherIdentifier],
           DOB,
           DOD,
           Gender,
           Address1,
		   Address2,
           City,
           State,
           Zipcode,
           PhoneNumber,
           EmailAddress
    from Intake_Clean ic
    where ic.PersonId is null
/*where ic.Id not in (
                           select [UniqueId] from [dbo].[Func_Get_PersonUpdateTable]()
                       )*/
)
GO
