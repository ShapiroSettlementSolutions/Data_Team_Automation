USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_InjuryCategoryUpload]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_Get_InjuryCategoryUpload] (@TortId INT = NULL)
    RETURNS @ResultTable TABLE (ClientId int, InjuryCategoryId NVARCHAR(255))
AS
BEGIN
    -- Insert logic to populate the result table
if @TortId = ''
begin
	return
end
else
  INSERT INTO @ResultTable (ClientId, InjuryCategoryId)
    SELECT 
       ClientId,
	   CASE
            WHEN InjuryCategory IS NOT NULL 
                 AND InjuryCategory IN (SELECT Name FROM S3Reporting.dbo.InjuryCategory)
            THEN (SELECT Id FROM S3Reporting.dbo.InjuryCategory 
                  WHERE Name = InjuryCategory AND TortId = @TortId)
            ELSE NULL
        END as 'InjuryCategoryId'
From Intake_Clean

    RETURN
END
GO
