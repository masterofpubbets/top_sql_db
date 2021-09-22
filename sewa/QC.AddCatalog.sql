CREATE PROC QC.AddCatalog
@catalogName NVARCHAR(100),
@discipline NVARCHAR(100),
@description NVARCHAR(255)
AS
DECLARE @id INT
SELECT @id = catalogId FROM QC.tblCatalog WHERE discipline = @discipline AND catalogName = @catalogName
IF @id IS NULL
INSERT INTO QC.tblCatalog (discipline,catalogName,catalogDescription)
    VALUES (@discipline,@catalogName,@description)