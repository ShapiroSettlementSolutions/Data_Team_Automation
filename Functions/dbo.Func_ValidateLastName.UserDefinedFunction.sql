USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_ValidateLastName]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_ValidateLastName] (@LastName NVARCHAR(255))
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @LastName_Result NVARCHAR(255);

    SELECT @LastName_Result = CASE
                                  WHEN @LastName LIKE '%(Deceased)%'
                                       OR @LastName LIKE '%(Estate Of)%' THEN
                                      LTRIM(RTRIM(REPLACE(REPLACE(@LastName, '(Deceased)', ''), '(Estate Of)', '')))
                                  WHEN @LastName LIKE '%,%' THEN
                                      LTRIM(RTRIM(REPLACE(@LastName, ',', '')))
                                  ELSE
                                      LTRIM(RTRIM(@LastName))
                              END;

    RETURN @LastName_Result;
END;
GO
