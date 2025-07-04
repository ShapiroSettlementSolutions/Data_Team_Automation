USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateZipcode]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateZipcode] (@Zipcode NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @Zipcode_Result NVARCHAR(255);

    SELECT @Zipcode_Result = CASE
								 /*When Len (@Zipcode) = 4
									  AND @Zipcode NOT LIKE '%[^0-9]%' then 
									  CONCAT('0',@zipcode)*/ --Removed because it's not necessary that missing character is always zero.
                                 WHEN LEN(@Zipcode) = 5
                                      AND @Zipcode NOT LIKE '%[^0-9]%'
									  AND LEFT (@Zipcode, 1) != '0' THEN
                                     @Zipcode          -- Basic 5-digit zip code
								WHEN Left(@Zipcode,1) = '0' THEN
										CONCAT('''',@zipcode)			--Handles when 1st digit is zero to skip stripping while copying in excel.
                                 WHEN LEN(@Zipcode) = 10
                                      AND SUBSTRING(@Zipcode, 6, 1) = '-'
                                      AND LEFT(@Zipcode, 5)NOT LIKE '%[^0-9]%' THEN
                                     LEFT(@Zipcode, 5) -- Zip+4 format with hyphen								 
                                 ELSE
                                     NULL              -- Invalid format or characters in zip code
                             END;

    RETURN @Zipcode_Result;
END;


GO
