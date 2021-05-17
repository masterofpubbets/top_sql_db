CREATE PROC sp_getWorkCompletionValidation
AS
SELECT
lotoPermitId
,FORMAT(workCompletionValidationDate,'dddd dd-MM-yyyy') AS [Validation Date]
,HSE.tblHSEMember.memberName AS [System Owner]
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.workValidationOwnerId = HSE.tblHSEMember.memId