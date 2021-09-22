ALTER PROC PIPING.ValidateStagingWeldingMap03
AS

--If x Not in (C, M, R, RR, F, T, S, V, Null) => Wrong 
UPDATE v
SET ValidateError = 'Wrong Joint Name'
FROM (
    SELECT
    ID
    ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] AS [Line Number]
    ,[Train] AS [ISO Number]
    ,[Spool]
    ,[JointNumber]
    ,[JoinName]
    ,ValidateError
    FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
    WHERE ValidateError IS NULL
    AND 
    NOT (JoinName IN ('C', 'M', 'R', 'RR', 'F', 'T', 'S', 'V') OR JoinName IS NULL)
) AS v
--------------------------------------------------------------------------------

--If x in (C, M, R) => It must be another Iso Number + Joint number with x = Null and Joint Status = Cancel
UPDATE v
SET v.ValidateError = 'Missing Original Joint'
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
        JoinName IN ('C', 'M', 'R')
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
        JoinName IS NULL
        AND JointStatus = 'Cancel'
    ) AS OriginCancel
    ON OriginActive.[Joint Number] = OriginCancel.[Joint Number]
    WHERE OriginCancel.[Joint Number] IS NULL
) AS v
--------------------------------------------------------------------------------

--If Join Type NOT IN (TH, VT, FJ) and Date of Welded IS NOT NULL  AND Join Status = Active=> Must be a welder
UPDATE v
SET v.ValidateError = 'Missing Welder'
FROM (
    SELECT
    ID
    ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
    ,JoinName,JointStatus
    ,ValidateError
    FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
    WHERE ValidateError IS NULL
    AND 
    JointType NOT IN ('TH', 'VT', 'FJ')
    AND WeldDate IS NOT NULL
    AND JointStatus = 'Active'
    AND [Welder1] IS NULL AND [Welder2] IS NULL AND [Welder3] IS NULL AND [Welder4] IS NULL AND [Welder5] IS NULL AND [Welder6] IS NULL
) AS v
--------------------------------------------------------------------------------
