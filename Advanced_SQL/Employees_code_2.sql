-- GROUP BY
-- Question: How many employees worked in each department.
/*
SELECT dept_no, COUNT(emp_no) 
FROM dept_emp 
GROUP BY dept_no
ORDER BY dept_no;
*/

-- QUESTION 2: Show me all the employees, hired after 1991 and count the amount of positions they've had
/*
SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS "Amount of titles"
FROM employees AS e
JOIN titles AS t USING(emp_no)
WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
ORDER BY e.emp_no;
*/

-- Question 2:  Show me all the employees that work in the department development and the from and to date.
-- Department development es d005, se observa en la tabla "departments".
/*
SELECT e.emp_no, de.from_date, de.to_date
FROM employees as e
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no, de.from_date, de.to_date
ORDER BY e.emp_no, de.to_date;
*/

-- HAVING
-- Example: # of employees per department, departments with more than 25000 employees, and F.
/*
SELECT d.dept_name, COUNT(e.emp_no) AS "# of employees per department"
FROM employees AS e 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
WHERE e.gender = 'F'
GROUP BY d.dept_name
HAVING COUNT(e.emp_no) > 25000           -- Para ver solo los departamentos con más de 25mil employees
*/

-- Question: Show me all the employees, hired after 1991, that have had more than 2 titles.
/*
SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS "Amount of titles"
FROM employees AS e
JOIN titles AS t USING(emp_no)
WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
GROUP BY e.emp_no
HAVING count(t.title) > 2
ORDER BY e.emp_no;
*/

-- Question:  Show me all the employees that have had more than 15 salary changes that work in the department development.
/*
SELECT e.emp_no, e.first_name, e.last_name, COUNT(s.from_date) as "CHANGES"
FROM employees AS e 
JOIN salaries AS s USING(emp_no)
JOIN dept_emp AS de USING(emp_no)
WHERE de.dept_no = 'd005'
GROUP BY e.emp_no
HAVING COUNT(s.from_date) > 15
ORDER BY e.emp_no;
*/

-- WINDOW FUNCTION
-- Ejemplo: PARTITION BY
/*
SELECT * ,   
       AVG(salary) OVER (
            PARTITION BY d.dept_name         -- Se agrupan por departamento cada promedio.
            ) 
FROM salaries
JOIN dept_emp AS de USING (emp_no)
JOIN departments AS d USING (dept_no)
*/
-- Ejemplo: ORDER BY
/*
SELECT emp_no,  
       COUNT(salary) OVER (
            PARTITION BY emp_no
            --ORDER BY emp_no         -- Se agrupan por departamento cada promedio.
            ) 
FROM salaries
*/
-- Ejemplo:
/*
SELECT emp_no,  
       salary,
       COUNT(salary) OVER (
            PARTITION BY emp_no
            ORDER BY salary
            ) 
FROM salaries
*/

-- Example: Solving for Current Salary:
/*
SELECT DISTINCT e.emp_no,
       e.first_name,
       d.dept_name,
       LAST_VALUE(s.salary) OVER (
           PARTITION BY e.emp_no
           ORDER BY s.from_date
           RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING   -- CURRENT ROW AND UNBOUNDED FOLLOWING
       ) AS "Current Salary"
FROM salaries AS s
JOIN employees AS e USING(emp_no)   
JOIN dept_emp AS de USING(emp_no)
JOIN departments AS d USING(dept_no)
ORDER BY e.emp_no;
*/











