ALTER TRIGGER PIPING.tg_LineListKKS_Insert ON PIPING.tblLineList
AFTER INSERT, UPDATE
AS

UPDATE v
SET v.lineKKS = plant + '-' + unit + '-' + [system] + '-' + subsystem + '-' + equipmentCode + '-' + branchNumber
FROM (
SELECT inserted.lineId
,PIPING.tblLineList.lineKKS,PIPING.tblLineList.plant,PIPING.tblLineList.unit,PIPING.tblLineList.[system]
,PIPING.tblLineList.subsystem,PIPING.tblLineList.equipmentCode,PIPING.tblLineList.branchNumber
FROM inserted
INNER JOIN PIPING.tblLineList ON inserted.lineId = PIPING.tblLineList.lineId
) AS v