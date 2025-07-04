USE [Data_Team_Automation]
GO
/****** Object:  StoredProcedure [dbo].[Sp_IntakeMaster]    Script Date: 6/19/2025 7:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Sp_IntakeMaster] (@AttorneyId int, @OrgId int, @CaseId int, @DeficiencyTypeId int)
AS
BEGIN

select * from [dbo].[Func_Get_WIPFile](@AttorneyId, @OrgId, @CaseId)

--exec [dbo].[Sp_To_IntakeCleaned]

exec [dbo].[SP_To_Intake_Cleaned] @AttorneyId, @OrgId, @CaseId --Updated

select * from [dbo].[Func_Get_PersonUploadTable]()  --Updated

select * from [dbo].[Func_Get_PersonUpdateTable]() --Updated

select * from [dbo].[Func_Get_ClientUploadTable](@AttorneyId, @OrgId, @CaseId) --Updated

select * from [dbo].[Func_Get_ClientUpdateTable]()  --Updated

--Select * from [dbo].[Func_Get_McaidCollectorLienholder]() --Updated

--select * from [dbo].[Func_Get_LienPreTable]() --Updated

--Select * from [dbo].[Func_Get_LienUpdate]('Updated Stage from System Generated / Needs Review as per instructions from [Ticket Requestor] on ticket [#TicketNo.]') --Updated

--select * from [dbo].[Func_Get_DeficiencyPreTable]() --Not Required

--select * from [dbo].[Func_GetDeficiencyUpload](@DeficiencyTypeId) --Updated

Truncate Table Intake_Clean

END
GO
