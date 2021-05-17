CREATE PROC sp_addLogginLog
@userName NVARCHAR(50),
@fullName NVARCHAR(100),
@computerUserName NVARCHAR(100),
@loginAs NVARCHAR(50)
AS
INSERT INTO tblLoginLog (userName,fullName,computerUserName,loginDate,loginAs)
VALUES (@userName,@fullName,@computerUserName,GETDATE(),@loginAs)