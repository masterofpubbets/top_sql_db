ALTER PROC QC.GetJointsRules
AS
SELECT
QC.tblJointRules.RuleId AS [Id],QC.tblJointRules.RulesName AS [Rule Name]
,Cat.catalogName AS [Catalog],Cat.discipline AS [Discipline]
,CASE WHEN Cat.isDefault = 1 THEN 'Yes' ELSE 'No' END AS [Default]
,ProChek.PropertyName AS [Property]
,CASE WHEN QC.tblJointRules.MaterialClass = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.MaterialClass END AS [Material Class]
,CASE WHEN QC.tblJointRules.ServiceFluid = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.ServiceFluid END AS [Service Fluid]
,CASE WHEN QC.tblJointRules.Temp = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.Temp END AS [Temperature]
,CASE WHEN QC.tblJointRules.[Size] = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.[Size] END AS [Size]
,CASE WHEN QC.tblJointRules.Schedule = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.Schedule END AS [Schedule]
,CASE WHEN QC.tblJointRules.JointType = 'NULL' THEN 'N/A' ELSE QC.tblJointRules.JointType END AS [Joint Type]
,QC.tblJointRules.ChkValue AS [Applied Value]
FROM QC.tblJointRules WITH (NOLOCK)
INNER JOIN QC.tblCheckProprty AS ProChek WITH (NOLOCK) ON QC.tblJointRules.ChkProId = ProChek.ChkId
INNER JOIN QC.tblCatalog AS Cat ON QC.tblJointRules.CatlogId = Cat.catalogId