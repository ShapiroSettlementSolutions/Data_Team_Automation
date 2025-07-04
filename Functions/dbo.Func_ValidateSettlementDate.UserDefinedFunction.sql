USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateSettlementDate]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_ValidateSettlementDate] (@SettlementDate Date)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @SettlementDate_Result date;

    SELECT @SettlementDate_Result = CASE
                             WHEN @SettlementDate < GETDATE()
                                  AND LEN(@SettlementDate) = 10
                                  AND YEAR(@SettlementDate) NOT IN (1900, 1905) 
								  THEN @SettlementDate
                             ELSE
                                 NULL
                         END

    RETURN @SettlementDate_Result;
END;
GO
