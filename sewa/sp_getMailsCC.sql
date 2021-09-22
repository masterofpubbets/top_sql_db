CREATE PROC sp_getMailsCC
AS
SELECT
mailSetId AS Id,mailCategory AS [Category],cc AS CC
FROM tblMailSettings