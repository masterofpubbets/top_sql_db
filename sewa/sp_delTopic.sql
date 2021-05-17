CREATE PROC sp_delTopic
@topic NVARCHAR(255)
AS
DECLARE @id INT
DECLARE @punchId INT
SELECT @id = topicId FROM tblTopic WHERE topicName = @topic
SELECT @punchId = punchId FROM tblPunchList WHERE topicId = @id
IF @punchId IS NULL
    BEGIN
        DELETE FROM tblTopic WHERE topicId = @id
    END
