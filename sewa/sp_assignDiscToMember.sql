CREATE PROC sp_assignDiscToMember
@discipline NVARCHAR(50)
,@fullName NVARCHAR(255)

AS
DECLARE @discID INT
DECLARE @memID INT
SELECT @discID = tblPunchDiscipline.punchDiscId FROM tblPunchDiscipline WHERE punchDiscipline = @discipline
SELECT @memID = memberId FROM tblMembers WHERE fullName = @fullName
IF ((@discID IS NOT NULL) AND (@memID IS NOT NULL))
    BEGIN
        INSERT INTO tblMemberDiscipline (memberId,punchDiscId) VALUES (@memID,@discID)
    END
