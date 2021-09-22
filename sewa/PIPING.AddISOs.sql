ALTER PROC PIPING.AddISOs
AS
--UPDATE CURRENT ISOs
UPDATE v
SET v.iso = v.[Current ISO],
    v.systemKKS = v.[Current SYSTEM KKS],
    v.bore = v.[Current BORE],
    v.designArea = v.[Current DESIGN AREA],
    v.officialSentDOC = v.[Current OFFICIAL SEND DOC],
    v.rev = v.[Current REV],
    v.revDate = v.[Current REV DATE],
    v.remarks = v.[Current REMARKS],
    v.status = v.[Current STATUS],
    v.mirNumber = v.[Current MIR NUMBER],
    v.testPack = v.[Current TEST PACK],
    v.validUntil = NULL
FROM (
    SELECT 
    ISO.[iso],ISO.[systemKKS],ISO.[bore],ISO.[designArea],ISO.[officialSentDOC],ISO.[rev]
    ,ISO.[revDate],ISO.[remarks],ISO.[status],ISO.[mirNumber],ISO.[testPack],ISO.[validUntil]
    ,isFixed
    ,ISO.isoID

    ,TEMP.[iso] AS [Current ISO],TEMP.[systemKKS] AS [Current SYSTEM KKS],TEMP.[bore] AS [Current BORE]
    ,TEMP.[designArea] AS [Current DESIGN AREA],TEMP.[officialSentDOC] AS [Current OFFICIAL SEND DOC]
    ,TEMP.[rev] AS [Current REV],TEMP.[revDate] AS [Current REV DATE],TEMP.[remarks] AS [Current REMARKS]
    ,TEMP.[status] AS [Current STATUS],TEMP.[mirNumber] AS [Current MIR NUMBER],TEMP.[testPack] AS [Current TEST PACK]

    FROM PIPING.tblIsos_temp AS TEMP 
    INNER JOIN PIPING.tblLineList AS LINES ON REPLACE(TEMP.PDSLINEID,' ','') = REPLACE(LINES.lineKKS,' ','')
    INNER JOIN PIPING.tblIsos AS ISO ON ISO.lineId = LINES.lineId
    WHERE TEMP.isFixed IS NULL
) AS v
-----------------------

--UPDATE ISFIXED
UPDATE v
SET v.isFixed = 'YES'
FROM (
    SELECT 
    ISO.[iso],ISO.[systemKKS],ISO.[bore],ISO.[designArea],ISO.[officialSentDOC],ISO.[rev]
    ,ISO.[revDate],ISO.[remarks],ISO.[status],ISO.[mirNumber],ISO.[testPack],ISO.[validUntil]
    ,isFixed
    ,ISO.isoID

    ,TEMP.[iso] AS [Current ISO],TEMP.[systemKKS] AS [Current SYSTEM KKS],TEMP.[bore] AS [Current BORE]
    ,TEMP.[designArea] AS [Current DESIGN AREA],TEMP.[officialSentDOC] AS [Current OFFICIAL SEND DOC]
    ,TEMP.[rev] AS [Current REV],TEMP.[revDate] AS [Current REV DATE],TEMP.[remarks] AS [Current REMARKS]
    ,TEMP.[status] AS [Current STATUS],TEMP.[mirNumber] AS [Current MIR NUMBER],TEMP.[testPack] AS [Current TEST PACK]

    FROM PIPING.tblIsos_temp AS TEMP 
    INNER JOIN PIPING.tblLineList AS LINES ON REPLACE(TEMP.PDSLINEID,' ','') = REPLACE(LINES.lineKKS,' ','')
    INNER JOIN PIPING.tblIsos AS ISO ON ISO.lineId = LINES.lineId
    WHERE TEMP.isFixed IS NULL
) AS v
-----------------------

--INSERT NEW ISOs
INSERT INTO PIPING.tblIsos (
    [lineId],[iso],[systemKKS],[bore],[designArea],[officialSentDOC],[rev]
    ,[revDate],[remarks],[status],[mirNumber],[testPack]
)

SELECT *
FROM (
    SELECT 
    LINES.lineId,TEMP.[iso],TEMP.[systemKKS],TEMP.[bore],TEMP.[designArea],TEMP.[officialSentDOC]
    ,TEMP.[rev],TEMP.[revDate],TEMP.[remarks],TEMP.[status],TEMP.[mirNumber],TEMP.[testPack]

    FROM PIPING.tblIsos_temp AS TEMP 
    INNER JOIN PIPING.tblLineList AS LINES ON REPLACE(TEMP.PDSLINEID,' ','') = REPLACE(LINES.lineKKS,' ','')
    WHERE TEMP.isFixed IS NULL
) AS v
-----------------------

UPDATE PIPING.tblIsos_temp SET rev = '0' + rev WHERE LEN(rev) = 1