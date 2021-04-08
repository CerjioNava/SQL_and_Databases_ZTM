
# SQL Deep Dive

# SUMMARY:

   - SQL COMMANDS (DDL, DQL, DML, DCL)
   - AGREGGATE & SCALAR FUNCTIONS
   - LOGICAL OPERATORS (AND, OR, NOT)
   - IS (NULL, NOT NULL, TRUE, FALSE), COALESCE
   - THREE VALUED LOGIC
   - BETWEEN AND
   - IN
   - LIKE & ILIKE
   - DATES & TIMEZONES (timestamps, date operators and functions, AGE, EXTRACT, DATE_TRUNC)
   - DISTINCT
   - ORDER BY
   - MULTITABLE SELECT
   - JOINS (LEFT, RIGHT, FULL, SELF, OUTER, CROSS)
   
Nota: Estamos trabajando con la data provista en el curso.

### Using " " (for tables) instead of ' ' (for text)

--------------------------------------------------------------------------------------------------------------------------------------

## SQL COMMANDS

Los siguientes comandos son los que serán utilizados a lo largo del curso. Por supuesto, existen más.

### DDL (Data Definition Language)

   * Create
   * Alter
   * Drop
   * Rename
   * Truncate
   * Comment

### DQL (Data Query Language)

   * Select   ----->     To Retrieve Data

### DML (Data Modification Language)

   * Insert
   * Update
   * Delete
   * Merge
   * Call
   * Explain Plain
   * Lock Table

### DCL (Data Control Language)

   * Grant
   * Revoke

   Granting and revoking access to a certain data.

--------------------------------------------------------------------------------------------------------------------------------------

### Exercise: Simple Queries

   * Question 1: Give me a list of all employees in the company.

      Opción 1:      SELECT * FROM employees
      Opción 2:      SELECT * FROM "public"."employees"      (Haciendo doble click en la tabla que buscamos, rellena con el Schema)

   * Question 2: How many departments are there in the company?

      SELECT * FROM departments

   * Question 3: How many times has employee 10001 had a raise?

      SELECT * FROM salaries WHERE emp_no='10001';
      
   * Question 4: What title does 10006 have?

      SELECT title FROM titles WHERE emp_no='10006'

--------------------------------------------------------------------------------------------------------------------------------------

### Renaming Columns

No es cambiar el formato de las columnas, sino extraer la columna con un nombre distinto.

   > SELECT column as '<new name>'

   SELECT emp_no as "Employee #", birth_date as "Birthday", first_name as "First Name" FROM employees

### Concat Function / Column Concatenation

Concat es una función de SQL, recibe entradas y arroja una salida.

   > CONCAT(TEXT, TEXT)
   > CONCAT(COLUMN1, COLUMN2)

   * Question: Concatenate the first and last name of the employee into one column and rename the concatenated column.
      
      SELECT concat(first_name, ' ' , last_name) AS "Full Name" from employees

--------------------------------------------------------------------------------------------------------------------------------------

## FUNCTIONS IN SQL

Una funcíón es un conjunto de pasos que generan un solo valor. Hay dos tipos de funciones:

* Aggregate Functions:

   Operan en muchos archivos de la data y producen una salida. 
   Ejemplo: Sumar un total de una columna.

   - AVG()     -- Calcula el promedio de un conjunto de valores.
   - COUNT()   -- Conteo de filas en una tabla o conjunto.
   - MIN()     -- Devuelve el mínimo valor de un conjunto de valores.
   - MAX()     -- Devuelve el máximo valor de un conjunto de valores.
   - SUM()     -- Calcula una suma de valores.

   Mas funciones: https://www.postgresql.org/docs/12/functions-aggregate.html

   * Question 1: Get the highest salary available.

      SELECT max(salary) FROM salaries;

   * Question 2: Get the total amount of salaries paid.

      SELECT sum(salary) FROM salaries;

   * Ejemplos:

      SELECT avg(salary) FROM salaries;
      SELECT count( * ) FROM employees;
      SELECT count(emp_no) FROM employees;
      SELECT min(birth_date) FROM employees

