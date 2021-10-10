CREATE PROC PIPING.DeleteJoint
@jointId INT
AS

BEGIN TRY
    BEGIN TRANSACTION DELETEISO WITH MARK 'DELETEISO'
        DELETE FROM PIPING.tblWelders WHERE JointId = @jointId
        DELETE FROM PIPING.tblWeldingMap WHERE PIPING.tblWeldingMap.Id = @jointId
    COMMIT TRANSACTION DELETEISO
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION DELETEISO
END CATCH