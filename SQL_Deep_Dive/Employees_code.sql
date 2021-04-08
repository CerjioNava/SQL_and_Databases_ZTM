-- Esto es un comentario de una linea.
/* Esto es un comentario 
   de varias lineas
*/


-- Question 1: List of all employees in the company.
-- SELECT * FROM employees;
-- SELECT * FROM "public"."employees" ;

-- Question 2: How many departments are there in the company?
-- SELECT * FROM departments;

-- Question 3: How many times has employee 10001 had a raise?
-- SELECT * FROM salaries WHERE emp_no='10001';

-- Question 4: What title does 10006 have?
-- SELECT title FROM titles WHERE emp_no='10006';

-- Renaming columns 
-- SELECT emp_no AS "Employee #", birth_date AS "Birthday", first_name AS "First Name" FROM employees;

-- Column Concatenation 
-- SELECT concat(first_name, ' ' , last_name) AS "Full Name" from employees;

-- Aggregate functions:
-- SELECT count(*) FROM employees;
-- SELECT count(emp_no) FROM employees;
-- SELECT avg(salary) FROM salaries;
-- SELECT min(salary) FROM salaries;
-- SELECT max(salary) FROM salaries;    -- Question 1: Get the Highest salary available.
-- SELECT sum(salary) FROM salaries;    -- Question 2: Get the total amount of salaries paid.
-- SELECT min(birth_date) FROM employees

-- " " y ' '
-- SELECT * from employees WHERE gender='F';  -- Question: Get all the females employees.

-- AND & OR
/* AND Exercise: Filter of Mayumi Schueller
SELECT * from employees
-- Filtering on a single person (this is commenting between statements)
WHERE first_name='Mayumi' AND last_name='Schueller'; 
*/
/* OR Exercise: Filter on 2 first names
SELECT * FROM employees
WHERE (first_name='Georgi' AND last_name='Facello') OR (first_name='Mayumi' AND gender='F');
*/

-- IS (NULL, NOT NULL, TRUE, FALSE)
-- SELECT * FROM employees WHERE gender IS NULL;
-- SELECT * FROM employees WHERE gender IS NOT NULL;
-- SELECT * FROM salaries WHERE salary<39000 IS TRUE;

-- IN keyword
--SELECT * FROM employees 
-- WHERE emp_no IN (10001, 10006, 11008)                -- Más sencillo así
-- WHERE emp_no=10001 OR emp_no=10006 OR emp_no=11008

-- LIKE keyword
-- SELECT first_name FROM employees 
-- WHERE first_name LIKE 'M%'  
-- WHERE first_name LIKE '%a'
-- WHERE first_name LIKE '%s%'

-- ILIKE keyword
-- SELECT * FROM employees
-- WHERE first_name LIKE 'G%er';
-- WHERE first_name ILIKE 'g%er';
--
--SELECT emp_no, first_name, EXTRACT (YEAR FROM AGE(birth_date)) 
--as "age" FROM employees WHERE first_name ILIKE 'M%';

-- TIMEZONE
-- SET TIME ZONE 'UTC';
-- ALTER USER postgres SET timezone='UTC';
-- SHOW TIMEZONE;
-- SELECT now()

-- EJEMPLO TIMEZONE:
/*
CREATE TABLE timezones (
    ts TIMESTAMP WITHOUT TIME ZONE,
    tz TIMESTAMP WITH TIME ZONE    
)
*/
/*
INSERT INTO timezones VALUES(
    TIMESTAMP WITHOUT TIME ZONE '2000-01-01 10:00:00-05',
    TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00-05'
);
*/
-- SELECT * FROM timezones

-- Date functions
-- SELECT NOW()::date;
-- SELECT CURRENT_DATE;
-- SELECT TO_CHAR(CURRENT_DATE, 'yyyy/mm/dd');
-- SELECT TO_CHAR(AGE(date '1999/03/19', date '1800/01/01'), 'YY')

-- Date exercises:
-- SELECT * FROM employees WHERE EXTRACT(YEAR FROM AGE(birth_date)) > 60;       -- Trabajadores mayores a 60 años
-- SELECT * FROM employees WHERE birth_date < now() - interval '61 years';      -- Opción 2 con INTERVAL
-- SELECT count( * ) FROM employees WHERE EXTRACT(MONTH FROM hire_date) = 2;    -- Empleados contratados en febrero
-- SELECT count( * ) FROM employees WHERE EXTRACT(MONTH FROM birth_date) = 11;  -- Empleados nacidos en noviembre
-- SELECT MAX(AGE(birth_date)) FROM employees;
-- SELECT EXTRACT(YEAR FROM hire_date) AS "YEAR", EXTRACT(MONTH FROM hire_date) AS "MONTH" FROM employees

-- DISTINCT KEYWORD
--SELECT count(*), count(DISTINCT salary) AS "Distinct" FROM salaries;        -- 

-- SORTING DATA
-- SELECT * FROM salaries ORDER BY salary DESC
-- SELECT * FROM employees ORDER BY first_name ASC, last_name DESC;
-- SELECT * FROM employees ORDER BY LENGTH(first_name) asc;

-- SELECT a.first_name, b.salary FROM employees as a, salaries as b; 
/*
SELECT a.emp_no, b.salary, b.from_date FROM employees as a, salaries as b
WHERE a.emp_no = b.emp_no
ORDER BY a.emp_no;
*/

--Exercise: INNER JOIN
/*
SELECT a.emp_no, CONCAT(a.first_name, a.last_name) as "name", b.salary, c.title, c.from_date AS "promoted on"
FROM employees AS a
INNER JOIN salaries AS b ON a.emp_no = b.emp_no
INNER JOIN titles AS c ON c.emp_no = a.emp_no           -- ON puede seguirse con AND
    AND c.from_date = (b.from_date + interval '2 days')     -- title change always follows 2 days after the raise
ORDER BY a.emp_no;
*/

-- REVISAR ESTE EJEMPLO!!!!
/*
SELECT a.emp_no, 
       CONCAT(a.first_name, a.last_name) as "name",
       b.salary,
       coalesce(c.title, 'No title change'),
       coalesce(c.from_date::text, '-') AS "title taken on"
FROM employees AS a
INNER JOIN salaries AS b ON a.emp_no = b.emp_no
INNER JOIN titles AS c
ON c.emp_no = a.emp_no AND (
   c.from_date = (b.from_date + interval '2 days') OR
   c.from_date = b.from_date
)
ORDER BY a.emp_no;
*/

-- LEFT JOIN EXERCISE
/*
--SELECT emp.emp_no, dep.emp_no 
SELECT count(emp.emp_no)
FROM employees AS emp
LEFT JOIN dept_manager AS dep ON emp.emp_no = dep.emp_no
WHERE dep.emp_no IS NULL;
*/

-- Exercise:
/*
SELECT e.emp_no, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS dp ON dp.dept_no = de.dept_no
*/
/*
SELECT e.emp_no, e.first_name, dp.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de USING(emp_no)         -- USING(emp_no)   --->   ON de.emp_no = e.emp_no
INNER JOIN departments AS dp USING(dept_no)
*/


