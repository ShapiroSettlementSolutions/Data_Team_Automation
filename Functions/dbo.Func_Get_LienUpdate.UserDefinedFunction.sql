USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_LienUpdate]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Func_Get_LienUpdate] (@NewLienNote Nvarchar(255))
RETURNS @LienUpdate TABLE
(
    Id bigint,
    Stage nvarchar(50), -- Specify the length for nvarchar
    NewLienNote nvarchar(255)
)
AS
BEGIN
    -- Directly select the results to return from the function
    INSERT INTO @LienUpdate
    (
        Id,
        Stage,
        NewLienNote
    )
    SELECT Id,
           CASE
               WHEN LienType = 'Medicare Lien - MT'
                    and Stage = 'System Generated / Needs Review'
                    and (
                            ClientSSN IS NOT NULL
                            and ClientDOB IS NOT NULL
                        ) THEN
                   'To Send - EV'
               WHEN LienType = 'Medicaid Lien - MT'
                    and Stage = 'System Generated / Needs Review'
                    and (
                            ClientSSN IS NOT NULL
                            and ClientDOB IS NOT NULL
                            and ClientState IS NOT NULL
                        )
                    and LienHolderName not like '%Placeholder%' THEN
                   'To Send - EV'
               WHEN LienType = 'MAR'
                    and Stage = 'System Generated / Needs Review' THEN
                   'Closed'
               ELSE
                   'Awaiting Information'
           END,
           @NewLienNote
    FROM [dbo].[Func_Get_LienPreTable]()

    RETURN;
END
GO
