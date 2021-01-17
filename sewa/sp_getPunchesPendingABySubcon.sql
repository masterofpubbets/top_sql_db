ALTER PROC sp_getPunchesPendingABySubcon
AS

IF OBJECT_ID('tempdb..#tempPunch') IS NOT NULL
DROP TABLE #tempPunch
CREATE TABLE #tempPunch
(
ID Int,
[Punch No] NVARCHAR(100),
[Top] NVARCHAR(100),
[Top Description] NVARCHAR(255),
[Category] NVARCHAR(50),
[Description] NVARCHAR(MAX),
[Unit] NVARCHAR(100),
[Discipline] NVARCHAR(50),
[Subcontractor] NVARCHAR(100),
[Responsible] NVARCHAR(100),
[Created On] DATE,
[Cons. Closed Date] DATE,
[Offical CLosed Date] DATE,
[Target Date] DATE,
Issues NVARCHAR(MAX),
Flag NVARCHAR(100)
)
insert into #tempPunch
EXEC sp_getPunches


DECLARE @result as nvarchar(max)
DECLARE @col as nvarchar(max)
SELECT @col = STUFF((select  ',' + quotename(x.[Subcontractor])

FROM (SELECT DISTINCT [Subcontractor]  FROM #tempPunch) as x order by [Subcontractor]
FOR xml path ('') ,TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'') 

set @result = '
            SELECT memberPending.[Top],memberPending.[Top Description]
            ,CASE WHEN PunchTargetDate.[Target Date] = ''1/1/2100'' THEN ''Pending Target Date'' ELSE CONVERT(NVARCHAR(50), PunchTargetDate.[Target Date]) END AS [Target Date]
            ,PunchTargetDate.[Open Punches],' + @col + '
            FROM (
                SELECT [Top],[Top Description], ' + @col + ' FROM 
                (
                    SELECT ID,[Top],[Top Description],[Cons. Closed Date],[Subcontractor]

                    FROM #tempPunch
				    WHERE [Offical CLosed Date] IS NULL AND [Category] = ''A'' AND [Cons. Closed Date] IS NULL

                ) x

                pivot 
                (
                    COUNT([ID]) FOR [Subcontractor] in (' + @col + ')
                ) p 
            ) AS memberPending

            INNER JOIN (
                            SELECT [Top],MAX(CASE WHEN [Target Date] IS NULL THEN ''1/1/2100'' ELSE [Target Date] END) AS [Target Date],SUM(CASE WHEN [Cons. Closed Date] IS NULL THEN 1 ELSE 0 END) AS [Open Punches]  
                            FROM #tempPunch WHERE [Offical CLosed Date] IS NULL AND [Category] =''A'' GROUP BY [Top]
                       ) AS PunchTargetDate

            ON memberPending.[Top] = PunchTargetDate.[Top]
'


execute(@result)