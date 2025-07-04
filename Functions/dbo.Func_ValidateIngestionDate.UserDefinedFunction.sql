USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateIngestionDate]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateIngestionDate]
(
    @IngestionDate DATE,
    @ValidatedDOB DATE,
    @ValidatedDOD DATE
-- @ValidatedInjuryDate DATE
)
RETURNS DATE
AS
BEGIN
    DECLARE @Result DATE;

    IF @IngestionDate > GETDATE()
        Set @IngestionDate = NULL

    IF (
           @ValidatedDOB IS NULL
           AND @ValidatedDOD IS NULL /* AND @ValidatedInjuryDate IS NULL*/
       )
        SET @Result = @IngestionDate; --PASSED


    ELSE IF (@ValidatedDOB IS NOT NULL AND @ValidatedDOD IS NULL)
    BEGIN
        IF (@ValidatedDOB < @IngestionDate)
            SET @Result = @IngestionDate;
    END
    ELSE IF (@ValidatedDOB IS NULL AND @ValidatedDOD IS NOT NULL)
    BEGIN
        If (@IngestionDate > @ValidatedDOD)
            SET @Result = NULL
        ELSE
            Set @Result = @IngestionDate
    END --LOOKS GOOD

    ELSE IF (@ValidatedDOD IS NOT NULL AND @ValidatedDOB IS NOT NULL)
    BEGIN
        If (@IngestionDate > @ValidatedDOB AND @IngestionDate < @ValidatedDOD)
            SET @Result = @IngestionDate
        ELSE
            SET @Result = NULL
    END
    ELSE
        SET @Result = NULL;

    RETURN @Result;
END;
GO
