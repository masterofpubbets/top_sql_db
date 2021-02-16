ALTER PROC sp_getSystems
AS
SELECT
sysId,[systemName] AS [System Name], [systemKKS] AS KKS, [systemDescription] AS [Description]
FROM tblSystems