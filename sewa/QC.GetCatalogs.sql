CREATE PROC QC.GetCatalogs
AS
SELECT 
Catalogs.catalogId AS Id
,Catalogs.catalogName AS [Name]
,Catalogs.discipline AS Discipline
,Catalogs.catalogDescription AS [Description]
,CASE WHEN Catalogs.isDefault = 1 THEN 'Yes' ELSE 'No' END AS [Default]
,COUNT(Rules.RulesName) AS [Count of Rules]
FROM QC.tblCatalog AS Catalogs WITH (NOLOCK)
LEFT JOIN QC.tblJointRules AS Rules WITH (NOLOCK) ON Catalogs.catalogId = Rules.CatlogId
GROUP BY 
Catalogs.catalogId
,Catalogs.catalogName
,Catalogs.discipline
,Catalogs.catalogDescription
,Catalogs.isDefault