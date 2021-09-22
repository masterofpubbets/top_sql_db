CREATE PROC ClearInstrumentLeakTestRFINo
@Id INT
AS
UPDATE tblInstruments SET 
    leakTestRFINo = NULL
WHERE ins_id = @Id