USE [Data_Team_Automation]
GO
/****** Object:  StoredProcedure [dbo].[Insert_Process_Detail]    Script Date: 6/19/2025 7:08:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Viral Panchal
-- Create date	:	2024-12-24
-- Description	:	Process Detail Procedure for log maintanance 
-- Modification History
-- Date			Changed By			Description
-- =============================================
CREATE PROCEDURE [dbo].[Insert_Process_Detail]
    @ProcessID INT,
    @SubProcessName NVARCHAR(255),
    @StartTime DATETIME,
    @EndTime DATETIME = NULL, -- Correct syntax for setting default value
	@RowCount INT	
AS
BEGIN
    SET NOCOUNT ON;
	Declare @Duration VARCHAR(10) = NULL -- Update the parameter type
    --DECLARE @Duration AS INT;
    IF @EndTime IS NOT NULL
        SET @Duration = CONVERT(varchar,@EndTime - @StartTime,108);
    ELSE
        SET @Duration = NULL;
    BEGIN TRY
        -- Insert the log entry into the Process_Detail table
        INSERT INTO dbo.Process_Detail (Process_ID, Sub_Process_Name, Start_Time, End_Time, Row_Count, [Duration(Min)])
        VALUES (@ProcessID, @SubProcessName, @StartTime, @EndTime, @RowCount, @Duration);
        --PRINT 'Log entry created for subprocess: ' + @SubProcessName;
    END TRY
    BEGIN CATCH
        -- Handle any errors
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        --PRINT 'Error occurred while logging subprocess: ' + @ErrorMessage;
    END CATCH
END;
GO
