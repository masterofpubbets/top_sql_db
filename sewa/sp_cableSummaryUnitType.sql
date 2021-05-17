SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_cableSummaryUnitType]
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1
SELECT
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,CASE WHEN [Type] IS NULL THEN 'Total' ELSE [Type] END AS [Type]
,[Scope (Un)],[Scope (Lm)],[Pulled Actual (Un)],[Pulled Week Actual (Un)]
,[Pulled Actual (Lm)],[Pulled Week Actual (Lm)],[Connect Actual (Un)],[Connect Week Actual (Un)]
--,[Connect 1 end Actual (Un)]
,[Connect(2 Ends) Scope (Un)],[Connects(2 Ends) Actual (Un)],[Connects(2 Ends) Week Actual (Un)]

FROM (
SELECT
tblunits.unit_name as Unit
,tblCables.discipline as [Type]
,COUNT(tag) AS [Scope (Un)]
,SUM(design_length) AS [Scope (Lm)]
,SUM(CASE WHEN pulled_date <= @date THEN 1 ELSE 0 END) as [Pulled Actual (Un)]

,SUM(CASE WHEN pulled_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) as [Pulled Week Actual (Un)]
,SUM(CASE WHEN pulled_date <= @date THEN design_length ELSE 0 END) as [Pulled Actual (Lm)]
,SUM(CASE WHEN pulled_date BETWEEN DATEADD(day,-6,@date) AND @date THEN design_length ELSE 0 END) as [Pulled Week Actual (Lm)]
,SUM(CASE WHEN (con_from_date <= @date) AND (con_to_date <= @date) THEN 1 ELSE 0 END) as [Connect Actual (Un)]

,SUM(
CASE WHEN 
((con_from_date IS NOT NULL) AND (con_to_date BETWEEN DATEADD(day,-6,@date) AND @date))
OR
((con_to_date IS NOT NULL) AND (con_from_date BETWEEN DATEADD(day,-6,@date) AND @date))
THEN 1 ELSE 0 
END
) AS [Connect Week Actual (Un)]

,SUM(
CASE WHEN 
((con_from_date IS NULL) AND (con_to_date IS NOT NULL))
OR
((con_to_date IS NULL) AND (con_from_date IS NOT NULL))
THEN 1 ELSE 0 
END
) AS [Connect 1 end Actual (Un)]

,COUNT(tag) * 2 AS [Connect(2 Ends) Scope (Un)]
,SUM(CASE WHEN con_from_date <= @date THEN 1 ELSE 0 END) + SUM(CASE WHEN con_to_date <= @date THEN 1 ELSE 0 END) AS [Connects(2 Ends) Actual (Un)]
,SUM(CASE WHEN con_from_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) + SUM(CASE WHEN con_to_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Connects(2 Ends) Week Actual (Un)]
FROM tblCables WITH (NOLOCK)
INNER JOIN tblUnits On tblCables.unit_id =tblunits.unit_id
WHERE tblunits.unit_name in ('00','10','20')
AND tblCables.active=1
GROUP BY ROLLUP(tblunits.unit_name,tblCables.discipline)
) as vSummary

GO
