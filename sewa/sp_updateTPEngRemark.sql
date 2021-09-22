CREATE PROC sp_updateTPEngRemark
@id INT,
@remark NVARCHAR(255) = NULL
AS
UPDATE tblHT SET engRemark = @remark WHERE tblHT.ht_id = @id