ALTER PROC PIPING.UpdateWelders
@jointId INT,
@welder NVARCHAR(100)
AS
DECLARE @ID INT
SELECT @ID = PIPING.tblWelders.WelderID FROM PIPING.tblWelders WHERE JointId = @jointId AND WelderName = @welder

IF @ID IS NULL
    BEGIN
        INSERT INTO PIPING.tblWelders (JointId,WelderName) VALUES (@jointId,@welder)
    END