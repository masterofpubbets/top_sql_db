CREATE PROC [dbo].[sp_cableConnWeekProgress]
AS
If(OBJECT_ID('tempdb..#temp_cableConnecting') Is Not Null)
Begin
    Drop Table #temp_cableConnecting
End
If(OBJECT_ID('tempdb..#temp_cableConnectingTotal') Is Not Null)
Begin
    Drop Table #temp_cableConnectingTotal
End

create table #temp_cableConnecting
(
    dt DATE,
    dtName NVarchar(50),
    tag NVarchar(100),
    con_to_date date,
    con_from_date date,
    plan_connected_date date,
    unit_id int
)
create table #temp_cableConnectingTotal
(
    dt DATE,
    dtName NVarchar(50),
    tag NVarchar(100),
    con_total int,
    plan_count int,
    unit_id int
)

DECLARE @fromD date
DECLARE @fromD_from date
DECLARE @fromD_to date
DECLARE @toD date
DECLARE @col as nvarchar(max)
DECLARE @colSum as nvarchar(max)
DECLARE @colHeader as nvarchar(max)
declare @result as nvarchar(max)

SELECT @fromD_from = MIN(tblCables.con_from_date)
FROM tblCables
SELECT @fromD_to = MIN(tblCables.con_to_date)
FROM tblCables
IF @fromD_from > @fromD_to
BEGIN
    SELECT @fromD = @fromD_to
END
ELSE
BEGIN
    SELECT @fromD = @fromD_from
END

SELECT @toD = tblOptions.cutoffdate
from tblOptions
WHERE id = 1;

WITH
    cteDate
    as
    (
        SELECT ROW_NUMBER() OVER(ORDER BY NEWID()) as id, @fromD as dt,
        DATENAME(dw, @fromD) as dtName

        UNION ALL

        SELECT id + 1 as id, DATEADD(day, 1, dt), DATENAME(dw, DATEADD(day, 1, 
   dt)) dtName
            FROM cteDate
            WHERE dt < @toD
    )

INSERT INTO #temp_cableConnecting
SELECT
    cteDate.dt, cteDate.dtName 
, tblCables.tag, NULL AS con_to_date, tblCables.con_from_date, tblCables.plan_connected_date, tblCables.unit_id
FROM cteDate
    LEFT JOIN tblCables ON (tblCables.con_from_date BETWEEN DATEADD(day,-6,CONVERT(date,cteDate.dt)) AND CONVERT(date,cteDate.dt))
WHERE cteDate.dtName in( 'Friday')
OPTION(MAXRECURSION 0);

WITH
    cteDate
    as
    (
        SELECT ROW_NUMBER() OVER(ORDER BY NEWID()) as id, @fromD as dt,
        DATENAME(dw, @fromD) as dtName

        UNION ALL

        SELECT id + 1 as id, DATEADD(day, 1, dt), DATENAME(dw, DATEADD(day, 1, 
   dt)) dtName
            FROM cteDate
            WHERE dt < @toD
    )

INSERT INTO #temp_cableConnecting
SELECT
    cteDate.dt, cteDate.dtName 
, tblCables.tag, tblCables.con_to_date, NULL AS con_from_date, tblCables.plan_connected_date, tblCables.unit_id
FROM cteDate
    LEFT JOIN tblCables ON (tblCables.con_to_date BETWEEN DATEADD(day,-6,CONVERT(date,cteDate.dt)) AND CONVERT(date,cteDate.dt))
WHERE cteDate.dtName in( 'Friday')
OPTION(MAXRECURSION 0);

INSERT INTO #temp_cableConnectingTotal
SELECT
dt,dtName,tag
,COUNT(con_from_date) + COUNT(con_to_date) AS con_total
,COUNT(plan_connected_date) as plan_count,unit_id
FROM #temp_cableConnecting
GROUP BY dt,dtName,tag,plan_connected_date,unit_id

select @col = STUFF((select distinct ',' + quotename(x.dt)
    FROM (SELECT DISTINCT dt
        FROM #temp_cableConnecting) as x
    for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
select @colSum = STUFF((select distinct ',SUM(' + quotename(x.dt) + ') as ' + quotename(x.dt)
    FROM (SELECT DISTINCT dt
        FROM #temp_cableConnecting) as x
    for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
select @colHeader = STUFF((select distinct ',FORMAT(' + quotename(x.dt) + 'dd-MM-yyyy)'
    FROM (SELECT DISTINCT dt
        FROM #temp_cableConnecting) as x
    for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')

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
SELECT unit_id,''Planned Terminated'' as Planned,dt,con_total FROM #temp_cableConnectingTotal WHERE plan_count <> 0
UNION ALL
SELECT unit_id,''Not Planned Terminated'' as Planned,dt,con_total FROM #temp_cableConnectingTotal WHERE plan_count = 0
UNION ALL
SELECT unit_id,''Terminated Total'' as Planned,dt,con_total FROM #temp_cableConnectingTotal
) as groupedResult
PIVOT (
	SUM(con_total) FOR dt IN (' + @col + ')
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
SELECT dt,con_total FROM #temp_cableConnectingTotal WHERE plan_count = 0
) as groupedResult
PIVOT (
	SUM(con_total) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
UNION ALL

SELECT ''Total'' as unit_name,''Total Planned'' as Planned,' + @colSum + '
FROM 
(
SELECT * FROM (
SELECT dt,con_total FROM #temp_cableConnectingTotal WHERE plan_count <> 0
) as groupedResult
PIVOT (
	SUM(con_total) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UNION ALL

SELECT ''Total'' as unit_name,''Total'' as Planned,' + @colSum + '
FROM 
(
SELECT * FROM (
SELECT dt,con_total FROM #temp_cableConnectingTotal
) as groupedResult
PIVOT (
	SUM(con_total) FOR dt IN (' + @col + ')
) as P
) as result
GROUP BY ' + @col + '
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
) as v
WHERE unit_name IS NOT NULL
ORDER BY unit_name
'
EXECUTE (@result)


