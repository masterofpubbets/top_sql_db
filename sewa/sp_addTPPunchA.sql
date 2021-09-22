CREATE PROC sp_addTPPunchA
@TPID INT,
@punch NVARCHAR(255) = NULL
AS
UPDATE tblHT SET a_punch = @punch WHERE ht_id = @TPID