ALTER PROC QC.GetCatalog
AS
SELECT
Catalogs.catalogId AS [ID],Catalogs.discipline AS Discipline,Catalogs.catalogName AS [Catalog],Catalogs.catalogDescription AS [Description]
,CASE WHEN Catalogs.isDefault = 1 THEN 'Yes' ELSE 'No' END AS [Is Default]
FROM QC.tblCatalog AS Catalogs WITH (NOLOCK)
