ALTER PROC sp_assignPunchTopic
@punchNumber NVARCHAR(100),
@topic NVARCHAR(255) = NULL
AS
DECLARE @topicId INT
IF @topic IS NULL
    BEGIN
        UPDATE tblPunchList SET topicId = NULL WHERE punchNo = @punchNumber
    END
ELSE
    BEGIN
        SELECT @topicId = topicId FROM tblTopic WHERE topicName = @topic
        UPDATE tblPunchList SET topicId = @topicId WHERE punchNo = @punchNumber
    END

