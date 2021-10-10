ALTER PROC sp_editMember
@memberId INT,
@fullName NVARCHAR(255)
,@mail NVARCHAR(max)
,@code NVARCHAR(255)
,@title NVARCHAR(255)
,@phone NVARCHAR(255) = NULL
AS
UPDATE tblMembers 
    SET fullName = @fullName,
        mail = @mail,
        memCode = @code,
        title = @title,
        phoneNumber = @phone
    WHERE memberId = @memberId