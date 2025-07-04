USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[CleanAndTrimString]    Script Date: 6/19/2025 7:10:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CleanAndTrimString](@input NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @output NVARCHAR(MAX) = @input;

    -- Remove leading and trailing spaces
    SET @output = LTRIM(RTRIM(@output));

    -- Remove common invisible characters
    SET @output = REPLACE(@output, CHAR(9), ' ');    -- Tab
    SET @output = REPLACE(@output, CHAR(10), ' ');   -- Line Feed
    SET @output = REPLACE(@output, CHAR(13), ' ');   -- Carriage Return
    SET @output = REPLACE(@output, CHAR(160), ' ');  -- Non-breaking space

    -- Remove additional Unicode whitespace characters
    SET @output = REPLACE(@output, NCHAR(5760), ' '); -- Ogham Space Mark
    SET @output = REPLACE(@output, NCHAR(6158), ' '); -- Mongolian Vowel Separator
    SET @output = REPLACE(@output, NCHAR(8192), ' '); -- En Quad
    SET @output = REPLACE(@output, NCHAR(8193), ' '); -- Em Quad
    SET @output = REPLACE(@output, NCHAR(8194), ' '); -- En Space
    SET @output = REPLACE(@output, NCHAR(8195), ' '); -- Em Space
    SET @output = REPLACE(@output, NCHAR(8196), ' '); -- Three-Per-Em Space
    SET @output = REPLACE(@output, NCHAR(8197), ' '); -- Four-Per-Em Space
    SET @output = REPLACE(@output, NCHAR(8198), ' '); -- Six-Per-Em Space
    SET @output = REPLACE(@output, NCHAR(8199), ' '); -- Figure Space
    SET @output = REPLACE(@output, NCHAR(8200), ' '); -- Punctuation Space
    SET @output = REPLACE(@output, NCHAR(8201), ' '); -- Thin Space
    SET @output = REPLACE(@output, NCHAR(8202), ' '); -- Hair Space
    SET @output = REPLACE(@output, NCHAR(8232), ' '); -- Line Separator
    SET @output = REPLACE(@output, NCHAR(8233), ' '); -- Paragraph Separator
    SET @output = REPLACE(@output, NCHAR(8287), ' '); -- Medium Mathematical Space
    SET @output = REPLACE(@output, NCHAR(12288), ' '); -- Ideographic Space

    -- Replace multiple spaces with a single space
    WHILE CHARINDEX('  ', @output) > 0
    BEGIN
        SET @output = REPLACE(@output, '  ', ' ');
    END

    RETURN @output;
END;
GO
