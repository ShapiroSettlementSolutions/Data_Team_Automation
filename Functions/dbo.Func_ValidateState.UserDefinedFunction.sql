USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateState]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateState] (@State NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @State_Result NVARCHAR(255);

    SELECT @State_Result = CASE
                               WHEN LEN(@State) = 2 THEN
                                   UPPER(@State)                                -- State abbreviation provided
                               WHEN LEN(@State) > 2 THEN
                                   dbo.Func_StateFullNameToAbbreviation(@State) -- Full state name provided
                               ELSE
                                   NULL
                           END;

    RETURN @State_Result;
END;

GO
