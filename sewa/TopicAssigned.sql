CREATE FUNCTION dbo.TopicAssigned (
@topic NVARCHAR(255)
)
RETURNS INT
AS
BEGIN
    DECLARE @id INT
    SELECT @id = topicId FROM tblTopic WHERE topicName = @topic
    RETURN (SELECT COUNT(punchId)  FROM tblPunchList WHERE topicId = @id)
END