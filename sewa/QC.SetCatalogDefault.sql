CREATE PROC QC.SetCatalogDefault
@CatalogId INT,
@Default BIT
AS

IF @Default = 1
UPDATE QC.tblCatalog SET isDefault = 0

UPDATE QC.tblCatalog SET isDefault = @Default WHERE catalogId = @CatalogId