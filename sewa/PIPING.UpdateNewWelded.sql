ALTER PROC PIPING.UpdateNewWelded
@dateType INT
AS
UPDATE v
SET
v.ISOId = v.StagingISOId
,v.MapRevision = v.StagingMapRevision
,v.Subcontractor = v.StagingSubcontractor
,v.Spool = v.StagingSpool
,v.JointNumber = v.StagingJointNumber
,v.JoinName = v.StagingJoinName
,v.JointLocation = v.StagingJointLocation
,v.JointType = v.StagingJointType
,v.JointSize = v.StagingJointSize
,v.JointStatus = v.StagingJointStatus
,v.WeldDate = v.StagingWeldDate
,v.WQT = v.StagingWQT
,v.HN1 = v.StagingHN1
,v.HN2 = v.StagingHN2
,v.WPS = v.StagingWPS
,v.HeatRod = v.StagingHeatRod
,v.HeatE = v.StagingHeatE
,v.Category = v.StagingCategory
,v.VisualInsp = v.StagingVisualInsp
,v.Temprature = v.StagingTemprature
,v.PostheatingNumberChartNumber = v.StagingPostheatingNumberChartNumber
,v.PostheatingDate = v.StagingPostheatingDate
,v.PWHT1Number = v.StagingPWHT1Number
,v.PWHT1Date = v.StagingPWHT1Date
,v.HTaNumber = v.StagingHTaNumber
,v.HTDate = v.StagingHTDate
,v.RT1UT1Number = v.StagingRT1UT1Number
,v.RT1UT1Date = v.StagingRT1UT1Date
,v.RTUTReShoot1Number = v.StagingRTUTReShoot1Number
,v.RTUTReShoot1Date = v.StagingRTUTReShoot1Date
,v.RTUTReShoot2Number = v.StagingRTUTReShoot2Number
,v.RTUTReShoot2Date = v.StagingRTUTReShoot2Date
,v.RTUTRemarks = v.StagingRTUTRemarks
,v.PMINumber = v.StagingPMINumber
,v.PMIDate = v.StagingPMIDate
,v.MTNumber = v.StagingMTNumber
,v.MTDate = v.StagingMTDate
,v.PTTCNumber = v.StagingPTTCNumber
,v.PTDate = v.StagingPTDate
,v.MTPTRemarks = v.StagingMTPTRemarks

