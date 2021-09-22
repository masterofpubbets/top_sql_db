CREATE PROC sp_addTPRemark
@TPID INT,
@remark NVARCHAR(255) = NULL
AS
UPDATE tblHT SET remarks = @remark WHERE ht_id = @TPID