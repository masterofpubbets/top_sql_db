CREATE PROC getActivities
AS
SELECT 
actid AS Id,act_name AS Activity,subcon AS Subcontractor
,family AS Family,[block] AS [Block],area AS Area,budget AS Budget
FROM tblActids