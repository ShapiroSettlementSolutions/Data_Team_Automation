USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateDOB]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateDOB] (@DOB Date)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @DOB_Result date;

    SELECT @DOB_Result = CASE
							WHEN Year(@DOB) < 1900 THEN NULL
                             WHEN @DOB < GETDATE()
                                  AND LEN(@DOB) = 10
                                  AND YEAR(@DOB) NOT IN ( 1900, 1905 ) 
								  THEN @DOB								  
                             ELSE
                                 NULL
                         END

    RETURN @DOB_Result;
END;
GO
