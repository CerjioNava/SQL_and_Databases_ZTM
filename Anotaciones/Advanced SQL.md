# Advanced SQL

# SUMMARY:

   - GROUP BY
   - HAVING
   - UNION & GROUPING SETS
   - ROLL UP
   - WINDOW FUNCTIONS (PARTITION BY, ORDER BY, FRAMING, FUNCTIONS FOR WINDOW FUNCTIONS)
   - CONDITIONAL STATEMENTS (CASE STATEMENT, NULLIF STATEMENT)
   - VIEWS
   - INDEXES (TYPES, EXPLAIN ALAYZE, ALGORITHMS)
   - EXPLAIN ANALYZE
   - SUBQUERIES (TYPES. USED ON: WHERE, SELECT, FROM, HAVING y JOIN. SUBQUERIES OPERATORS)


--------------------------------------------------------------------------------------------------------------------------------------

## GROUP BY keyword

Summarize or aggregate data by groups. 
GROUP BY divide la data en grupos de manera que podamos aplicar funciones a cada grupo en vez de a toda la tabla.
Es decir, GROUP BY se utiliza casi exclusivamente con AGGREGATE FUNCTIONS.

   * Question: How many employees worked in each department.

   		SELECT dept_no, COUNT(emp_no) 		-- Al agrupar por dept_no, la función COUNT se ejecuta en cada grupo individual.
   		FROM dept_emp 
   		GROUP BY dept_no
   		ORDER BY dept_no;

**NOTA: La columna «dept_emp.emp_no» debe aparecer en la cláusula GROUP BY o ser usada en una función de agregación.
	  	Es decir, cada columna que no pertenezca a la clausula GROUP BY, debe aplicar una función.
	  	Al agrupar, toda la data de un grupo se convierte en un solo "record".**

GROUP BY utilizes a SPLIT-APPLY-COMBINE strategy:

   - SPLIT: Donde divide en grupos con valores.
   - APPLY: Aplica una aggregate function sobre las columnas no agrupadas.
   - COMBINE: Combina los grupos con sus salidas, en una sola salida.

### ORDER OF OPERATIONS

   > FROM  --->  WHERE  --->  GROUP BY  --->  SELECT  --->  ORDER BY

EJERCICIOS: 
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Group%20By/answers.sql

   * Question 1: Show me all the employees, hired after 1991 and count the amount of positions they've had

   	SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS "Amount of titles"
		FROM employees AS e
		JOIN titles AS t USING(emp_no)
		WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
		GROUP BY e.emp_no
		ORDER BY e.emp_no;

	NOTA: Se pudo añadir first_name y last_name PROBABLEMENTE ya que no cambian.
   
   * Question 2:  Show me all the employees that work in the department development and the from and to date.

   		SELECT e.emp_no, de.from_date, de.to_date
   		FROM employees as e
   		JOIN dept_emp AS de USING(emp_no)
   		WHERE de.dept_no = 'd005'
   		GROUP BY e.emp_no, de.from_date, de.to_date
   		ORDER BY e.emp_no, de.to_date;

NOTA: Si hacemos multiples agrupaciones, se hace alguna especie de arbol. Es decir, supongamos que:

   Col1: A, B, C.
   Col2: 1, 2, 3.
   Col3: X, Y, Z.

   Al hacer "GROUP BY col1, col2, col3", se obtiene como resultado algo como:

   A 1 X
   A 1 Y
   A 1 Z
   A 2 X
   A 2 Y
   ...
   A 3 Z
   B 1 X
   B 1 Y
   ...
   B 3 Z
   C 1 X
   C 2 Y
   ...
   C 3 Z

--------------------------------------------------------------------------------------------------------------------------------------

## HAVING keyword

Se sabe que WHERE aplica filtros a cada fila por individual.
Mientras que HAVING aplica filtros a todo el grupo como un todo.

### ORDER OF OPERATIONS

   > FROM  --->  WHERE  --->  GROUP BY  --->  HAVING  --->  SELECT  --->  ORDER


   * Question: # of employees per department, departments with more than 25000 employees, and F.
	   
	   SELECT d.dept_name, COUNT(e.emp_no) AS "# of employees per department"
	   FROM employees AS e 
	   INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
	   INNER JOIN departments AS d ON de.dept_no = d.dept_no
	   WHERE e.gender = 'F'
	   GROUP BY d.dept_name
	   HAVING COUNT(e.emp_no) > 25000           -- Para ver solo los departamentos con más de 25mil employees. Aplica por grupo.

