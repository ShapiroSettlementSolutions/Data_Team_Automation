USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_GetDeficiencyUpload]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_GetDeficiencyUpload]
(
    @EntityTypeId int,
    @CaseId int
)
RETURNS @ResultTable TABLE
(
    EntityTypeId int,
    EntityId int,
    DeficiencyTypeId int,
    Note NVARCHAR(50)
)
AS
BEGIN
    DECLARE @TypeId int;
    SET @TypeId = @EntityTypeId;

    If @TypeId = 1
    Begin
        -- Check for missing SSN
        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               Id,
               1013 AS DeficiencyTypeId,
               'SSN' AS Note
        FROM [dbo].[Func_Get_LienPreTable]()
        WHERE ClientId IN (
                              SELECT ClientId FROM Intake_Clean
                          )
              AND ClientSSN IS NULL;

        -- Check for missing DOB
        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               Id,
               1016 AS DeficiencyTypeId,
               'DOB' AS Note
        FROM [dbo].[Func_Get_LienPreTable]()
        WHERE ClientId IN (
                              SELECT ClientId FROM Intake_Clean
                          )
              AND ClientDOB IS NULL;

        -- Check for missing Address
        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               Id,
               1015 AS DeficiencyTypeId,
               'Address' AS Note
        FROM [dbo].[Func_Get_LienPreTable]()
        WHERE ClientId IN (
                              SELECT ClientId FROM Intake_Clean
                          )
              AND (
                      ClientAddress1 IS NULL
                      OR ClientCity IS NULL
                      OR ClientState IS NULL
                      OR ClientZipcode IS NULL
                  )
			  AND LienType not like '%Medicare%'	
        RETURN;
    END;

    Else IF @TypeId = 4 AND @CaseId = 9443
    Begin
        -- Check for missing SSN
        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               39 AS DeficiencyTypeId,
               'SSN' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  SSN IS NULL
                  or SSN = ''
              )
              and (
                      ITIN is Null
                      or ITIN = ''
                  )
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 39
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               38 AS DeficiencyTypeId,
               'DOB' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  DOB IS NULL
                  or FirstName = ''
              )
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 38
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               1081 AS DeficiencyTypeId,
               'Full Legal Name' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  (
                      FirstName IS NULL
                      or FirstName = ''
					  or FirstName = 'NO DATA'
                  )
                  or (Len(Firstname) = 1)
                  or (
                         FirstName like '._'
                         or FirstName like '_.'
                         or FirstName like '._.'
                     )
                  or (
                         FirstName like ',_'
                         or FirstName like '_,'
                         or FirstName like ',_,'
                     )
                  or (
                         FirstName like '?_'
                         or FirstName like '_?'
                         or FirstName like '?_?'
                     )
                  or (
                         FirstName like '!_'
                         or FirstName like '_!'
                         or FirstName like '!_!'
                     )
                  or (
                         FirstName like ':_'
                         or FirstName like '_:'
                         or FirstName like ':_:'
                     )
                  or (
                         FirstName like ';_'
                         or FirstName like '_;'
                         or FirstName like ';_;'
                     )
                  or (
                         FirstName like '''_'
                         or FirstName like '_'''
                         or FirstName like '''_'''
                     )
                  or (
                         FirstName like '"_'
                         or FirstName like '_"'
                         or FirstName like '"_"'
                     )
                  or (
                         FirstName like '()_'
                         or FirstName like '_()'
                         or FirstName like '()_()'
                     )
                  or (
                         FirstName like '-_'
                         or FirstName like '_-'
                         or FirstName like '-_-'
                     )
                  or (
                         FirstName like '[]_'
                         or FirstName like '_[]'
                         or FirstName like '[]_[]'
                     )
					or (
                         FirstName like '/_'
                         or FirstName like '_/'
                         or FirstName like '/_/'
                     )
					or (
                         FirstName like ' _'
                         or FirstName like '_ '
                         or FirstName like ' _ '
                     )
              )
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 1081
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               1081 AS DeficiencyTypeId,
               'Full Legal Name' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  (
                      LastName IS NULL
                      or LastName = ''
					  or LastName = 'NO DATA'
                  )
                  or (LEN(LastName) = 1)
                  or (
                         LastName like '._'
                         or LastName like '_.'
                         or LastName like '._.'
                     )
                  or (
                         LastName like ',_'
                         or LastName like '_,'
                         or LastName like ',_,'
                     )
                  or (
                         LastName like '?_'
                         or LastName like '_?'
                         or LastName like '?_?'
                     )
                  or (
                         LastName like '!_'
                         or LastName like '_!'
                         or LastName like '!_!'
                     )
                  or (
                         LastName like ':_'
                         or LastName like '_:'
                         or LastName like ':_:'
                     )
                  or (
                         LastName like ';_'
                         or LastName like '_;'
                         or LastName like ';_;'
                     )
                  or (
                         LastName like '''_'
                         or LastName like '_'''
                         or LastName like '''_'''
                     )
                  or (
                         LastName like '"_'
                         or LastName like '_"'
                         or LastName like '"_"'
                     )
                  or (
                         LastName like '()_'
                         or LastName like '_()'
                         or LastName like '()_()'
                     )
                  or (
                         LastName like '-_'
                         or LastName like '_-'
                         or LastName like '-_-'
                     )
                  or (
                         LastName like '[]_'
                         or LastName like '_[]'
                         or LastName like '[]_[]'
                     )
				or (
                         LastName like '/_'
                         or LastName like '_/'
                         or LastName like '/_/'
                     )
					or (
                         LastName like ' _'
                         or LastName like '_ '
                         or LastName like ' _ '
                     )
              )
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 1081
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               1083 AS DeficiencyTypeId,
               'Email Address' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  EmailAddress IS NULL
                  or EmailAddress = ''
              )
              and DOD is NULL
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 1083
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT DISTINCT
            @EntityTypeId AS EntityTypeId,
            qc.Id,
            1084 AS DeficiencyTypeId,
            'Duplicate Email Address' AS Note
        FROM S3Reporting.dbo.clients qc
            JOIN S3Reporting.dbo.persons p
                ON qc.PersonId = p.Id
        WHERE qc.CaseId = 5864
              AND p.EmailAddress IN (
                                        SELECT EmailAddress
                                        FROM S3Reporting.dbo.persons ps
                                            JOIN S3Reporting.dbo.clients cl
                                                ON ps.Id = cl.PersonId
                                        WHERE cl.CaseId = 5864
                                        GROUP BY EmailAddress
                                        HAVING COUNT(*) > 1 -- Only include duplicate email addresses
                                    )
              AND qc.Id NOT IN (
                                   SELECT EntityId
                                   FROM [dbo].[Func_Get_DeficiencyPreTable](@CaseId)
                                   WHERE DeficiencyTypeId = 1084
                               )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               1082 AS DeficiencyTypeId,
               'Phone Number' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE (
                  PhoneNumber IS NULL
                  or PhoneNumber = ''
              )
              and DOD is NULL
              and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 1082
                                  )

        INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT DISTINCT
            @EntityTypeId AS EntityTypeId,
            qc.Id,
            1085 AS DeficiencyTypeId,
            'Duplicate Phone Number' AS Note
        FROM S3Reporting.dbo.clients qc
            JOIN Func_Get_ClientPostTable(@CaseId) funclient
                ON qc.PhoneNumber = funclient.PhoneNumber
        WHERE qc.CaseId = 5864
              AND qc.PhoneNumber IN (
                                        SELECT PhoneNumber
                                        FROM S3Reporting.dbo.clients
                                        WHERE CaseId = 5864
                                        GROUP BY PhoneNumber
                                        HAVING COUNT(*) > 1 -- Only include duplicate phone numbers
                                    )
              AND qc.Id NOT IN (
                                   SELECT EntityId
                                   FROM [dbo].[Func_Get_DeficiencyPreTable](@CaseId)
                                   WHERE DeficiencyTypeId = 1085
                               );
		INSERT INTO @ResultTable
        (
            EntityTypeId,
            EntityId,
            DeficiencyTypeId,
            Note
        )
        SELECT @EntityTypeId AS EntityTypeId,
               ClientId,
               223 AS DeficiencyTypeId,
               'DOD - Less than DOB ' AS Note
        FROM [dbo].[Func_Get_ClientPostTable](@CaseId)
        WHERE DOD < DOB	
		and ClientId not in (
                                      Select EntityId
                                      from Func_Get_DeficiencyPreTable(@CaseId)
                                      where DeficiencyTypeId = 223
                                  )

    End;
    Return
end

GO
