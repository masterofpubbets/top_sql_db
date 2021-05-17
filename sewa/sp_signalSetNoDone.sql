CREATE PROC sp_signalSetNoDone
@tag NVARCHAR(100)
AS
UPDATE tblSignals SET loop_done = NULL WHERE tag = @tag