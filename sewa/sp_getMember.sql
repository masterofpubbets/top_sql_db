CREATE PROC sp_getMember
AS
SELECT
tblMembers.fullName AS [Full Name],tblMembers.mail AS Mail
FROM tblMembers
ORDER BY tblMembers.fullName