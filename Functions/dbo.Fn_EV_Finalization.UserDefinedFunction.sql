USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_EV_Finalization]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--================================================================--
-- Author : Ronak Vadher
-- Created Date : 11/6/2024
-- Description : To get lienId's for finalization through batches

--Modification History
--	Date			Name				Description
--	2024-11-21		Viral Panchal		Optimize SP
--================================================================--


CREATE function [dbo].[Fn_EV_Finalization] ()
Returns table
as
return
(
    select f.ClientId,
           r.EV,
           f.Id,
           f.ClientSSN,
           f.Stage,
           f.OnBenefits,
           f.OnBenefitsVerified,
           f.LienProductStatus,
           f.RequiredMedicaidMCOLienCount,
           f.MedicaidNumber,
           f.IdentificationNumber,
           f.MedicareHicNumber,
           f.CaseNumber,
           f.ClientSettlementDate,
           f.ClientSettlementAmount,
           f.CaseName,
           case
               When r.EV = 'Yes' then
                   'Keep as it is'
               When CaseName like '%Pinnacle%' then
                   'Final No Entitlement'
               when ClientSettlementDate IS null
                    or clientsettlementdate = ' ' then
                   'Keep stage as is'
               when datediff(day, onbenefitsverified, clientsettlementdate) > 90 then
                   'To Send - Final No Entitlement'
               else
                   'Final No Entitlement'
           end Next_stage,
           datediff(day, onbenefitsverified, clientsettlementdate) date_diff
    FROM [S3Reporting].dbo.Fullproductviews as f
        INNER JOIN medicaid_raw AS r WITH (NOLOCK)
            ON f.id = r.lienid
    where f.Stage = 'Initial No Entitlement'
          --'Final No Entitlement' , 'Initial No Entitlement'													
          --and f.Id in (
          --                select LienId from Medicaid_Raw
          --            )
)
GO
