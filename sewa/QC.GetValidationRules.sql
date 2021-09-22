CREATE PROC QC.GetValidationRules
AS
SELECT
Catalogs.discipline AS Discipline,Catalogs.catalogName AS [Catalog]
,Rules.ruleId AS [Rule Id],Rules.ruleName AS [Rule],Rules.rulePriority AS [Priority]
,CASE WHEN Rules.stopAfter = 0 THEN 'No' 
WHEN Rules.stopAfter = 1 THEN 'Yes'
ELSE NULL END AS [Stop Process If Applied]
,Conditions.condId AS [Condition Id],Conditions.objectName AS [Check Object],Conditions.applyOn AS [Apply On]
,Conditions.condition AS [Condition],Conditions.condSequence AS [Sequence]
FROM QC.tblCatalog AS Catalogs WITH (NOLOCK)
LEFT JOIN QC.tblRule AS Rules WITH (NOLOCK) ON Catalogs.catalogId = Rules.catalogId
LEFT JOIN QC.tblCondition AS Conditions WITH (NOLOCK) ON Rules.ruleId = Conditions.ruleId
ORDER BY Catalogs.discipline,Rules.rulePriority,Conditions.condSequence