ALTER PROC PIPING.UpdateWeldersStaging
AS
IF OBJECT_ID('tempdb..#tempWelders') IS NOT NULL
DROP TABLE #tempWelders
CREATE TABLE #tempWelders
(
JointID Int,
[Welder1] NVARCHAR(100),
[Welder2] NVARCHAR(100),
[Welder3] NVARCHAR(100),
[Welder4] NVARCHAR(100),
[Welder5] NVARCHAR(100),
[Welder6] NVARCHAR(100)
)

INSERT INTO #tempWelders

    SELECT
        CurrentJoints.Id AS JointId
        ,Welder1,Welder2,Welder3,Welder4,Welder5,Welder6

        FROM (
            SELECT
                ISOs.ISOId,Staging.*
                FROM (
                    SELECT
                    [Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
                    ,MapRevision,Subcontractor,Spool,JointNumber,JoinName,JointLocation,JointType,JointSize,JointStatus
                    ,Welder1,Welder2,Welder3,Welder4,Welder5,Welder6

                    ,ValidateError
                    ,Id as tempid
                    FROM [PIPING].[tblWeldingMap_TEMP] WITH (NOLOCK)
                    WHERE ValidateStatus = 'Accepted'
                    AND JointType NOT IN ('TH', 'VT', 'FJ')
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
            INNER JOIN (
                SELECT
                *
                FROM PIPING.tblWeldingMap
                WHERE WeldDate IS NOT NULL
            ) AS CurrentJoints
            ON 
            StagingJoints.ISOId = CurrentJoints.ISOId 
            AND StagingJoints.JointNumber = CurrentJoints.JointNumber 
            AND (CASE WHEN StagingJoints.JoinName IS NULL THEN 'Standard' ELSE StagingJoints.JoinName END) = (CASE WHEN CurrentJoints.JoinName IS NULL THEN 'Standard' ELSE CurrentJoints.JoinName END)
            



DELETE FROM PIPING.tblWelders WHERE JointId IN (
    SELECT DISTINCT JointId FROM #tempWelders
)

INSERT INTO PIPING.tblWelders ([JointId],[WelderName])
SELECT DISTINCT
JointId,Welder
FROM (
    SELECT
    JointId,welder1 AS [Welder]
    FROM #tempWelders
    UNION ALL
    SELECT
    JointId,welder2 AS [Welder]
    FROM #tempWelders
    UNION ALL
    SELECT
    JointId,welder3 AS [Welder]
    FROM #tempWelders
    UNION ALL
    SELECT
    JointId,welder4 AS [Welder]
    FROM #tempWelders
    UNION ALL
    SELECT
    JointId,welder5 AS [Welder]
    FROM #tempWelders
    UNION ALL
    SELECT
    JointId,welder6 AS [Welder]
    FROM #tempWelders
) AS AllWelders
WHERE Welder IS NOT NULL
