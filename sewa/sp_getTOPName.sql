CREATE PROC sp_getTOPName
AS
SELECT
top_name AS [TOP],subsystem_description AS [Description],cod AS [COD]
FROM tblTOP