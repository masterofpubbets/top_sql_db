SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[sp_cablePlanSummary]
@withTotal bit
AS
DECLARE @date date
SELECT @date =tblOptions.cutoffDate FROM tblOptions WHERE tblOptions.id = 1

if @withTotal = 1
BEGIN
	SELECT
	CASE WHEN [plan_pulling_date] IS NULL THEN 'Total' ELSE FORMAT([plan_pulling_date],'dd/MM/yyyy') END AS [Plan Week]
	,COUNT(Tag) as [Plan U]
	,SUM([design_length]) as [Plan Lm]
	,COUNT([pulled_date]) as [Complete U]
	,SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) AS [Complete Lm]
	,SUM(CASE WHEN [pulled_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) as [Weekly U]
	,SUM(CASE WHEN [pulled_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN [design_length] ELSE 0 END) as [Weekly Lm]
	,SUM([design_length]) - SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) as [Pending Lm]
	,COUNT(Tag) - COUNT([pulled_date]) as [Pending U]
	,(SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) * 100 * COUNT([pulled_date])) / 
	(SUM([design_length]) * COUNT(Tag))
	AS [Progress Ratio]
	FROM [tblCables]
	WHERE [plan_pulling_date] IS NOT NULL
    AND tblCables.active=1
	GROUP BY ROLLUP([plan_pulling_date])
END
ELSE
BEGIN
	SELECT
	[plan_pulling_date] AS [Plan Week]
	,COUNT(Tag) as [Plan U]
	,SUM([design_length]) as [Plan Lm]
	,COUNT([pulled_date]) as [Complete U]
	,SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) AS [Complete Lm]
	,SUM(CASE WHEN [pulled_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) as [Weekly U]
	,SUM(CASE WHEN [pulled_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN [design_length] ELSE 0 END) as [Weekly Lm]
	,SUM([design_length]) - SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) as [Pending Lm]
	,COUNT(Tag) - COUNT([pulled_date]) as [Pending U]
	,(SUM(CASE WHEN [pulled_date] IS NOT NULL THEN [design_length] ELSE 0 END) * 100 * COUNT([pulled_date])) / 
	(SUM([design_length]) * COUNT(Tag))
	AS [Progress Ratio]
	FROM [tblCables]
	WHERE [plan_pulling_date] IS NOT NULL
    AND tblCables.active=1
	GROUP BY [plan_pulling_date]
	ORDER BY [plan_pulling_date]
END
GO
