CREATE PROC sp_clearUnLock
@lockId INT

AS
UPDATE HSE.tblLocks 
    SET unlockDate = NULL,
        unlockBy = NULL
WHERE HSE.tblLocks.lockId = @lockId