CREATE PROC sp_addTPTargetDate
@TPID INT,
@TargetDate DATE = NULL
AS
UPDATE tblHT SET target_date = @TargetDate WHERE ht_id = @TPID