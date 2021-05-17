CREATE PROC sp_addLockObservation
@lockId INT,
@observation NVARCHAR(255)
AS
UPDATE HSE.tblLocks 
    SET observation = @observation
WHERE HSE.tblLocks.lockId = @lockId