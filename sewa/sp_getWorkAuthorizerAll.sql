ALTER PROC sp_getWorkAuthorizerAll
AS
SELECT
HSE.tblHSEMember.memberName AS [Authorized Employee]
,permitMember.memberName AS [Permit Authorizer]
,HSE.tblLotoPermit.lotoPermitId
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.authorizedMemberId = HSE.tblHSEMember.memId
INNER JOIN HSE.tblHSEMember AS permitMember ON HSE.tblLotoPermit.authorizedPermitMemberId = permitMember.memId
