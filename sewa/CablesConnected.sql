CREATE VIEW CablesConnected
AS

SELECT
unit_id,discipline,cable_type,[Connected Date]
,SUM([Connected Done]) AS [Connected Done]
FROM (
    SELECT
    unit_id,discipline,cable_type,con_from_date AS [Connected Date]
    ,COUNT(con_from_date) AS [Connected Done]
    FROM tblCables
    WHERE active = 1 AND con_from_date IS NOT NULL
    GROUP BY unit_id,discipline,cable_type,con_from_date
    UNION ALL
    SELECT
    unit_id,discipline,cable_type,con_to_date AS [Connected Date]
    ,COUNT(con_to_date) AS [Connected Done]
    FROM tblCables
    WHERE active = 1 AND con_to_date IS NOT NULL
    GROUP BY unit_id,discipline,cable_type,con_to_date
) AS CablesConn
GROUP BY unit_id,discipline,cable_type,[Connected Date]