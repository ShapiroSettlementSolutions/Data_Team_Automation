USE [Data_Team_Automation]
GO
/****** Object:  UserDefinedFunction [dbo].[Fn_Update_MCO_Count]    Script Date: 6/19/2025 7:10:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--==========================================================--
-- Author : Ronak Vadher
-- Created Date : 11/5/2024
-- Description : To get clientIds to update MCO count as 9

-- Modified History
--	Date			Name			Description
--	12-03-2024		Ronak Vadher	Added to additional condition where if any special character recevied it will still count as 'No MCO'
--  12-13-2024		Ronak Vadher	Updated function where if we recevied (Molina,Aetna) then consider those and give the 9 as result.
--  12-20-2024      Ronak Vadher    Updated function where it is not giving notes against the 9.
--===========================================================================================================================================================


CREATE Function [dbo].[Fn_Update_MCO_Count] ()
Returns table
As
Return
(
  WITH FilteredMedicaidData AS (
    SELECT 
        f.clientid as Id,
        CASE
            WHEN m.mco IN ('', ' ', 'N/A', 'none', 'NO', 'N', '-', ',') THEN 'No MCO'
            WHEN PATINDEX('%[^a-zA-Z&,(,),;/ ]%', m.mco) > 0 THEN 'No MCO'
            WHEN m.mco IS NULL THEN 'No MCO'
            ELSE '9'
        END AS RequiredMedicaidMCOLienCount,
        CASE 
            WHEN 
                (CASE
                    WHEN m.mco IN ('', ' ', 'N/A', 'none', 'NO', 'N', '-', ',') THEN 'No MCO'
                    WHEN PATINDEX('%[^a-zA-Z&,(,),;/ ]%', m.mco) > 0 THEN 'No MCO'
                    WHEN m.mco IS NULL THEN 'No MCO'
                    ELSE '9'
                END) = '9'
            THEN 'Updated MCO count to 9 as placeholder until MCOs can be created'
            ELSE 'No Action'
        END AS NewClientNote
    FROM Medicaid_Raw AS m WITH (NOLOCK)
    INNER JOIN [S3Reporting].dbo.Fullproductviews AS f
        ON f.id = m.lienid
)
SELECT *
FROM FilteredMedicaidData
WHERE RequiredMedicaidMCOLienCount = '9' 
  AND NewClientNote = 'Updated MCO count to 9 as placeholder until MCOs can be created'
    --code 1--WHERE CASE
    --          WHEN m.mco in ( '', 'N/A', 'none', 'NO', 'N' ) THEN
    --              'No MCO'
    --          WHEN m.mco IS NULL THEN
    --              'No MCO'
    --          ELSE
    --              '9'
    --      END = '9'
	---code 2------------------------------------
	/* SELECT * 
	FROM
	(
	    SELECT Lienid,
	           f.clientid,
	           m.MCO,
	           CASE
	               WHEN m.mco in ( '', 'N/A', 'none', 'NO', 'N' ) THEN
	                   'No MCO'
				   WHEN PATINDEX('%[^a-zA-Z0-9 ]%', m.mco) > 0 THEN
					   'No MCO'
	               WHEN m.mco IS NULL THEN
	                   'No MCO'
	               ELSE
	                   '9'
	           END AS MCO_status
	    FROM Medicaid_Raw AS m with (Nolock)
	        INNER JOIN [S3Reporting].dbo.Fullproductviews AS f
	            ON f.id = m.lienid
	) AS T
	WHERE MCO_status = '9'
	-----------code 3 -----------------------------------------------------------
	code 3--SELECT *
	FROM
	(
	    SELECT --Lienid,
	           f.clientid,
	           --m.MCO,
	           CASE
	               WHEN m.mco in ( '',' ', 'N/A', 'none', 'NO', 'N','-',',' ) THEN
	                   'No MCO'
				   WHEN PATINDEX('%[^a-zA-Z&, ]%', m.mco) > 0 THEN
					   'No MCO'
	               WHEN m.mco IS NULL THEN
	                   'No MCO'
	               ELSE
	                   '9'
	           END AS RequiredMedicaidMCOLienCount,
			   Case when RequiredMedicaidMCOLienCount = '9' then 'Updated MCO count to 9 as placeholder until MCOs can be created'
			   Else 'No Action'
			   end as NewClientNote
	    FROM Medicaid_Raw AS m with (Nolock)
	        INNER JOIN [S3Reporting].dbo.Fullproductviews AS f
	            ON f.id = m.lienid
	) AS T
	WHERE RequiredMedicaidMCOLienCount = '9'

	*/
)
GO
