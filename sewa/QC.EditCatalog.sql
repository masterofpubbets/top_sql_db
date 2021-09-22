ALTER PROC QC.EditCatalog
@Id INT,
@Name NVARCHAR(100),
@Discipline NVARCHAR(50),
@Description NVARCHAR(255) = NULL,
@Default BIT
AS
UPDATE QC.tblCatalog
    SET discipline = @Discipline,
        catalogName = @Name,
        catalogDescription = @Description
WHERE catalogId = @Id
EXEC QC.SetCatalogDefault @Id,@Default