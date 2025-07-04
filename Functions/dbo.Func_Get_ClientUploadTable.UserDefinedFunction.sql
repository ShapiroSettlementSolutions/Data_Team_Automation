USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_ClientUploadTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_ClientUploadTable] (@AttorneyId int, @OrgId int, @CaseId int)
RETURNS TABLE
AS
RETURN
(
    select 
			/*When Ic.SSN is null then concat('REMOVEAFTERUPLOADS', ic.Id) AS [UniqueId],
			Else
			ic.id*/	 
		   ic.SSN,
		   ic.Address2,
           ic.PersonId,
           AttorneyId,
           Case
		   When ic.OrgId is null
		   then @OrgId
		   else
		   ic.OrgId
		   End as 'OrgId',
           CaseId,
           IngestionDate,
		   IngestionDate2,
		   IngestionDate3,
           InjuryDate,
           Surgery1,
		   Surgery2,
		   Surgery3,
		   Surgery4,
		   Surgery5,
		   Surgery6,
		   Surgery7,
		   Surgery8,
		   Surgery9,
		   Surgery10,
		   Surgery11,
		   Surgery12,
           DescriptionOfInjury,
		   InjuryCategory,
           SettlementDate,
           SettlementAmount,
           AttorneyFee,
           AttorneyFeePct,
           ExpensesAmount,
           AttorneyReferenceId,
           ThirdPartyId,
           DrugIngested,
           DefendantName
    from Intake_Clean ic
    where ic.ClientId is null and AttorneyId = @AttorneyId and CaseId = @CaseId
)
GO
