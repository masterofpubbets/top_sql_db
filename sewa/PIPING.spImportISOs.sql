CREATE PROC PIPING.spImportISOs
AS
--Deactivate Old Revision
UPDATE v
SET v.validUntil = GETDATE()

FROM (
    SELECT  
    PIPING.tblIsos_temp.isoId
    ,PIPING.tblIsos.validUntil
    FROM PIPING.tblIsos_temp
    INNER JOIN PIPING.tblLineList ON PIPING.tblIsos_temp.PDSLINEID = PIPING.tblLineList.lineKKS2
    INNER JOIN PIPING.tblIsos ON PIPING.tblLineList.lineId = PIPING.tblIsos.lineId
    AND PIPING.tblIsos.iso = PIPING.tblIsos_temp.iso
    WHERE PIPING.tblIsos.rev <> PIPING.tblIsos_temp.rev
) AS v

--Insert Revision Changed

INSERT INTO 
PIPING.tblIsos (
    lineId,iso,systemKKS,bore,
designArea,officialSentDOC,rev,revDate,remarks,[status],mirNumber,testPack
)

SELECT
PIPING.tblLineList.lineId,PIPING.tblIsos_temp.iso,PIPING.tblIsos_temp.systemKKS,PIPING.tblIsos_temp.bore,
PIPING.tblIsos_temp.designArea,PIPING.tblIsos_temp.officialSentDOC,
PIPING.tblIsos_temp.rev,PIPING.tblIsos_temp.revDate,PIPING.tblIsos_temp.remarks,PIPING.tblIsos_temp.[status],
PIPING.tblIsos_temp.mirNumber,PIPING.tblIsos_temp.testPack
FROM PIPING.tblIsos_temp
INNER JOIN PIPING.tblLineList ON PIPING.tblIsos_temp.PDSLINEID = PIPING.tblLineList.lineKKS2
INNER JOIN PIPING.tblIsos ON PIPING.tblLineList.lineId = PIPING.tblIsos.lineId
AND PIPING.tblIsos.iso = PIPING.tblIsos_temp.iso
WHERE PIPING.tblIsos.rev <> PIPING.tblIsos_temp.rev

--Insert New Isos

INSERT INTO 
PIPING.tblIsos (
    lineId,iso,systemKKS,bore,
designArea,officialSentDOC,rev,revDate,remarks,[status],mirNumber,testPack
)

SELECT
PIPING.tblLineList.lineId,PIPING.tblIsos_temp.iso,PIPING.tblIsos_temp.systemKKS,PIPING.tblIsos_temp.bore,
PIPING.tblIsos_temp.designArea,PIPING.tblIsos_temp.officialSentDOC,
PIPING.tblIsos_temp.rev,PIPING.tblIsos_temp.revDate,PIPING.tblIsos_temp.remarks,PIPING.tblIsos_temp.[status],
PIPING.tblIsos_temp.mirNumber,PIPING.tblIsos_temp.testPack
FROM PIPING.tblIsos_temp
INNER JOIN PIPING.tblLineList ON PIPING.tblIsos_temp.PDSLINEID = PIPING.tblLineList.lineKKS2
LEFT JOIN PIPING.tblIsos ON PIPING.tblLineList.lineId = PIPING.tblIsos.lineId
AND PIPING.tblIsos.iso = PIPING.tblIsos_temp.iso
WHERE PIPING.tblIsos.lineId IS NULL