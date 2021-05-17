ALTER PROC sp_hseLocks
AS
SELECT
HSE.tblLocks.lockId as ID
,HSE.tblLocks.position AS Position,HSE.tblLocks.lockNumber AS [Lock Number],HSE.tblLocks.boxNumber AS [Box Number]
,HSE.tblLocks.ptw AS [PTW-ECP No],HSE.tblLocks.kks AS KKS,HSE.tblLocks.[location] AS [Location]
,CASE WHEN HSE.tblLocks.isElectricalIsolated =1 THEN 'Electrical' ELSE 'Mechanical' END AS [Type of Isolation]
,CASE WHEN HSE.tblLocks.lockPosition =1 THEN 'Closed' ELSE 'Open' END AS [Isolation Position]
,HSE.tblLocks.lockDate AS [Lock Date]
,HSE.tblHSEMember.memberName AS [Lock By]
,dbo.tblSubcontractor.subconName AS [Lock By Company]
,HSE.tblLocks.unlockDate AS [Unlock Date]
,hseUnloacMembers.memberName AS [Unlock By]
,hseUnlockSubcon.subconName AS [Unlock By Company]
,HSE.tblLocks.observation AS Observation
FROM HSE.tblLocks
INNER JOIN HSE.tblHSEMember ON HSE.tblLocks.lockBy = HSE.tblHSEMember.memId
INNER JOIN dbo.tblSubcontractor ON HSE.tblHSEMember.subconID = dbo.tblSubcontractor.subconId

LEFT JOIN HSE.tblHSEMember AS hseUnloacMembers ON HSE.tblLocks.unlockBy = hseUnloacMembers.memId
LEFT JOIN dbo.tblSubcontractor AS hseUnlockSubcon ON hseUnloacMembers.subconID = hseUnlockSubcon.subconId