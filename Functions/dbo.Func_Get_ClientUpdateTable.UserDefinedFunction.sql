USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_ClientUpdateTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_Get_ClientUpdateTable] ()
RETURNS TABLE
AS
RETURN
(
    Select ic.id [UniqueId],
           ic.clientId [Id],
           c.caseid [CaseId],
           Case
               When [dbo].[Func_ValidateIngestionDate](c.IngestionDate, c.DOB, c.DOD) is null then
                   Ic.IngestionDate
               When [dbo].[Func_ValidateIngestionDate](c.IngestionDate, c.DOB, c.DOD) != ic.IngestionDate then
                   Ic.IngestionDate
           End as 'IngestionDate',
           Case
               When [dbo].[Func_ValidateInjuryDate](C.Injurydate, c.IngestionDate, c.DOB, c.DOD) is null then
                   Ic.InjuryDate
               When [dbo].[Func_ValidateInjuryDate](C.Injurydate, c.IngestionDate, c.DOB, c.DOD) != ic.InjuryDate then
                   Ic.InjuryDate
           End as 'InjuryDate',
           Case
               When [dbo].[Func_ValidateDescriptionOfInjury](C.DescriptionOfInjury) is null then
                   Ic.DescriptionOfInjury
               When [dbo].[Func_ValidateDescriptionOfInjury](C.DescriptionOfInjury) != ic.DescriptionOfInjury then
                   Ic.DescriptionOfInjury
           End as 'DescriptionOfInjury',
           Case
               When [dbo].[Func_ValidateSettlementDate](C.SettlementDate) is null then
                   Ic.SettlementDate
               When [dbo].[Func_ValidateSettlementDate](C.SettlementDate) != ic.SettlementDate then
                   Ic.SettlementDate
           End as 'SettlementDate',
           Case
               When (C.SettlementAmount) is null then
                   Ic.SettlementAmount
              When  Replace(Replace(replace(C.SettlementAmount, '$',''),',',''),'.00','') != Convert(nvarchar,Replace(Replace(replace(ic.SettlementAmount, '$',''),',',''),'.00','')) then
                   Ic.SettlementAmount
           End as 'SettlementAmount',
           Case
               When [dbo].[Func_ValidateAttorneyFees](C.AttorneyFee, C.SettlementAmount, C.AttorneyFeePct) is null then
                   Ic.AttorneyFee
               when [dbo].[Func_ValidateAttorneyFees](C.AttorneyFee, C.SettlementAmount, C.AttorneyFeePct) != ic.AttorneyFee then
                   Ic.AttorneyFee
           End as 'AttorneyFee',
           Case
               When [dbo].[Func_ValidateAttorneyFeePct](C.AttorneyFeePct, C.SettlementAmount, C.AttorneyFee) is null then
                   Ic.AttorneyFeePct
               When [dbo].[Func_ValidateAttorneyFeePct](C.AttorneyFeePct, C.SettlementAmount, C.AttorneyFee) != ic.AttorneyFeePct then
                   Ic.AttorneyFeePct
           End as 'AttorneyFeePct',
           Case
               When (C.ExpensesAmount) is null then
                   Ic.ExpensesAmount
               When (C.ExpensesAmount) != Convert(nvarchar,ic.ExpensesAmount) then
                   Ic.ExpensesAmount
           End as 'ExpensesAmount',
           Case
               When [dbo].[Func_ValidateAttorneyRefId](C.AttorneyReferenceId) is null then
                   Ic.AttorneyReferenceId
               When [dbo].[Func_ValidateAttorneyRefId](C.AttorneyReferenceId) != ic.AttorneyReferenceId then
                   Ic.AttorneyReferenceId
           End as 'AttorneyReferenceId',
           Case
               When [dbo].[Func_ValidateThirdPartyId](C.ThirdPartyId) is null then
                   Ic.ThirdPartyId
               When [dbo].[Func_ValidateThirdPartyId](C.ThirdPartyId) != ic.ThirdPartyId then
                   Ic.ThirdPartyId
           End as 'ThirdPartyId',
           Case
               When [dbo].[Func_ValidateDefendantName](C.DefendantName) is null then
                   Ic.DefendantName
               When [dbo].[Func_ValidateDefendantName](C.DefendantName) != ic.DefendantName then
                   Ic.DefendantName
           End as 'DefendantName',
           Case
               When [dbo].[Func_ValidateDrugIngested](c.DrugIngested) is null then
                   Ic.DrugIngested
               When [dbo].[Func_ValidateDrugIngested](c.DrugIngested) != ic.DrugIngested then
                   Ic.DrugIngested
           End as 'DrugIngested'
    from Intake_Clean ic
        join S3Reporting.dbo.clients c
            ON ic.PersonId = C.PersonId
    where c.CaseId in (
                          Select CaseId from Intake_Clean
                      )
)
GO
