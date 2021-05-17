ALTER PROC sp_updatePermitWorkAuthorization
@permitNumber INT,
@authorizedMemberName NVARCHAR(50),
@authorizedPermitMemberName NVARCHAR(50),
@lotoNumber INT,
@permitRequired BIT
AS
DECLARE @permitId INT
DECLARE @authorizedMemberId INT
DECLARE @authorizedPermitMemberId INT

SELECT @permitId = HSE.tblLotoPermit.lotoPermitId FROM HSE.tblLotoPermit WHERE HSE.tblLotoPermit.permitNumber = @permitNumber
SELECT @authorizedMemberId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @authorizedMemberName
SELECT @authorizedPermitMemberId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @authorizedPermitMemberName

UPDATE HSE.tblLotoPermit
        SET authorizedMemberId = @authorizedMemberId,
            authorizedPermitMemberId = @authorizedPermitMemberId,
            lotoNumber = @lotoNumber,
            workAuthorizedDate = GETDATE(),
            permitRequired = @permitRequired
        WHERE lotoPermitId = @permitId