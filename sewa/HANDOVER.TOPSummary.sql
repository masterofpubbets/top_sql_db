ALTER VIEW HANDOVER.TOPSummary
AS
SELECT 
top_name,cod,plan_ho_date,walk_through_date,transfer_date
FROM tblTOP
WHERE top_name  <> 'UNDEFINED'