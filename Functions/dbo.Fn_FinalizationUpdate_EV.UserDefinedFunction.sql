USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_FinalizationUpdate_EV]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Fn_FinalizationUpdate_EV]
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
            WHEN Stage = 'Initial No Entitlement' and Next_Stage = 'Final No Entitlement' THEN 'Final No Entitlement'
            ELSE 'Error'
        END AS Stage, -- Remove the quotes here for alias
        CONCAT(@State, ' ', 'Mcaid - EV Response rec''d', ' ', convert(nvarchar,@RecDate,110),'.', ' ', 'Finalization.') AS NewLienNote
    FROM 
        dbo.Fn_EV_Finalization() -- Assuming Fn_EV_Finalization is a table-valued function that returns a table
		Where Stage = 'Initial No Entitlement'
			and Next_stage = 'Final No Entitlement'
)
GO
