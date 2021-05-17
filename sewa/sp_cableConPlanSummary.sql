SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_cableConPlanSummary]
@withTotal bit
AS
DECLARE @date date
SELECT @date =tblOptions.cutoffDate FROM tblOptions WHERE tblOptions.id = 1

IF @withTotal = 0
BEGIN
	SELECT
	[plan_connected_date] AS [Plan Week]
	,COUNT(Tag) as [Plan N.Cables]
	
	,SUM(
		CASE WHEN 
				([con_from_date] IS NOT NULL) AND ([con_to_date] IS NOT NULL)
		THEN 1 ELSE 0 END
		) as [Complete N.Cables]

	,SUM(
		CASE WHEN 
			(
				(([con_from_date] BETWEEN DATEADD(day,-6,@date) AND @date)) AND ([con_to_date] IS NOT NULL)
			) OR
			(
				(([con_to_date] BETWEEN DATEADD(day,-6,@date) AND @date)) AND ([con_from_date] IS NOT NULL)
			)
		THEN 1 ELSE 0 END
		) as [Weekly N.Cables]
	
	
	,COUNT(Tag) -
	SUM(
		CASE WHEN 
				([con_from_date] IS NOT NULL) AND ([con_to_date] IS NOT NULL)
		THEN 1 ELSE 0 END
		) as [Pending N.Cables]
	
	,COUNT(Tag) * 2 as [Plan N.Ends]

	,SUM(CASE WHEN [con_from_date] IS NOT NULL THEN 1 ELSE 0 END) + SUM(CASE WHEN [con_to_date] IS NOT NULL THEN 1 ELSE 0 END) as [Complete N.Ends]

		,(COUNT(Tag) * 2) - 
		SUM(CASE WHEN [con_from_date] IS NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN [con_to_date] IS NOT NULL THEN 1 ELSE 0 END) as [Pending N.Ends]

		,SUM(CASE WHEN [con_from_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) + SUM(CASE WHEN [con_to_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) as [Weekly N.Ends]

	FROM [tblCables]
	WHERE [plan_connected_date] IS NOT NULL
    AND tblCables.active=1
	GROUP BY [plan_connected_date]
	ORDER BY [plan_connected_date]
END
ELSE
BEGIN
	SELECT
	CASE WHEN [plan_connected_date] IS NULL THEN 'Total' ELSE FORMAT([plan_connected_date],'dd/MM/yyyy') END AS [Plan Week]
	,COUNT(Tag) as [Plan N.Cables]
	
	,SUM(
		CASE WHEN 
				([con_from_date] IS NOT NULL) AND ([con_to_date] IS NOT NULL)
		THEN 1 ELSE 0 END
		) as [Complete N.Cables]

	,SUM(
		CASE WHEN 
			(
				(([con_from_date] BETWEEN DATEADD(day,-6,@date) AND @date)) AND ([con_to_date] IS NOT NULL)
			) OR
			(
				(([con_to_date] BETWEEN DATEADD(day,-6,@date) AND @date)) AND ([con_from_date] IS NOT NULL)
			)
		THEN 1 ELSE 0 END
		) as [Weekly N.Cables]
	
	
	,COUNT(Tag) -
	SUM(
		CASE WHEN 
				([con_from_date] IS NOT NULL) AND ([con_to_date] IS NOT NULL)
		THEN 1 ELSE 0 END
		) as [Pending N.Cables]
	
	,COUNT(Tag) * 2 as [Plan N.Ends]

	,SUM(CASE WHEN [con_from_date] IS NOT NULL THEN 1 ELSE 0 END) + SUM(CASE WHEN [con_to_date] IS NOT NULL THEN 1 ELSE 0 END) as [Complete N.Ends]

		,(COUNT(Tag) * 2) - 
		SUM(CASE WHEN [con_from_date] IS NOT NULL THEN 1 ELSE 0 END) - SUM(CASE WHEN [con_to_date] IS NOT NULL THEN 1 ELSE 0 END) as [Pending N.Ends]

		,SUM(CASE WHEN [con_from_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) + SUM(CASE WHEN [con_to_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) as [Weekly N.Ends]

	FROM [tblCables]
	WHERE [plan_connected_date] IS NOT NULL
    AND tblCables.active=1
	GROUP BY ROLLUP([plan_connected_date])
END
GO
