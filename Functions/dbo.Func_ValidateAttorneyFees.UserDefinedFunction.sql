USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateAttorneyFees]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateAttorneyFees]
(
    @AttorneyFee Nvarchar(12),
    @SettlementAmount Nvarchar(12),
    @AttorneyFeePct Decimal(10, 2)
)
RETURNS Decimal(10, 2)
AS
BEGIN
    DECLARE @AttorneyFee_Result Decimal(10, 2)

    --TRY_CAST to handle conversion failures
    DECLARE @AttorneyFee_Decimal Decimal(10, 2) = TRY_CAST(@AttorneyFee AS Decimal(10, 2));
    DECLARE @SettlementAmount_Decimal Decimal(10, 2) = TRY_CAST(@SettlementAmount AS Decimal(10, 2));

    -- Determine the result based on the provided logic
    SELECT @AttorneyFee_Result
        = CASE
              -- If AttorneyFee is null and SettlementAmount is not null and AttorneyFeePct is not null, calculate the fee
              WHEN @AttorneyFee_Decimal IS NULL
                   AND @SettlementAmount_Decimal IS NOT NULL
                   AND @AttorneyFeePct IS NOT NULL THEN
                  CAST((@SettlementAmount_Decimal * @AttorneyFeePct) / 100 AS Decimal(10, 2))

              -- If AttorneyFee is null and both SettlementAmount and AttorneyFeePct are null, return NULL
              WHEN @AttorneyFee_Decimal IS NULL
                   AND @SettlementAmount_Decimal IS NULL
                   AND @AttorneyFeePct IS NULL THEN
                  NULL

              -- If AttorneyFee is null and either SettlementAmount or AttorneyFeePct is null, return NULL
              WHEN @AttorneyFee_Decimal IS NULL
                   AND (
                           @SettlementAmount_Decimal IS NULL
                           OR @AttorneyFeePct IS NULL
                       ) THEN
                  NULL

              -- If AttorneyFee is not null and it does not match the calculated fee, return NULL
              WHEN @AttorneyFee_Decimal IS NOT NULL then
                   @AttorneyFee_Decimal

              -- If AttorneyFee is not null and it matches the calculated fee, return the AttorneyFee
              WHEN @AttorneyFee_Decimal IS NOT NULL then
                   @AttorneyFee_Decimal
              -- For any other case, return the AttorneyFee
              ELSE
                  CAST(@AttorneyFee_Decimal AS Nvarchar(12))
          END;

    RETURN @AttorneyFee_Result;
END;
GO
