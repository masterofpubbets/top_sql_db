CREATE PROC ClearInstrumentHookupRFINo
@Id INT
AS
UPDATE tblInstruments SET 
    hookupRFINo = NULL
WHERE ins_id = @Id