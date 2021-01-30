CREATE PROC sp_getLog
AS
SELECT 
logDescription AS [Description],userName AS [User Name] 
,FORMAT(logDate,'dd/MM/yyyy') AS [Date]
FROM tblLog