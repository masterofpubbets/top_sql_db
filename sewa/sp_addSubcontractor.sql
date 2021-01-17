CREATE PROC sp_addSubcontractor
@subconCode NVARCHAR(50)
,@subconName NVARCHAR(50)
AS
INSERT INTO tblSubcontractor (subconCode,subconName) VALUES (@subconCode,@subconName)