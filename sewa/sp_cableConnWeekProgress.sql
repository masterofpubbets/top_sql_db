CREATE PROC [dbo].[sp_cableConnWeekProgress]
AS
If(OBJECT_ID('tempdb..#temp_cableConnecting') Is Not Null)
Begin
    Drop Table #temp_cableConnecting
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
, tblCables.tag, tblCables.con_to_date, tblCables.con_from_date, tblCables.plan_connected_date, tblCables.unit_id
FROM cteDate
    LEFT JOIN tblCables ON ((tblCables.con_from_date BETWEEN DATEADD(day,-6,CONVERT(date,cteDate.dt)) AND CONVERT(date,cteDate.dt))
                            OR
                            (tblCables.con_to_date BETWEEN DATEADD(day,-6,CONVERT(date,cteDate.dt)) AND CONVERT(date,cteDate.dt)))
WHERE cteDate.dtName in( 'Friday')
OPTION(MAXRECURSION
0)


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
SELECT unit_id,''Planned Pulled'' as Planned,dt,CASE WHEN plan_con_from_date IS NOT NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cableConnecting
UNION ALL
SELECT unit_id,''Not Planned Pulled'' as Planned,dt,CASE WHEN plan_con_from_date IS NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cableConnecting
UNION ALL
SELECT unit_id,''Pulled Total'' as Planned,dt,design_length FROM #temp_cableConnecting
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
SELECT dt,CASE WHEN plan_con_from_date IS NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cableConnecting
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
SELECT dt,CASE WHEN plan_con_from_date IS NOT NULL THEN design_length ELSE 0 END AS design_length FROM #temp_cableConnecting
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
SELECT dt,design_length FROM #temp_cableConnecting
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
