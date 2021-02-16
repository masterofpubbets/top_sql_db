ALTER PROC sp_dailyTracking
AS
declare @col as nvarchar(max)
declare @colSUM as nvarchar(max)
declare @result as nvarchar(max)
declare @startdate as char(10)
declare @enddate as char(10)
declare @startdate0 as date
declare @enddate0 as date
 
select @enddate0 =  [cutoffDate] FROM [tblOptions] WHERE id=1
select @startdate0 = dateadd(d,-6,@enddate0) --'04/11/2015'
set @enddate =  convert(char(10),cast(@enddate0 as smalldatetime),111)
set @startdate = convert(char(10),cast(@startdate0 as smalldatetime),111)
 
 
select @col = STUFF((select distinct ',' + quotename(x.Date)
FROM (select DATE FROM (select convert(char(10),dateadd(d,(x.a + (10 * x.b) + (100 * x.c) + (1000 * x.d)),cast(@startdate as smalldatetime)),111) as Date
FROM (select * FROM (select 0 as a UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as a CROSS JOIN
(select 0 as b UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as b CROSS JOIN
(select 0 as c UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as c CROSS JOIN
(select 0 as d UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as d) as x) as x1
where date between @startdate and @enddate) as x for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
 
select @colSUM =  STUFF((select distinct ',' + 'SUM(' + quotename(x.Date) + ') as ' + quotename(x.Date)
FROM (select DATE FROM (select convert(char(10),dateadd(d,(x.a + (10 * x.b) + (100 * x.c) + (1000 * x.d)),cast(@startdate as smalldatetime)),111) as Date
FROM (select * FROM (select 0 as a UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as a CROSS JOIN
(select 0 as b UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as b CROSS JOIN
(select 0 as c UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as c CROSS JOIN
(select 0 as d UNION ALL select 1 UNION ALL select 2 UNION ALL select 3 UNION ALL select 4 UNION ALL select 5 UNION ALL select 6 UNION ALL select 7 UNION ALL select 8 UNION ALL select 9) as d) as x) as x1
where date between @startdate and @enddate) as x for xml path (''),TYPE).value('.' ,'NVARCHAR(MAX)'),1,1,'')
 
 
set @result = '
 
select
tblUnits.unit_name As [Unit],x2.[Category],x2.[Subcategory],x2.[Type]
--,X2.[Activity Name]
,UOM
,SUM(X2.SCOPE) AS Scope
,sum(x2.Cummulative) as Cumulative
,SUM(X2.SCOPE)-sum(x2.Cummulative) AS [TOTAL REM QTY]
,sum(x2.[Last 4 Weekly]) as [4 Weeks Ago]
,sum(x2.[Last 3 Weekly]) as [3 Weeks Ago]
,sum(x2.[Last 2 Weekly]) as [2 Weeks Ago]
,sum(x2.[Last 1 Weekly]) as [1 Week Ago]
,sum(x2.Weekly) as Weekly
,'+ @colSUM +'
 
 
FROM
(
select [Category],[Subcategory],[Type],unit_id
,[Activity Name]
,[Unit] AS UOM
,Scope
,case when Cummulative is null then 0 else Cummulative end as Cummulative
,CASE WHEN [Last 4 Weekly] IS NULL THEN 0 ELSE [Last 4 Weekly] END AS [Last 4 Weekly]
,CASE WHEN [Last 3 Weekly] IS NULL THEN 0 ELSE [Last 3 Weekly] END AS [Last 3 Weekly]
,CASE WHEN [Last 2 Weekly] IS NULL THEN 0 ELSE [Last 2 Weekly] END AS [Last 2 Weekly]
,CASE WHEN [Last 1 Weekly] IS NULL THEN 0 ELSE [Last 1 Weekly] END AS [Last 1 Weekly]
,CASE WHEN Weekly IS NULL THEN 0 ELSE WEEKLY END AS Weekly
,'+ @col +' FROM
 
--******************************************************************
(--Cable Pulling	 

select convert(char(10),cast([Pulled_Date] as smalldatetime),111) as Daily,
''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],[unit_id] as unit_id 
FROM tblCables
where [Pulled_Date] is not null
group by [discipline],[Pulled_Date],unit_id
UNION ALL
select ''Cummulative'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where Pulled_Date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1) 
group by [discipline],unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where [Pulled_Date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [discipline],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where [Pulled_Date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [discipline],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where [Pulled_Date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [discipline],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where [Pulled_Date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [discipline],unit_id
UNION ALL
select ''Weekly'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id 
FROM tblCables
where [Pulled_Date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [discipline],unit_id
UNION ALL
select ''Scope'' as Daily,''Cable Pulling - '' + [discipline] as [Activity Name]
,sum([design_length]) as ''Pulled'',''Cable'' as [Category],''Pulling'' AS [Subcategory],''Pulling '' + [discipline] AS [Type],''LM'' as [Unit],unit_id as unit_id FROM 
tblCables
group by [discipline],unit_id
--******************************************************************
UNION ALL
---Cable Connections 01
select convert(char(10),cast([Conn_Date] as smalldatetime),111) as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by Conn_Date,[unit_id],discipline
UNION ALL
select ''Cummulative'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by Conn_Date,[unit_id],discipline
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by Conn_Date,[unit_id],discipline
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by Conn_Date,[unit_id],discipline
UNION ALL
select ''Weekly'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_from_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_from_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by con_from_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Scope'' as Daily,
''Cable Connection From - '' + discipline as [Activity Name]
,count([tag]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id 
FROM tblCables
group by [unit_id],discipline
--*********************************************************************************
UNION ALL
---Cable Connections 02
select convert(char(10),cast([Conn_Date] as smalldatetime),111) as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] is not null
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by Conn_Date,[unit_id],discipline
UNION ALL
select ''Cummulative'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Weekly'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,sum([EC_Conn1]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id FROM 
(select con_to_date as [Conn_Date]
,count([tag]) as [EC_Conn1] ,[unit_id],discipline
FROM tblCables where [con_to_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by con_to_date,[unit_id],discipline
)
as vELECon1
group by [unit_id],discipline
UNION ALL
select ''Scope'' as Daily,
''Cable Connection To - '' + discipline as [Activity Name]
,count([tag]) as ''Conn'',''Cable'' as [Category],''Connection'' AS [Subcategory],''Connections '' + [discipline] AS [Type],''Each'' as [Unit],[unit_id] as unit_id 
FROM tblCables
group by [unit_id],discipline
--*********************************************************************************
UNION ALL
---JB Installtion
select convert(char(10),cast([erected_date] as smalldatetime),111) as daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Cummulative'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and [erected_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and [erected_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and [erected_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and [erected_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Weekly'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
and [erected_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Scope'' as Daily,
''JB Installation'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''JB'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''JB''
group by unit_id
--*********************************************************
UNION ALL
---Mechanical Eq
select convert(char(10),cast([erected_date] as smalldatetime),111) as daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and [erected_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and [erected_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and [erected_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and [erected_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Weekly'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
and [erected_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Scope'' as Daily,
''Mechanical Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Mechanical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Mechanical''
group by unit_id
--*********************************************************
UNION ALL
---Electrical Eq
select convert(char(10),cast([erected_date] as smalldatetime),111) as daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and erected_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and [erected_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and [erected_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and [erected_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and [erected_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [erected_date],unit_id
UNION ALL
select ''Weekly'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
and [erected_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [erected_date],unit_id
UNION ALL
select ''Scope'' as Daily,
''Electrical Equipment Erection'' as [activity Name]
,count([tag]) as ''Installed Count'',''Equipment'' as [Category],''Electrical'' AS [Subcategory],''Erection'' AS [Type],''Each'' as [Unit],unit_id as unit_id 
FROM tblEquipment 
where [type] = ''Electrical''
group by unit_id
--*********************************************************
UNION ALL
---Instrument Installation - Mechanical
select convert(char(10),cast([installed_date] as smalldatetime),111) as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and installed_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [installed_date],unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and installed_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and [installed_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and [installed_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and [installed_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and [installed_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Weekly'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
and [installed_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [installed_date],unit_id
UNION ALL
select ''Scope'' as Daily,
''Instrument Installation - Mechanical'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Mechanical''
group by unit_id
--*********************************************************
UNION ALL
---Instrument Installation - Electronic
select convert(char(10),cast([installed_date] as smalldatetime),111) as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and installed_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [installed_date],unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and installed_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and [installed_date] between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and [installed_date] between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and [installed_date] between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and [installed_date] between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by [installed_date],unit_id
UNION ALL
select ''Weekly'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
and [installed_date] between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by [installed_date],unit_id
UNION ALL
select ''Scope'' as Daily,
''Instrument Installation - Electronic'' as [Activity Name]
,count([tag]) as ''Installed Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Installation'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where main_device = 1
AND Installation_scope LIKE ''TR%''
AND device_type = ''Electronic''
group by unit_id
--*********************************************************
UNION ALL
---Hook Ups
select convert(char(10),cast(HookUp_Date as smalldatetime),111) as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments
WHERE hookup_require = 1
group by unit_id,hookup_date
UNION ALL
select ''Cummulative'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where HookUp_Date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
and hookup_require = 1
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
and hookup_date between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
and hookup_date between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
and hookup_date between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
and hookup_date between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Weekly'' as Daily,
''Hook Ups'' as [Activity Name]
,count([HookUp_Date]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
and hookup_date between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Scope'' as Daily,
''Hook Ups'' as [Activity Name]
,count([tag]) as ''Hookup Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Hookups'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where hookup_require = 1
group by unit_id
--*********************************************************
UNION ALL
---Calibration
select convert(char(10),cast(Calibration_Date as smalldatetime),111) as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
group by unit_id,Calibration_Date
UNION ALL
select ''Cummulative'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by unit_id
UNION ALL
select ''Weekly'' as Daily,
''Calibration'' as [Activity Name]
,count([Calibration_Date]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
and Calibration_Date between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Scope'' as Daily,
''Calibration'' as [Activity Name]
,count([tag]) as ''Calibration Count'',''Instrumentation'' as [Category],''Instrument'' AS [Subcategory],''Calibration'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblInstruments 
where Calibration_require = 1
group by unit_id
--*********************************************************
UNION ALL
---Loop
select convert(char(10),cast(loop_done as smalldatetime),111) as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblSignals where comm_responsible = ''TR''
group by loop_done,unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as unit_id FROM tblSignals where comm_responsible = ''TR''
and loop_done <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
and loop_done between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by loop_done,unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
and loop_done between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by loop_done,unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
and loop_done between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by loop_done,unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
and loop_done between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by loop_done,unit_id
UNION ALL
select ''Weekly'' as Daily,
''Loop Test'' as [Activity Name]
,count([loop_done]) as ''Installed Count'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
and loop_done between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by loop_done,unit_id
UNION ALL
select ''Scope'' as Daily,
''Loop Test'' as [Activity Name]
,count(tag) as ''Scope'',''Loop'' as [Category],''Loop'' AS [Subcategory],''Test'' AS [Type],''Each'' as [Unit],unit_id as ActID FROM tblSignals where comm_responsible = ''TR''
group by unit_id
--*********************************************************
UNION ALL
---TOP Transfer
select convert(char(10),cast(transfer_date as smalldatetime),111) as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as unit_id FROM tbltop
group by transfer_date,unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as unit_id FROM tbltop
WHERE transfer_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE transfer_date between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by transfer_date,unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE transfer_date between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by transfer_date,unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE transfer_date between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by transfer_date,unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE transfer_date between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by transfer_date,unit_id
UNION ALL
select ''Weekly'' as Daily,
''Top Transfer'' as [Activity Name]
,count([transfer_date]) as ''Transfer Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE transfer_date between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by transfer_date,unit_id
UNION ALL
select ''Scope'' as Daily,
''Top Transfer'' as [Activity Name]
,count(top_name) as ''Scope'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
group by unit_id
--*********************************************************
UNION ALL
---TOP Walk Through
select convert(char(10),cast(walk_through_date as smalldatetime),111) as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as unit_id FROM tbltop
group by walk_through_date,unit_id
UNION ALL
select ''Cummulative'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as unit_id FROM tbltop
WHERE walk_through_date <= (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by unit_id
UNION ALL
select ''Last 1 Weekly'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE walk_through_date between dateadd(d,-13,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by walk_through_date,unit_id
UNION ALL
select ''Last 2 Weekly'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE walk_through_date between dateadd(d,-13-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-7,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by walk_through_date,unit_id
UNION ALL
select ''Last 3 Weekly'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE walk_through_date between dateadd(d,-13-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-14,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by walk_through_date,unit_id
UNION ALL
select ''Last 4 Weekly'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE walk_through_date between dateadd(d,-13-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and dateadd(d,-7-21,(select [cutoffDate] FROM [tblOptions] WHERE id=1))
group by walk_through_date,unit_id
UNION ALL
select ''Weekly'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count([walk_through_date]) as ''Walkthrough Count'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
WHERE walk_through_date between dateadd(d,-6,(select [cutoffDate] FROM [tblOptions] WHERE id=1)) and (select [cutoffDate] FROM [tblOptions] WHERE id=1)
group by walk_through_date,unit_id
UNION ALL
select ''Scope'' as Daily,
''Top Walkthrough'' as [Activity Name]
,count(top_name) as ''Scope'',''Top'' as [Type],''Each'' as [Unit],unit_id as ActID FROM tbltop
group by unit_id
--*********************************************************
--******************************************************************
) as X

PIVOT 
(sum (Pulled) for Daily in ('+ @col +',Scope,[Cummulative],[Last 1 Weekly],[Last 2 Weekly],[Last 3 Weekly],[Last 4 Weekly],weekly)
)as X1
) as X2
INNER JOIN tblUnits On x2.unit_id = tblUnits.unit_id

group by tblUnits.unit_name,x2.[Category],[Subcategory],x2.[Type],UOM
'

EXECUTE (@result)