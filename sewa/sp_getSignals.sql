ALTER PROC sp_getSignals
AS
SELECT 
tblSignals.signal_id AS [ID]
,tblSignals.tag AS Tag
,tblSystems.systemName AS [System Name],tblSystems.systemDescription AS [System Description]
,tblTOP.top_name AS [TOP],tblTop.transfer_date AS [Transfer Date],tblTOP.sequenceName AS [TOP Sequence]
,tblUnits.unit_name AS [Unit]
,tblSignals.actId AS [Activity ID],tblSignals.category AS [Category],tblSignals.sub_category AS [Subcategory]
,tblSignals.loop_type AS [Loop Type],tblSignals.plan_date AS [Plan Date],tblSignals.Service,tblSignals.owner AS [Owner]
,tblSignals.cons_responsible AS [Cons Responsible],tblSignals.comm_responsible AS [Comm Responsible]
,tblSignals.remarks AS [Remarks],tblSignals.signalConstraint AS [Constraint],tblMembers.fullName AS [Constraint Responsible]
,tblSignals.constraintResolvedDate AS [Constraint Resolved Date]
,tblSignals.loop_done AS [Done Date]
,tblSignals.active AS Active
FROM tblSignals 
INNER JOIN tblTOP ON tbltop.top_id = tblSignals.top_id 
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id
INNER JOIN tblSystems ON tbltop.systemId = tblSystems.sysId
LEFT JOIN tblMembers ON tblSignals.constraintResponsibleID = tblMembers.memberId