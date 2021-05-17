ALTER PROC sp_getLotoLockoutListAll
AS
SELECT 
HSE.tblLotoPermitRequired.lotoId AS ID
,HSE.tblLotoPermitRequired.equipmentKKS AS [Device Or Equipment Isolated]
,HSE.tblLotoPermitRequired.requiredPosition AS [Required Position]
,HSE.tblLotoPermitRequired.padlockNo AS [Padlock No]
,HSE.tblHSEMember.memberName
,HSE.tblLotoPermit.lotoPermitId
,HSE.tblLotoPermitRequired.removalDate AS [Cleared Date]
FROM HSE.tblLotoPermitRequired
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermitRequired.lotoById = HSE.tblHSEMember.memId
INNER JOIN HSE.tblLotoPermit ON HSE.tblLotoPermitRequired.permitId = HSE.tblLotoPermit.lotoPermitId
