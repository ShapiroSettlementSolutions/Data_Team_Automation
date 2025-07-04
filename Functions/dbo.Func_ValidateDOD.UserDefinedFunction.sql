USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateDOD]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateDOD](@DOD Date,@DOB Date)
    RETURNS NVARCHAR(10)
AS
BEGIN
    DECLARE @DOD_Result NVARCHAR(10);

Set @DOD_Result = 
        CASE 
			
            WHEN @DOD < GETDATE()
                 AND LEN(@DOD) = 10
                 AND YEAR(@DOD) not IN (1900,1905)
                 AND @DOD > [dbo].[Func_ValidateDOB] (@DOB)			 
                THEN CONVERT(date, @DOD, 120)
			WHen @DOB is null then @DOD
            ELSE
                NULL
        END
   

    RETURN @DOD_Result;
END;
GO
