USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateITIN]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Viral Panchal
-- Create date: 07/19/2024
-- Description:	ValidateITIN
-- =============================================
CREATE FUNCTION [dbo].[Func_ValidateITIN]
(
    @ssn nvarchar(15),
    @itin NVARCHAR(15)
)
RETURNS NVARCHAR(15)
AS
BEGIN
    DECLARE @ValidITIN NVARCHAR(15);

SET @ssn = [dbo].[Func_FormatSSN_ITIN](@ssn)
SET @itin = [dbo].[Func_FormatSSN_ITIN](@itin)

SELECT @ValidITIN = CASE
                        WHEN
                        (
                            @ssn IS NOT NULL
                            AND @itin IS NOT NULL
                        ) THEN
                            NULL
                        WHEN
                        (
                            @ssn IS NULL
                            AND @itin IS NOT NULL
                            AND SUBSTRING(@itin, 1, 1) <> '9'
                        ) THEN
                            NULL
                        WHEN
                        (
                            @ssn IS NOT NULL
                            AND @itin IS NULL
                            AND SUBSTRING(@ssn, 1, 1) = '9'
                        ) THEN
                            @ssn
                        ELSE
                            @itin
                    END
RETURN @ValidITIN;
END
GO
