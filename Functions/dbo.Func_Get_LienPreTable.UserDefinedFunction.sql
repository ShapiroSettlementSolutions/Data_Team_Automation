USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_LienPreTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_LienPreTable] ()
RETURNS TABLE
AS
RETURN
(
    select ClientSSN,
		   ClientDOB,
		   ClientAddress1,
		   ClientCity,
		   ClientState,
		   ClientZipcode,
           ClientId,
           Id,
           Stage,
           LienType,
           CollectorId,
           LienholderId,
           AssignedUserId,
           statusid,
           LienHolderName
    from S3Reporting.DBO.FullProductViews
    where ClientId in (
                          Select ClientId from Intake_Clean
                      )
)
GO
