ALTER VIEW HookupScope
AS
SELECT
unit_id,hookup_type AS [Hookup Type],
COUNT(tag) AS Scope
FROM tblInstruments
WHERE active = 1
AND hookup_require = 1
GROUP BY unit_id,hookup_type