ALTER PROC PIPING.AddNewJoints
@dateType INT
AS

INSERT INTO PIPING.tblWeldingMap (
    [ISOId],[MapRevision],[Subcontractor],[Spool],[JointNumber],[JoinName],[JointLocation],[JointType],[JointSize],Schedule_mm
,[JointStatus],[FitUpDate],[WeldDate],[WQT],[HN1],[HN2],[WPS],[HeatRod],[HeatE],[Category],[VisualInsp],[Temprature]
,[PostheatingNumberChartNumber],[PostheatingDate],[PWHT1Number],[PWHT1Date],[HTaNumber],[HTDate],[RT1UT1Number]
,[RT1UT1Date],[RTUTReShoot1Number],[RTUTReShoot1Date],[RTUTReShoot2Number],[RTUTReShoot2Date],[RTUTRemarks],[PMINumber]
,[PMIDate],[MTNumber],[MTDate],[PTTCNumber],[PTDate],[MTPTRemarks]
)

SELECT
StagingJoints.[ISOId],[MapRevision],[Subcontractor],[Spool],StagingJoints.[JointNumber],StagingJoints.[JoinName],[JointLocation],[JointType],[JointSize],Schmm
,[JointStatus],[FitUpDate],[WeldDate],[WQT],[HN1],[HN2],[WPS],[HeatRod],[HeatE],[Category],[VisualInsp],[Temprature]
,[PostheatingNumberChartNumber],[PostheatingDate],[PWHT1Number],[PWHT1Date],[HTaNumber],[HTDate],[RT1UT1Number]
,[RT1UT1Date],[RTUTReShoot1Number],[RTUTReShoot1Date],[RTUTReShoot2Number],[RTUTReShoot2Date],[RTUTRemarks],[PMINumber]
,[PMIDate],[MTNumber],[MTDate],[PTTCNumber],[PTDate],[MTPTRemarks]
FROM (
    SELECT
        ISOs.ISOId,Staging.*
        FROM (
            SELECT
            [Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
            ,MapRevision,Subcontractor,Spool,JointNumber,JoinName,JointLocation,JointType,JointSize
            ,CONVERT(FLOAT,Schmm) AS Schmm
            ,JointStatus
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
    LEFT JOIN (
        SELECT
        ISOId,JointNumber,JoinName
        FROM PIPING.tblWeldingMap
    ) AS CurrentJoints
    ON 
    StagingJoints.ISOId = CurrentJoints.ISOId 
    AND StagingJoints.JointNumber = CurrentJoints.JointNumber
    AND (CASE WHEN StagingJoints.JoinName IS NULL THEN 'Standard' ELSE StagingJoints.JoinName END) = (CASE WHEN CurrentJoints.JoinName IS NULL THEN 'Standard' ELSE CurrentJoints.JoinName END)
    WHERE CurrentJoints.ISOId IS NULL