ALTER PROC PIPING.ValidateStagingWeldingMap02
AS

--ISOs don’t have revision
UPDATE [PIPING].[tblWeldingMap_TEMP] SET ValidateError = 'Missing ISO Revision' WHERE ISORevision IS NULL
--------------------------------------------------------------------------------
--Join Map don’t have revision
UPDATE [PIPING].[tblWeldingMap_TEMP] SET ValidateError = 'Missing Map Revision' WHERE MapRevision IS NULL
--------------------------------------------------------------------------------

--ISOs must exists in system’s ISO
UPDATE v
SET v.ValidateError = 'ISO Does Not Exist'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISO Number],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND JointStatus = 'Active'
    ) AS OriginActive
    LEFT JOIN (
        SELECT [isoID],REPLACE(PIPING.tblLineList.lineKKS,'-','') + [PIPING].[tblIsos].iso AS [ISO Number]
        FROM [PIPING].[tblIsos] WITH (NOLOCK)
        INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
        WHERE [PIPING].[tblIsos].validUntil IS NULL
    ) AS ISOs
    ON OriginActive.[ISO Number] = ISOs.[ISO Number]
    WHERE ISOs.[ISO Number] IS NULL
) AS v
--------------------------------------------------------------------------------
