ALTER PROC sp_addMember
@fullName NVARCHAR(255)
,@mail NVARCHAR(max)
AS
INSERT INTO tblMembers (fullName,mail) VALUES (@fullName,@mail)