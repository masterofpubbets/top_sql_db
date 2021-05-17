CREATE PROC sp_getLockoutAppliedAll
AS
SELECT
lotoPermitId,lockoutAppliedDate AS [Lockout Applied Date]
,HSE.tblHSEMember.memberName AS [System Owner]
,ptw.memberName AS [PTW Engineer]
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.lockoutAppliedSystemownerId = HSE.tblHSEMember.memId
INNER JOIN HSE.tblHSEMember AS ptw ON HSE.tblLotoPermit.lockoutAppliedSystemownerId = ptw.memId