CREATE PROC deattachMemberDiscipline
@memberId INT,
@disc NVARCHAR(100)
AS
DECLARE @DiscId INT
SELECT @DiscId = punchDiscId FROM tblPunchDiscipline WHERE punchDiscipline = @disc
DELETE FROM tblMemberDiscipline WHERE memberId = @memberId AND punchDiscId = @DiscId