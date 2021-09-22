ALTER PROC PIPING.ValidateStagingWeldingMap05
@datetype INT
AS

UPDATE PIPING.tblWeldingMap_TEMP SET FitUpDate = NULL WHERE FitUpDate IN  ('-','','01/00/1900')
UPDATE PIPING.tblWeldingMap_TEMP SET WeldDate = NULL WHERE WeldDate IN  ('-','','01/00/1900')

--Catche wrong fitup and welded dates
UPDATE PIPING.tblWeldingMap_TEMP SET ValidateError ='Incorrect Fitup Date' WHERE FitUpDate LIKE '%//%' AND ValidateError IS NULL
UPDATE PIPING.tblWeldingMap_TEMP SET ValidateError ='Incorrect Fitup Date' WHERE WeldDate LIKE '%//%' AND ValidateError IS NULL

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

--If WeldDate > FitUpDate
UPDATE v
SET v.ValidateError = 'Welded Without Fit Up'
FROM (
    SELECT
    ID
    ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
    ,JoinName,JointStatus
    ,ValidateError
    FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
    WHERE ValidateError IS NULL
    AND 
    FitUpDate IS NULL AND WeldDate IS NOT NULL
    AND JointStatus = 'Active'
) AS v
--------------------------------------------------------------------------------
--If WeldDate > FitUpDate
UPDATE v
SET v.ValidateError = 'Welded Before Fit Up'
FROM (
    SELECT
    ID
    ,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [JointNumber] AS [Joint Number]
    ,JoinName,JointStatus
    ,ValidateError
    FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
    WHERE ValidateError IS NULL
    AND 
    (CASE WHEN ISDATE(FitUpDate)=0 THEN CONVERT(DATE,FitUpDate,@datetype) ELSE CONVERT(DATE,FitUpDate,101) END) > 
    (CASE WHEN ISDATE(WeldDate)=0 THEN CONVERT(DATE,WeldDate,@datetype) ELSE CONVERT(DATE,WeldDate,101) END)
    AND JointStatus = 'Active'
) AS v
--------------------------------------------------------------------------------

