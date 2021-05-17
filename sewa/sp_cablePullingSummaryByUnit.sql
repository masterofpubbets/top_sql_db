SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_cablePullingSummaryByUnit]
AS
SELECT
tblUnits.unit_name
,SUM(tblCables.design_length) AS [Scope Lm]
,SUM(CASE WHEN tblCables.pulled_date IS NOT NULL THEN tblCables.design_length ELSE 0 END) AS [Done Lm]
FROM tblCables
INNER JOIN tblUnits ON tblCables.unit_id = tblUnits.unit_id
WHERE tblCables.active=1
GROUP BY tblUnits.unit_name
GO
