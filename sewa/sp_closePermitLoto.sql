CREATE PROC sp_closePermitLoto
@lotoId INT
AS
UPDATE HSE.tblLotoPermitRequired SET HSE.tblLotoPermitRequired.removalDate = GETDATE() 
WHERE HSE.tblLotoPermitRequired.lotoId = @lotoId AND HSE.tblLotoPermitRequired.removalDate IS NULL