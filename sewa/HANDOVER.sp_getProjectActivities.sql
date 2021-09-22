ALTER PROC HANDOVER.sp_getProjectActivities
AS
SELECT
Tasks.taskType AS [Task Type]
,Tasks.projectActId AS [Task Id]
,Tasks.systemOwner AS [System Owner]
,Tasks.siNo AS [Si No],Tasks.piItemNo AS [Pi Item No]
,Tasks.[description] AS [Description]
,Tasks.scope AS Scope
,Tasks.subcon AS Subcontractor
,Tasks.comments AS Comments
,Tasks.doneDate AS [Done Date]
,CASE WHEN Tasks.doneDate IS NOT NULL THEN 'DONE'
    WHEN ((Tasks.doneDate IS NULL) AND (Tasks.active = 1)) THEN 'PENDING'
    WHEN ((Tasks.doneDate IS NULL) AND (Tasks.active = 0)) THEN 'DELETED'
ELSE
    'UNKNOWN'
END AS [Status]

FROM HANDOVER.tblProjectActivity AS Tasks