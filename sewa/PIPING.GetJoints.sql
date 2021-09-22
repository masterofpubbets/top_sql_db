CREATE PROC PIPING.GetJoints
@isoId INT
AS
SELECT [Id] AS Id
,MapRevision AS [Map Revision],Subcontractor AS [Subcontractor],Spool AS [Spool],JointNumber AS [Number],JoinName AS [Join Name]
,JointLocation AS [Location],JointType AS [Type],JointSize AS [Size],JointStatus AS [Status],FitUpDate AS [FitUp Date]
,WeldDate AS [Weld Date],WQT AS [WQT],HN1 AS [HN1],HN2 AS [HN2],WPS AS [WPS],HeatRod AS [Heat Rod],HeatE AS [Heat E]
,Category AS [Category],VisualInsp AS [Visual Inspection],Temprature AS [Temprature],PostheatingNumberChartNumber AS [Postheating Number Chart Number]
,PostheatingDate AS [Postheating Date],PWHT1Number AS [PWHT1 Number],PWHT1Date AS [PWHT1 Date],HTaNumber AS [HTA Number]
,HTDate AS [HT Date],RT1UT1Number AS [RT1UT1 Number],RT1UT1Date AS [RT1UT1 Date],RTUTReShoot1Number AS [RTUT ReShoot1 Number]
,RTUTReShoot1Date AS [RTUT ReShoot1 Date],RTUTReShoot2Number AS [RTUT ReShoot2 Number],RTUTReShoot2Date AS [RTUT ReShoot2 Date]
,RTUTRemarks AS [RTUT Remarks],PMINumber AS [PMI Number],PMIDate AS [PMI Date],MTNumber AS [MT Number],MTDate AS [MT Date]
,PTTCNumber AS [PTTC Number],PTDate AS [PT Date],MTPTRemarks AS [MTPT Remarks]
,CASE WHEN ValidUntil IS NULL THEN 'Active' ELSE 'Deactivated' END AS [ValidUntil]
,ValidateError AS [ValidateError]
FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
WHERE [ISOId] = @isoId