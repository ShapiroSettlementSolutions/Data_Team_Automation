USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_MatchSSN_Stage]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--========================================================--
--Author : Ashram Subba
--Create Date : 10/23/2024
--Description : To match SSN and check Stage with LPM

--	Date			Name				Description
--	2024-11-28		Viral Panchal		Replace [S3Reporting].dbo.Fullproductviews with S3Reporting tables
--========================================================--
CREATE function [dbo].[fn_MatchSSN_Stage] ()
Returns table
As
Return
(
    WITH CTE_Medicaid_Raw
    AS (SELECT RTRIM(LTRIM(M.ClientSSN)) as Uncleaned_SSN,
               [dbo].[Fn_CleanSSN_Mcaid](M.ClientSSN) as Cleaned_SSN,
               M.LienId,
               M.McaidNumber,
               M.IdNumber,
               M.CaseNum,
               M.EV
        FROM Medicaid_Raw as M WITH (NOLOCK)
       )
    SELECT LP.ClientId,
           M.Uncleaned_SSN,
           M.Cleaned_SSN,
           RTRIM(LTRIM(C.SSN)) as LPM_SSN,
           CASE
               WHEN LEFT(TRIM(M.EV), 1) IN ( 'Y', 'N' ) THEN
                   CASE LEFT(TRIM(M.EV), 1)
                       WHEN 'Y' THEN
                           'Yes'
                       ELSE
                           'No'
                   END
               WHEN LEFT(TRIM(M.EV), 3) = 'Yes' THEN
                   'Yes'
			   WHEN ISNUMERIC(M.EV) = 1 
			   THEN 'Yes'
               WHEN LEFT(TRIM(M.EV), 2) = 'No' THEN
                   'No'
               ELSE
                   'Unknown' -- Handle unexpected formats
           END AS 'EV',
           M.LienId,
           LP.Id,
           LP.Stage,
           LP.lientype,
		   LP.OnBenefits,
		   LP.OnBenefitsVerified,
           LP.MedicaidNumber,
           M.McaidNumber,
           LP.IdentificationNumber,
           M.IdNumber,
           LP.CaseNumber,
           M.CaseNum,
           Case
               When LP.Stage = 'Entitlement Verification'
                    and RTRIM(LTRIM(C.SSN)) = M.Cleaned_SSN then
                   'Good'
               when LP.Stage = 'Entitlement Verification'
                    and RTRIM(LTRIM(C.SSN)) != M.Cleaned_SSN then
                   'Bad - SSN Does not match'
               When LP.Stage != 'Entitlement Verification'
                    and RTRIM(LTRIM(C.SSN)) = M.Cleaned_SSN then
                   'Bad - Stage does not match'
               Else
                   'Bad'
           End as 'Result'
    FROM CTE_Medicaid_Raw as M
        INNER JOIN S3Reporting.dbo.lien_products as LP WITH (NOLOCK)
            ON LP.Id = M.LienId
        INNER JOIN S3Reporting.dbo.clients AS C WITH (NOLOCK)
            ON LP.ClientId = C.Id

/*WITH CTE_Medicaid_Raw
	AS (SELECT M.ClientSSN as Uncleaned_SSN,
	           [dbo].[Fn_CleanSSN_Mcaid](M.ClientSSN) as Cleaned_SSN,
	           M.LienId,
	           M.McaidNumber,
	           M.IdNumber,
	           M.CaseNum,
			   M.EV
	    FROM Medicaid_Raw as M WITH (NOLOCK)
	   )
	SELECT f.ClientId,
	       M.Uncleaned_SSN,
	       M.Cleaned_SSN,
	       TRIM(f.ClientSSN) as LPM_SSN,
	       CASE
	           WHEN LEFT(M.EV, 1) IN ( 'Y', 'N' ) THEN
	               CASE LEFT(M.EV, 1)
	                   WHEN 'Y' THEN
	                       'Yes'
	                   ELSE
	                       'No'
	               END
	           WHEN LEFT(M.EV, 3) = 'Yes' THEN
	               'Yes'
	           WHEN LEFT(M.EV, 2) = 'No' THEN
	               'No'
	           ELSE
	               'Unknown' -- Handle unexpected formats
	       END AS 'EV',
	       M.LienId,
	       f.Id,
	       f.Stage,
	       f.lientype,
	       f.MedicaidNumber,
	       M.McaidNumber,
	       f.IdentificationNumber,
	       M.IdNumber,
	       f.CaseNumber,
	       M.CaseNum,
	       Case
	           When f.Stage = 'Entitlement Verification'
	                and f.clientSSN = M.Cleaned_SSN then
	               'Good'
	           when f.Stage = 'Entitlement Verification'
	                and f.ClientSSN != M.Cleaned_SSN then
	               'Bad'
	           When f.Stage != 'Entitlement Verification'
	                and f.ClientSSN = M.Cleaned_SSN then
	               'Bad'
	           Else
	               'Bad'
	       End as 'Result'
	FROM [S3Reporting].dbo.Fullproductviews as f
	    INNER JOIN CTE_Medicaid_Raw as M
	        on f.Id = M.LienId
			*/

)
GO
