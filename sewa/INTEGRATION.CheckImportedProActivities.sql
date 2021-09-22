CREATE PROC INTEGRATION.CheckImportedProActivities
AS
SELECT 
'Unknown System Owner' AS Error
,[data1] AS [Full Name]
FROM [INTEGRATION].[tempData] AS tempData
LEFT JOIN dbo.tblMembers AS Members ON tempData.data1 = Members.fullName
WHERE Members.fullName IS NULL
UNION ALL
SELECT 
'Unknown Subcontractor' AS Error
,[data2] AS [Full Name]
FROM [INTEGRATION].[tempData] AS tempData
LEFT JOIN dbo.tblSubcontractor AS Subcontractor ON tempData.data2 = Subcontractor.subconName
WHERE Subcontractor.subconName IS NULL