* Scalar Functions:

   Se ejecutan en cada archivo de manera independiente y producen multiples salidas. 
   Ejemplo: La función CONCAT se ejecuta en cada fila y produce multiples salidas.

NOTA: AGGREGATE FUNCTIONS NO SE PERMITEN EN WHERE.

--------------------------------------------------------------------------------------------------------------------------------------

## AND & OR keywords

Permiten filtrar la data de una manera más específica. 
Nota: Tener en cuenta el order de operaciones. Se facilita usando paréntesis.

   * Question AND: Select the employee with the name Mayumi Schueller.

      SELECT * from employees
      -- Filtering on a single person (this is commenting between statements)
      WHERE first_name='Mayumi' AND last_name='Schueller'; 

      -- Notese que existían muchos trabajadores con nombre "Mayumi", así que usamos AND con el apellido.

   * Question OR: Filter on 2 first names.

      SELECT * FROM employees 
      WHERE (first_name='Georgi' AND last_name='Facello') 
      OR (first_name='Mayumi' AND gender='F');

### Exercise: Filtering Data
Nota: Usamos la database Store.

   * Question: How many female customers do we have from the state of Oregon (OR) and New York (NY).

      SELECT count( * ) FROM customers WHERE gender='F' AND (state='OR' or state='NY'); 

## NOT keyword

Permite filtrar la data sin un tipo de data en específico.
   
   * Question: How many customers aren't 55?

      SELECT count( * ) FROM customers WHERE NOT age=55;

### Comparison Operators

   * <         -- Menor que
   * >         -- Mayor que
   * =         -- Igual que
   * >=        -- Mayor o igual que
   * <=        -- Menos o igual que
   * <> or !=  -- Distinto que

   * Question: Who between the ages of 30 and 50 has an income less than 50 000?

      SELECT COUNT(income) FROM customers WHERE (age >= 30 and age <= 50) AND income < 50000;

--------------------------------------------------------------------------------------------------------------------------------------

## LOGICAL OPERATORS (AND, OR, NOT)

   * AND: Si ambas expresiones booleanas son True, entonces devuelve el resultado.
   * OR:  Si alguna de las expresiones booleanas son True, entonces devuelve los resultados.
   * NOT: Si alguna de las expresiones no es True, entonces devuelve los resultados.

### Order of Operations
   
Como se llevan a cabo las operaciones?

   > FROM ---> WHERE ---> SELECT          **(IMPORTANTE)**

### Operator Precedence

Un statement que tenga multiples operadores es evaluado según la prioridad de los operadores. 

https://www.postgresql.org/docs/12/sql-syntax-lexical.html#SQL-PRECEDENCE

   * Orden de prioridad:

      1. Parenthesis
      2. Arithmetic Operators 
         a. Multiplicación/División
         b. Substracción/Adición
      3. Concatenation Operators
      4. Comparison Conditions
      5. IS NULL, LIKE, NOT IN, etc.
      6. NOT
      7. AND
      8. OR

Nota: Si los operadores tienen igual prioridad, entonces los operadores son evaluados direccionalmente, de izquierda a derecha o de derecha a izquierda, dependiendo de su "Asociatividad".

   * Question: What was our total sales in June of 2004 for orders over 100 dollars?

      SELECT SUM(totalamount) from orders
      WHERE (orderdate >= '2004-06-01' AND orderdate <= '2004-06-30') AND totalamount > 100

--------------------------------------------------------------------------------------------------------------------------------------

## CHECKING FOR EMPTY (NULL) VALUES

Cuando a una fila le hace hace falta un valor, se considera vacio o null.
Es distinto un valor que se vea vacío como solo colocar un espacio en blanco '   ', o que realmente sea 'null'.
Al crear una tabla, por default cada campo es null.

Notas: 

   - Null siempre devuelve Null, aun si haces "Null = Null" o "Null != Null", siempre devolverá Null.
   - No importa que hagas con un valor null. Un valor Null siempre será Null.
   - En SQL, un valor NULL "PUEDE SER LO CUALQUIER COSA".
   - Nada es igual a NULL, ni siquiera NULL. Cada Null puede ser diferente.

