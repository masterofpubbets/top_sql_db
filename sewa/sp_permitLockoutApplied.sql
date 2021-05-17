ALTER PROC sp_permitLockoutApplied
@permitNumber INT,
@lockoutAppliedSystemowner NVARCHAR(250),
@lockoutAppliedPTW NVARCHAR(250)
AS
DECLARE @lockoutAppliedSystemownerId INT
DECLARE @lockoutAppliedPTWId INT

SELECT @lockoutAppliedSystemownerId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @lockoutAppliedSystemowner
SELECT @lockoutAppliedPTWId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @lockoutAppliedPTW

UPDATE HSE.tblLotoPermit
        SET lockoutAppliedDate = GETDATE(),
            lockoutAppliedSystemownerId = @lockoutAppliedSystemownerId,
            lockoutAppliedPTWId = @lockoutAppliedPTWId
WHERE HSE.tblLotoPermit.permitNumber = @permitNumber
