ALTER PROC sp_getSystems
AS
SELECT
sysId,[systemName] AS [System Name], [systemKKS] AS KKS,[systemKKS2] AS KKS2
, [systemDescription] AS [Description]
FROM tblSystems