### When to use NULL

   * Is my data optional or required?
   * Future info?
   * Rational? Consecuences?

Importante: Siempre verificar si existen o no valores Null.

--------------------------------------------------------------------------------------------------------------------------------------

## IS keyword

Permite filtrar valores que son Null, Not Null, True o False.

   > SELECT * FROM <table> WHERE <field> IS NOT NULL;

### IS (NULL, NOT NULL, TRUE, FALSE)

IS NULL verifica por Nulls en la tabla.

Ejemplos:
   SELECT * FROM employees WHERE gender IS NULL;
   SELECT * FROM employees WHERE gender IS NOT NULL;
   SELECT * FROM salaries WHERE salary<39000 IS TRUE;

--------------------------------------------------------------------------------------------------------------------------------------

## NULL VALUE SUBSTITUTION

   Se trata de reemplazar valores NULL por otro valor para operar en la data. Esto se puede hacer con al función COALESCE.

### COALESCE
   
Devuelve el primer valor NON-NULL en una lista.

   > SELECT coalesce(<column1>, <column2>, ... , 'Empty') AS columns_alias FROM <table>;

Ejemplos:
   SELECT coalesce(name, 'no name available') FROM "Student";
   SELECT sum(coalesce(age, 20)) FROM "Student";
   SELECT id, coalesce(name, 'fallback'), coalesce(lastName, 'lastName'), age FROM "Student";

--------------------------------------------------------------------------------------------------------------------------------------

## THREE-VALUED LOGIC

A parte de True y False, el resultado de una expresión lógica puede ser "desconocido (Unknown)" también.

Ejemplo: NULL  = NULL         --->  Devuelve NULL
         NULL != NULL         --->  Devuelve NULL
         (NULL=1) OR (1=1)    --->  Devuelve TRUE
         (NULL=1) AND (0=1)   --->  Devuelve NULL

--------------------------------------------------------------------------------------------------------------------------------------

## BETWEEN AND

Es una manera sencilla de "Match" en un rango de valores. Es igual que usar comparadores lógicos.

   > SELECT <column> FROM <table> WHERE <column> BETWEEN X AND Y;

   * Question 1: Who between the ages of 30 and 50 has an income less than 50 000? (include 30 and 50 in the results)
         
         SELECT * FROM customers WHERE age BETWEEN 30 AND 50 AND income < 50000;

   * Question 2: What is the average income between the ages of 20 and 50? (Including 20 and 50)

         SELECT AVG(income) FROM customers WHERE age BETWEEN 20 AND 50;

--------------------------------------------------------------------------------------------------------------------------------------

## IN Keyword

Verifica si un valor coincide con algún valor en una lista de valores. Sirve para filtrar multiples valores.

   > SELECT * FROM <table> WHERE <column> IN (value1, value2, ...);

Ejemplo:

   SELECT * FROM employees WHERE emp_no IN (10001, 10006, 11008)                 -- Más sencillo
   SELECT * FROM employees WHERE emp_no=10001 OR emp_no=10006 OR emp_no=11008    -- Que esto

   * Question: How many orders were made by customer 7888, 1082, 12808, 9623
      
      SELECT COUNT(orderid) FROM orders WHERE customerid IN (7888, 1082, 12808, 9623)

   * Question: How many cities are in the district of Zuid-Holland, Noord-Brabant and Utrecht?

      SELECT COUNT(id) FROM city WHERE district IN ('Zuid-Holland', 'Noord-Brabant', 'Utrecht');

--------------------------------------------------------------------------------------------------------------------------------------

## LIKE Keyword (Partial Matching)

Si no sabes exactamente que estas buscando, puedes hacer observaciones parciales.

   * Question: Get everyone who's name start with 'M'.

      SELECT first_name FROM employees WHERE first_name LIKE 'M%'

   * Question: Get everyone who's name ends with 'a'.

      SELECT first_name FROM employees WHERE first_name LIKE '%a'

### Pattern Matching

