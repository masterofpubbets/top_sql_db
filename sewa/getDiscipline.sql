CREATE PROC getDiscipline
AS
SELECT 
punchDiscId AS ID,punchDiscipline AS [Discipline],punchDisciplineDesc AS [Description]
FROM tblPunchDiscipline