CREATE PROC sp_signalListMini

AS
SELECT
tblUnits.unit_name AS Unit,tblTop.top_name AS [Top]
,tblSignals.tag AS Tag,tblSignals.category AS [Category]
,tblSignals.sub_category AS [Sub Category],tblSignals.loop_type AS [Type]

FROM tblSignals
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id
INNER JOIN tblTop On tblSignals.top_id = tblTop.top_id

