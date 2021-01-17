CREATE PROC sp_addPunchCatalog
@punchCategory NVARCHAR(50)
,@punchCategoryDes NVARCHAR(255)
AS
INSERT INTO tblPunchCategory (punchCategory,punchCategoryDes) VALUES (@punchCategory,@punchCategoryDes)