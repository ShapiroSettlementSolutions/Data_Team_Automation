USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_FinalizationUpdate_Claims]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fn_FinalizationUpdate_Claims]
(
    @RecDate DATE,
    @State NVARCHAR(5)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
          Id,
        CASE
            WHEN Stage = 'No Lien/Pending Settlement' THEN 'Final - No Interest'
            ELSE 'Error'
        END AS Stage, 
        CASE 
            WHEN Stage = 'No Lien/Pending Settlement' THEN @RecDate
            ELSE NULL -- Returning NULL to maintain consistency with DATE type
        END AS FinalDemandDate,
        CASE
            WHEN Stage = 'No Lien/Pending Settlement' THEN 0
            ELSE NULL -- Returning NULL to maintain consistency with numeric type
        END AS FinalDemandAmount,
        CONCAT(@State, ' ', 'Mcaid - Claims Response rec''d', ' ', convert(nvarchar,@RecDate,110),'.', ' ', 'Finalization') AS NewLienNote
    FROM 
        dbo.Fn_Claims_Finalization() -- Assuming Fn_Claims_Finalization is a table-valued function that returns a table
);
GO
