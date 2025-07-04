USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Intake_Parse_Address]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Viral Panchal
-- Create date: 08/22/2024
-- Description:	Parse Address from Intake Raw table

-- Modified Detail
--	Date			Name				Description
--	2024-12-16		Viral Panchal		Modifed City in Part 1
--	2025-03-26		Amber Desai		Added Address conditions
-- =============================================
CREATE FUNCTION [dbo].[Intake_Parse_Address]
(
    @irid int,
    @irAddress1 NVARCHAR(255),
    @irAddress2 NVARCHAR(255),
    @irCity NVARCHAR(50),
    @irState NVARCHAR(50),
    @irZipcode NVARCHAR(20)
)
RETURNS @ParsedAddress TABLE
(
    IRId int,
    Address1 NVARCHAR(255),
    City NVARCHAR(255),
    State NVARCHAR(50),
    Zip NVARCHAR(20)
)
AS
BEGIN
    DECLARE @Id int,
            @Address1 NVARCHAR(255),
            @Address2 NVARCHAR(255),
            @City NVARCHAR(255),
            @State NVARCHAR(50),
            @stateId int,
            @Zip NVARCHAR(20)

    DECLARE @TempAddress NVARCHAR(255),
            @LastCommaIndex INT,
            @State_Id INT,
            @City_Id INT

    -----------------------------------------------------------------------------Check for all Address possibilities when provided in separate columns-------------------------------------------------------------------------------------
    SET @id = @irid;
    IF (
           @irAddress1 IS NOT NULL
           AND @irCity IS NOT NULL
           AND @irState IS NOT NULL
           AND @irZipcode IS NOT NULL -- ALL 4 NOT NULL AND SEPARATE
       )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NULL
              AND @irState IS NULL
              AND @irZipcode IS NOT NULL -- ONLY ZIP NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NULL -- ONLY STATE NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NOT NULL
              AND @irState IS NULL
              AND @irZipcode IS NULL -- ONLY CITY NOT NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NULL
              AND @irState IS NULL
              AND @irZipcode IS NULL -- ONLY ADDRESS NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NOT NULL -- ONLY STATE AND ZIP IS NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NOT NULL
              AND @irState IS NULL
              AND @irZipcode IS NOT NULL -- ONLY CITY AND ZIP IS NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NOT NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NULL -- ONLY CITY AND STATE IS NOT NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NULL
              AND @irState IS NULL
              AND @irZipcode IS NOT NULL -- ONLY ADDRESS AND ZIP IS NOT NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NOT NULL
              AND @irState IS NULL
              AND @irZipcode IS NULL -- ONLY ADDRESS AND CITY IS NOT NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NULL -- ONLY ADDRESS AND STATE IS NOT NULL
          )
       OR (
              @irAddress1 IS NULL
              AND @irCity IS NOT NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NOT NULL -- ONLY ADDRESS IS NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NOT NULL -- ONLY CITY IS NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NOT NULL
              AND @irState IS NULL
              AND @irZipcode IS NOT NULL -- ONLY STATE IS NULL
          )
       OR (
              @irAddress1 IS NOT NULL
              AND @irCity IS NOT NULL
              AND @irState IS NOT NULL
              AND @irZipcode IS NULL -- ONLY ZIP IS NULL
          )
    BEGIN
        --Address1 & Address2 Validations
        SET @Address1 = NULL
        IF @irAddress1 IS NULL
        BEGIN
            SET @Address1 = NULL;
        END
        ELSE IF @irAddress1 LIKE ' '
                OR @irAddress1 LIKE ''
        BEGIN
            SET @Address1 = NULL;
        END
        ELSE IF @irAddress1 IS NOT NULL
                OR @irAddress1 LIKE '%,%'
        BEGIN
            SET @Address1
                = [dbo].[CleanAndTrimString](REPLACE(CONCAT(TRIM(@irAddress1), ' ', TRIM(@irAddress2)), ',', ''));
        END
        ELSE
        BEGIN
            SET @Address1
                = [dbo].[CleanAndTrimString](REPLACE(CONCAT(TRIM(@irAddress1), ' ', TRIM(@irAddress2)), ',', ''));
        END;

        --City Validations
        SET @City = NULL
        IF @irCity IS NULL
        BEGIN
            SET @City = NULL;
        END
        ELSE
        BEGIN
            SET @City = REPLACE([dbo].[CleanAndTrimString](@irCity), ',', '')
        END

        /*SELECT @City = City
		from [dbo].[Intake_US_Cities]
		WHERE City_Ascii  = @irCity*/


        --State Validations
        --SET @irState = REPLACE(RTRIM(LTRIM(@irState)),' ' ,'')
        SET @State = NULL
        IF @irState IS NULL
        BEGIN
            SET @State = NULL;
        END
        ELSE
        BEGIN
            SET @State = REPLACE(REPLACE([dbo].[CleanAndTrimString](@irState), ' ', ''), ',', '')

            SELECT @State = State_Abbreviation
            FROM dbo.Intake_US_State WITH (NOLOCK)
            WHERE State_Name = @irState
                  OR State_Abbreviation = @irState
        END


        -- Check if @Zipcode has a length of 5 and contains only numeric characters
        SET @Zip = NULL
        IF @irZipcode IS NULL
        BEGIN
            SET @Zip = NULL;
        END
        ELSE
        BEGIN
            IF LEN(@irZipcode) = 5
               AND @irZipcode NOT LIKE '%[^0-9]%'
            BEGIN
                SET @Zip = @irZipcode; -- Valid 5-digit zip code
            END

            -- Check if @Zipcode has a length of 10, contains a hyphen at the 6th position, and the first 5 characters are numeric
            ELSE IF LEN(@irZipcode) = 10
                    AND SUBSTRING(@irZipcode, 6, 1) = '-'
                    AND LEFT(@irZipcode, 5)NOT LIKE '%[^0-9]%'
            BEGIN
                SET @Zip = LEFT(@irZipcode, 5); -- Extract the first 5 digits (Zip+4 format with hyphen)
            END

            -- For any other case
            ELSE
            BEGIN
                SET @Zip = NULL; -- Invalid format or characters in zip code
            END

        END
    END

    ---------------------------------------------------Check for Address NOT NULL, City NOT NULL, State NOT NULL, Zip NOT NULL & Combined------------------------------------------------------------------
    ELSE
    BEGIN
        -- Remove leading and trailing spaces
        SET @TempAddress = LTRIM(RTRIM(@irAddress1))

        SET @TempAddress = REPLACE(@TempAddress, ', United States.', '')
        SET @TempAddress = REPLACE(REPLACE(@TempAddress, CHAR(10), '<>'), ',', '')

        --Zip
        SET @Zip = NULL
        IF RIGHT(@tempaddress, 5) LIKE '%[0-9][0-9][0-9][0-9][0-9]%'
        BEGIN
            SET @Zip = RIGHT(@TempAddress, 5)
            SET @TempAddress = LTRIM(RTRIM(LEFT(@TempAddress, LEN(@TempAddress) - 5)))
        END

        --State
        SET @State = NULL
        IF EXISTS
        (
            SELECT 1
            FROM [dbo].[Intake_US_State]
            WHERE @tempaddress LIKE '%' + state_name
        )
        BEGIN
            SELECT @state = State_Abbreviation,
                   @irState = State_Name
            from [dbo].[Intake_US_State]
            WHERE @tempaddress LIKE '%' + state_name

            SET @tempAddress = RTRIM(LTRIM(REPLACE(@tempAddress, @irState, '')))
        END
        ELSE IF RIGHT(@tempaddress, 4) LIKE '%[A-Z][A-Z][,]%'
        BEGIN
            SET @irState = REPLACE(RIGHT(@tempaddress, 3), ',', '')

            SELECT @state = State_Abbreviation
            from [dbo].[Intake_US_State]
            WHERE State_Abbreviation = @irState

            SET @tempAddress = LTRIM(RTRIM(LEFT(@tempAddress, LEN(@tempAddress) - 3)))
        END
        ELSE IF RIGHT(LTRIM(RTRIM(@tempaddress)), 4) LIKE '%[, ][A-Z][A-Z]'
        BEGIN
            SET @irState = RIGHT(RTRIM(@tempaddress), 2)

            SELECT @state = State_Abbreviation
            from [dbo].[Intake_US_State]
            WHERE State_Abbreviation = @irState

            SET @tempAddress = LTRIM(RTRIM(LEFT(@tempAddress, LEN(@tempAddress) - 2)))
        END
        ELSE IF RIGHT(@tempaddress, 3) LIKE '%[ ][A-Z][A-Z]'
        BEGIN
            SET @irState = RIGHT(@tempaddress, 2)

            SELECT @state = State_Abbreviation
            from [dbo].[Intake_US_State]
            WHERE State_Abbreviation = @irState

            SET @tempAddress = LTRIM(RTRIM(LEFT(@tempAddress, LEN(@tempAddress) - 2)))
        END
        ELSE
        BEGIN
            DECLARE @Address VARCHAR(100) = @tempAddress
            -- Find the position of '<>'
            DECLARE @StartPosition INT = CHARINDEX('<>', @Address) + 2;

            -- Extract the substring starting after '<>'
            Declare @citystate varchar(100) = SUBSTRING(@Address, @StartPosition, LEN(@Address) - @StartPosition + 1)

            -- Find the position of ','
            DECLARE @CommaPosition INT = CHARINDEX(',', @citystate);

            -- Extract the part before the comma (Hamilton)
            --DECLARE @City VARCHAR(50) = LEFT(@citystate, @CommaPosition - 1);

            -- Extract the part after the comma for State
            SEt @irState = LTRIM(RIGHT(@citystate, LEN(@citystate) - @CommaPosition))

            SELECT @State = State_Abbreviation
            from [dbo].[Intake_US_State]
            WHERE State_Name = @irState;

            SET @tempAddress = REPLACE(@tempAddress, LTRIM(RIGHT(@citystate, LEN(@citystate) - @CommaPosition)), '')
        END

        SELECT @stateId = State_Id
        FROM dbo.Intake_US_State WITH (NOLOCK)
        WHERE State_Abbreviation = @State

        SET @TempAddress = REPLACE(@TempAddress, '  ', '<>')
        SET @TempAddress = REPLACE(@TempAddress, '><', '')

        -- Extract City
        SET @City = NULL
        IF @TempAddress LIKE '%<>%'
        BEGIN
            SET @City
                = REPLACE(
                             REPLACE(
                                        LTRIM(RTRIM(REPLACE(
                                                               SUBSTRING(
                                                                            @TempAddress,
                                                                            PATINDEX('%<>%', @TempAddress),
                                                                            LEN(@TempAddress)
                                                                        ),
                                                               '<>',
                                                               ''
                                                           )
                                                   )
                                             ),
                                        ',',
                                        ''
                                    ),
                             ';',
                             ''
                         )

            SET @irCity = REPLACE(@City, ' ', '')
            SELECT @city = City
            from [dbo].[Intake_US_Cities]
            WHERE City = @irCity

            SET @TempAddress = LEFT(@TempAddress, PATINDEX('%<>%', @TempAddress) - 1)
        END
        ELSE IF @City IS NULL
        BEGIN
            Declare @tempaddresscity varchar(250)
            SET @tempaddresscity = REPLACE(REPLACE(REPLACE(@tempAddress, '<', ''), '>', ''), ' ', '')

            SELECT @City = City
            FROM dbo.Intake_US_Cities
            WHERE State_Id = @stateId
                  and @tempaddresscity LIKE CONCAT('%', City_Ascii, '%');

            IF @City IS NOT NULL --Updated NULI to NULL
            BEGIN
                SET @tempAddress = REPLACE(RTRIM(REPLACE(@tempAddress, @City, '')), ' ,', '')
            END

        END
        ELSE
        BEGIN
            SET @Address1 = @TempAddress
        END

        -- Match City with Intake_US_Cities table
        IF @City IS NOT NULL
           AND @State_Id IS NOT NULL
        BEGIN
            SELECT @City_Id = City_Id
            FROM [dbo].Intake_US_Cities
            WHERE City = @City
                  AND State_Id = @State_Id
            IF @City_Id IS NULL
            BEGIN
                SET @City = NULL -- Reset city if not found
            END
        END

        SET @Address1 = @TempAddress
    END
    -- Insert into table
    INSERT INTO @ParsedAddress
    (
        IRId,
        Address1,
        City,
        State,
        Zip
    )
    VALUES
    (@Id, @Address1, @City, @State, @Zip)

    RETURN
END
GO
