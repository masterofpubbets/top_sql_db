CREATE PROC PIPING.ValidateStagingJointTypeChanged
AS
UPDATE v
SET
v.ValidateError = 'Joint Type Has Changed'

FROM (
    SELECT
    StagingJoints.[ISOId] AS StagingISOId
    ,StagingJoints.[ValidateError] AS ValidateError

    FROM (
        SELECT
            ISOs.ISOId,Staging.ValidateError,Staging.JointNumber,Staging.JointType
            FROM (
                SELECT
                [Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
                ,MapRevision,Subcontractor,Spool,JointNumber,JoinName,JointLocation,JointType,JointSize,JointStatus
                ,ValidateError
                FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
                WHERE JointStatus = 'Active'
                AND ValidateError IS NULL
            ) AS Staging
            INNER JOIN (
                SELECT [isoID] AS ISOId,REPLACE(PIPING.tblLineList.lineKKS,'-','') + [PIPING].[tblIsos].iso AS [ISO Number]
                FROM [PIPING].[tblIsos] WITH (NOLOCK)
                INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
                WHERE [PIPING].[tblIsos].validUntil IS NULL
            ) AS ISOs
            ON Staging.[ISO Number] = ISOs.[ISO Number]
    ) AS StagingJoints
        INNER JOIN (
            SELECT
            ISOId,JointNumber,JointType
            FROM PIPING.tblWeldingMap
            WHERE FitUpDate IS NOT NULL AND WeldDate IS NOT NULL
        ) AS CurrentJoints
        ON 
        StagingJoints.ISOId = CurrentJoints.ISOId 
        AND StagingJoints.JointNumber = CurrentJoints.JointNumber 
        AND StagingJoints.JointType <> CurrentJoints.JointType

) AS v
