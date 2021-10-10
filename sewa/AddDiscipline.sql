CREATE PROC AddDiscipline
@disc NVARCHAR(100),
@Desc NVARCHAR(255)
AS
INSERT INTO tblPunchDiscipline (punchDiscipline,punchDisciplineDesc) VALUES (@disc,@Desc)