EJERCICIOS:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Having/answers.sql

   * Question: Show me all the employees, hired after 1991, that have had more than 2 titles.
	   
	   SELECT e.emp_no, e.first_name, e.last_name, COUNT(t.title) AS "Amount of titles"
	   FROM employees AS e
	   JOIN titles AS t USING(emp_no)
	   WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
	   GROUP BY e.emp_no
	   HAVING count(t.title) > 2
	   ORDER BY e.emp_no;
   
   * Question:  Show me all the employees that have had more than 15 salary changes that work in the department development.

      SELECT e.emp_no, e.first_name, e.last_name, COUNT(s.from_date) as "CHANGES"
      FROM employees AS e 
      JOIN salaries AS s USING(emp_no)
      JOIN dept_emp AS de USING(emp_no)
      WHERE de.dept_no = 'd005'
      GROUP BY e.emp_no
      HAVING COUNT(s.from_date) > 15
      ORDER BY e.emp_no;

--------------------------------------------------------------------------------------------------------------------------------------

## UNION & GROUPING SETS

* UNION: Permite ejecutar multiples queries y combinar los resultados en una tabla

* UNION ALL: Igual que UNION, pero no remueve los records duplicados.

   * Question: What if we want to combine the results of multiple groupings?

Ejemplo UNION:

   SELECT NULL AS "prod_id", sum(ol.quantity)
   FROM orderlines AS ol
   
   UNION
   
   SELECT prod_id AS "prod_id", sum(ol.quantity)
   FROM orderlines AS ol 
   GROUP BY prod_id
   ORDER BY prod_id DESC;

* GROUPING SETS: Permite combinar las salidas de distintos grupos. Funciona igual que UNION.

Ejemplo GROUPING SETS: (Misma salida que el anterior)

   SELECT prod_id AS "prod_id", sum(ol.quantity)
   FROM orderlines AS ol 
   GROUP BY 
   	  GROUPING SETS (
   		(),											-- Sin agrupar nada, expresa solo la suma total.
   		(prod_id)									-- Agrupando por prod_id, expresa la suma por grupo.
   	  )
   ORDER BY prod_id DESC;

Ejemplo 2:

   SELECT prod_id AS "prod_id", orderlineid, sum(ol.quantity)
   FROM orderlines AS ol 
   GROUP BY 
   	  GROUPING SETS (
   		(),											-- Sin agrupar nada, expresa solo la suma total.
   		(prod_id),									-- Agrupando por prod_id, expresa la suma por grupo.
   		(orderlineid)
   	  )
   ORDER BY prod_id DESC, orderlineid DESC;

NOTA: Para llevar a cabo el union, ya que se va a combinar una tabla con otra, deben poseer las mismas columnas, es decir, mismo identificador de columna. Para el ejemplo anterior, en ambas tablas se imprimian "prod_id" y la función de sum().

--------------------------------------------------------------------------------------------------------------------------------------

## ROLL UP

ROLLUP devuelve todas las posibles combinaciones para un agrupamiento.

Véase un ejemplo sin ROLL UP:

   SELECT  EXTRACT (YEAR FROM orderdate) AS "year",
   		   EXTRACT (MONTH FROM orderdate) AS "month",
   		   EXTRACT (DAY FROM orderdate) AS "day",
   		   sum(ol.quantity)
   FROM orderlines as ol
   GROUP BY
   		GROUPING SETS (
   			(EXTRACT (YEAR FROM orderdate)),			
   			(
   				EXTRACT (YEAR FROM orderdate),
   				EXTRACT (MONTH FROM orderdate)
   			),
   			(
   				EXTRACT (YEAR FROM orderdate),
   				EXTRACT (MONTH FROM orderdate),
   				EXTRACT (DAY FROM orderdate)
   			),
   			(
   				EXTRACT (MONTH FROM orderdate),
   				EXTRACT (DAY FROM orderdate)
   			),
   			(EXTRACT (MONTH FROM orderdate)),
   			(EXTRACT (DAY FROM orderdate)),
   			()
   		)
   	ORDER BY
   		EXTRACT (YEAR FROM orderdate),
   		EXTRACT (MONTH FROM orderdate),
   		EXTRACT (DAY FROM orderdate);

