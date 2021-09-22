CREATE PROC HANDOVER.setProActNotDone
@id INT

AS

UPDATE HANDOVER.tblProjectActivity SET doneDate = Null
WHERE 
projectActId = @id