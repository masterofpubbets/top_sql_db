ALTER PROC sp_getMember
AS
SELECT
memberId AS [ID]
,tblMembers.fullName AS [Full Name],tblMembers.mail AS Mail,tblMembers.memCode AS [Code],tblMembers.phoneNumber AS [Phone],
tblMembers.title AS Title
FROM tblMembers
ORDER BY tblMembers.fullName