USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_DeficiencyPreTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_DeficiencyPreTable] (@CaseId INT)
RETURNS TABLE
AS
RETURN
(
    Select DeficiencyId,
           EntityId,
           EntityTypeId,
           EntityTypeName,
           DeficiencyTypeId,
           TypeName,
           StageId,
           StageName,
           Deleted,
           Note,
           CreatedBy,
           CreatedByName,
           RequestedBy,
           RequestedDate,
           CuredBy,
           CuredDate,
           d.FollowUpDate
    from S3Reporting.dbo.Deficiencies d JOIN
	[dbo].[Func_Get_ClientPostTable](@CaseId) funcpt on d.EntityId = funcpt.ClientId
    where EntityTypeId = 4 and stageid != 4
)
GO
