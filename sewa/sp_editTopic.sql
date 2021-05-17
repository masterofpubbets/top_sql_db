CREATE PROC sp_editTopic
@topicId INT,
@topic NVARCHAR(255)
AS
UPDATE tblTopic SET topicName = @topic WHERE topicId = @topicId