USE [Data_Team_Automation]
GO
/****** Object:  StoredProcedure [dbo].[Sp_Medicaid]    Script Date: 6/19/2025 7:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================
-- Author : Ashram Subba
-- Created Date : 11/11/2024
-- Description : To get all the results from functions

--------Modified History-----------
-- Date           Name              Description
-- 11/20/2024     Ashram Subba      Added an extra parameter for capturing the ReceivedDate only for claims part

-- ====================================================================
CREATE Procedure [dbo].[Sp_Medicaid]
(
    @OperationType as nvarchar(20),
    @RecDate Date,
	@State nvarchar(5),
	@TicketNumber nvarchar(20)
)
As
Begin
    If (@OperationType = 'EV')
    Begin
        Select *
        from fn_MatchSSN_Stage()
		Where EV = 'Yes'

		Select *
        from fn_MatchSSN_Stage()
		Where EV = 'No'

        Select LienId as Id, Stage, OnBenefits, Convert(nvarchar,OnBenefitsVerified,110) as OnBenefitsVerified, NewLienNote
        from fn_GetLienIds_EV('Yes', 'Good',@RecDate,@State,@TicketNumber)

        Select LienId as Id, Stage, OnBenefits, Convert(nvarchar,OnBenefitsVerified,110) as OnBenefitsVerified, Convert(nvarchar,LienDate1,110) as LienDate1, LienAmount1, AuditedAmount1, Convert(nvarchar,FinalDemandDate,110) as FinalDemandDate, FinalDemandAmount, NewLienNote
        from fn_GetLienIds_EV('No', 'Good',@RecDate,@State,@TicketNumber)

        Select *
        from fn_Update_McaidNumber()

        Select *
        from fn_Update_MCO_Count()

        Select *
        from Fn_EV_Finalization()

		Select *
		from Fn_FinalizationUpdate_EV(@RecDate,@State)
    End
    Else if (@OperationType = 'Claims')
    Begin
        Select *
        from fn_Match_Stage()

        Select LienId as Id, Stage, NewLienNote
        from fn_GetLienIds_Claims('Yes', 'Good',@RecDate,@State,@TicketNumber)

        Select LienId as Id, Stage, NewLienNote
        from fn_GetLienIds_Claims('No', 'Good',@RecDate,@State,@TicketNumber)

        Select *
        from Fn_Update_LienAmount(@RecDate)

        Select *
        from fn_Update_McaidNumber()

        Select *
        from fn_Update_MCO_Count()

        Select *
        from Fn_Claims_Finalization()

		Select *
		from Fn_FinalizationUpdate_Claims(@RecDate,@State)
    End

End
GO
