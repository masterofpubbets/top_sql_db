CREATE PROC sp_deletePermit
@permitId INT

AS
DELETE FROM HSE.tblLotoPermit
WHERE lotoPermitId = @permitId