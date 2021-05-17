ALTER PROC sp_p6Summary
AS
DECLARE @dte DATE
SELECT @dte = tblOptions.cutoffDate FROM tblOptions WHERE id = 1

SELECT
tblActids.area AS Unit,tblActids.family AS Family,tblActids.act_name AS [Activity],tblActids.subcon As Subcontractor
,itemsProduction.*

FROM (
--Cables Pulling
SELECT 
pulling_actid AS [ActID]
,SUM(tblCables.design_length) AS [Scope]
,SUM(CASE WHEN tblCables.pulled_date <= @dte THEN design_length ELSE 0 END) AS [Cummlative]
,SUM(CASE WHEN pulled_date BETWEEN DATEADD(DAY,-6,@dte) AND @dte THEN design_length ELSE 0 END) As [Weekly]
FROM tblCables WITH (NOLOCK)
WHERE active=1
GROUP BY tblCables.pulling_actid
UNION ALL
--Cables Pulling
SELECT 
con_actid AS [ActID]
,COUNT(tblCables.tag) * 2 AS [Scope]
,SUM(CASE WHEN tblCables.con_from_date <= @dte THEN 1 ELSE 0 END) + SUM(CASE WHEN tblCables.con_to_date <= @dte THEN 1 ELSE 0 END)
AS [Cummlative]
,SUM(CASE WHEN con_from_date BETWEEN DATEADD(DAY,-6,@dte) AND @dte THEN 1 ELSE 0 END) + SUM(CASE WHEN con_to_date BETWEEN DATEADD(DAY,-6,@dte) AND @dte THEN 1 ELSE 0 END)
As [Weekly]
FROM tblCables WITH (NOLOCK)
WHERE active = 1
GROUP BY tblCables.con_actid
UNION ALL
--Instrument Installation
SELECT 
installation_actid AS [ActID]
,COUNT(tblInstruments.tag) AS [Scope]
,SUM(CASE WHEN tblInstruments.installed_date <= @dte THEN 1 ELSE 0 END) AS [Cummlative]
,SUM(CASE WHEN installed_date BETWEEN DATEADD(DAY,-6,@dte) AND @dte THEN 1 ELSE 0 END) As [Weekly]
FROM tblInstruments WITH (NOLOCK)
WHERE main_device = 1 AND Installation_scope LIKE 'TR%'
AND active = 1
GROUP BY tblInstruments.installation_actid
) AS itemsProduction
LEFT JOIN tblActids ON itemsProduction.ActID = tblActids.actid