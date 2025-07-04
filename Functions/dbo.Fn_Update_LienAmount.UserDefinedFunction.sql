USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_Update_LienAmount]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--==========================================================================================================================================================================================================================================================================================================================================
-- Author : Ronak Vadher
-- Created Date : 10/31/2024
-- Description : To get lienamount for lienupdate

--	Modification History
--	Date			Name				Description
--	2024-12-23		Ronak Vadher		The function has been updated to reflect the fields being updated based on the received date. For example, instead of returning fields that were already updated (such as LienDate1, LienAmount1, and AuditedAmount1), it now only returns the fields that are being updated.
--===========================================================================================================================================================================================================================================================================================================================================


CREATE FUNCTION [dbo].[Fn_Update_LienAmount] (@RecDate Date)
RETURNS TABLE
AS
RETURN
( WITH UpdatedLienData
    AS (SELECT r.lienid,
               r.lienamount,
               f.Id,
               f.stage,
               ROUND(TRY_CAST(r.lienamount AS numeric(18, 2)), 2) AS RoundedAmount,
               CONVERT(VARCHAR(10), @RecDate, 101) AS CurrentDate -- mm-dd-yyyy
        FROM [S3Reporting].dbo.Fullproductviews AS f
            JOIN medicaid_raw AS r with (Nolock)
                ON f.id = r.lienid
       )
    SELECT lienid as Id,
           -- LienDate and Amount Update Logic
           CASE
               WHEN f.LienDate1 IS NULL THEN
                   CurrentDate
               ELSE
                   NULL
           END AS LienDate1,
           CASE
               WHEN f.LienAmount1 IS NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS LienAmount1,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount1 IS NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS AuditedAmount1,
           CASE
               WHEN f.LienDate2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   CurrentDate
               ELSE
                   NULL
           END AS LienDate2,
           CASE
               WHEN f.LienAmount2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                  NULL
           END AS LienAmount2,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS AuditedAmount2,
           CASE
               WHEN f.LienDate3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   CurrentDate
               ELSE
                  NULL
           END AS LienDate3,
           CASE
               WHEN f.LienAmount3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS LienAmount3,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS AuditedAmount3,
           CASE
               WHEN f.LienDate4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   CurrentDate
               ELSE
                   NULL
           END AS LienDate4,
           CASE
               WHEN f.LienAmount4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS LienAmount4,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   NULL
           END AS AuditedAmount4
    FROM UpdatedLienData AS r
        JOIN [S3Reporting].dbo.Fullproductviews AS f
            ON r.Id = f.Id
    where r.lienamount IS NOT NULL -- Only rows with non-NULL lienamount

/*
    WITH UpdatedLienData
    AS (SELECT r.lienid,
               r.lienamount,
               f.Id,
               f.stage,
               ROUND(TRY_CAST(r.lienamount AS numeric(18, 2)), 2) AS RoundedAmount,
               CONVERT(VARCHAR(10), @RecDate, 101) AS CurrentDate -- mm-dd-yyyy
        FROM [S3Reporting].dbo.Fullproductviews AS f
            JOIN medicaid_raw AS r with (Nolock)
                ON f.id = r.lienid
       )
    SELECT lienid,
           -- LienDate and Amount Update Logic
           CASE
               WHEN f.LienDate1 IS NULL THEN
                   CurrentDate
               ELSE
                   f.LienDate1
           END AS LienDate1,
           CASE
               WHEN f.LienAmount1 IS NULL THEN
                   RoundedAmount
               ELSE
                   f.LienAmount1
           END AS LienAmount1,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount1 IS NULL THEN
                   RoundedAmount
               ELSE
                   f.AuditedAmount1
           END AS AuditedAmount1,
           CASE
               WHEN f.LienDate2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   CurrentDate
               ELSE
                   f.LienDate2
           END AS LienDate2,
           CASE
               WHEN f.LienAmount2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.LienAmount2
           END AS LienAmount2,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount2 IS NULL
                    AND f.LienDate1 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.AuditedAmount2
           END AS AuditedAmount2,
           CASE
               WHEN f.LienDate3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   CurrentDate
               ELSE
                   f.LienDate3
           END AS LienDate3,
           CASE
               WHEN f.LienAmount3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.LienAmount3
           END AS LienAmount3,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount3 IS NULL
                    AND f.LienDate2 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.AuditedAmount3
           END AS AuditedAmount3,
           CASE
               WHEN f.LienDate4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   CurrentDate
               ELSE
                   f.LienDate4
           END AS LienDate4,
           CASE
               WHEN f.LienAmount4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.LienAmount4
           END AS LienAmount4,
           CASE
               WHEN TRY_CAST(r.lienamount AS numeric(18, 2)) <= 0
                    AND f.AuditedAmount4 IS NULL
                    AND f.LienDate3 IS NOT NULL THEN
                   RoundedAmount
               ELSE
                   f.AuditedAmount4
           END AS AuditedAmount4
    FROM UpdatedLienData AS r
        JOIN [S3Reporting].dbo.Fullproductviews AS f
            ON r.Id = f.Id
    where r.lienamount IS NOT NULL -- Only rows with non-NULL lienamount 
	*/
)
GO
