USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Update_McaidNumber]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--===================================================================================================================================================================================================================================
-- Author : Ashram Subba
-- Created Date : 10/30/2024
-- Description : To update Mcaid numbers if any

--	Modification History
--	Date			Name				Description
--	2024-12-23		Ronak Vadher		Updated the function to handle cases where F.MedicaidNumber does not match M.MedicaidNumber. In such instances, both values will be updated as concatenated data.
--  2025-01-02		Ronak Vadher		Updated the function to handle cases where F.MedicaidNumber, IdentificationNumber, or CaseNumber do not match their respective values in Medicaid_Raw; in such instances, mismatched values are concatenated, while rows with invalid data ('N/A', 'No', 'Not Eligible', 'None') are excluded.
--===========================================================================================================================================================================================================================================================================================================================================================


CREATE FUNCTION [dbo].[fn_Update_McaidNumber] ()
RETURNS TABLE
AS
RETURN
(SELECT f.Id,
       --f.MedicaidNumber AS [LPM MedicaidNumber],
       --M.McaidNumber, -- Medicaid number from Medicaid_Raw
       --f.IdentificationNumber AS [LPM IdentificationNumber],
       --M.IdNumber,    -- ID number from Medicaid_Raw
       --f.CaseNumber AS [LPM CaseNumber],
       --M.Casenum,     -- Case number from Medicaid_Raw

       MedicaidNumber = CASE
                            -- If McaidNumber is NULL or blank, and f.MedicaidNumber is not null or blank, use f.MedicaidNumber
                            WHEN (
                                     LTRIM(RTRIM(M.McaidNumber)) IS NULL
                                     OR LTRIM(RTRIM(M.McaidNumber)) = ''
                                 )
                                 AND (LTRIM(RTRIM(f.MedicaidNumber)) <> '') THEN
                                Null

       WHEN (
                                     LTRIM(RTRIM(f.MedicaidNumber)) IS Not NULL
                                     OR LTRIM(RTRIM(m.McaidNumber)) <> ''
                                 )
                                 AND (LTRIM(RTRIM(M.McaidNumber)) = LTRIM(RTRIM(f.MedicaidNumber))) THEN
                                Null
                                              -- If McaidNumber and MedicaidNumber differ, concatenate them
                            WHEN LTRIM(RTRIM(M.McaidNumber)) <> LTRIM(RTRIM(f.MedicaidNumber)) THEN
                                CONCAT(LTRIM(RTRIM(M.McaidNumber)), ', ', LTRIM(RTRIM(f.MedicaidNumber)))
                            ELSE
                                LTRIM(RTRIM(m.McaidNumber)) -- Keep existing value if no condition is met
                        END,
       IdentificationNumber = CASE
                                  -- If MedicaidNumber is NULL or blank, and f.IdNumber is not null or blank, use f.IdNumber
                                  WHEN (
                                           LTRIM(RTRIM(IdNumber)) IS NULL
                                           OR LTRIM(RTRIM(IdNumber)) = ''
                                       )
                                       AND (LTRIM(RTRIM(f.IdentificationNumber)) <> '') THEN
                                      null
WHEN (
 LTRIM(RTRIM(f.IdentificationNumber)) IS Not NULL
  OR LTRIM(RTRIM(m.IdNumber)) <> ''
)
AND (LTRIM(RTRIM(M.IdNumber)) = LTRIM(RTRIM(f.IdentificationNumber))) THEN Null

                                  WHEN (
                                           LTRIM(RTRIM(f.IdentificationNumber)) IS NULL
                                           OR LTRIM(RTRIM(f.IdentificationNumber)) = ''
                                       )
                                       AND LTRIM(RTRIM(M.McaidNumber)) <> '' THEN
                                      LTRIM(RTRIM(M.McaidNumber))

                                                 -- If IdNumber and McaidNumber differ, concatenate them
                                  WHEN LTRIM(RTRIM(IdNumber)) <> LTRIM(RTRIM(McaidNumber)) THEN
                                      CONCAT(LTRIM(RTRIM(IdNumber)), ', ', LTRIM(RTRIM(McaidNumber)))
                                  ELSE
                                      LTRIM(RTRIM(m.IdNumber)) -- Keep existing value if no condition is met
                              END,
       CaseNumber = CASE
                        -- If McaidNumber is NULL or blank, and f.MedicaidNumber is not null or blank, use f.MedicaidNumber
                        WHEN (
                                 LTRIM(RTRIM(M.Casenum)) IS NULL
                                 OR LTRIM(RTRIM(M.Casenum)) = ''
                             )
                             AND (LTRIM(RTRIM(f.CaseNumber)) <> '') THEN
                            null
WHEN (
 LTRIM(RTRIM(f.CaseNumber)) IS Not NULL
  OR LTRIM(RTRIM(m.Casenum)) <> ''
)
AND (LTRIM(RTRIM(M.Casenum)) = LTRIM(RTRIM(f.CaseNumber))) THEN Null
                                      -- If McaidNumber and MedicaidNumber differ, concatenate them
                        WHEN LTRIM(RTRIM(M.Casenum)) <> LTRIM(RTRIM(f.CaseNumber)) THEN
                            CONCAT(LTRIM(RTRIM(M.Casenum)), ', ', LTRIM(RTRIM(f.CaseNumber)))
                        ELSE
                            LTRIM(RTRIM(M.Casenum)) -- Keep existing value if no condition is met
                    END
FROM Medicaid_Raw as m
    INNER JOIN [S3Reporting].dbo.fullproductviews AS f WITH (NOLOCK)
        ON M.LienId = f.Id
WHERE
    -- Only consider rows where at least one column in Medicaid_Raw is not NULL and doesn't contain 'N/A' or 'No'
    (
        (
            M.McaidNumber IS NOT NULL
            AND M.McaidNumber NOT IN ( 'N/A', 'No' ,'Not Eligible','None','Not a med client','Not a Medicaid Client' )
        )
        OR (
               M.IdNumber IS NOT NULL
               AND M.IdNumber NOT IN ( 'N/A', 'No' ,'Not Eligible','None','Not a med client','Not a Medicaid Client' )
           )
        OR (
               M.Casenum IS NOT NULL
               AND M.Casenum NOT IN ( 'N/A', 'No' ,'Not Eligible','None','Not a med client','Not a Medicaid Client')
           )
    )
)


