CREATE PROC sp_updateUnLock
@lockId INT,
@unloackDate DATE,
@unlockBy INT

AS
UPDATE HSE.tblLocks 
    SET unlockDate = @unloackDate,
        unlockBy = @unlockBy
WHERE HSE.tblLocks.lockId = @lockId