Pattern wildcards are placeholders that we can put in a LIKE operator to match parts of strings.

   * %   --->   Cualquier cantidad de caracteres.
   * _   --->   1 caracter.

Ejemplos:

   * LIKE '2%'       --->   Campos que inician con 2.
   * LIKE '%2'       --->   Campos que terminan con 2.
   * LIKE '%2%'      --->   Campos que tienen un 2 en algún lugar del valor.
   * LIKE '_00%'     --->   Campos que tienen dos ceros luego del primer caractér, y cualquier cosa después.
   * LIKE '%200%'    --->   Campos que tienen un 200 en algún lugar del valor.
   * LIKE '2_%_%'    --->   Encuentra cualquier valor que inicie con 2 y posee al menos 3 caracteres de longitud.
   * LIKE '2___3'    --->   Encuentra cualquir valor de 5 numeros que inicia con 2 y termina con 3.

Nota: Postgres LIKE solo hace comparación de texto, se debe hacer "casting" en texto de lo que usemos.

### Casting to text

Hay dos maneras de hacer casting a texto:

   > CAST(<column> AS text);
   > <column>::text;

   * Question: Which states have phone numbers starting with 302?

      SELECT coalesce(state, 'No State') as "State" FROM customers WHERE phone::text LIKE '302%';

## ILIKE keyword (Case insensitive matching)

Funciona igual que LIKE, solo que no es sensible. 
Por ejemplo, ILIKE 'MO%' puede obtener valores que inicien con Mo, mo, MO, mO.

Más ejercicios LIKE & ILIKE: 
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Like%20Operator/answers.sql

   * Question: Find the age of all employees who's name starts with M.

      SELECT emp_no, first_name, EXTRACT (YEAR FROM AGE(birth_date)) as "age" FROM employees WHERE first_name ILIKE 'M%';
      
      Nota: EXTRACT(part FROM date) extrae un valor específico del "date", según se especifique "part".

--------------------------------------------------------------------------------------------------------------------------------------

## DATES AND TIMEZONES

   * GMT (Greenwich Mean Time) is a Time Zone.
   * UTC (Universal Coordinate Time) is a Time Standard.

   > SET TIME ZONE 'UTC';     -- Set our time zone only for the session.
   > SHOW TIMEZONE;           -- 

Nota: Postgres almacena todo en formato UTC, siempre que no se especifique lo contrario.

### Setting Up Timezones

   > ALTER USER postgres SET timezone='UTC';    -- Altera el usuario con el que iniciamos sesión.

### Manipulating dates

IMPORTANTE: PostgreSQL utiliza el formato ISO-8601 como estandar para representar fechas y horas. Es decir:

   > YYYY-MM-DDTHH:MM:SS
   > 2017-08-17T12:47:16+02:00      (+02:00 representa el timezone del UTC, sin ello, supone que estamos en el centro)

### Timestamps

Es una fecha con tiempo y timezone.

   > SELECT now()    -- Devuelve la fecha en formato ISO-8601. 

Sirve por ejemplo, para registrar el timestamp de alguna transacción.

Ejemplo:
      CREATE TABLE timezones (
         ts TIMESTAMP WITHOUT TIME ZONE,  
         tz TIMESTAMP WITH TIME ZONE
      )
      INSERT INTO timezones VALUES(
         TIMESTAMP WITHOUT TIME ZONE '2000-01-01 10:00:00-05',       -- Sin el timezone, se ignora el '-05'
         TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00-05'
      )
      SELECT * FROM timezones

NOTA: Utilizar timestamps o dates depende de la información que estas almacenando.

