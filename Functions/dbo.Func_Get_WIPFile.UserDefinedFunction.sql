USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_WIPFile]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================
-- Author:		Amber Desai
-- Create date: 07/16/2024
-- Description:	Generate WIP file

-- Modified Detail
--	Date			Name				Description
--	2024-08-27		Viral Panchal		Updated select query for Ingestion Date, Injury Date validation
--	2024-09-09		Viral Panchal		Used WITH(NOLOCK) in Select Query
--	2024-09-16		Nishant Sharma		Added InjuryDate validations on Surgery1 field
--	2024-12-11		Viral Panchal		Optimize the Query
-- ================================================================================================
CREATE FUNCTION [dbo].[Func_Get_WIPFile]
(
    @AttorneyId int,
    @OrgId int,
    @CaseId int
)
RETURNS TABLE
AS
RETURN
(
    -- Optimized Query with Modularized Structure and Improved Performance
    WITH
    -- CTE for Parsing Ingestion Dates
    Get_Parse_IngestionDates
    AS (SELECT A.IRId,
               A.IngestionDate1,
               A.IngestionDate2,
               A.IngestionDate3
        FROM Intake_Raw AS IR WITH (NOLOCK)
            CROSS APPLY [dbo].[Intake_Parse_Ingestion_Date](IR.Id, TRY_CONVERT(NVARCHAR, IR.IngestionDate)) AS A
        WHERE A.IRId = IR.Id
       ),
    -- CTE for Parsing Injury Dates
    Get_Parse_InjuryDates
    AS (SELECT A.IRId,
               A.InjuryDate,
               A.Surgery1,
               A.Surgery2,
               A.Surgery3,
               A.Surgery4,
               A.Surgery5,
               A.Surgery6,
               A.Surgery7,
               A.Surgery8,
               A.Surgery9,
               A.Surgery10,
               A.Surgery11,
               A.Surgery12
        FROM Intake_Raw AS IR WITH (NOLOCK)
            CROSS APPLY [dbo].[Intake_Parse_Injury_Date](IR.Id, IR.InjuryDate) AS A
        WHERE A.IRId = IR.Id
       ),
    -- CTE for Parsing Address
    Get_Parse_Address
    AS (SELECT 
            A.IRId,
            A.Address1,
            A.City,
            A.State,
            A.Zip
        FROM 
            Intake_Raw AS IR WITH (NOLOCK)
        CROSS APPLY 
            [dbo].[Intake_Parse_Address](IR.Id, IR.Address1, IR.Address2, IR.City, IR.State, IR.Zipcode) AS A
        WHERE 
            A.IRId = IR.Id       
       ),
    -- Pre-calculate DOB and DOD Validation
    DOB_DOD_Validation
    AS (SELECT IR.Id,
               [dbo].[Func_ValidateDOB](IR.DOB) AS ValidDOB,
		Case
			When @CaseId = 9443 then ir.DOD
			ELSE
               [dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)  End AS ValidDOD
        FROM Intake_Raw AS IR
       )
    SELECT IR.Id,
           IR.Prefix,
           [dbo].[CleanAndTrimString](IR.Prefix) AS Prefix_Result,
           IR.FirstName,
           [dbo].[Func_ValidateFirstName](IR.FirstName) AS FirstName_Result,
           IR.MiddleName,
           [dbo].[CleanAndTrimString](IR.MiddleName) AS MiddleName_Result,
           IR.LastName,
           [dbo].[Func_ValidateLastName](IR.LastName) AS LastName_Result,
           IR.Suffix,
           [dbo].[CleanAndTrimString](IR.Suffix) AS Suffix_Result,
           IR.SSN,
           [dbo].[Func_ValidateSSN](IR.SSN, IR.ITIN) AS SSN_Result,
           IR.ITIN,
           [dbo].[Func_ValidateITIN](IR.SSN, IR.ITIN) AS ITIN_Result,
           IR.DOB,
           DDV.ValidDOB AS DOB_Result,
           IR.DOD,
           DDV.ValidDOD AS DOD_Result,
           IR.Gender,
           [dbo].[Func_ValidateGender](IR.Gender) AS Gender_Result,
           IR.Address1,
           CONCAT('Unique', IR.Id) AS Address2,
           [dbo].[Func_ValidateAddress](GPA.Address1, NULL) AS Address_Result,
           IR.City,
           [dbo].[Func_ValidateCity](GPA.City) AS City_Result,
           IR.State,
           [dbo].[Func_ValidateState](GPA.State) AS State_Result,
           IR.Zipcode,
           [dbo].[Func_ValidateZipcode](GPA.Zip) AS Zipcode_Result,
           IR.PhoneNumber1,
           [dbo].[Func_ValidatePhoneNumber](IR.PhoneNumber1) AS Phone_Result,
           IR.EmailAddress,
           [dbo].[Func_ValidateEmailAddress](IR.EmailAddress) AS Email_Result,
           @AttorneyId AS AttorneyId,
           CASE
               WHEN IR.OrgId IS NOT NULL THEN
                   IR.OrgId
               ELSE
                   @OrgId
           END AS OrgId,
           @CaseId AS CaseId,
           IR.IngestionDate,
           [dbo].[Func_ValidateIngestionDate](GPI.IngestionDate1, DDV.ValidDOB, DDV.ValidDOD) AS IngestionDate1_Result,
           GPI.IngestionDate2,
           GPI.IngestionDate3,
           IR.InjuryDate,
           [dbo].[Func_ValidateInjuryDate](
                                              GPID.InjuryDate,
                                              [dbo].[Func_ValidateIngestionDate](
                                                                                    GPI.IngestionDate1,
                                                                                    DDV.ValidDOB,
                                                                                    DDV.ValidDOD
                                                                                ),
                                              DDV.ValidDOB,
                                              DDV.ValidDOD
                                          ) AS InjuryDate_Result,
           [dbo].[Func_ValidateInjuryDate](
                                              GPID.Surgery1,
                                              [dbo].[Func_ValidateIngestionDate](
                                                                                    GPI.IngestionDate1,
                                                                                    DDV.ValidDOB,
                                                                                    DDV.ValidDOD
                                                                                ),
                                              DDV.ValidDOB,
                                              DDV.ValidDOD
                                          ) AS Surgery1,
           GPID.Surgery2,
           GPID.Surgery3,
           GPID.Surgery4,
           GPID.Surgery5,
           GPID.Surgery6,
           GPID.Surgery7,
           GPID.Surgery8,
           GPID.Surgery9,
           GPID.Surgery10,
           GPID.Surgery11,
           GPID.Surgery12,
           IR.DescriptionOfInjury,
           [dbo].[Func_ValidateDescriptionOfInjury](IR.DescriptionOfInjury) AS DescriptionOfInjury_Result,
           IR.InjuryCategory,
           [dbo].[Func_ValidateInjuryCategory](IR.InjuryCategory) AS InjuryCategory_Result,
           IR.SettlementDate,
           [dbo].[Func_ValidateSettlementDate](IR.SettlementDate) AS SettlementDate_Result,
           IR.SettlementAmount,
           IR.AttorneyFee,
           [dbo].[Func_ValidateAttorneyFees](
                                                IR.AttorneyFee,
                                                IR.SettlementAmount,
                                                [dbo].[Func_ValidateAttorneyFeePct](
                                                                                       IR.AttorneyFeePct,
                                                                                       IR.SettlementAmount,
                                                                                       IR.AttorneyFee
                                                                                   )
                                            ) AS AttorneyFee_Result,
           IR.AttorneyFeePct,
           [dbo].[Func_ValidateAttorneyFeePct](IR.AttorneyFeePct, IR.SettlementAmount, IR.AttorneyFee) AS AttorneyFeePct_Result,
           IR.CaseExpenses,
           IR.AttorneyReferenceId,
           [dbo].[Func_ValidateAttorneyRefId](IR.AttorneyReferenceId) AS AttorneyRefId_Result,
           IR.ThirdPartyId,
           [dbo].[Func_ValidateThirdPartyId](IR.ThirdPartyId) AS ThirdPartyId_Result,
           IR.DrugIngested,
           [dbo].[Func_ValidateDrugIngested](IR.DrugIngested) AS DrugIngested_Result,
           IR.DefendantName,
           [dbo].[Func_ValidateDefendantName](IR.DefendantName) AS DefendantName_Result
    FROM Intake_Raw AS IR WITH (NOLOCK)
        INNER JOIN Get_Parse_Address AS GPA
            ON IR.Id = GPA.IRId
        INNER JOIN Get_Parse_IngestionDates AS GPI
            ON IR.Id = GPI.IRId
        INNER JOIN Get_Parse_InjuryDates AS GPID
            ON IR.Id = GPID.IRId
        INNER JOIN DOB_DOD_Validation AS DDV
            ON IR.Id = DDV.Id
)
/* WITH Get_Parse_IngestionDates
    AS (Select PID.*
        FROM Intake_Raw AS IR WITH(NOLOCK)
            Cross Apply
        (
            SELECT *
            from [dbo].[Intake_Parse_Ingestion_Date](IR.Id, TRY_Convert(nvarchar, ir.IngestionDate)) as A
            where A.IRId = IR.Id
        ) AS PID
       ),
         Get_Parse_InjuryDates
    AS (Select PIN.*
        FROM Intake_Raw AS IR WITH(NOLOCK)
            Cross Apply
        (
            Select *
            from [dbo].[Intake_Parse_Injury_Date](IR.Id, TRY_Convert(nvarchar, ir.InjuryDate)) as A
            where A.IRID = IR.Id
        ) AS PIN
       ),
         Get_Parse_Address
    AS (SELECT PA.*
        FROM dbo.Intake_Raw AS IR WITH(NOLOCK)
            Cross apply
        (
            SELECT *
            FROM [dbo].[Intake_Parse_Address](IR.id, IR.Address1, IR.Address2, IR.City, IR.State, IR.Zipcode) AS A
            WHERE A.IRID = IR.ID
        ) AS PA
       )
    SELECT 
           ir.Id,
		   ir.Prefix,
           [dbo].[CleanAndTrimString](ir.prefix) AS [Prefix_Result],
		   ir.FirstName,
		   [dbo].[Func_ValidateFirstName](ir.FirstName) AS [FirstName_Result],
		   ir.MiddleName,
           [dbo].[CleanAndTrimString](ir.MiddleName) AS [MiddleName_Result],
		   ir.LastName,
		   [dbo].[Func_ValidateLastName](ir.LastName) AS [LastName_Result],
		   ir.Suffix,
           [dbo].[CleanAndTrimString](ir.Suffix) AS [Suffix_Result],
		   ir.SSN,
		   [dbo].[Func_ValidateSSN](ir.SSN, ir.ITIN) AS [SSN_Result],
		   ir.ITIN,
		   [dbo].[Func_ValidateITIN](ir.SSN, ir.ITIN) AS [ITIN_Result],
		   ir.DOB,
		   [dbo].[Func_ValidateDOB](ir.DOB) AS [DOB_Result],
		   ir.DOD,
		   [dbo].[Func_ValidateDOD](ir.DOD, ir.DOB) AS [DOD_Result],
		   ir.Gender,
		   [dbo].[Func_ValidateGender](ir.Gender) AS [Gender_Result],
		   ir.Address1,
		   concat('Unique',ir.id) as [Address2],
		   [dbo].[Func_ValidateAddress](gpa.Address1, NULL) AS [Address_Result],
		   ir.City,
		   [dbo].[Func_ValidateCity](gpa.City) AS [City_Result],
		   ir.State,
		   [dbo].[Func_ValidateState](gpa.State) AS [State_Result],
		   ir.Zipcode,
		   [dbo].[Func_ValidateZipcode](gpa.Zip) AS [Zipcode_Result],
		   ir.PhoneNumber1,
		   [dbo].[Func_ValidatePhoneNumber](ir.PhoneNumber1) AS [Phone_Result],
		   ir.EmailAddress,
		   [dbo].[Func_ValidateEmailAddress](ir.EmailAddress) AS [Email_Result],
		  @AttorneyId AS AttorneyId,
		  Case
			When ir.OrgId is not null
			then Ir.orgId
			Else
		   @OrgId 
		   End as 'OrgId',
		   @CaseId AS CaseId,
		   ir.IngestionDate,
		   [dbo].[Func_ValidateIngestionDate](
                                                 gpi.IngestionDate1,
                                                 [dbo].[Func_ValidateDOB](ir.DOB),
                                                 [dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)
                                             ) AS [IngestionDate1_Result],
			gpi.IngestionDate2,
			gpi.IngestionDate3,
			ir.InjuryDate,
			[dbo].[Func_ValidateInjuryDate] (gpid.injuryDate, [dbo].[Func_ValidateIngestionDate]
					(gpi.IngestionDate1, [dbo].[Func_ValidateDOB](ir.DOB),[dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)),
            [dbo].[Func_ValidateDOB](ir.DOB),[dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)) AS [InjuryDate_Result],

			[dbo].[Func_ValidateInjuryDate] (gpid.Surgery1, [dbo].[Func_ValidateIngestionDate]
					(gpi.IngestionDate1, [dbo].[Func_ValidateDOB](ir.DOB),[dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)),
            [dbo].[Func_ValidateDOB](ir.DOB),[dbo].[Func_ValidateDOD](ir.DOD, ir.DOB)) AS [Surgery1],

			gpid.Surgery2,
			gpid.Surgery3,
			gpid.Surgery4,
			gpid.Surgery5,
			gpid.Surgery6,
			gpid.Surgery7,
			gpid.Surgery8,
			gpid.Surgery9,
			gpid.Surgery10,
			gpid.Surgery11,
			gpid.Surgery12,
			ir.DescriptionOfInjury,
			[dbo].[Func_ValidateDescriptionOfInjury](ir.DescriptionOfInjury) AS [DescriptionOfInjury_Result],
			ir.InjuryCategory,
			[dbo].[Func_ValidateInjuryCategory](ir.InjuryCategory) AS [InjuryCategory_Result],
			ir.SettlementDate,
			[dbo].[Func_ValidateSettlementDate](ir.SettlementDate) AS [SettlementDate_Result],
			ir.SettlementAmount,
			ir.AttorneyFee,
			[dbo].[Func_ValidateAttorneyFees](
                                                    ir.AttorneyFee,
                                                    ir.SettlementAmount,
                                                    [dbo].[Func_ValidateAttorneyFeePct](
                                                                                           ir.AttorneyFeePct,
                                                                                           ir.SettlementAmount,
                                                                                           ir.AttorneyFee
                                                                                       )
                                                ) AS [AttorneyFee_Result],
			ir.AttorneyFeePct,
			[dbo].[Func_ValidateAttorneyFeePct](AttorneyFeePct, SettlementAmount, AttorneyFee) AS [AttorneyFeePct_Result],
			ir.CaseExpenses,
			AttorneyReferenceId,
			[dbo].[Func_ValidateAttorneyRefId](AttorneyReferenceId) AS [AttorneyRefId_Result],
			ir.ThirdPartyId,
			[dbo].[Func_ValidateThirdPartyId](ThirdPartyId) AS [ThirdPartyId_Result],
			ir.DrugIngested,
			[dbo].[Func_ValidateDrugIngested](DrugIngested) AS [DrugIngested_Result],
			ir.DefendantName,
			[dbo].[Func_ValidateDefendantName](DefendantName) AS [DefendantName_Result]
    FROM
        Intake_Raw AS ir WITH(NOLOCK)
		inner join Get_Parse_Address gpa on ir.Id = gpa.IRId
		inner join Get_Parse_IngestionDates gpi on ir.Id = gpi.IRId
		inner join Get_Parse_InjuryDates gpid on ir.Id = gpid.IRId */
GO
