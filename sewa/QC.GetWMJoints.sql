CREATE PROC QC.GetWMJoints
AS
SELECT
TOP 1 PERCENT 
ISO.isoID AS [ISO ID]
,LineList.lineKKS + ISO.iso + WM.Spool + WM.JointNumber + (CASE WHEN WM.JoinName IS NULL THEN '' ELSE WM.JoinName END) AS [Joint Key]
,LineList.materialClass AS [Material Class],LineList.fluidService AS [Service Fluid]
,CONVERT(FLOAT,LineList.designTemperature) AS Temperature
,CONVERT(FLOAT,WM.JointSize) AS Size,WM.Schedule_mm AS [Schedule mm]
,WM.PWHTChkValue,WM.HTChkValue,WM.RTUTChkValue,WM.PMIChkValue,WM.MTPTChkValue,WM.PTTCChkValue
FROM PIPING.tblWeldingMap AS WM WITH (NOLOCK)
INNER JOIN PIPING.tblIsos AS ISO WITH (NOLOCK) ON WM.ISOId = ISO.isoID
INNER JOIN PIPING.tblLineList AS LineList WITH (NOLOCK) ON ISO.lineId = LineList.lineId