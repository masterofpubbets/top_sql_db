ALTER PROC PIPING.ValidiateWeldingMapFact
AS

UPDATE PIPING.tblWeldingMap SET ValidateError = NULL

--If x in (C, M, R) => It must be another Iso Number + ISOID with x = Null and Joint Status = Cancel
UPDATE v
SET v.ValidateError = 'Missing Original Join'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISOID],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND 
        JoinName IN ('C', 'M', 'R')
        AND JointStatus = 'Active'
    ) AS OriginActive
    LEFT JOIN (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE 
        JoinName IS NULL
        AND JointStatus = 'Cancel'
    ) AS OriginCancel
    ON OriginActive.[ISOID] = OriginCancel.[ISOID]
    WHERE OriginCancel.[ISOID] IS NULL
) AS v
--------------------------------------------------------------------------------
--If x = Null => Joint Status = Active unless the whole ISO is Deleted
UPDATE v
SET v.ValidateError = 'Joint Canceled Without Repair Nor Modification'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISOID],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND JointStatus = 'Cancel'
        AND JoinName IS NULL
    ) AS OriginActive

    INNER JOIN (
        SELECT [isoID]
        ,rev,validUntil
        FROM [PIPING].[tblIsos] WITH (NOLOCK)
        INNER JOIN PIPING.tblLineList ON [PIPING].[tblIsos].lineId = PIPING.tblLineList.lineId
        WHERE [PIPING].[tblIsos].validUntil IS NULL
    ) AS ISOs
    ON OriginActive.[ISOID] = ISOs.[ISOID]

    LEFT JOIN (
        SELECT
        ID
        ,ISOId AS [ISOId]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND JointStatus = 'Active'
        AND JoinName IS NOT NULL
    ) AS OriginAnotherJoin
    ON OriginActive.[ISOID] = OriginAnotherJoin.[ISOID]
    WHERE OriginAnotherJoin.[ISOID] IS NULL
    AND ISOs.validUntil IS NULL
) AS v
--------------------------------------------------------------------------------

--If x = RR => It must be another Iso Number + ISOID with x = R and Joint Status = Cancel
UPDATE v
SET v.ValidateError = 'Second Time Repair Without First Time Join'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISOID],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND 
        JoinName = 'RR'
        AND JointStatus = 'Active'
    ) AS OriginActive
    LEFT JOIN (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE 
        JoinName = 'R'
        AND JointStatus = 'Cancel'
    ) AS OriginCancel
    ON OriginActive.[ISOID] = OriginCancel.[ISOID]
    WHERE OriginCancel.[ISOID] IS NULL
) AS v
--------------------------------------------------------------------------------
--If x = RR => It must be another Iso Number + ISOID with x = R and Joint Status = Cancel
UPDATE v
SET v.ValidateError = 'Second Time Repair Without First Time Join'
FROM (
    SELECT
    OriginActive.Id,OriginActive.[ISOID],OriginActive.ValidateError,OriginActive.JoinName,OriginActive.JointStatus
    FROM (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE ValidateError IS NULL
        AND 
        JoinName = 'RR'
        AND JointStatus = 'Active'
    ) AS OriginActive
    LEFT JOIN (
        SELECT
        ID
        ,isoid AS [ISOID]
        ,JoinName,JointStatus
        ,ValidateError
        FROM [PIPING].[tblWeldingMap] WITH (NOLOCK)
        WHERE 
        JoinName = 'R'
        AND JointStatus = 'Cancel'
    ) AS OriginCancel
    ON OriginActive.[ISOID] = OriginCancel.[ISOID]
    WHERE OriginCancel.[ISOID] IS NULL
) AS v
--------------------------------------------------------------------------------