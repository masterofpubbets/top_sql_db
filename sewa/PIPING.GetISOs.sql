ALTER PROC PIPING.GetISOs
AS
SELECT
ISO.[isoID] AS ID,UNITS.unit_name AS Unit
,REPLACE(LINES.lineKKS,'-','') + iso AS [ISO Key]
,REPLACE(LINES.lineKKS,'-','') AS [Line KKS Native],LINES.lineKKS AS [Line KKS],[iso] AS ISO,[systemKKS] AS [System KKS],[bore] AS Bore
,[designArea] AS [Design Area],[officialSentDOC] AS [Official Sent DOC],[rev] AS Revision
,[revDate] AS [Revision Date],[remarks] AS Remarks,ISO.[status] AS [Status],[mirNumber] AS [MIR Number],[testPack] AS [Test Pack]
,CASE WHEN ISO.validUntil IS NOT NULL THEN 'Deleted' ELSE 'Active' END AS Active
FROM PIPING.tblIsos AS ISO
INNER JOIN PIPING.tblLineList AS LINES ON ISO.lineId = LINES.lineId
INNER JOIN dbo.tblUnits AS UNITS ON LINES.unitId = UNITS.unit_id