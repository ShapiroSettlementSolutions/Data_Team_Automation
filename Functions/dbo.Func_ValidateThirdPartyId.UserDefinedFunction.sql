USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateThirdPartyId]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateThirdPartyId] (@ThirdPartyId NVARCHAR(255))
    RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @ThirdPartyId_Result NVARCHAR(255);
    SELECT  @ThirdPartyId_Result = 
        CASE 
            WHEN @ThirdPartyId IS NULL THEN NULL
            WHEN @ThirdPartyId LIKE '' THEN NULL
			WHEN @ThirdPartyId LIKE '%,%' THEN [dbo].[CleanAndTrimString](REPLACE(@ThirdPartyId,',', ''))
            ELSE [dbo].[CleanAndTrimString](@ThirdPartyId)
        END;

    RETURN @ThirdPartyId_Result

END;
GO
