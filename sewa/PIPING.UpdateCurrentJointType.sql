CREATE PROC PIPING.UpdateCurrentJointType
@stagingJointId INT

AS

UPDATE v
SET v.[Current Joint Type] = v.[Staging Joint Type]
FROM (
    SELECT
    StagingJoints.[Id] AS [Staging Joint Id],StagingJoints.JointType AS [Staging Joint Type]
    ,CurrentJoints.Id AS [Current Joint Id],CurrentJoints.JointType AS [Current Joint Type]

    FROM (
        SELECT
            ISOs.ISOId,Staging.ValidateError,Staging.JointNumber,Staging.JointType,Id
            FROM (
                SELECT
                [Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
                ,MapRevision,Subcontractor,Spool,JointNumber,JoinName,JointLocation,JointType,JointSize,JointStatus
                ,ValidateError,Id
                FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
                WHERE Id = @stagingJointId
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
            ISOId,JointNumber,JointType,Id
            FROM PIPING.tblWeldingMap
            WHERE FitUpDate IS NOT NULL AND WeldDate IS NOT NULL
        ) AS CurrentJoints
        ON 
        StagingJoints.ISOId = CurrentJoints.ISOId 
        AND StagingJoints.JointNumber = CurrentJoints.JointNumber 
) AS v


