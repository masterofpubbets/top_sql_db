CREATE PROC sp_updateTPREV
@id INT,
@rev NVARCHAR(255) = NULL
AS
UPDATE tblHT SET testPackRev = @rev WHERE tblHT.ht_id = @id