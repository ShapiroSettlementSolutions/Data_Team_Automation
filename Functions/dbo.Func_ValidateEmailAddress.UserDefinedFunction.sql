USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateEmailAddress]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateEmailAddress] (@EmailAddress NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @Email_Result NVARCHAR(255);

    SELECT @Email_Result = CASE
                               WHEN @EmailAddress LIKE '%@%'
                                    OR @EmailAddress LIKE '%com%'
                                    OR @EmailAddress LIKE '%.%' THEN
                                   [dbo].[CleanAndTrimString](@EmailAddress)
                               ELSE
                                   NULL
                           END;

    RETURN @Email_Result;
END;
GO