Véase un ejemplo con ROLL UP:

   SELECT  EXTRACT (YEAR FROM orderdate) AS "year",
   		   EXTRACT (MONTH FROM orderdate) AS "month",
   		   EXTRACT (DAY FROM orderdate) AS "day",
   		   sum(ol.quantity)
   FROM orderlines as ol
   GROUP BY
   		ROLLUP (
   			EXTRACT (YEAR FROM orderdate),			
   			EXTRACT (MONTH FROM orderdate),
   			EXTRACT (DAY FROM orderdate) 
   		)
   	ORDER BY
   		EXTRACT (YEAR FROM orderdate),
   		EXTRACT (MONTH FROM orderdate),
   		EXTRACT (DAY FROM orderdate);

--------------------------------------------------------------------------------------------------------------------------------------

## WINDOW FUNCTIONS

Window Functions crean una nueva columna basada en funciones ejecutadas en un subset o "ventana" de la data.
Se aplica sobre la data completa luego de los filtros pero antes de los límites.
Suelen ser utilizadas para realizar cálculos analíticos.
La cláusula OVER determina la ventana.

   > window_function(arg1, arg2, ...) OVER (
   		[PARTITION BY partition_expression]
   		[ORDER BY sort_expression [ASC | DESC] [NULLS {FIRST | LAST}]]
   		)

Ejemplo simple:

   SELECT *,
   		  MAX(salary) OVER () 
   FROM salaries;
   -- WHERE salary < 70000
   -- LIMIT 100

¿Como aplicamos funciones a un set de filas relacionadas con la fila actual?

Question: Obtener el salario promedio por departamento? (FACIL)

   SELECT d.dept_name, ROUND(AVG(s.salary))
   FROM salaries AS s
   JOIN dept_emp AS de USING(emp_no)
   JOIN departments AS d USING(dept_no)
   GROUP BY dept_no, dept_name

Question 2: Ahora desde el anterior ejemplo, añade el promedio de CADA SALARIO, de manera que se pueda visualizar que tan alejado 				esta cada empleado del promedio.

### PARTITION BY

Divide columnas en grupos para aplicar en ellos la función ventana (Opcional).

Ejemplo:
   SELECT * ,  
          AVG(salary) OVER (
               PARTITION BY d.dept_name         -- Se agrupan por departamento cada promedio.
               ) 
   FROM salaries
   JOIN dept_emp AS de USING (emp_no)
   JOIN departments AS d USING (dept_no)

### ORDER BY

Ordena los resultados y también puede utilizarse dentro de una Window Function.

Ejemplo:
   SELECT emp_no,  
          COUNT(salary) OVER (
               --PARTITION BY emp_no
               ORDER BY emp_no         -- Distinto a Partition, ORDER BY cambia el frame de la función ventana.
               ) 
   FROM salaries

NOTA: Para el ejemplo anterior, PARTITION BY devuelve la cantidad de salarios que tuvo cada empleados, mientras que ORDER BY no solo devuelve la cantidad por empleado, sino que acumula cada cantidad y la devuelve en un total.

### Framing

Cuando se utiliza una cláusula de FRAME en una función de ventana, se puede crear un subrango o FRAME.
PARTITION BY devuelve pedazos de la data según la función aplicada.

Keys:

   * ROWS or RANGE: Para utilizar un rango o filas como un frame.

   * PRECEDING: Filas antes de la actual.

   * FOLLOWING: Filas despues de la actual.

   * UNBOUNDED PRECEDING or FOLLOWING: Devuelve todo antes o después de la fila actual.

   * CURRENT ROW: La fila actual.

Ejemplo de cláusula:
   
   > PARTITION BY category ORDER BY price RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT 

NOTA: Without ORDER BY, by default the framing is usually all partition rows.
      With ORDER BY, by default the framing is usually everything BEFORE the current row and the current row.

Ejemplo:
   SELECT emp_no,  
          salary,
          COUNT(salary) OVER (
               PARTITION BY emp_no
               ORDER BY emp_no         
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
               ) 
   FROM salaries

### Example: Solving for Current Salary:

