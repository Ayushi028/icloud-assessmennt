-- iCloudEMS Support Engineer AI assignment
-- Database: SQLite. Imported CSV columns are renamed to snake_case.
-- Import the 2,767-row CSV into this table using the schema below.
-- Note: text fields are TEXT; marks fields are REAL to preserve decimal marks.

CREATE TABLE exam_wise_report (
    sr INTEGER,
    exam_session TEXT,
    academic_year TEXT,
    branch TEXT,
    department TEXT,
    class TEXT,
    semester TEXT,
    batch TEXT,
    admno TEXT,
    rollno TEXT,
    student TEXT,
    division TEXT,
    course TEXT,
    code TEXT,
    type TEXT,
    alloted_empid TEXT,
    exam_name TEXT,
    marks_entry_status TEXT,
    marks_obtained REAL,
    max_marks REAL,
    freeze_unfreeze_status TEXT,
    scaled_marks REAL,
    scaled_maxmarks REAL,
    register_status TEXT,
    result_process TEXT,
    result_publish TEXT
);

-- 1) Rows for each exam_name + marks_entry_status combination.
-- Expected result rows: 5
SELECT exam_name, marks_entry_status, COUNT(*) AS row_count
FROM exam_wise_report
GROUP BY exam_name, marks_entry_status
ORDER BY exam_name, marks_entry_status;

-- 2) Published results with marks missing or entry not done.
-- Expected result rows: 1,849
SELECT admno, student, code, course, exam_name
FROM exam_wise_report
WHERE result_publish = 'Published'
  AND (marks_entry_status = 'Not Done' OR marks_obtained IS NULL);

-- 3) Duplicate keys: same admno + code + exam_name more than once.
-- Expected result rows (duplicate key groups): 356
SELECT admno, code, exam_name, COUNT(*) AS occurrences
FROM exam_wise_report
GROUP BY admno, code, exam_name
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, admno, code, exam_name;

-- 4) Impossible marks / scaling inconsistencies.
-- Expected result rows: 10 (10 negative rows; 9 also have a scaled mismatch).
SELECT sr, admno, student, code, exam_name, marks_obtained, max_marks,
       scaled_marks, scaled_maxmarks
FROM exam_wise_report
WHERE marks_obtained < 0
   OR (max_marks IS NOT NULL AND marks_obtained > max_marks)
   OR (max_marks = scaled_maxmarks
       AND marks_obtained IS NOT NULL
       AND scaled_marks IS NOT NULL
       AND scaled_marks <> marks_obtained)
ORDER BY sr;

-- 5a) Preview original semester values and proposed cleaned values.
-- Expected result rows: 17 distinct original values.
SELECT DISTINCT semester AS original_value,
       CASE UPPER(TRIM(semester))
         WHEN 'SEM I' THEN 'Sem I'
         WHEN 'SEM II' THEN 'Sem II'
         WHEN 'SEM III' THEN 'Sem III'
         WHEN 'SEM IV' THEN 'Sem IV'
         WHEN 'SEM V' THEN 'Sem V'
         WHEN 'SEM VI' THEN 'Sem VI'
         WHEN 'SEM VII' THEN 'Sem VII'
         WHEN 'SEM VIII' THEN 'Sem VIII'
         WHEN 'SEM IX' THEN 'Sem IX'
         ELSE 'REVIEW - do not auto-clean'
       END AS cleaned_value
FROM exam_wise_report
ORDER BY original_value;

-- 5b) Safety: take a full backup before update.
-- Expected copied rows: 2,767
CREATE TABLE exam_wise_report_backup AS
SELECT * FROM exam_wise_report;

-- 5c) Standardise only known Roman-numeral case variants.
-- Expected affected rows: 139. The one value 'Sem 9' is intentionally not changed;
-- confirm it with the registrar before mapping it to Sem IX.
UPDATE exam_wise_report
SET semester = CASE UPPER(TRIM(semester))
         WHEN 'SEM I' THEN 'Sem I'
         WHEN 'SEM II' THEN 'Sem II'
         WHEN 'SEM III' THEN 'Sem III'
         WHEN 'SEM IV' THEN 'Sem IV'
         WHEN 'SEM V' THEN 'Sem V'
         WHEN 'SEM VI' THEN 'Sem VI'
         WHEN 'SEM VII' THEN 'Sem VII'
         WHEN 'SEM VIII' THEN 'Sem VIII'
         WHEN 'SEM IX' THEN 'Sem IX'
       END
WHERE UPPER(TRIM(semester)) IN
      ('SEM I','SEM II','SEM III','SEM IV','SEM V','SEM VI','SEM VII','SEM VIII','SEM IX')
  AND semester <> CASE UPPER(TRIM(semester))
         WHEN 'SEM I' THEN 'Sem I'
         WHEN 'SEM II' THEN 'Sem II'
         WHEN 'SEM III' THEN 'Sem III'
         WHEN 'SEM IV' THEN 'Sem IV'
         WHEN 'SEM V' THEN 'Sem V'
         WHEN 'SEM VI' THEN 'Sem VI'
         WHEN 'SEM VII' THEN 'Sem VII'
         WHEN 'SEM VIII' THEN 'Sem VIII'
         WHEN 'SEM IX' THEN 'Sem IX'
       END;
-- Expected affected rows: 139 (not 140; 'Sem 9' is a manual-review value).

-- 6) Distinct missing scheme configuration list for developers.
-- Expected result rows: 273 distinct department + semester + code + course combinations.
SELECT department, semester, code, course, COUNT(DISTINCT admno) AS students_affected
FROM exam_wise_report
WHERE exam_name = 'Scheme Not Found'
GROUP BY department, semester, code, course
ORDER BY students_affected DESC, department, semester, code;

-- Bonus) Morning alert: detect published rows without marks or completed entry.
-- Expected result rows: 1,849 on this export.
SELECT sr, admno, student, code, course, exam_name,
       marks_entry_status, marks_obtained, result_process, result_publish
FROM exam_wise_report
WHERE result_publish = 'Published'
  AND (marks_obtained IS NULL OR marks_entry_status = 'Not Done');
