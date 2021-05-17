CREATE PROC sp_delLock
@lockId INT
AS
DELETE FROM HSE.tblLocks WHERE HSE.tblLocks.lockId = @lockId