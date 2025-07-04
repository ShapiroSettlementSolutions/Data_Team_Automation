USE [Data_Team_Automation]
GO
/****** Object:  StoredProcedure [dbo].[SP_To_Intake_Cleaned_Talc]    Script Date: 6/19/2025 7:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===============================================================================================================================================================
-- Author:    Amber Desai
-- Create date: 12-23-2024
-- Description:  Move Clean data to Intake_Clean table [Talc Requirements]

--Modified History
--Date				Name							Description
--12/23/24		Amber			Created SP to accommodate Talc Requirements
-- =================================================================================================================================================================
CREATE PROCEDURE [dbo].[SP_To_Intake_Cleaned_Talc]
(
    @AttorneyId int,
    @OrgId int,
    @CaseId int
)
AS
BEGIN
    SET nocount ON;


    IF OBJECT_ID('tempdb..#WipFile') IS NOT NULL
        DROP TABLE #WipFile

    -- Use a temporary table to store the results of the function call for better performance.
    -- This helps avoid multiple executions of the function.
    SELECT *
    INTO #WipFile
    FROM [dbo].[Func_get_wipfile](@AttorneyId, @OrgId, @CaseId);

-- Insert statements for procedure here
INSERT INTO intake_clean
(
    prefix,
    firstname,
    middleName,
    lastname,
    suffix,
    personid,
    clientid,
    attorneyid,
    orgid,
    caseid,
    ssn,
    itin,
    dob,
    dod,
    gender,
    address1,
    Address2,
    city,
    state,
    zipcode,
    phonenumber,
    emailaddress,
    ingestiondate,
    ingestiondate2,
    ingestiondate3,
    injurydate,
    surgery1,
    surgery2,
    surgery3,
    surgery4,
    surgery5,
    surgery6,
    surgery7,
    surgery8,
    surgery9,
    surgery10,
    surgery11,
    surgery12,
    descriptionofinjury,
    injurycategory,
    settlementdate,
    settlementamount,
    attorneyfee,
    attorneyfeepct,
    expensesamount,
    attorneyreferenceid,
    thirdpartyid,
    drugingested,
    defendantname
)
-- Main query
SELECT gw.Prefix_Result,
       gw.firstname_result,
       gw.MiddleName_Result,
       gw.lastname_result,
       gw.Suffix_Result,
       CASE
           WHEN gw.SSN_Result IS NOT NULL
                AND CONCAT(p.FirstName, p.LastName) = CONCAT(gw.FirstName_Result, gw.LastName_Result)
                AND p.DOB = gw.DOB_Result
                AND cc.PersonId IS NULL THEN
               p.Id
           WHEN gw.ITIN_Result IS NOT NULL
                AND CONCAT(p.FirstName, p.LastName) = CONCAT(gw.FirstName_Result, gw.LastName_Result)
                AND p.DOB = gw.DOB_Result
                AND cc.PersonId IS NULL THEN
               o.Id
           WHEN (
                    GW.SSN_Result IS NULL
                    AND GW.ITIN_Result IS NULL
                )
                AND (gw.AttorneyRefId_Result IS NOT NULL or gw.ThirdPartyId_Result IS NOT NULL)
                AND (CONCAT(a.FirstName, a.LastName) = CONCAT(gw.FirstName_Result, gw.LastName_Result))
                AND a.DOB = gw.DOB_Result
                AND a.CaseId = gw.CaseId
                AND cc.PersonId IS NULL THEN
               a.PersonId
           WHEN GW.SSN_Result IS NULL
                AND GW.ITIN_Result IS NULL
                AND gw.AttorneyRefId_Result IS NULL
                AND gw.ThirdPartyId_Result IS NULL
                AND cc.PersonId IS NULL THEN
               q.Id
           ELSE
               q.Id
       END AS PersonId,
       CASE
	   WHEN c.PersonId != p.Id THEN NULL
		   WHEN c.PersonId != o.Id THEN NULL
           WHEN c.OrgId = gw.OrgId
                THEN
               c.Id
           ELSE
               NULL
       END AS ClientId,
       @AttorneyId AS attorneyid,
       gw.OrgId,
       gw.caseid,
       gw.ssn_result,
       gw.itin_result,
       gw.dob_result,
       gw.dod_result,
       gw.gender_result,
       gw.address_result,
       gw.Address2,
       gw.city_result,
       gw.state_result,
       gw.zipcode_result,
       gw.phone_result,
       gw.email_result,
       CONVERT(varchar, gw.ingestiondate1_result, 101) AS ingestiondate1_result,
       CONVERT(varchar, gw.ingestiondate2, 101) AS ingestiondate2,
       CONVERT(varchar, gw.ingestiondate3, 101) AS ingestiondate3,
       CONVERT(varchar, gw.injurydate_result, 101) AS InjuryDate_Result,
       CONVERT(varchar, gw.Surgery1, 101) AS Surgery1,
       CONVERT(varchar, gw.Surgery2, 101) AS Surgery2,
       CONVERT(varchar, gw.Surgery3, 101) AS Surgery3,
       CONVERT(varchar, gw.Surgery4, 101) AS Surgery4,
       CONVERT(varchar, gw.Surgery5, 101) AS Surgery5,
       CONVERT(varchar, gw.Surgery6, 101) AS Surgery6,
       CONVERT(varchar, gw.Surgery7, 101) AS Surgery7,
       CONVERT(varchar, gw.Surgery8, 101) AS Surgery8,
       CONVERT(varchar, gw.Surgery9, 101) AS Surgery9,
       CONVERT(varchar, gw.Surgery10, 101) AS Surgery10,
       CONVERT(varchar, gw.Surgery11, 101) AS Sugery11,
       CONVERT(varchar, gw.Surgery12, 101) AS Surgery12,
       gw.descriptionofinjury_result,
       gw.injurycategory_result,
       gw.settlementdate_result,
       gw.settlementamount,
       gw.attorneyfee_result,
       gw.attorneyfeepct_result,
       gw.caseexpenses,
       gw.attorneyrefid_result,
       gw.thirdpartyid_result,
       gw.drugingested_result,
       gw.defendantname_result
FROM #WipFile gw
    LEFT JOIN S3reporting.dbo.persons AS p WITH (NOLOCK)
        ON p.SSN = gw.SSN_Result
    LEFT JOIN S3reporting.dbo.persons AS q WITH (NOLOCK)
        ON q.Address2 = gw.Address2
    LEFT JOIN S3reporting.dbo.persons AS o WITH (NOLOCK)
        ON o.OtherIdentifier = gw.ITIN_Result
    LEFT JOIN S3reporting.dbo.clients AS a WITH (NOLOCK)
        ON (
               a.AttorneyReferenceId = gw.AttorneyRefId_Result
               OR a.ThirdPartyId = gw.ThirdPartyId_Result
           )
           AND a.CaseId = gw.CaseId
    LEFT JOIN S3Reporting.ac.ClientContact AS cc WITH (NOLOCK)
        ON cc.PersonId IN (p.Id, q.Id, o.Id, A.PersonId)
    LEFT JOIN S3reporting.dbo.clients AS c WITH (NOLOCK)
        ON (
               c.PersonId IN (p.Id, q.Id, o.Id, a.PersonId)
           )
        AND c.CaseId = gw.CaseId
        AND c.OrgId = gw.OrgId

-- Clean up the temporary table
DROP TABLE #WipFile;

END
GO
