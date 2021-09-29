ALTER PROC PIPING.GetAllJoints
AS
SELECT [Id] AS Id
,tblUnits.unit_name AS Unit
,ISOS.[ISO Key],ISOS.rev AS [ISO REV],ISOS.testPack AS [Test Pack]
,MapRevision AS [Map Revision],Subcontractor AS [Subcontractor],Spool AS [Spool],JointNumber AS [Joint Number],JoinName AS [Joint Name]
,JointLocation AS [Location],JointType AS [Type]
,CONVERT(FLOAT,JointSize) AS [Size]
,Schedule_mm AS [Schedule mm]
,JointStatus AS [Status],FitUpDate AS [FitUp Date]
,WeldDate AS [Weld Date],WQT AS [WQT],HN1 AS [HN1],HN2 AS [HN2],WPS AS [WPS],HeatRod AS [Heat Rod],HeatE AS [Heat E]
,Category AS [Category],VisualInsp AS [Visual Inspection]
,CASE WHEN VisualAccept=0 THEN 'NO' ELSE 'YES' END AS [Visual Accepted]
,Temprature AS [Temprature],PostheatingNumberChartNumber AS [Postheating Number Chart Number]
,PostheatingDate AS [Postheating Date]
,PWHT1Number AS [PWHT1 Number],PWHT1Date AS [PWHT1 Date],PWHTChkValue AS [PWHT%]
,CASE WHEN PWHTAccepted=0 THEN 'NO' ELSE 'YES' END AS [PWHT Accepted]
,HTaNumber AS [HTA Number],HTDate AS [HT Date],HTChkValue AS [HT%]
,CASE WHEN HTAccepted=0 THEN 'NO' ELSE 'YES' END AS [HT Accepted]
,RT1UT1Number AS [RT1UT1 Number],RT1UT1Date AS [RT1UT1 Date],RTUTChkValue AS [RTUT%]
,CASE WHEN RTUTAccepted=0 THEN 'NO' ELSE 'YES' END AS [RTUT Accepted]
,RTUTReShoot1Number AS [RTUT ReShoot1 Number],RTUTReShoot1Date AS [RTUT ReShoot1 Date]
,RTUTReShoot2Number AS [RTUT ReShoot2 Number],RTUTReShoot2Date AS [RTUT ReShoot2 Date]
,RTUTRemarks AS [RTUT Remarks]
,PMINumber AS [PMI Number],PMIDate AS [PMI Date],PMIChkValue AS [PMI%]
,CASE WHEN PMIAccepted=0 THEN 'NO' ELSE 'YES' END AS [PMI Accepted]
,MTNumber AS [MT Number],MTDate AS [MT Date],MTPTChkValue AS [MTPT%]
,CASE WHEN MTPTAccepted=0 THEN 'NO' ELSE 'YES' END AS [MTPT Accepted]
,PTTCNumber AS [PTTC Number],PTDate AS [PT Date],PTTCChkValue AS [PTT%]
,CASE WHEN PTTCAccepted=0 THEN 'NO' ELSE 'YES' END AS [PTTC Accepted]
,MTPTRemarks AS [MTPT Remarks]
,CASE WHEN ValidUntil IS NULL THEN 'Active' ELSE 'Deactivated' END AS [Active]
,ValidateError AS [ValidateError]
,[PIPING].[tblWeldingMap].ISOId
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

