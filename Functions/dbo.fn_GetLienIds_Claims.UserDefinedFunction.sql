USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetLienIds_Claims]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--================================================--
-- Author : Ashram Subba
-- Created Date : 10/28/2024
-- Description : To get liends based on response
--================================================--


CREATE Function [dbo].[fn_GetLienIds_Claims]
(
    @Claims nvarchar(20),
    @Result nvarchar(20),
	@RecDate Date,
	@State nvarchar (5),
	@TicketNumber nvarchar (20)
)
Returns Table
As
Return
(
    Select LienId,
			Stage as LPM_Stage,
           CASE 
				WHEN @Claims = 'Yes' AND @Result = 'Good' THEN 'Claims Received'
				WHEN @Claims = 'No' AND @Result = 'Good' THEN 'No Lien/Pending Settlement'
				ELSE 'Unknown Stage'  -- Optionally handle other cases
				END AS Stage,

		    CASE 
				WHEN @Claims = 'Yes' AND @Result = 'Good' THEN 
				    CONCAT(@State,' ','Mcaid - Claims Response',' ', 'CPL rec''d',' ',Convert(nvarchar,@RecDate,110),'.',' ','Ticket #',@TicketNumber)
				WHEN @Claims = 'No' AND @Result = 'Good' THEN 
				    CONCAT(@State,' ','Mcaid - Claims Response rec''d',' ',convert(nvarchar,@RecDate,110),'.',' ','No Lien','.',' ','Ticket #',@TicketNumber)
				ELSE 
					'No Data'
				END AS NewLienNote
    from fn_Match_Stage()
    Where Claims = @Claims
          and Result = @Result
)
GO
