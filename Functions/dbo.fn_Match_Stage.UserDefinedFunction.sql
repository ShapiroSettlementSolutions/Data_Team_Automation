USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Match_Stage]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--===============================================================--
-- Author : Ashram Subba
-- Create Date : 10/24/2024
-- Description : To check Stage as Pending Claims on LPM
--===============================================================--

CREATE function [dbo].[fn_Match_Stage] ()
Returns table
As
Return
(
    Select Round(M.LienAmount,2) AS LienAmount,
           f.ClientId,
           M.ClientSSN,
           CASE
               WHEN LEFT(M.Claims, 1) IN ( 'Y', 'N' ) THEN
                   CASE LEFT(M.Claims, 1)
                       WHEN 'Y' THEN
                           'Yes'
                       ELSE
                           'No'
                   END
               WHEN LEFT(M.Claims, 3) = 'Yes' THEN
                   'Yes'
               WHEN LEFT(M.Claims, 2) = 'No' THEN
                   'No'
               ELSE
                   'Unknown' -- Handle unexpected formats
           END AS 'Claims',
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
		   f.Liendate1,
		   f.LienAmount1,
		   f.AuditedAmount1,
		   f.LienDate2,
		   f.lienAmount2,
		   f.AuditedAmount2,
		   f.LienDate3,
		   f.LienAmount3,
		   f.AuditedAmount3,
		   f.LienDate4,
		   f.LienAmount4,
		   f.AuditedAmount4,
           Case
               When f.Stage = 'Pending Claims' then
                   'Good'
               Else
                   'Bad'
           End as 'Result'
    FROM [S3Reporting].dbo.Fullproductviews as f
        Inner join Medicaid_Raw as M WITH (NOLOCK)
            On f.Id = M.LienId
)
GO
