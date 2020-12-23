CREATE PROC sp_signalSetDone
@tag NVARCHAR(100)
AS
UPDATE tblSignals SET loop_done = GETDATE() WHERE tag = @tag AND loop_done IS NULL