CREATE PROC HANDOVER.setProActDone
@id INT

AS

UPDATE HANDOVER.tblProjectActivity SET doneDate = GETDATE() 
WHERE 
projectActId = @id
AND active = 1 
AND doneDate IS NULL