ALTER PROC sp_addMember
@fullName NVARCHAR(255)
,@mail NVARCHAR(max)
,@code NVARCHAR(255)
,@title NVARCHAR(255)
AS
INSERT INTO tblMembers (fullName,mail,memCode,title) VALUES (@fullName,@mail,@code,@title)