CREATE PROC sp_updatePunchesOriginator
AS
UPDATE v
SET raisedById = raisedBy
FROM (
    SELECT
        tblPunchList.punchId, tblPunchList.raisedById
        , punchList_temp.punchNo, punchList_temp.raisedBy
    FROM tblPunchList
        INNER JOIN (
    SELECT tblPunchList_temp.raisedBy, tblPunchList_temp.punchNo
        FROM tblPunchList_temp
        WHERE tblPunchList_temp.isRaisedByFixed = 1
    ) AS punchList_temp
        ON tblPunchList.punchNo = punchList_temp.punchNo
    WHERE tblPunchList.raisedById IS NULL
) AS v