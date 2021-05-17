CREATE PROC sp_clearLoopConstraint
@tag NVARCHAR(100)
AS
UPDATE tblSignals SET signalConstraint = NULL, constraintResolvedDate = NULL, constraintResponsibleId = NULL
WHERE tblSignals.tag = @tag
