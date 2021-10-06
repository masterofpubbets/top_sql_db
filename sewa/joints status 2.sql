WITH JOINTSSUMMARY AS (

    SELECT tblUnits.unit_name AS Unit

    ,Id
    ,WeldDate AS [Joints Welded]

    ,CASE WHEN VisualAccept IS NULL THEN 0 ELSE VisualAccept END AS VisualAccept

    ,PWHTChkValue
    ,CASE WHEN PWHTChkValue IS NULL THEN 0 ELSE PWHTChkValue END AS [PWHT%],CASE WHEN PWHTAccepted IS NULL THEN 0 ELSE PWHTAccepted END AS PWHTAccepted

    ,HTChkValue
    ,CASE WHEN HTChkValue IS NULL THEN 0 ELSE HTChkValue END AS [HT%],CASE WHEN HTAccepted IS NULL THEN 0 ELSE HTAccepted END AS HTAccepted

    ,RTUTChkValue
    ,CASE WHEN RTUTChkValue IS NULL THEN 0 ELSE RTUTChkValue END AS [RTUT%],CASE WHEN RTUTAccepted IS NULL THEN 0 ELSE RTUTAccepted END AS RTUTAccepted
    
    ,PMIChkValue
    ,CASE WHEN PMIChkValue IS NULL THEN 0 ELSE PMIChkValue END AS [PMI%],CASE WHEN PMIAccepted IS NULL THEN 0 ELSE PMIAccepted END AS PMIAccepted
    
    ,MTPTChkValue
    ,CASE WHEN MTPTChkValue IS NULL THEN 0 ELSE MTPTChkValue END AS [MTPT%],CASE WHEN MTPTAccepted IS NULL THEN 0 ELSE MTPTAccepted END AS MTPTAccepted
    
    ,PTTCChkValue
    ,CASE WHEN PTTCChkValue IS NULL THEN 0 ELSE PTTCChkValue END AS [PTT%],CASE WHEN PTTCAccepted IS NULL THEN 0 ELSE PTTCAccepted END AS PTTCAccepted

    ,((CASE WHEN PWHTChkValue IS NULL THEN 0 ELSE PWHTChkValue END) + (CASE WHEN HTChkValue IS NULL THEN 0 ELSE HTChkValue END)
        + (CASE WHEN RTUTChkValue IS NULL THEN 0 ELSE RTUTChkValue END) + (CASE WHEN PMIChkValue IS NULL THEN 0 ELSE PMIChkValue END)
        + (CASE WHEN MTPTChkValue IS NULL THEN 0 ELSE MTPTChkValue END) + (CASE WHEN PTTCChkValue IS NULL THEN 0 ELSE PTTCChkValue END)+ 100) / 100 AS [QC Scope]

    ,(CASE WHEN PWHTChkValue = 100 AND PWHTAccepted = 1 THEN 1 ELSE 0 END) + (CASE WHEN HTChkValue = 100 AND HTAccepted = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN RTUTChkValue = 100 AND RTUTAccepted = 1 THEN 1 ELSE 0 END) + (CASE WHEN PMIChkValue = 100 AND PMIAccepted = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN MTPTChkValue = 100 AND MTPTAccepted = 1 THEN 1 ELSE 0 END) + (CASE WHEN PTTCChkValue = 100 AND PTTCAccepted = 1 THEN 1 ELSE 0 END)
    + (CASE WHEN VisualAccept IS NULL THEN 0 ELSE VisualAccept END) AS [QC Done]

    FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
    INNER JOIN (
        SELECT PIPING.tblIsos.isoID,LINES.lineKKS + '-' + PIPING.tblIsos.iso AS [ISO Key],PIPING.tblIsos.rev,PIPING.tblIsos.testPack,LINES.unitId
        FROM PIPING.tblIsos WITH (NOLOCK)
        INNER JOIN (
            SELECT PIPING.tblLineList.lineId,PIPING.tblLineList.lineKKS,unitId
            FROM PIPING.tblLineList WITH (NOLOCK)
        ) AS LINES
        ON PIPING.tblIsos.lineId = LINES.lineId
    ) AS ISOS
    ON [PIPING].[tblWeldingMap].ISOId = ISOS.isoID
    INNER JOIN tblUnits ON ISOS.unitId = tblUnits.unit_id

    WHERE [PIPING].[tblWeldingMap].[JointStatus] = 'ACTIVE'
    AND [PIPING].[tblWeldingMap].JointLocation = 'FW'
    AND [PIPING].[tblWeldingMap].JointType NOT IN ('TH','VT','LAM','FJ')
    AND ValidUntil IS NULL

)

SELECT 
Unit
,COUNT(Id) AS [Total Joints]
,COUNT([Joints Welded]) AS [Joints Welded]
,COUNT(Id) - COUNT([Joints Welded]) AS [Pending To Weld]
 ,SUM(CASE WHEN (([QC Scope] = [QC Done]) AND ([Joints Welded] IS NOT NULL)) THEN 1 ELSE 0 END) AS [QC Done]
 ,SUM(CASE WHEN ([QC Scope] > [QC Done]) AND ([Joints Welded] IS NOT NULL) THEN 1 ELSE 0 END) AS [QC Backlog]

 ,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND VisualAccept = 1 THEN 1 ELSE 0 END) AS VT
,SUM([VisualAccept]) AS [VisualAccept]


,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND PWHTChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (PWHTAccepted = 1) AND (PWHTChkValue = 100)) THEN 1 ELSE 0 END) AS PWHT
,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND HTChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (HTAccepted = 1) AND (HTChkValue = 100)) THEN 1 ELSE 0 END) AS HT
,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND RTUTChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (RTUTAccepted = 1) AND (RTUTChkValue = 100)) THEN 1 ELSE 0 END) AS RTUT
,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND PMIChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (PMIAccepted = 1) AND (PMIChkValue = 100)) THEN 1 ELSE 0 END) AS PMI
,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND MTPTChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (MTPTAccepted = 1) AND (MTPTChkValue = 100)) THEN 1 ELSE 0 END) AS MTPT
,SUM(CASE WHEN [Joints Welded] IS NOT NULL AND PTTCChkValue = 100 THEN 1 ELSE 0 END) - SUM(CASE WHEN (([Joints Welded] IS NOT NULL) AND (PTTCAccepted = 1) AND (PTTCChkValue = 100)) THEN 1 ELSE 0 END) AS PTTC
FROM JOINTSSUMMARY
GROUP BY Unit