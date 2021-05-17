CREATE PROC sp_addPermitCloseOut
@permitNumber INT
AS
UPDATE HSE.tblLotoPermit SET closeoutDate = GETDATE() WHERE permitNumber = @permitNumber AND closeoutDate IS NULL