CREATE PROC sp_getWorkAuthorizer
@permitID INT
AS
SELECT
HSE.tblHSEMember.memberName AS [Authorized Employee]
,permitMember.memberName AS [Permit Authorizer]
FROM HSE.tblLotoPermit
INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.authorizedMemberId = HSE.tblHSEMember.memId
INNER JOIN HSE.tblHSEMember AS permitMember ON HSE.tblLotoPermit.authorizedPermitMemberId = permitMember.memId
WHERE HSE.tblLotoPermit.lotoPermitId = @permitID