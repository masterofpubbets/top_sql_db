CREATE PROC AddInstrumentHookupRFINo
@Id INT,
@RFI NVARCHAR(100)
AS
UPDATE tblInstruments SET 
    hookupRFINo = @RFI
WHERE ins_id = @Id
UPDATE tblInstruments SET 
    hookup_date = GETDATE()
WHERE ins_id = @Id AND hookup_date IS NULL