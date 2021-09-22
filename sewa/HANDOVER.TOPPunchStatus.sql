ALTER PROC HANDOVER.TOPPunchStatus
AS
SELECT
tblTOP.top_name AS [TOP],tblTOP.subsystem_description AS [Description],tblTOP.cod AS COD,tblTOP.res AS Responsible
,tblTOP.walk_through_date AS [Walkthrough Date],tblTOP.transfer_date AS [Transfer Date]
,TOPPunchSummary.PunchCategory,TOPPunchSummary.TotalPunch,TOPPunchSummary.CreatedDate,TOPPunchSummary.LastClosedDate
,TOPPunchSummary.DaysToClose

FROM tblTOP WITH (NOLOCK)
LEFT JOIN
(
    SELECT
    topID,PunchCategory
    ,COUNT(punchId) AS TotalPunch
    ,MIN(createdDate) AS CreatedDate
    ,CASE WHEN COUNT(closedDate) = COUNT(punchId) THEN MAX(closedDate)
        ELSE
            NULL
        END AS LastClosedDate

    ,CASE WHEN ((MAX(closedDate) IS NOT NULL) AND (COUNT(closedDate) = COUNT(punchId))) THEN
        DATEDIFF(DAY,MIN(createdDate),MAX(closedDate))
    ELSE
        NULL
    END AS DaysToClose
    FROM (
        SELECT
        tblPunchList.top_id AS topID
        ,CASE WHEN tblPunchCategory.punchCategory = 'A' THEN 'A' ELSE 'Other' END AS PunchCategory
        ,tblPunchList.createdDate,tblPunchList.closedDate
        ,tblPunchList.punchId
        FROM tblPunchList WITH (NOLOCK)
        INNER JOIN tblPunchCategory WITH (NOLOCK) ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
    ) AS PunchGroups
    GROUP BY topID,PunchCategory
) AS TOPPunchSummary

ON tblTOP.top_id = TOPPunchSummary.topID