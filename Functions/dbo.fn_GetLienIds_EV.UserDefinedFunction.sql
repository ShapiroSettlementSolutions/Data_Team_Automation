USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetLienIds_EV]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetLienIds_EV]
(
    @EVStatus nvarchar(20),
    @Result nvarchar(20),
    @RecDate date,          -- The @RecDate parameter is passed in to set OnBenefitsVerified
    @State nvarchar(5),  -- New parameter for State
    @TicketNumber nvarchar(20)     -- New parameter for TicketNumber
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        LienId,
        
        -- Automatically set Stage based on EVStatus and Result
        CASE
		    WHEN @EVStatus = 'No' AND @Result = 'Good' and McaidNumber is not null THEN 'Final - No Interest'
            WHEN @EVStatus = 'Yes' AND @Result = 'Good' THEN 'To Send - Claims Request'
            WHEN @EVStatus = 'No' AND @Result = 'Good' THEN 'Initial No Entitlement'
            ELSE 'Unknown Stage'  -- Optionally handle other cases
        END AS Stage,

        -- Automatically set OnBenefits based on EVStatus
        CASE 
			WHEN @EVStatus = 'NO' and McaidNumber is not null THEN 'Yes'
            WHEN @EVStatus = 'Yes' THEN 'Yes'
            WHEN @EVStatus = 'No' THEN 'No'
            ELSE 'Unknown OnBenefits' -- This can be handled differently if needed
        END AS OnBenefits,

        -- Automatically set OnBenefitsVerified to @RecDate
        OnBenefitsVerified = Convert(nvarchar,@RecDate,110),

		CASE
			WHEN @EVStatus = 'NO' and McaidNumber is not null THEN @RecDate
			Else Null
			End as LienDate1,

		CASE
			WHEN @EVStatus = 'NO' and McaidNumber is not null THEN 0
			Else NULL
			End as LienAmount1,

		CASE
			WHEN @EVStatus = 'NO' and McaidNumber is not null THEN 0
			Else NULL
			End as AuditedAmount1,


		--FinalDemandDate for No and MedicaidNumber
		Case
			WHEN @EVStatus = 'No' AND @Result = 'Good' and McaidNumber is not null THEN @RecDate
			Else NULL
			End as FinalDemandDate,

		--FinalDemandAmount
		Case
			WHEN @EVStatus = 'No' AND @Result = 'Good' and McaidNumber is not null THEN 0
			Else NULL
			End As FinalDemandAmount,

        -- New column: NewLienNote, which is a conditional concat based on EVStatus, Result, and now including @State
        CASE 
            WHEN @EVStatus = 'Yes' AND @Result = 'Good' THEN 
                CONCAT(@State,' ','Mcaid - EV Response rec''d',' ',Convert(nvarchar,@RecDate,110),'.',' ','Yes on Benefits. Ticket #',@TicketNumber)
            WHEN @EVStatus = 'No' AND @Result = 'Good' THEN 
                CONCAT(@State,' ','Mcaid - EV Response rec''d',' ',convert(nvarchar,@RecDate,110),'.',' ','No Entitlement. Ticket #',@TicketNumber)
            ELSE 
               'No Data'
        END AS NewLienNote

    FROM dbo.fn_MatchSSN_Stage()
    WHERE EV = @EVStatus and
	Result = @Result
)
GO
