ALTER PROC PIPING.sp_ValidateNewIsos
AS
-- Unknown Line
SELECT  
'Unknown Line' AS [Staging Status],
PIPING.tblIsos_temp.PDSLINEID AS [Line KKS],PIPING.tblIsos_temp.iso AS ISO,PIPING.tblIsos_temp.systemKKS AS [System KKS],PIPING.tblIsos_temp.bore AS Bore,
PIPING.tblIsos_temp.designArea AS [Design Area],PIPING.tblIsos_temp.officialSentDOC AS [Official Sent Doc],
PIPING.tblIsos_temp.rev AS Revision,PIPING.tblIsos_temp.revDate AS [Revision Date],PIPING.tblIsos_temp.remarks AS Remarks,PIPING.tblIsos_temp.[status] AS [Status],
PIPING.tblIsos_temp.mirNumber AS [Mir Number],PIPING.tblIsos_temp.testPack AS [Test Pack]
FROM PIPING.tblIsos_temp
LEFT JOIN PIPING.tblLineList ON REPLACE(PIPING.tblIsos_temp.PDSLINEID,'-','') = REPLACE(PIPING.tblLineList.lineKKS2,'-','')
WHERE PIPING.tblLineList.lineKKS2 IS NULL

UNION ALL

-- Revision Changed
SELECT  
'Revision Changed' AS [Staging Status],
PIPING.tblIsos_temp.PDSLINEID AS [Line KKS],PIPING.tblIsos_temp.iso AS ISO,PIPING.tblIsos_temp.systemKKS AS [System KKS],PIPING.tblIsos_temp.bore AS Bore,
PIPING.tblIsos_temp.designArea AS [Design Area],PIPING.tblIsos_temp.officialSentDOC AS [Official Sent Doc],
PIPING.tblIsos_temp.rev AS Revision,PIPING.tblIsos_temp.revDate AS [Revision Date],PIPING.tblIsos_temp.remarks AS Remarks,PIPING.tblIsos_temp.[status] AS [Status],
PIPING.tblIsos_temp.mirNumber AS [Mir Number],PIPING.tblIsos_temp.testPack AS [Test Pack]
FROM PIPING.tblIsos_temp
INNER JOIN PIPING.tblLineList ON REPLACE(PIPING.tblIsos_temp.PDSLINEID,'-','') = REPLACE(PIPING.tblLineList.lineKKS2,'-','')
INNER JOIN PIPING.tblIsos ON PIPING.tblLineList.lineId = PIPING.tblIsos.lineId
AND PIPING.tblIsos.iso = PIPING.tblIsos_temp.iso
WHERE PIPING.tblIsos.rev <> PIPING.tblIsos_temp.rev

UNION ALL

-- New Iso
SELECT  
'New Iso' AS [Staging Status],
PIPING.tblIsos_temp.PDSLINEID AS [Line KKS],PIPING.tblIsos_temp.iso AS ISO,PIPING.tblIsos_temp.systemKKS AS [System KKS],PIPING.tblIsos_temp.bore AS Bore,
PIPING.tblIsos_temp.designArea AS [Design Area],PIPING.tblIsos_temp.officialSentDOC AS [Official Sent Doc],
PIPING.tblIsos_temp.rev AS Revision,PIPING.tblIsos_temp.revDate AS [Revision Date],PIPING.tblIsos_temp.remarks AS Remarks,PIPING.tblIsos_temp.[status] AS [Status],
PIPING.tblIsos_temp.mirNumber AS [Mir Number],PIPING.tblIsos_temp.testPack AS [Test Pack]
FROM PIPING.tblIsos_temp
INNER JOIN PIPING.tblLineList ON REPLACE(PIPING.tblIsos_temp.PDSLINEID,'-','') = REPLACE(PIPING.tblLineList.lineKKS2,'-','')
LEFT JOIN PIPING.tblIsos ON PIPING.tblLineList.lineId = PIPING.tblIsos.lineId
AND PIPING.tblIsos.iso = PIPING.tblIsos_temp.iso
WHERE PIPING.tblIsos.lineId IS NULL

