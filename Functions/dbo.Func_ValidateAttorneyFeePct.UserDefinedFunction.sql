USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateAttorneyFeePct]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateAttorneyFeePct] 
(
    @AttorneyFeePct Decimal(10,4),
    @SettlementAmount Nvarchar(12),
    @AttorneyFee Nvarchar(12)
)
RETURNS decimal(10,2)
AS
BEGIN
    DECLARE @AttorneyFeePct_Result decimal(10,4);

    -- Convert inputs to decimal values, using TRY_CAST to handle conversion failures
    DECLARE @AttorneyFee_Decimal Decimal(10,4) = TRY_CAST(@AttorneyFee AS Decimal(10,4));
    DECLARE @SettlementAmount_Decimal Decimal(10,4) = TRY_CAST(@SettlementAmount AS Decimal(10,4));
    
    -- Determine the result based on the provided logic
    SELECT @AttorneyFeePct_Result = 
        CASE 
			When @AttorneyFeePct like '_.__%' then @AttorneyFeePct*100
            -- If AttorneyFeePct is null and SettlementAmount is not null and AttorneyFee is not null, calculate the fee
            WHEN @AttorneyFeePct IS NULL AND @SettlementAmount_Decimal IS NOT NULL AND @AttorneyFee_Decimal IS NOT NULL 
                THEN CAST((@AttorneyFee_Decimal/@SettlementAmount_Decimal) * 100 AS Decimal(10,2))
            
            -- If AttorneyFeePct is null and both SettlementAmount and AttorneyFee are null, return NULL
            WHEN @AttorneyFeePct IS NULL AND @SettlementAmount_Decimal IS NULL AND @AttorneyFee_Decimal IS NULL 
                THEN NULL

            -- If AttorneyFeePct is null and either SettlementAmount or AttorneyFee is null, return NULL
            WHEN @AttorneyFeePct IS NULL AND (@SettlementAmount_Decimal IS NULL OR @AttorneyFee_Decimal IS NULL) 
                THEN NULL
            
            -- If AttorneyFeePct is not null and it does not match the calculated fee, return NULL
            WHEN @AttorneyFeePct IS NOT NULL AND @AttorneyFee_Decimal != ROUND((@AttorneyFee_Decimal/@SettlementAmount_Decimal)*100, 2) 
                THEN ROUND((@AttorneyFee_Decimal/@SettlementAmount_Decimal)*100, 2) 

            -- If AttorneyFee is not null and it matches the calculated fee, return the AttorneyFee
            WHEN @AttorneyFee_Decimal IS NOT NULL AND @AttorneyFee_Decimal = ROUND((@AttorneyFee_Decimal/@SettlementAmount_Decimal)*100, 2) 
                THEN @AttorneyFeePct
            
            -- For any other case, return the AttorneyFee
            ELSE @AttorneyFeePct
        END;

    RETURN @AttorneyFeePct_Result;
END;

GO
