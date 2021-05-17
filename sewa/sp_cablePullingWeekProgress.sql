SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_cablePullingWeekProgress]
AS
If(OBJECT_ID('tempdb..#temp_cablePulling') Is Not Null)
Begin
    Drop Table #temp_cablePulling
End

create table #temp_cablePulling
(
    dt DATE, 
    dtName NVarchar(50), 
    tag NVarchar(100),
    design_length float, 
    pulled_date date,
	plan_pulled_date date,
	unit_id int
)

DECLARE @fromD date
DECLARE @toD date
DECLARE @col as nvarchar(max)
DECLARE @colSum as nvarchar(max)
DECLARE @colHeader as nvarchar(max)
declare @result as nvarchar(max)

SELECT @fromD = MIN(tblCables.pulled_date) FROM tblCables
SELECT @toD = tblOptions.cutoffdate from tblOptions WHERE id = 1;

WITH cteDate as 
  (
   SELECT ROW_NUMBER() OVER(ORDER BY NEWID()) as id, @fromD as dt, 
   DATENAME(dw, @fromD) as dtName

   UNION ALL

   SELECT id + 1 as id, DATEADD(day, 1, dt), DATENAME(dw, DATEADD(day, 1, 
   dt)) dtName
   FROM cteDate
   WHERE dt < @toD
  )

INSERT INTO #temp_cablePulling
SELECT 
cteDate.dt, cteDate.dtName 
,tblCables.tag,tblCables.design_length,tblCables.pulled_date,tblCables.plan_pulling_date,tblCables.unit_id
FROM cteDate
LEFT JOIN tblCables ON tblCables.pulled_date BETWEEN DATEADD(day,-6,CONVERT(date,cteDate.dt)) AND CONVERT(date,cteDate.dt)
WHERE cteDate.dtName in( 'Friday')
AND tblCables.active=1
OPTION(MAXRECURSION 0)


select @col = STUFF((select distinct ',' + quotename(x.dt)
FROM (SELECT DISTINCT dt FROM #temp_cablePulling) as x for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
select @colSum = STUFF((select distinct ',SUM(' + quotename(x.dt) + ') as ' + quotename(x.dt)
FROM (SELECT DISTINCT dt FROM #temp_cablePulling) as x for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
select @colHeader = STUFF((select distinct ',FORMAT(' + quotename(x.dt) + 'dd-MM-yyyy)'
FROM (SELECT DISTINCT dt FROM #temp_cablePulling) as x for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')

SET @result = '
SELECT * 
FROM
(
SELECT
tblUnits.unit_name,Planned,' + @col + '
FROM
(
SELECT unit_id,Planned,' + @colSum + '
FROM 
(
SELECT * FROM (

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT unit_id,''Planned Pulled'' as Planned,dt,CASE WHEN plan_pulled_date IS NOT NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cablePulling
UNION ALL
SELECT unit_id,''Not Planned Pulled'' as Planned,dt,CASE WHEN plan_pulled_date IS NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cablePulling
UNION ALL
SELECT unit_id,''Pulled Total'' as Planned,dt,design_length FROM #temp_cablePulling
) as groupedResult
PIVOT (
	SUM(design_length) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY unit_id,Planned,' + @col + '
) as vAll
LEFT JOIN tblUnits ON tblUnits.unit_id = vAll.unit_id
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL

SELECT ''Total'' as unit_name,''Total Not Planned'' as Planned,' + @colSum + '
FROM 
(
SELECT * FROM (
SELECT dt,CASE WHEN plan_pulled_date IS NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cablePulling
) as groupedResult
PIVOT (
	SUM(design_length) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL

SELECT ''Total'' as unit_name,''Total Planned'' as Planned,' + @colSum + '
FROM 
(
SELECT * FROM (
SELECT dt,CASE WHEN plan_pulled_date IS NOT NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cablePulling
) as groupedResult
PIVOT (
	SUM(design_length) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UNION ALL

SELECT ''Total'' as unit_name,''Total'' as Planned,' + @colSum + '
FROM 
(
SELECT * FROM (
SELECT dt,design_length FROM #temp_cablePulling
) as groupedResult
PIVOT (
	SUM(design_length) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
) as v
ORDER BY unit_name
'
EXECUTE (@result)






GO
