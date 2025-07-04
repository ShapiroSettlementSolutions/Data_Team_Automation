USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_Claims_Finalization]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--==================================================================--
-- Author : Ronak Vadher
-- Created Date : 11/7/2024
-- Description : To get lienId's for finalization thorugh batches

--	Modification History
--	Date			Name				Description
--	2024-11-21		Viral Panchal		Optimize SP
--==================================================================--


CREATE FUNCTION [dbo].[Fn_Claims_Finalization] ()
RETURNS TABLE
AS
RETURN
(
    SELECT f.ClientId,
           r.Claims,
           f.Id,
           ClientLastName,
           ClientFirstName,
           f.ClientSSN,
           LienType,
           f.Stage,
           CollectorName,
           LienholderName,
           Casename,
           ClientSettlementAmount,
           ClientSettlementDate,
           OnBenefits,
           OnBenefitsVerified,
           coalesce(LienDate4, LienDate3, LienDate2, LienDate1) as 'Current Lien Date',
           coalesce(LienAmount4, LienAmount3, LienAmount2, LienAmount1) as 'Current Lien Amount',
           coalesce(AuditedAmount4, AuditedAmount3, AuditedAmount2, AuditedAmount1) as 'Current Audited Amount',
           FinalDemandDate,
           FinalDemandAmount
    FROM [S3Reporting].dbo.Fullproductviews as f
        INNER JOIN medicaid_raw AS r with (Nolock)
            ON f.id = r.lienid
    WHERE f.stage = 'No Lien/Pending Settlement'
          -- 'Final No Lien Received' 'No Lien/Pending Settlement', '*Final - No Interest'
          and (
                  (
                      Casename like '%Moore%'
                      --or Casename like '%Moore%'
                  )
                  or (
                         Casename not like '%Pinnacle'
                         and ClientSettlementDate is not null
                         and (ClientSettlementdate <= (coalesce(LienDate4, LienDate3, LienDate2, LienDate1)))
                     )
              )
          --and f.Id in (
          --                select LienId from Medicaid_Raw
          --            )
)
GO
