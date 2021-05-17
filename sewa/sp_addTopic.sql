CREATE PROC sp_addTopic
@topic NVARCHAR(255)
AS
INSERT INTO tblTopic (topicName) VALUES (@topic)