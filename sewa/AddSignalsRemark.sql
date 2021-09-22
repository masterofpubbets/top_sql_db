CREATE PROC AddSignalsRemark
@tag NVARCHAR(100),
@remark NVARCHAR(255) = NULL
AS
UPDATE tblSignals SET remarks = @remark WHERE tag = @tag
