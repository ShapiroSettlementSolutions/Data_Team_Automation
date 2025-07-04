USE [Data_Team_Automation]
GO
/****** Object:  StoredProcedure [dbo].[Send_Email_Notification]    Script Date: 6/19/2025 7:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author		:	Surender
-- Create date	:	2025-04-02
-- Description	:	Send email notification from Data_Team profile

-- Note			:	Grant execute permission on sp_send_dbmail to resolve the permission issue for the Send_Email_Notification process

-- Modification History
-- Date			Changed By			Description

-- =============================================
CREATE  PROCEDURE [dbo].[Send_Email_Notification]
    @MailSubject NVARCHAR(255),
    @MailBody NVARCHAR(MAX),
    @Recipients NVARCHAR(1000),
    @CCRecipients NVARCHAR(1000) = NULL  -- New parameter for CC
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Send mail using Database Mail
        EXEC msdb.dbo.sp_send_dbmail
            @profile_name = 'Data_Team',  -- Make sure this profile exists in DB Mail
            @recipients = @Recipients,
            @copy_recipients = @CCRecipients, -- Add CC recipients
            @subject = @MailSubject,
            @body = @MailBody;
            --@importance = 'High';		-- Commented out as priority is not required
    END TRY
    BEGIN CATCH
        -- Handle errors and log them if necessary
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error sending email: ' + @ErrorMessage;
    END CATCH;
END;
GO
