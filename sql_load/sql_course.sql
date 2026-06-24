--datetime functions
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date:: DATE AS posted_date,
    EXTRACT(MONTH FROM job_posted_date) AS date_month
   -- ,MONTH(job_posted_date)
FROM job_postings_fact
LIMIT 5;

--Extracting month
SELECT 
    COUNT(job_id) AS job_count,
    EXTRACT(MONTH FROM job_posted_date) AS month_posted
FROM job_postings_fact

WHERE job_title_short = 'Data Analyst'
    AND job_country = 'United States'
GROUP BY month_posted
ORDER by job_count DESC;

--Creating tables for jobs_posted in each month from Jan to March

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2; 

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


--SELECT * FROM company_dim
-- companies with the most job postings
WITH job_counts AS (
SELECT 
    company_id
    ,COUNT(job_id) AS job_count
FROM job_postings_fact
GROUP BY company_id
)

SELECT c.name AS company_name,
        job_count
FROM company_dim c
LEFT JOIN job_counts jc
ON c.company_id=jc.company_id
ORDER BY job_count DESC;


--Skill in demand for work from home jobs
SELECT skills,
        job.job_work_from_home,
        count(job.job_id) AS "Count of Jobs"
FROM job_postings_fact job
JOIN skills_job_dim sjd ON job.job_id = sjd.job_id
JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE job_work_from_home = 'TRUE' AND
    job_title_short = 'Data Analyst'

GROUP BY skills,
    job.job_work_from_home
ORDER BY "Count of Jobs" DESC
LIMIT 5;

-----Practice problem:
SELECT quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::date,
    quarter1_job_postings.salary_year_avg
FROM
(
    SELECT *
    FROM january_jobs 
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY quarter1_job_postings.salary_year_avg DESC;
