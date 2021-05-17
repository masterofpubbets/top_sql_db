ALTER PROC sp_getWorkPermitIssuedAll
AS
SELECT
lotoPermitId
,FORMAT(workPermitIssuedDate,'dddd dd-MM-yyyy') AS [Issued Date]
,HSE.tblHSEMember.memberName AS [Permit Issuer]
,ptw.memberName AS [Permit Receiver]
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.workPermitIssuerId = HSE.tblHSEMember.memId
INNER JOIN HSE.tblHSEMember AS ptw ON HSE.tblLotoPermit.workPermitReceiverId = ptw.memId