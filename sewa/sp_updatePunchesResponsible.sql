CREATE PROC sp_updatePunchesResponsible
AS
UPDATE v
SET memberId = responsible
FROM (
    SELECT
        tblPunchList.punchId, tblPunchList.memberId
        , punchList_temp.punchNo, punchList_temp.responsible
    FROM tblPunchList
        INNER JOIN (
    SELECT tblPunchList_temp.responsible, tblPunchList_temp.punchNo
        FROM tblPunchList_temp
        WHERE tblPunchList_temp.isResponsibleFixed = 1
    ) AS punchList_temp
        ON tblPunchList.punchNo = punchList_temp.punchNo
    WHERE tblPunchList.memberId IS NULL
) AS v