FROM (
    SELECT
    StagingJoints.[ISOId] AS StagingISOId,StagingJoints.[MapRevision] AS StagingMapRevision,StagingJoints.[Subcontractor] AS StagingSubcontractor
    ,StagingJoints.[Spool] AS StagingSpool,StagingJoints.[JointNumber] AS StagingJointNumber,StagingJoints.[JoinName] AS StagingJoinName
    ,StagingJoints.[JointLocation] AS StagingJointLocation,StagingJoints.[JointType] AS StagingJointType,StagingJoints.[JointSize] AS StagingJointSize
    ,StagingJoints.[JointStatus] AS StagingJointStatus,StagingJoints.[FitUpDate] AS StagingFitUpDate,StagingJoints.[WeldDate] AS StagingWeldDate
    ,StagingJoints.[WQT] AS StagingWQT,StagingJoints.[HN1] AS StagingHN1,StagingJoints.[HN2] AS StagingHN2,StagingJoints.[WPS] AS StagingWPS
    ,StagingJoints.[HeatRod] AS StagingHeatRod,StagingJoints.[HeatE] AS StagingHeatE,StagingJoints.[Category] AS StagingCategory
    ,StagingJoints.[VisualInsp] AS StagingVisualInsp,StagingJoints.[Temprature] AS StagingTemprature,StagingJoints.[PostheatingNumberChartNumber] AS StagingPostheatingNumberChartNumber
    ,StagingJoints.[PostheatingDate] AS StagingPostheatingDate,StagingJoints.[PWHT1Number] AS StagingPWHT1Number
    ,StagingJoints.[PWHT1Date] AS StagingPWHT1Date,StagingJoints.[HTaNumber] AS StagingHTaNumber
    ,StagingJoints.[HTDate] AS StagingHTDate,StagingJoints.[RT1UT1Number] AS StagingRT1UT1Number
    ,StagingJoints.[RT1UT1Date] AS StagingRT1UT1Date,StagingJoints.[RTUTReShoot1Number] AS StagingRTUTReShoot1Number
    ,StagingJoints.[RTUTReShoot1Date] AS StagingRTUTReShoot1Date,StagingJoints.[RTUTReShoot2Number] AS StagingRTUTReShoot2Number
    ,StagingJoints.[RTUTReShoot2Date] AS StagingRTUTReShoot2Date,StagingJoints.[RTUTRemarks] AS StagingRTUTRemarks
    ,StagingJoints.[PMINumber] AS StagingPMINumber,StagingJoints.[PMIDate] AS StagingPMIDate
    ,StagingJoints.[MTNumber] AS StagingMTNumber,StagingJoints.[MTDate] AS StagingMTDate
    ,StagingJoints.[PTTCNumber] AS StagingPTTCNumber,StagingJoints.[PTDate] AS StagingPTDate,StagingJoints.[MTPTRemarks] AS StagingMTPTRemarks
    ,CurrentJoints.*

    FROM (
        SELECT
            ISOs.ISOId,Staging.*
            FROM (
                SELECT
                [Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
                ,MapRevision,Subcontractor,Spool,JointNumber,JoinName,JointLocation,JointType,JointSize,JointStatus
                ,CONVERT(DATE,FitUpDate,@datetype) AS FitUpDate,CONVERT(DATE,WeldDate,@datetype) AS WeldDate
                ,WQT,HN1,HN2,WPS,HeatRod,HeatE,Category,VisualInsp,Temprature,PostheatingNumberChartNumber
                ,CONVERT(DATE,PostheatingDate,@datetype) AS PostheatingDate
                ,PWHT1Number
                ,CONVERT(DATE,PWHT1Date,@datetype) AS PWHT1Date
                ,HTaNumber
                ,CONVERT(DATE,HTDate,@datetype) AS HTDate,RT1UT1Number
                ,CONVERT(DATE,RT1UT1Date,@datetype) AS RT1UT1Date,RTUTReShoot1Number
                ,CONVERT(DATE,RTUTReShoot1Date,@datetype) AS RTUTReShoot1Date,RTUTReShoot2Number
                ,CONVERT(DATE,RTUTReShoot2Date,@datetype) AS RTUTReShoot2Date
                ,RTUTRemarks,PMINumber
                ,CONVERT(DATE,PMIDate,@datetype) AS PMIDate,MTNumber
                ,CONVERT(DATE,MTDate,@datetype) AS MTDate,PTTCNumber
                ,CONVERT(DATE,PTDate,@datetype) AS PTDate,MTPTRemarks

                ,ValidateError
                FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
                WHERE ValidateStatus = 'Accepted'
            ) AS Staging
            INNER JOIN (
                SELECT [isoID] AS ISOId,REPLACE(PIPING.tblLineList.lineKKS,'-','') + [PIPING].[tblIsos].iso AS [ISO Number]
                FROM [PIPING].[tblIsos] WITH (NOLOCK)
                INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
                WHERE [PIPING].[tblIsos].validUntil IS NULL
            ) AS ISOs
            ON Staging.[ISO Number] = ISOs.[ISO Number]
            WHERE Staging.ValidateError IS NULL
    ) AS StagingJoints
        INNER JOIN (
            SELECT
            *
            FROM PIPING.tblWeldingMap
            WHERE FitUpDate IS NOT NULL AND WeldDate IS NULL
        ) AS CurrentJoints
        ON 
        StagingJoints.ISOId = CurrentJoints.ISOId 
        AND StagingJoints.JointNumber = CurrentJoints.JointNumber 
        AND (CASE WHEN StagingJoints.JoinName IS NULL THEN 'Standard' ELSE StagingJoints.JoinName END) = (CASE WHEN CurrentJoints.JoinName IS NULL THEN 'Standard' ELSE CurrentJoints.JoinName END )

) AS v
