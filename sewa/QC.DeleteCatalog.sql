CREATE PROC QC.DeleteCatalog
@id INT
AS
DELETE FROM QC.tblCatalog WHERE catalogId = @id