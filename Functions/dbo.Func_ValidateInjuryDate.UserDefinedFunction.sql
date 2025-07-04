USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateInjuryDate]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateInjuryDate]
(
    @InjuryDate DATE,
    @IngestionDate Date,
    @ValidatedDOB Date,
    @ValidatedDOD Date

-- @ValidatedInjuryDate DATE
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;

    IF (@InjuryDate > GETDATE())
        SET @InjuryDate = NULL


    IF (
           ([dbo].[Func_ValidateIngestionDate](@IngestionDate, @ValidatedDOB, @ValidatedDOD) is null) 
		   or (@InjuryDate >= [dbo].[Func_ValidateIngestionDate](@IngestionDate, @ValidatedDOB, @ValidatedDOD))
       )
        Set @Result = @InjuryDate
    ELSE
        Set @Result = NULL

    RETURN @Result;
END;
GO