### Date Operators and Functions

   * Current Date: Hay dos maneras de obtener la fecha actual.

      > SELECT NOW()::date;      -- Hace casting del formato ISO-8601 a formato date.  (2021-03-18)

      > SELECT CURRENT_DATE;     -- Obtiene la fecha actual.                           (2021-03-18)

   * Formatting: Para pasarle un formato específico a la fecha.

      > SELECT TO_CHAR(CURRENT_DATE, 'dd/mm/yyyy');                                    (18/03/2021)

      > SELECT TO_CHAR(CURRENT_DATE, 'yyyy/mm/dd');                                   (2021/03/18)

   * Format Modifiers:

      - D: Day   
      - M: Month    
      - Y: Year

   NOTA: Si revisamos la documentación de Postgres, se puede observar el resto de modificadores, hay muchos. 
         Por ejemplo:

         SELECT TO_CHAR(CURRENT_DATE, 'DDD');      -- Day of the Year
         SELECT TO_CHAR(CURRENT_DATE, 'WW');       -- Week of the Year

### Date DIFFERENCE and Casting (date & AGE)

Substrayendo fechas devuelve la diferencia en días.

   * To Date:

      > SELECT date '1800/01/01';         -- Devuelve la fecha casteada al formato de Postgres (1800-01-01)

   * Calculate Age:

      > SELECT AGE('1800/01/01')          -- ESTO DEVUELVE ERROR, DEBEMOS CASTEAR A DATE. 

      > SELECT AGE(date '1800/01/01')     -- Devuelve años, meses y días.

      > SELECT AGE(date '1999/03/19', date '1800/01/01')  -- Devuelve diferencia entre dos dates en años, meses y días.

### Extract

Si quisiera extraer un dato específico de una fecha, se puede usar EXTRACT.

   > SELECT EXTRACT (DAY FROM date '1999/03/19') AS DAY
   > SELECT EXTRACT (MONTH FROM date '1999/03/19') AS MONTH
   > SELECT EXTRACT (YEAR FROM date '1999/03/19') AS YEAR

### Round a Date (DATE_TRUNC)

Redondea hacia abajo.

   > SELECT DATE_TRUNC('year', date '1999/03/19')     -- Devuelve 1999-01-01
   > SELECT DATE_TRUNC('month', date '1999/03/19')    -- Devuelve 1999-03-01
   > SELECT DATE_TRUNC('day', date '1999/03/19')      -- Devuelve el mismo 1999-03-19, a menos que haya un timestamp.

### Interval

Los intervalos permiten escribir queries de una manera simple para almacenar y manipular un período de tiempo en años, meses, días, horas, minutos, segundos, etc. Los intervalos son ajustables.

Ejemplo:

   SELECT * FROM orders
   WHERE purchaseDate <= now() - interval '30 days';

   INTERVAL ('1 year 2 months 3 days');
   INTERVAL ('2 weeks ago');
   INTERVAL ('1 year 3 hours 20 minutes');

EJERCICIOS DE DATES:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Date%20Filtering/answers.sql

   * Question 1: Get me all the employees above 60.

      SELECT * FROM employees WHERE EXTRACT(YEAR FROM AGE(birth_date)) > 60;     -- Opción 1 con EXTRACT
      SELECT * FROM employees WHERE birth_date < now() - interval '60 years';    -- Opción 2 con INTERVAL

   * Question 2: How many employees were hired in February?

      SELECT count( * ) FROM employees WHERE EXTRACT(MONTH FROM hire_date) = 2;

   * Question 3:  How many employees were born in November?

      SELECT count( * ) FROM employees WHERE EXTRACT(MONTH FROM birth_date) = 11;

   * Question 4: Who is the oldest employee?

      SELECT MAX(AGE(birth_date)) FROM employees;

   * Question 5: Question: How many orders were made in January 2004?
      
      SELECT COUNT(orderid) FROM orders 
      WHERE DATE_TRUNC('month', orderdate) = date '2004-01-01';                           -- Opcion 1: DATE_TRUNC
      WHERE EXTRACT(YEAR FROM orderdate) = 2004 AND EXTRACT(MONTH FROM orderdate) = 01;   -- Opcion 2: EXTRACT


--------------------------------------------------------------------------------------------------------------------------------------

## DISTINCT keyword

Remueve los duplicados (Mantiene una fila por cada grupo de duplicados).

Multiples columnas pueden ser evaluadas según la combinación de las columnas.

   > SELECT DISTINCT <col1>, <col2>, ... FROM <table>;

