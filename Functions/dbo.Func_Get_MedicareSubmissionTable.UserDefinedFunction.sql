USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Func_Get_MedicareSubmissionTable]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Nishant Sharma>
-- Create date: <3/10/2025>
-- Description:	<This function generates Medicare Submissions update table>
-- =============================================
CREATE FUNCTION [dbo].[Func_Get_MedicareSubmissionTable]
(
    @MedicareSubmission nvarchar(5),
    @SubmissionTypeId int = NULL -- Make @SubmissionTypeId optional
)
RETURNS @MedicareSubmissions TABLE
(
    EntityId Bigint,
    EntityTypeId int,
    SubmissionTypeId int,
    StatusId int,
    Note nvarchar(255),
    Active nvarchar(20)
)
AS
Begin

    -- If @MedicareSubmission is 'N', return an empty table and terminate
    If @MedicareSubmission = 'N'
    Begin
        Return
    End

    -- Proceed with the rest of the logic if @MedicareSubmission is 'Y'
	IF @SubmissionTypeId = ''
	Begin
		Return
	End
    Else If @MedicareSubmission = 'Y'
    Begin
        Insert into @MedicareSubmissions
        (
            Entityid,
            EntityTypeId,
            SubmissionTypeId,
            StatusId,
            Note,
            Active
        )
        Select Id,
               1 as EntityTypeId,
               @SubmissionTypeId,
               263 as StatusId,
               Case	
                   When @SubmissionTypeId = 20 then
                       'Section 111 submission completed on behalf of this claimant as ARCHER contracted by defense counsel or defendant to handle reporting.'
                   Else
                       'Claimant''s Medicare beneficiary confirmation and data submitted to defense counsel and/or defendant so they can complete their Section 111 Medicare reporting.'
               End as 'Note',
               'TRUE' as Active
        from [dbo].[Func_Get_LienPreTable]()
        where LienType like '%Medicare%'
    End

    Return
End
GO
