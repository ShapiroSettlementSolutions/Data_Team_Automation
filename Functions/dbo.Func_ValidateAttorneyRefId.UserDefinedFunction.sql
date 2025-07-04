USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateAttorneyRefId]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateAttorneyRefId] (@AttorneyRefId NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @AttorneyRefId_Result NVARCHAR(255);
    SELECT  @AttorneyRefId_Result = 
        CASE 
            WHEN @AttorneyRefId IS NULL THEN NULL
            WHEN @AttorneyRefId LIKE '' THEN NULL
			WHEN @AttorneyRefId LIKE '%,%' THEN [dbo].[CleanAndTrimString] (REPLACE(trim(@AttorneyRefId),',', ''))
            ELSE (REPLACE(trim(@AttorneyRefId),',', ''))
        END;

    RETURN @AttorneyRefId_Result

END;
GO
