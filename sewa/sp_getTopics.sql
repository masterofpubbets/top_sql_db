CREATE PROC sp_getTopics
AS
SELECT topicId As ID,topicName AS Topic
FROM tblTopic