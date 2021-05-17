ALTER FUNCTION HSE.PendingPemitLoto (
    @permitId INT
)
RETURNS INT
AS
BEGIN
    RETURN(
        SELECT 
        CASE WHEN COUNT(HSE.tblLotoPermitRequired.lotoId) IS NULL THEN 0 ELSE COUNT(HSE.tblLotoPermitRequired.lotoId) END AS [Pending Loto]
        FROM HSE.tblLotoPermitRequired 
        WHERE permitId = @permitId AND removalDate IS NULL
    )
END