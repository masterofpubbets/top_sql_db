CREATE PROC PIPING.ValidateStagingWeldingMapISORevision
AS
--ISO’s revision must be the same as system ISO’s revision.
UPDATE v
SET v.ValidateError = 'Mismatch ISO Revision Welding Map With the Current One in the System'
FROM (
SELECT
        OriginActive.Id,OriginActive.[ISO Number],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus,OriginActive.ISORevision
        ,ISOs.rev
        FROM (
            SELECT
            ID
            ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
            ,JoinName,JointStatus,ISORevision
            ,ValidateError
            FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
            WHERE ValidateError IS NULL
            AND JointStatus = 'Active'
        ) AS OriginActive
        INNER JOIN (
            SELECT [isoID],REPLACE(PIPING.tblLineList.lineKKS,'-','') + [PIPING].[tblIsos].iso AS [ISO Number]
            ,rev
            FROM [PIPING].[tblIsos] WITH (NOLOCK)
            INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
            WHERE [PIPING].[tblIsos].validUntil IS NULL
        ) AS ISOs
        ON OriginActive.[ISO Number] = ISOs.[ISO Number]
        LEFT JOIN PIPING.tblWeldingMap WITH (NOLOCK) ON ISOs.isoID = PIPING.tblWeldingMap.isoId
        WHERE ISOs.[ISO Number] IS NOT NULL
        AND PIPING.tblWeldingMap.isoId IS NULL
        AND OriginActive.ISORevision <> ISOs.rev
) AS v