Solución:
   SELECT DISTINCT e.emp_no,
       e.first_name,
       d.dept_name,
       LAST_VALUE(s.salary) OVER (
           PARTITION BY e.emp_no
           ORDER BY s.from_date
           RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING     -- CURRENT ROW AND UNBOUNDED FOLLOWING
       ) AS "Current Salary"
   FROM salaries AS s
   JOIN employees AS e USING(emp_no)   
   JOIN dept_emp AS de USING(emp_no)
   JOIN departments AS d USING(dept_no)
   ORDER BY e.emp_no;

### Funciones para WINDOW FUNCTIONS

* Aggregate functions:
   - SUM
   - MIN
   - MAX
   - AVG
   - COUNT
   - ...

* Offset: 
   - FIRST_VALUE
   - LAST_VALUE
   - LEAD / LAG
   - ...
* Statical:
   - PERCENT_RANK
   - CUME_DIST
   - PERCENTILE_CONT
   - ...

* NTH_VALUE
* RANK
* ROW_NUMBER
* ...

#### FIRST_VALUE

Devuelve un valor evaluado contra la primera fila dentro de su partición.

   * Question: How my prices compare to the item with the lowest price in the same category.

      SELECT 
         prod_id,
         price,
         category,
         FIRST_VALUE(price) OVER (
            PARTITION BY category 
            ORDER BY price 
            -- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING   -- (NO ES NECESARIO CON FIRST VALUE)
         )
      FROM products

      También hay una manera de resolverlo, y más recomendada (quizá por el calculo):

      SELECT 
         prod_id,
         price,
         category,
         MIN(price) OVER (
            PARTITION BY category 
         )
      FROM products

#### LAST_VALUE

