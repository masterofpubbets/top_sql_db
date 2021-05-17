ALTER PROC sp_addLotoPermitRequired
@permitNumber INT,
@equipmentKKS NVARCHAR(100),
@requiredPosition NVARCHAR(50),
@padlockNo NVARCHAR(50),
@lotoBy NVARCHAR(100)
AS
DECLARE @lotobyId INT
DECLARE @permitId INT
SELECT @permitId = HSE.tblLotoPermit.lotoPermitId FROM HSE.tblLotoPermit WHERE HSE.tblLotoPermit.permitNumber = @permitNumber
SELECT @lotobyId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @lotoBy

INSERT INTO HSE.tblLotoPermitRequired (permitId,lotoById,equipmentKKS,requiredPosition,padlockNo)
VALUES (@permitId,@lotobyId,@equipmentKKS,@requiredPosition,@padlockNo)