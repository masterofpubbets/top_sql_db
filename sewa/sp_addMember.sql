ALTER PROC sp_addMember
@fullName NVARCHAR(255)
,@mail NVARCHAR(max)
,@code NVARCHAR(255)
,@title NVARCHAR(255)
,@phone NVARCHAR(255) = NULL
AS
INSERT INTO tblMembers (fullName,mail,memCode,title,phoneNumber) VALUES (@fullName,@mail,@code,@title,@phone)