Devuelve un valor evaluado contra la última fila dentro de su partición.

   * Question: How my prices compare to the item with the highest price in the same category.

      SELECT 
         prod_id,
         price,
         category,
         LAST_VALUE(price) OVER (            -- MAX(price) OVER (
            PARTITION BY category 
            ORDER BY price 
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING   
         )
      FROM products

#### SUM

Suma los valores dentro de un grupo dependiendo del FRAMING.

   * Question: How much cumulatively a customer has ordered at our store.

      SELECT 
         o.orderid,
         o.customerid,
         o.netamount,
         SUM(o.netamount) OVER (
            PARTITION BY o.customerid        -- Suma para todos los customerid
            ORDER BY o.orderid               -- Ordena las compras por orderid
         ) AS "Cum Sum"
      FROM orders as o
      ORDER BY o.customerid

#### ROW_NUMBER

Enumera la fila actual dentro de la partición iniciando desde 1 sin importar el framing.

   * Question: Where my product is positioned in the category by price.

      SELECT
         prod_id,
         price,
         category,
         ROW_NUMBER() OVER (              -- Sin parámetro
            PARTITION BY category
            ORDER BY price   
            -- RANGE BETWEEN CURRENT ROW AND CURRENT ROW       -- Ignora el framing         
         ) AS "Position in category by price"
      FROM products

NOTA: Hay más funciones como ya se sabe, pero queda de mi parte aprenderlas.

EJERCICIOS:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Window%20Functions/answers.sql

NOTA: Window Function suelen consumir más la capacidad de la computadora, ya que la función se ejecuta en cada fila de la data.

--------------------------------------------------------------------------------------------------------------------------------------

## CONDITIONAL STATEMENTS

Parecido a WHERE, los 'CASE statements' se pueden utilizar multiples veces en un solo query.
Cada valor que devuelve, es una sola salida.

### CASE STATEMENT

Ejemplo:
   SELECT a, 
          CASE 
            WHEN a=1 THEN 'one'     -- Cuando se cumple la condición (a=1), se cambia la salida ('one')
            WHEN a=2 THEN 'two'
            ELSE 'other'
          END
   FROM test;

#### CASE STATEMENT en SELECT:
*
   SELECT
      o.orderid,
      o.customerid,
      CASE
         WHEN o.customerid = 1
         THEN 'My first customer'
         ELSE 'Not my first customer'
      END,
      o.netamount
   FROM orders as o
   ORDER BY o.customerid

#### CASE STATEMENT en WHERE:
*
   SELECT
      o.orderid,
      o.customerid,
      o.netamount
   FROM orders as o
   WHERE CASE                             -- CONDITIONAL FILTER
            WHEN o.customerid > 10        -- Si customerid es mayor a 10, entonces
            THEN o.netamount < 100        -- Se muestra los datos donde netamount es menor a 100.
            ELSE o.netamount > 100        -- Sino, se muestras los datos donde netamount es mayor a 100.
         END
   ORDER BY o.customerid

NOTA: La solución anterior pudo resolverse con operadores lógicos, sin embargo, esta es otra solución (quizá algo más legible).

#### CASE STATEMENT en AGGREGATE FUNCTIONS:
*
   SELECT 
      SUM(
         CASE
            WHEN o.netamount < 100        -- Solo suma cuando se cumpla esta condición
            THEN -100                     
            ELSE o.netamount
         END
      ) AS "Returns",
      SUM(o.netamount) AS "Normal total"
   FROM orders AS o

EJERCICIOS:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Conditional%20Statements/answers.sql

### NULLIF STATEMENT

Devuelve NULL si la condición se cumple.

   > NULLIF(val_1, val_2)     -- Si val_1=val_2, devuelve NULL.

Ejemplo:
   NULLIF(0, 0)            -- Devuelve NULL
   NULLIF('ABC', 'DEF')    -- Devuelve ABC

NOTA: Si val_1 no coincide con val_2, devuelve val_1.

Puede utilizarse para rellenar espacios vacios con NULL para evitar problemas con ceros.

   * Question: Show NULL when the product is not on special (0).
         
         SELECT prod_id, title, price, NULLIF(special, 0) as "special"
         FROM products

--------------------------------------------------------------------------------------------------------------------------------------

## VIEWS

Views permiten almacenar y hacer queries sobre queries ejecutadas anteriormente.
Views son las salidas de el query que ejecutamos.
Views actuan con tablas, de manera que puedas hacer query con ellas.
Views usan poco espacio de almacenamiento, solo se almacenan las definiciones del View, no toda la data que devuelve.

Hay dos tipos de Views:

* Materialized Views: Almacena la data físicamente y la actualiza periódicamente cuando la tabla cambia.

* Non-Materialized Views: El query se re-ejecuta cada vez que se llama el View.

   > CREATE VIEW view_name AS query;

### Update a View

   > CREATE OR REPLACE <view_name> AS query;          -- Reemplaza la query si ya existe, sino la crea.

### Rename a View

   > ALTER VIEW <view_name> RENAME TO <view_name>;    -- Renombra el nombre del view

### Deleting a View

   > DROP VIEW [IF EXISTS] <view_name>                -- [IF EXISTS] para que si no existe, no arroje un error.

### Example: Solving for Current Salary

Aunque ya se haya resuelto otras veces antes, no eran de las maneras más intuitivas, sobre todo las funciones ventana.

   CREATE VIEW last_salary_change AS
   SELECT e.emp_no, MAX(s.from_date) 
   FROM salaries AS s
   JOIN employees AS e USING(emp_no)
   JOIN dept_emp AS de USING(emp_no)
   JOIN departments AS d USING(dept_no)
   GROUP BY e.emp_no
   ORDER BY e.emp_no

Luego puede obtenerse de la manera:

   SELECT * FROM last_salary_change;

No es una tabla, es el resultado del query anterior. Sin embargo, se puede utilizar igual.

   SELECT * FROM salaries
   JOIN last_salary_change AS l USING (emp_no)
   WHERE from_date = l.max
   ORDER BY emp_no

También de la forma:

   SELECT s.emp_no, d.dept_name, s.from_date, s.salary
   FROM last_salary_change
   JOIN salaries AS s USING(emp_no)
   JOIN dept_emp AS de USING(emp_no)
   JOIN departments AS d USING(dept_no)
   WHERE max = s.from_date

### Ventajas y desventajas.

PROS:
   - La sintaxis JOIN con filtros es más fácil de leer.
   - Es más fácil de analizar.

DRAWBACKS:
   - Hay que crear un View.


EJERCICIOS:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Views/answers.sql

--------------------------------------------------------------------------------------------------------------------------------------

## INDEXES

Es una construcción para mejorar el performance del query.
Es un apuntador hacia la data en una tabla.
Indexar la data ayuda a encontrar y acceder a la data más rapido.
Acelera los queries y optimiza la ejecución.

Sin embargo, hace más lento él insertar data y actualizarla.

### Creating an Index

   > CREATE UNIQUE INDEX <name> on <table> (column1, column2, ...);

### Deleting an Index

   > DROP INDEX <name>;

### Cuando utilizar?

- Siempre indexamos Foreign Keys
- Siempre indexamos Primary Keys y columnas únicas
- Siempre indexamos columnas que terminan en las cláusulas ORDER BY o WHERE con frecuencia. (IMPORTANTE)

### Cuando NO utilizar?

- No añadir index solo por añadir index.
- No usar index en tablas pequeñas (relativo).
- No usar index en tablas que son actualizadas frecuentemente.
- No usar index en columnas que contienen valores NULLS.
- No usar index en columnas que tienen valores muy grandes.

### TIPOS DE INDEX

   * Single-Column: Se aplica en la columna más utilizada en un query.
                    Se usa cuando estas obteniendo data que satisface una condición.

   * Multi-Column: Se aplica en las columnas más utilizadas en un query.
                   Se usa cuando estas obteniendo data que satisface multiples condiciones.
   
   * Unique: Se aplica para optimizar la velocidad y la integridad.
             Se usa cuando manejas una columna con valores únicos.

             > CREATE UNIQUE INDEX <name> on <table> (column1);

   * Partial: Se aplica para hacer index sobre un subset de una tabla.
              Se puede aplicar una expresión para obtener el pedazo de data que necesitas.

              > CREATE INDEX <name> on <table> (<expression>);

   * Implicit Indexes: Son creados automáticamente por la base de datos (Primary Key & Foreign Key).

Nota: Los index de una tabla se pueden observar en el esquema del editor.

### EXPLAIN ANALYZE
   
Explica y analiza la ejecución de los queries.

   > EXPLAIN ANALYZE       -- Antes del query

* Ejemplo: Utilizando un Single-Column Index.

   -- Ejecutamos el siguiente query:
   EXPLAIN ANALYZE
   SELECT "name", district, countrycode FROM city
   WHERE countrycode IN ('TUN', 'BE', 'NL')

   -- Observamos el tiempo de ejecución y resto de analisis. 
   -- Ahora procedemos a crear un index para la tabla

   -- Creamos el index y volvemos a ejecutar el query anterior, 
   -- se observa la diferencia considerable en el tiempo de ejecución.
   CREATE INDEX idx_countrycode
   ON city (countrycode);                                   -- Full index

* Ejemplo: Utilizando un Index Parcial.
   
   CREATE INDEX idx_countrycode
   ON city (countrycode) WHERE countrycode IN ('TUN', 'BE', 'NL');      -- Solo indexea donde los valores cumplen la condición.

   -- Nuevamente, ejecutamos el query  anterior:
   EXPLAIN ANALYZE
   SELECT "name", district, countrycode FROM city
   WHERE countrycode IN ('TUN', 'BE', 'NL')                 -- Se ejecuta rápido ya que se indexeo estos valores específicos.
   WHERE countrycode IN ('PSE', 'ZWE', 'USA')               -- Pero estos no, son lentos, ya que no están indexeados.

### Index Algorithms

   > CREATE [UNIQUE] INDEX <name> 
   > ON <table> USING <method> (column1, ...)

Cada tipo de index usa un algoritmo distinto y PostgreSQL provee varios algoritmos de indexacion:

   1. B-TREE: Es el algoritmo por default y es mejor utilizado para comparaciones con:
      
      * <, >, <=, >=, =.
      * BETWEEN
      * IN
      * IS NULL, IS NOT NULL.   

   2. HASH: Can only handle equality (=) operations.
   
      Ejemplo: WHERE countrycode='BEL' OR countrycode='TUN' OR countrycode='NLD'

   3. GIN: (Generalized Inverted Index), es mejor utilizado cuando multiples valores (arrays) son almacenados en un solo campo.

   4. GIST: (Generalized Search Tree), useful in  indexing geometric data and full-text search.


NOTA: En los index, si hacemos click derecho y Design, se puede observar el tipo de algortimo utilizado.

--------------------------------------------------------------------------------------------------------------------------------------

## SUBQUERIES

Es una construcción que permite crear queries extremadamente complejas.
Una subquery es un query dentro de otro query.
También se les conoce como Inner Query o Inner Select.
Se aplica frecuentemente en la cláusula WHERE, pero,  también puede ser utilizado en las cláusulas SELECT, FROM, HAVING y JOIN.

#### Subquery en WHERE: 
*
   SELECT * 
   FROM <table>
   WHERE <column> <condition> (
      SELECT <column>, <column>, ...
      FROM <table>
      [WHERE | GROUP BY | ORDER BY | ...]
   )

#### Subquery en SELECT:
*
   SELECT (
      SELECT <column>, <column>, ...
      FROM <table>
      [WHERE | GROUP BY | ORDER BY | ...]
   )                                         -- Must return a single record
   FROM <table>   

#### Subquery en FROM:
*
   SELECT  *
   FROM (
      SELECT <column>, <column>, ...         -- Parecido a View
      FROM <table>
      [WHERE | GROUP BY | ORDER BY | ...]
   ) AS <name>

#### Subquery en HAVING:
*
   SELECT  *
   FROM <table> AS <name>
   GROUP BY <column>
   HAVING (
      -- Must return a single records        --
      SELECT <column>, <column>, ...         
      FROM <table>
      [WHERE | GROUP BY | ORDER BY | ...]
   ) > X

### Subqueries vs Join

- Ambos, Subqueries como Join combinan data de diferentes tablas.

- Subqueries son queries que pueden ejecutarse individualmente (autónomas),
  Mientras que los Join depende del resto del query.

- Joins combinas filas de una o más tablas según la condición del match.

- Subqueries pueden devolver un solo resultado, o un set de filas, dependiendo donde se aplique el subquery.
  Joins solo pueden devolver un set de filas.

- Los resultados de un subquery son utilizados inmediatamente.
  Mientras que una tabla JOIN puede ser utilizada fuera del query.

### Subqueries Guidelines 

- Un subquery debe cerrarse en paréntesis.

- Debe colocarse al lado derecho del operador de comparación.    " WHERE X>= subquery "

- No se pueden manipular los resultados internamente (ORDER BY se ignora)

- Se debe usar operadores de Single-Row con subqueries de Single-Row.

- Los subqueries que devuelven NULL pueden no devolver resultados.

### Tipos de Subqueries

   * Single Row: Devuelve una o ninguna fila. 
      
      -- Ejemplo 1:
      SELECT name, salary
      FROM salaries
      WHERE salary = (SELECT AVG(salary) FROM salaries);

      -- Ejemplo 2:
      SELECT name, salary,
         (SELECT AVG(salary) FROM salaries)
         AS "Company Average Salary"
      FROM salaries;

   * Multiple Row: Devuelve una o más filas.

      -- Ejemplo 1:
      SELECT title, price, category
      FROM products
      WHERE category IN (
         SELECT category FROM categories
         WHERE categoryname IN ('Comedy', 'Family', 'Classics')
      )

   * Multiple Column: Devuelve una o más columnas.

      -- Ejemplo 1:
      SELECT emp_no, salary, dea.avg AS "Deparment Average Salary"
      FROM salaries AS s
      JOIN dept_emp AS de USING(emp_no)
      JOIN (
            SELECT dept_no, AVG(salary) FROM salaries AS s2
            JOIN dept_emp AS e USING(emp_no)
            GROUP BY dept_no
         ) AS dea USING(dept_no)
      WHERE salary > dea.avg

   * Correlated: Referencia una o más columnas fuera del statement. Se ejecuta contra cada fila.

      -- Ejemplo 1:
      SELECT emp_no, salary, from_date
      FROM salaries AS s
      WHERE from_date = (
         SELECT MAX(s2.from_date) AS max
         FROM salaries AS s2
         WHERE s2.emp_no = s.emp_no
      )
      ORDER BY emp_no

   * Nested: Son subqueries dentro de otros subqueries.

      -- Ejemplo:
      SELECT orderlineid, prod_id, quantity
      FROM orderlines
      JOIN (
         SELECT prod_id
         FROM products
         WHERE category IN (
            SELECT category FROM categories
            WHERE categoryname IN ('Comedy', 'Family', 'Classics')
         )  
      ) AS limited USING (prod_id)

### Exercises

   * Question: Show all employees older than the average age.

      SELECT first_name, last_name, AGE(birth_date)
      FROM employees
      WHERE AGE(birth_date) > (SELECT AVG(AGE(birth_date)) FROM employees WHERE gender='m') -- En WHERE no se puede usar AGGREGATE.

   * Question: Show the title by salary for each employee.

      SELECT 
         emp_no,
         salary,
         from_date
         (SELECT title FROM titles AS t
          WHERE t.emp_no=s.emp_no AND 
          (t.from_date=s.from_date + interval '2 days' OR t.from_date=s.from_date)
          )             -- Correlated subquery. Referenciamos al query padre.
      FROM salaries AS s
      ORDER BY emp_no

      -- Tambien puede ser con OUTER JOIN (Mejor)
       SELECT 
         emp_no,
         salary,
         from_date
         t.title
      FROM salaries AS s
      LEFT OUTER JOIN titles AS t USING(emp_no, from_date)     -- O mejor aún, solo JOIN.
      ORDER BY emp_no

### Getting the Latest Salaries

* Opción con Subqueries:
   SELECT
      emp_no,
      salary AS "Most recent salary",
      from_date
   FROM salaries AS s
   WHERE from_date = (
         SELECT MAX(from_date)
         FROM salaries AS sp
         -- Correlated subquery.
         WHERE sp.emp_no = s.emp_no
      )
ORDER BY emp_no ASC

NOTA: Aunque hayan menos pasos en el subquery, el tiempo de ejecución es muy largo.
      Para el caso de una window function, es mucho más rápido. 

* Opción con Window Function:
   SELECT DISTINCT e.emp_no,
       e.first_name,
       d.dept_name,
       LAST_VALUE(s.salary) OVER (
           PARTITION BY e.emp_no
           ORDER BY s.from_date
           RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING     -- CURRENT ROW AND UNBOUNDED FOLLOWING
       ) AS "Current Salary"
   FROM salaries AS s
   JOIN employees AS e USING(emp_no)   
   JOIN dept_emp AS de USING(emp_no)
   JOIN departments AS d USING(dept_no)
   ORDER BY e.emp_no;

* Opción con Subqueries y JOINS.
   
   SELECT 
      emp_no,
      salary AS "Most recent salary",
      from_date
   FROM salaries AS s
   JOIN ( 
      SELECT emp_no, MAX(from_date) AS "Max"
      FROM salaries AS sp
      GROUP BY emp_no
   ) AS ls USING (emp_no)
   WHERE ls.Max = from_date

NOTA: Mismo resultado, más rápido, eficiente.

### Subquery Operators

Cuales son los operadores que pueden utilizarse en una cláusula WHERE en un Subquery?

   * EXISTS: Verifica si un subquery devuelve alguna fila.

      SELECT firstname, lastname, income
      FROM customers AS c
      WHERE EXISTS (
         SELECT * FROM orders AS o
         WHERE c.customerid = o.customerid AND totalamount > 400     -- Correlated
      ) AND income > 90000

   * IN: Verifica que el valor es igual a alguno de las filas en el return (NULLS devuelve NULL)

      SELECT prod_id
      FROM products
      WHERE category IN (
         SELECT category FROM categories
         WHERE categoryname IN ('Comedy', 'Family', 'Classics')
      )

   * NOT IN: Verifica que el valor NO es igual a alguno de las filas en el return (NULLS devuelve NULL)

      SELECT prod_id
      FROM products
      WHERE category IN (
         SELECT category FROM categories
         WHERE categoryname NOT IN ('Comedy', 'Family', 'Classics')
      )

   * ANY/SOME: Verifica cada fila contra el operador y si la comparación coincide, devuelve TRUE.

      SELECT prod_id
      FROM products
      WHERE category = ANY (
         SELECT category FROM categories
         WHERE categoryname NOT IN ('Comedy', 'Family', 'Classics')
      )

   * ALL: Verifica cada fila contra el operador y si TODAS las comparaciones coinciden, devuelve TRUE.

      SELECT prod_id, title, sales
      FROM products
      JOIN inventory AS i USING (prod_id)
      WHERE i.sales > ALL (
         SELECT AVG(sales) FROM inventory
         JOIN products AS pl USING (prod_id)
         GROUP BY pl.category
      )

   * SINGLE VALUE COMPARISON: El subquery debe devolver una sola fila, así se verifica el comparador contra la fila.

      SELECT prod_id
      FROM products
      WHERE category = (
         SELECT category FROM categories
         WHERE categoryname IN ('Comedy')
      )


EJERCICIOS:
https://github.com/mobinni/Complete-SQL-Database-Bootcamp-Zero-to-Mastery/blob/master/SQL%20Deep%20Dive/Subqueries/answers.sql

--------------------------------------------------------------------------------------------------------------------------------------

