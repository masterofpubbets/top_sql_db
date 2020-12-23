CREATE PROC sp_signalDetails
@tag NVARCHAR(100)
AS
SELECT
tblUnits.unit_name AS Unit,tblTop.top_name AS [Top]
,tblSignals.tag AS Tag,tblSignals.category AS [Category]
,tblSignals.sub_category AS [Sub Category],tblSignals.loop_type AS [Type]
,FORMAT(tblSignals.plan_date,'dd/MM/yyyy') AS [Plan Date],FORMAT(tblSignals.loop_done,'dd/MM/yyyy') AS [Performed Date]
,tblSignals.Service,tblSignals.[owner],tblSignals.cons_responsible AS [Construction Resp.]
,tblSignals.comm_responsible AS [Comm Resp.]
FROM tblSignals
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id
INNER JOIN tblTop On tblSignals.top_id = tblTop.top_id
WHERE tblSignals.tag = @tag
