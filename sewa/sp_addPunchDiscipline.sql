ALTER PROC sp_addPunchDiscipline
@punchDiscipline NVARCHAR(50)
,@punchDisciplineDesc NVARCHAR(255)
AS
INSERT INTO tblPunchDiscipline (punchDiscipline,punchDisciplineDesc) VALUES (@punchDiscipline,@punchDisciplineDesc)