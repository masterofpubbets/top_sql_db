CREATE PROC sp_addLotoRemovalOwner
@permitNumber INT,
@systemOwner NVARCHAR(250)
AS
DECLARE @systemOwnerId INT

SELECT @systemOwnerId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @systemOwner

UPDATE HSE.tblLotoPermit
        SET lotoRemoveOwnerId = @systemOwnerId
WHERE HSE.tblLotoPermit.permitNumber = @permitNumber