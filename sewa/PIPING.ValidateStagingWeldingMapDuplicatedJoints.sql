ALTER PROC PIPING.ValidateStagingWeldingMapDuplicatedJoints
AS
UPDATE v
SET ValidateError = 'Duplicated Joint'
FROM (
    SELECT
    JOINTCOUNT
    ,[PIPING].[tblWeldingMap_TEMP].Id,[PIPING].[tblWeldingMap_TEMP].ValidateError
    FROM (
        SELECT
        COUNT([Joint Key]) OVER(PARTITION BY [Joint Key]) AS JOINTCOUNT
        ,Id,[Joint Key]
        FROM (
            SELECT
            Id
            ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] + [JoinName] AS [Joint Key]
            FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
            WHERE [JoinName] IS NOT NULL
            UNION ALL
            SELECT
            Id
            ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Key]
            FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
            WHERE [JoinName] IS NULL
        ) AS WMap
    ) AS WMapSorted
    INNER JOIN [PIPING].[tblWeldingMap_TEMP] ON WMapSorted.Id = [PIPING].[tblWeldingMap_TEMP].Id
    WHERE JOINTCOUNT > 1
) AS v
