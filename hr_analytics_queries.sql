-- Create Table to store HR data
CREATE TABLE hrdata (
    emp_no INT8 PRIMARY KEY,                      -- Employee Number
    gender VARCHAR(50) NOT NULL,                  -- Gender of the employee
    marital_status VARCHAR(50),                   -- Marital Status
    age_band VARCHAR(50),                         -- Age Band (e.g., 20-30, 30-40, etc.)
    age INT8,                                     -- Age of the employee
    department VARCHAR(50),                       -- Department the employee works in
    education VARCHAR(50),                        -- Education Level (e.g., Bachelor's, Master's)
    education_field VARCHAR(50),                  -- Field of Study (e.g., Engineering, Science)
    job_role VARCHAR(50),                         -- Job Role (e.g., Developer, HR Manager)
    business_travel VARCHAR(50),                  -- Business Travel (e.g., Frequently, Rarely)
    employee_count INT8,                          -- Number of employees in a group
    attrition VARCHAR(50),                        -- Whether the employee has left (Yes/No)
    attrition_label VARCHAR(50),                  -- Label for attrition status
    job_satisfaction INT8,                        -- Job Satisfaction Level (1-4 scale)
    active_employee INT8                          -- Whether the employee is active (1 for Yes, 0 for No)
);

-- Import Data into the Table (ensure the path is correct for your system)
-- COPY hrdata FROM 'C:\path\to\your\csv\file.csv' DELIMITER ',' CSV HEADER;

-- Query to calculate the total number of employees
SELECT SUM(employee_count) AS Employee_Count
FROM hrdata;

-- Query to calculate the number of employees who left the organization (Attrition Count)
SELECT COUNT(attrition)
FROM hrdata
WHERE attrition = 'Yes';

-- Query to calculate the attrition rate
SELECT 
    ROUND(((SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes') / 
    SUM(employee_count)) * 100, 2) AS Attrition_Rate
FROM hrdata;

-- Query to calculate the number of active employees
SELECT 
    SUM(employee_count) - (SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes') 
FROM hrdata;

-- Query to calculate the average age of employees
SELECT ROUND(AVG(age), 0) AS Average_Age
FROM hrdata;

-- Query to calculate attrition count by gender
SELECT gender, COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY gender
ORDER BY COUNT(attrition) DESC;

-- Query to calculate attrition by department
SELECT department, COUNT(attrition), 
    ROUND((CAST(COUNT(attrition) AS NUMERIC) / 
    (SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY department
ORDER BY COUNT(attrition) DESC;

-- Query to calculate the number of employees by age group
SELECT age, SUM(employee_count) AS employee_count
FROM hrdata
GROUP BY age
ORDER BY age;

-- Query to calculate attrition count by education field
SELECT education_field, COUNT(attrition) AS attrition_count
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY education_field
ORDER BY COUNT(attrition) DESC;

-- Query to calculate attrition rate by gender for different age groups
SELECT age_band, gender, COUNT(attrition) AS attrition, 
    ROUND((CAST(COUNT(attrition) AS NUMERIC) / 
    (SELECT COUNT(attrition) FROM hrdata WHERE attrition = 'Yes')) * 100, 2) AS pct
FROM hrdata
WHERE attrition = 'Yes'
GROUP BY age_band, gender
ORDER BY age_band, gender DESC;

-- Query to display job satisfaction ratings by job role (using crosstab function)
-- Activating the cosstab() function
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT *
FROM crosstab(
    'SELECT job_role, job_satisfaction, SUM(employee_count)
     FROM hrdata
     GROUP BY job_role, job_satisfaction
     ORDER BY job_role, job_satisfaction'
) AS ct(job_role VARCHAR(50), one NUMERIC, two NUMERIC, three NUMERIC, four NUMERIC)
ORDER BY job_role;

-- END OF SQL SCRIPT
