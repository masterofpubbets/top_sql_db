CREATE PROC sp_getHSEMember
AS
SELECT
tblHSEMember.memId AS ID,tblHSEMember.memberName AS [Name],dbo.tblSubcontractor.subconName AS Company
FROM HSE.tblHSEMember
INNER JOIN dbo.tblSubcontractor ON HSE.tblHSEMember.subconID = dbo.tblSubcontractor.subconId