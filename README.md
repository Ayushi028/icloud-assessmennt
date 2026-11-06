# iCloudEMS Support Engineer (AI) – Assignment

**Candidate:** Ayushi Shukla  
**Assignment:** iCloudEMS Support Engineer (AI)  
**Date:** November 2026

## Project Overview

This repository contains my solution to the iCloudEMS Support Engineer (AI) assignment. The task involved investigating two real-world examination ERP support tickets using CSV data analysis, SQL, Python and AI-assisted problem-solving.

The assignment focused on identifying missing examination marks, investigating exam scheme configuration issues, validating re-evaluation marks and preparing data for staging-table upload.

## Support Tickets

### Ticket 1: EX-20481 – Exam-Wise Report Not Working

**Problem:** The university reported that the Exam-Wise Report was no longer displaying marks.

**Work performed:**
- Analysed the examination report containing 2,767 records.
- Identified missing marks and incomplete marks-entry statuses.
- Investigated missing exam scheme configurations.
- Checked duplicate records and inconsistent data.
- Identified published results with missing marks.
- Prepared SQL queries and recommendations for resolving the issues.

### Key Findings

| Finding | Records |
|---|---:|
| Total records analysed | 2,767 |
| Records with marks present | 104 |
| Marks entry not done | 1,638 |
| Scheme not found | 1,025 |
| Published but marks missing | 1,849 |
| Duplicate key groups | 356 |

**Conclusion:** The primary issues appear to be incomplete marks entry and missing exam scheme configurations. The published-but-missing-marks records also require further verification.

### Ticket 2: GU-16432 – Re-Evaluation Marks Upload

**Problem:** The university requested uploading re-evaluation marks for the Winter 2025-26 examination session.

**Work performed:**
- Analysed all 41 re-evaluation records.
- Validated student identifiers and course codes.
- Checked marks against maximum marks.
- Identified duplicate records and inconsistent entries.
- Mapped source data to the temporary marks table upload template.
- Generated a staging-ready CSV file.
- Separated records requiring clarification into an exception report.

**Validation Summary:**
- 33 records prepared for staging upload.
- 8 records held for clarification.
- No marks were silently modified or uploaded into the live ERP.

## Technology and Tools Used

- **Python:** Data analysis and validation.
- **Pandas:** CSV processing, duplicate detection and data cleaning.
- **SQL (SQLite):** Database queries and data investigation.
- **Excel:** Data validation and exception reporting.
- **AI Tools (ChatGPT):** SQL assistance, anomaly identification, data-mapping guidance and documentation.

## Repository Structure

```text
iCloudEMS-Support-Engineer-AI/
│
├── answers.docx
├── queries.sql
├── exam_wise_findings.png
├── EX-20481_analysis.xlsx
├── GU-16432_upload_ready.csv
├── GU-16432_exceptions.xlsx
└── README.md
```

## Key Deliverables

| File | Description |
|---|---|
| `answers.docx` | Complete assignment investigation and findings |
| `queries.sql` | SQL table definition and investigation queries |
| `EX-20481_analysis.xlsx` | Examination report analysis |
| `exam_wise_findings.png` | Visual representation of report findings |
| `GU-16432_upload_ready.csv` | Validated re-evaluation records |
| `GU-16432_exceptions.xlsx` | Records requiring further clarification |

## AI Usage

AI was used as an assistance tool throughout the assignment.

Key applications included:

1. Generating and reviewing SQL queries.
2. Identifying potential data inconsistencies.
3. Supporting data validation and mapping.
4. Preparing technical documentation.
5. Drafting client communication and developer escalation notes.

All important findings and record counts were checked against the source data using Python and Pandas.

## Important Assumptions and Limitations

- The supplied re-evaluation data was provided in CSV format.
- The report export belongs to the September 2025-26 special examination, whereas the re-evaluation ticket concerns Winter 2025-26.
- Therefore, the report export was used as a validation reference, not as an authoritative source for Winter session marks.
- Records with ambiguous or conflicting information were held for clarification.
- No changes were made to the live ERP database.

## Conclusion

This assignment demonstrates a structured approach to technical support, data investigation, SQL-based analysis, data validation and AI-assisted problem-solving.

My focus was not only to identify errors but also to ensure data accuracy, maintain examination data integrity and recommend safe corrective actions before processing marks.

**Prepared by: Aje Shukla**
