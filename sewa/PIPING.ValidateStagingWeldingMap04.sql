ALTER PROC PIPING.ValidateStagingWeldingMap04
AS

--If x = Null => Joint Status = Active unless the whole ISO is Deleted
UPDATE v
SET v.ValidateError = 'Joint Canceled Without Repair Nor Modification'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISO Number],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus,OriginActive.[Joint Number]
    FROM (
        SELECT
        ID
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
        ,JoinName,JointStatus,ISORevision
        ,ValidateError
        FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND JointStatus = 'Cancel'
        AND JoinName IS NULL
    ) AS OriginActive

    INNER JOIN (
        SELECT [isoID],REPLACE(PIPING.tblLineList.lineKKS,'-','') + [PIPING].[tblIsos].iso AS [ISO Number]
        ,rev,validUntil
        FROM [PIPING].[tblIsos] WITH (NOLOCK)
        INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
        WHERE [PIPING].[tblIsos].validUntil IS NULL
    ) AS ISOs
    ON OriginActive.[ISO Number] = ISOs.[ISO Number]

    LEFT JOIN (
        SELECT
        ID
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
        ,JoinName,JointStatus,ISORevision
        ,ValidateError
        FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND JointStatus = 'Active'
        AND JoinName IS NOT NULL
    ) AS OriginAnotherJoin
    ON OriginActive.[Joint Number] = OriginAnotherJoin.[Joint Number]
    WHERE OriginAnotherJoin.[Joint Number] IS NULL
    AND ISOs.validUntil IS NULL
) AS v
--------------------------------------------------------------------------------

--If x = RR => It must be another Iso Number + Joint number with x = R and Joint Status = Cancel
UPDATE v
SET v.ValidateError = 'Second Time Repair Without First Time Joint'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[Joint Number],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND 
        JoinName = 'RR'
        AND JointStatus = 'Active'
    ) AS OriginActive
    LEFT JOIN (
        SELECT
        ID
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
        WHERE 
        JoinName = 'R'
        AND JointStatus = 'Cancel'
    ) AS OriginCancel
    ON OriginActive.[Joint Number] = OriginCancel.[Joint Number]
    WHERE OriginCancel.[Joint Number] IS NULL
) AS v
--------------------------------------------------------------------------------
