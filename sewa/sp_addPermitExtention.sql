CREATE PROC sp_addPermitExtention
@permitId INT,
@extendedDays INT

AS
UPDATE HSE.tblLotoPermit SET
        isExtended = 1,
        extendedDate = GETDATE(),
        extendedDays = @extendedDays
WHERE lotoPermitId = @permitId AND isExtended = 0