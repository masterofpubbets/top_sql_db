CREATE PROC AddInstrumentLeakTestRFINo
@Id INT,
@RFI NVARCHAR(100)
AS
UPDATE tblInstruments SET 
    leakTestRFINo = @RFI
WHERE ins_id = @Id
UPDATE tblInstruments SET 
    leak_test_date = GETDATE()
WHERE ins_id = @Id AND leak_test_date IS NULL