---Old code -------------------------------------------------------------------------------------------------------------------------
/*SELECT f.Id,
       --f.MedicaidNumber AS [LPM MedicaidNumber],
       --M.McaidNumber, -- Medicaid number from Medicaid_Raw
       -- f.IdentificationNumber AS [LPM IdentificationNumber],
       --M.IdNumber,    -- ID number from Medicaid_Raw
       --f.CaseNumber AS [LPM CaseNumber],
       --M.Casenum,     -- Case number from Medicaid_Raw

       MedicaidNumber = CASE
                            -- If McaidNumber is NULL or blank, and f.MedicaidNumber is not null or blank, use f.MedicaidNumber
                            WHEN (
                                     LTRIM(RTRIM(M.McaidNumber)) IS NULL
                                     OR LTRIM(RTRIM(M.McaidNumber)) = ''
                                 )
                                 AND (LTRIM(RTRIM(f.MedicaidNumber)) <> '') THEN
                                Null
                                              -- If McaidNumber and MedicaidNumber differ, concatenate them
                            WHEN LTRIM(RTRIM(M.McaidNumber)) <> LTRIM(RTRIM(f.MedicaidNumber)) THEN
                                CONCAT(LTRIM(RTRIM(M.McaidNumber)), ', ', LTRIM(RTRIM(f.MedicaidNumber)))
                            ELSE
                                m.McaidNumber -- Keep existing value if no condition is met
                        END,
       IdentificationNumber = CASE
                                  -- If MedicaidNumber is NULL or blank, and f.IdNumber is not null or blank, use f.IdNumber
                                  WHEN (
                                           LTRIM(RTRIM(IdNumber)) IS NULL
                                           OR LTRIM(RTRIM(IdNumber)) = ''
                                       )
                                       AND (LTRIM(RTRIM(f.IdentificationNumber)) <> '') THEN
                                      null
                                  WHEN (
                                           LTRIM(RTRIM(f.IdentificationNumber)) IS NULL
                                           OR LTRIM(RTRIM(f.IdentificationNumber)) = ''
                                       )
                                       AND LTRIM(RTRIM(M.McaidNumber)) <> '' THEN
                                      LTRIM(RTRIM(M.McaidNumber))

                                                 -- If IdNumber and McaidNumber differ, concatenate them
                                  WHEN LTRIM(RTRIM(IdNumber)) <> LTRIM(RTRIM(McaidNumber)) THEN
                                      CONCAT(LTRIM(RTRIM(IdNumber)), ', ', LTRIM(RTRIM(McaidNumber)))
                                  ELSE
                                      m.IdNumber -- Keep existing value if no condition is met
                              END,
       CaseNumber = CASE
                        -- If McaidNumber is NULL or blank, and f.MedicaidNumber is not null or blank, use f.MedicaidNumber
                        WHEN (
                                 LTRIM(RTRIM(M.Casenum)) IS NULL
                                 OR LTRIM(RTRIM(M.Casenum)) = ''
                             )
                             AND (LTRIM(RTRIM(f.CaseNumber)) <> '') THEN
                            null

                                      -- If McaidNumber and MedicaidNumber differ, concatenate them
                        WHEN LTRIM(RTRIM(M.Casenum)) <> LTRIM(RTRIM(f.CaseNumber)) THEN
                            CONCAT(LTRIM(RTRIM(M.Casenum)), ', ', LTRIM(RTRIM(f.CaseNumber)))
                        ELSE
                            M.Casenum -- Keep existing value if no condition is met
                    END
FROM Medicaid_Raw as m
    INNER JOIN [S3Reporting].dbo.fullproductviews AS f WITH (NOLOCK)
        ON M.LienId = f.Id
WHERE
    -- Only consider rows where at least one column in Medicaid_Raw is not NULL and doesn't contain 'N/A' or 'No'
    (
        (
            M.McaidNumber IS NOT NULL
            AND M.McaidNumber NOT IN ( 'N/A', 'No' ,'Not Eligible','None' )
        )
        OR (
               M.IdNumber IS NOT NULL
               AND M.IdNumber NOT IN ( 'N/A', 'No' ,'Not Eligible','None' )
           )
        OR (
               M.Casenum IS NOT NULL
               AND M.Casenum NOT IN ( 'N/A', 'No' ,'Not Eligible','None' )
           )
    )

=============================================================================================================================================
SELECT f.Id,
       f.MedicaidNumber AS [SYS MedicaidNumber],
       M.McaidNumber, -- Medicaid number from Medicaid_Raw
       f.IdentificationNumber AS [SYS IdentificationNumber],
       M.IdNumber,    -- ID number from Medicaid_Raw
       f.CaseNumber AS [SYS CaseNumber],
       M.Casenum,     -- Case number from Medicaid_Raw
       CASE
           -- If SYS MedicaidNumber is blank, update it with M.McaidNumber
           WHEN (f.MedicaidNumber IS NULL OR LTRIM(RTRIM(f.MedicaidNumber)) = '')
                AND (LTRIM(RTRIM(M.McaidNumber)) <> '' OR LTRIM(RTRIM(M.McaidNumber)) IS NOT NULL) THEN
               'Update McaidNumber in Medicaid_Raw'

           -- If SYS IdentificationNumber is blank, update it with M.IdNumber
           WHEN (f.IdentificationNumber IS NULL OR LTRIM(RTRIM(f.IdentificationNumber)) = '')
                AND (LTRIM(RTRIM(M.IdNumber)) <> '' OR LTRIM(RTRIM(M.IdNumber)) IS NOT NULL) THEN
               'Update IdNumber in Medicaid_Raw'

           -- If SYS CaseNumber is blank, update it with M.Casenum
           WHEN (f.CaseNumber IS NULL OR LTRIM(RTRIM(f.CaseNumber)) = '')
                AND (LTRIM(RTRIM(M.Casenum)) <> '' OR LTRIM(RTRIM(M.Casenum)) IS NOT NULL) THEN
               'Update Casenum in Medicaid_Raw'

           -- If no update is needed, do nothing
           ELSE
               'No action'
       END AS Action
FROM [S3Reporting].dbo.fullproductviews AS f
    INNER JOIN Medicaid_Raw AS M WITH (NOLOCK)
        ON f.Id = M.LienId
WHERE
    -- Only consider rows where at least one column in Medicaid_Raw is not NULL and doesn't contain 'N/A' or 'No'
    (
        (M.McaidNumber IS NOT NULL AND M.McaidNumber NOT IN ('N/A', 'No'))
        OR (M.IdNumber IS NOT NULL AND M.IdNumber NOT IN ('N/A', 'No'))
        OR (M.Casenum IS NOT NULL AND M.Casenum NOT IN ('N/A', 'No'))
    )*/
--)
GO
