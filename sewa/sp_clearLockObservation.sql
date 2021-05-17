CREATE PROC sp_clearLockObservation
@lockId INT
AS
UPDATE HSE.tblLocks 
    SET observation = NULL
WHERE HSE.tblLocks.lockId = @lockId