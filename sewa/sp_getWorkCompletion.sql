CREATE PROC sp_getWorkCompletion
AS
SELECT
lotoPermitId
,FORMAT(workCompletionDate,'dddd dd-MM-yyyy') AS [Completion Date]
,HSE.tblHSEMember.memberName AS [System Receiver]
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.workCompletionReceiverId = HSE.tblHSEMember.memId
