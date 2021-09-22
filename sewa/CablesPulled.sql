ALTER VIEW CablesPulled
AS
SELECT
unit_id,top_id,[discipline],cable_type,pulled_date
,COUNT(tag) AS [Pulled Number]
,SUM(design_length) AS [Pulled Lm]
FROM tblCables
WHERE active=1 AND pulled_date IS NOT NULL
GROUP BY unit_id,top_id,discipline,cable_type,pulled_date