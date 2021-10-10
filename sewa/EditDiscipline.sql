CREATE PROC EditDiscipline
@discId INT,
@disc NVARCHAR(100),
@Description NVARCHAR(255)
AS
UPDATE tblPunchDiscipline
    SET punchDiscipline = @disc,
        punchDisciplineDesc = @Description
WHERE punchDiscId = @discId