Ejemplo:
   
   SELECT count(*), count(DISTINCT salary) AS "Distinct" FROM salaries;

Ejercicios DISTINCT: 
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Distinct/answers.sql

--------------------------------------------------------------------------------------------------------------------------------------

## SORTING DATA (ORDER BY)

Ordenar data de manera ascendente o descendente por columna.

   > SELECT * FROM <table> ORDER BY <column> [ASC/DESC]

Ejemplos:

   SELECT * FROM salaries ORDER BY salary DESC;
   SELECT * FROM employees ORDER BY first_name ASC, last_name DESC;

También se puede ordenar con expresiones, por ejemplo:

   > SELECT * FROM <table> ORDER BY LENGTH(<column>);

Nota: ASC es el default.

   * Question: Sort employees who's name starts with a "k" by hire_date

      SELECT * FROM employees WHERE first_name ILIKE 'k%' ORDER BY hire_date;

Ejercicios:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Order%20By/answers.sql

--------------------------------------------------------------------------------------------------------------------------------------

## MULTI TABLE SELECT

Se refiere a trabajar con varias tablas a la vez, manipular y combinar la data de multiples tablas al mismo tiempo.

Ejemplo:

   SELECT a.emp_no, CONCAT(a.first_name, a.last_name), b.salary
   FROM employees as a, salaries as b
   WHERE a.emp_no = b.emp_no;

   SELECT a.emp_no, b.salary 
   FROM employees as a, salaries as b
   WHERE a.emp_no = b.emp_no
   ORDER BY a.emp_no;

NÓTESE como en la clausula FROM se asigna un nombre a cada tabla.

NOTA: Ambas tablas se relacionan mediante el PRIMARY KEY (emp_no)
      Es necesario añadir la clausula WHERE para que funcione de manera optima y no se crashee.

Básicamente se combinaron las columnas de una tabla con los de la otra tabla. La manera más común de llevar a cabo esto, es relacionar el PRIMARY KEY con el FOREIGN KEY (JOINS).

### INNER JOIN

Si posees columnas que relacionan la columna de una tabla 'A' a una tabla 'B', puedes realizar una Inner Join (Unión interna).
Es decir, una Inner Join encuentra la intersección entre dos datasets según su relación y devuelve ese subset.

Del ejemplo anterior de la multitabla, se puede hacer distinto:

   SELECT a.emp_no, CONCAT(a.first_name, a.last_name) as "name", b.salary
   FROM employees as a 
   INNER JOIN salaries as b      -- Join salaries to employees (in the from)
   ON b.emp_no = a.emp_no        -- Do it on the emp_no
   ORDER BY a.emp_no ASC;        -- Ordenar

- La sintaxis de INNER JOIN es más legible que usar WHERE, ya que refleja que es lo que se va a unir y como.
- ON sirve para definir las relaciones.
- IMPORTANTE decidir cual tabla va a la izquierda y cual a la derecha.

NOTA: El resultado siempre se devuelve desordenado, así que se debe ordenar.

   * Question: What if we only want to know the raises from a promotion.

      SELECT a.emp_no, CONCAT(a.first_name, a.last_name) as "name", b.salary, c.title, c.from_date AS "promoted on"
      FROM employees AS a
      INNER JOIN salaries AS b ON a.emp_no = b.emp_no
      INNER JOIN titles AS c ON c.emp_no = a.emp_no           -- ON puede seguirse con AND
         AND c.from_date = (b.from_date + interval '2 days')     -- title change always follows 2 days after the raise
      ORDER BY a.emp_no;

   * ANALIZAR ESTE EJEMPLO:

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

### SELF JOIN

Self Join puede unir una tabla consigo misma.
Esto puede lograrse cuando una tabla posee una FOREIGN KEY que referencia a su PRIMARY KEY.

Ejemplo:
   
   -- Opcion 1
   SELECT a.id, a.name AS "employee", b.name AS "supervisor name"
   FROM employee AS a, employee AS b                              -- Seleccionas dos veces la misma tabla
   WHERE a.supervisorID = b.id;

   -- Opcion 2
   SELECT a.id, a.name AS "employee", b.name AS "supervisor name"
   FROM employee AS a
   INNER JOIN employee AS b                             
   ON a.supervisorID = b.id;

### OUTER JOIN

Se puede añadir la data que no posee match.
Todo valor que no coincida (no match), será Null.
Existen dos tipos de outer joins:

   * LEFT OUTER JOIN: Añade la data que no posee match desde la tabla A. 
                      Devuelve todas las filas de la tabla izquierda, esten conectadas o no con la derecha (sin coincidencia, los deja en null).

      Ejemplo: SELECT * 
               FROM <table A> AS a 
               LEFT [OUTER] JOIN <table B> AS b
               ON a.id = b.id;

      * Question: How many employees aren't managers?

         SELECT COUNT(emp.emp_no) 
         FROM employees AS emp
         LEFT JOIN dept_manager AS dep ON emp.emp_no = dep.emp_no
         WHERE dep.emp_no IS NULL;

      * Question:  I need every salary raise and also know which ones where a promotion. (Casi igual al ejemplo en INNER)

         SELECT a.emp_no, 
               CONCAT(a.first_name, a.last_name) as "name",
               b.salary,
               coalesce(c.title, 'No title change'),
               coalesce(c.from_date::text, '-') AS "title taken on"
         FROM employees AS a
         INNER JOIN salaries AS b ON a.emp_no = b.emp_no
         LEFT JOIN titles AS c                                       -- AQUI EL CAMBIO
         ON c.emp_no = a.emp_no AND (
            c.from_date = (b.from_date + interval '2 days') OR
            c.from_date = b.from_date
         )
         ORDER BY a.emp_no;

   * RIGHT OUTER JOIN: Añade la data que no posee match desde la tabla b.
                       Devuelve todas las filas de la tabla derecha, esten conectadas o no con la izquierda (sin coincidencia, los deja en null).

       Ejemplo: SELECT * 
                FROM <table A> AS a 
                RIGHT [OUTER] JOIN <table B> AS b
                ON a.id = b.id;

### Less Common Joins

   * CROSS JOIN: Crea una combinación de cada fila de la tabla A con cada fila de la tabla B. 
                 Se le conoce también como "producto cartesiano".
                 Ambas tablas deben tener la misma cantidad de datos.

   * FULL OUTER JOIN: Devuelve todos los resultados de ambas tablas sin importar si hay match o no. 
                      Donde no exista match, devolverá Null.
                      No es obligatorio que ambas tablas tengan la misma cantidad de datos.

* Question 1: Get all orders from customers who live in Ohio (OH), New York (NY) or Oregon (OR) state ordered by orderid.

   SELECT c.firstname, c.lastname, o.orderid FROM orders AS o
   INNER JOIN customers AS c ON o.customerid = c.customerid
   WHERE c.state IN ('NY', 'OH', 'OR')
   ORDER BY o.orderid;

* Question 2: Show me the inventory for each product.

   SELECT p.prod_id, i.quan_in_stock
   FROM products as p
   INNER JOIN inventory AS i ON p.prod_id = i.prod_id 

* Question 3: Show me for each employee which department they work in.

   SELECT e.emp_no, e.first_name, dp.dept_name
   FROM employees AS e
   INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
   INNER JOIN departments AS dp ON dp.dept_no = de.dept_no

JOINS EXERCISES:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Joins/Inner%20Join/answers.sql

NOTA: JOIN es igual que INNER JOIN.

### USING keyword

Simplifica la sintaxis del JOIN (En la parte ON).
Si la columna existe entre ambas tablas, puede usarse.
Sirve para joins simples.

Ejemplo: PARECIDO a la question 3 anterior.
   
   SELECT e.emp_no, e.first_name, de.dept_name
   FROM employees AS e
   INNER JOIN dept_emp AS de USING(emp_no)         -- USING(emp_no)   --->   ON de.emp_no = e.emp_no
   INNER JOIN departments AS dp USING(dept_no)

--------------------------------------------------------------------------------------------------------------------------------------


