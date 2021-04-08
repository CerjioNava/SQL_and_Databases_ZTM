
## DATABASES

> Un DataBase es un sistema (Hardware y Software) que permite al usuario almacenar, organizar y utilizar data.

### DataBase Management Software (DBMS)

	Es un software encargado de manejar una base de datos, recibe instrucciones y 
	realiza acciones con la base de datos.

### Relational DataBase Management Software (RDBMS)

	Este es un derivado del DBMS. PostgreSQL.

### Structured Query Language (SQL)

	Permite interactuar con un DBMS. No es un lenguaje de programación, es un lenguaje de consulta 
	orientado a objetos para consultar bases de datos relacionales. Es un lenguaje DECLARATIVO.

--------------------------------------------------------------------------------------------------------------------------------------

## 5 TIPOS DE DATABASES

   1. Relational Model (PostgreSQL, MySQL, Microsoft SQL Server, etc)

   2. Document Model (MongoDB, CouchDB, Firebase, etc)

   3. Key Value (Redis, DynamoDB, etc)

   4. Graph Model (Neo4j, AWS, etc)

   5. Wide Columnar Model (Apache, Cassandra, Google Big Table, etc)

--------------------------------------------------------------------------------------------------------------------------------------

## WHAT IS A QUERY?

Query se traduce como una consulta/pregunta, no es más que una instrucción.
Se conocen como "SQL Statement" (i.e. SELECT\*FROM USERS)

### Query Breakdown (Ver imagen "QUERY BREAKDOWN.PNG")

				keyword		identifier
	clause:	 	SELECT 		NAME 					      |
	clause:	 	FROM 		   USERS  (Expression)		|: SQL STATEMENT
	clause:	 	WHERE 		ROLE = 'MANAGER';		   |
								  |expression|
						   |-- condition  --|

**Nota: Para comentar una linea de código, se antepone "--" (doble guión).**

--------------------------------------------------------------------------------------------------------------------------------------

## IMPERATIVE VS DECLARATIVE

* Declarative Language es un lenguaje donde definimos "Que va a suceder". 	(i.e. SQL)
	
	> Ejemplo: "Hazme un pasticho", pero no sabes como se hizo.

* Imperative Language es un lenguaje donde definimos "Como va a suceder".	(i.e. Java)

	> Ejemplo: "Toma pasta, tomate, estos ingredientes, etc... Cocinalo así".

También existen lenguajes como Python capaces de ser Declarativo como Imperativo.

--------------------------------------------------------------------------------------------------------------------------------------

## SQL STANDARDS

Se refiere a los estandares que se definen para una base de datos SQL en una organización o proyecto.

--------------------------------------------------------------------------------------------------------------------------------------

### Databases

Un DataBase es una estructura de datos, estructurada de una manera tal que sea escalable con organizaciones que poseen cantidades masivas de data.

El precursor de las bases de datos es "File Processing Systems". Estaba lleno de limitaciones.

### DataBase Oriented Approach

	Usuario ---> Computadora ---> SQL (Language) ---> DBMS (Software) ---> DataBase Storage

--------------------------------------------------------------------------------------------------------------------------------------

## DATABASE MODELS

Los modelos no son más que maneras de organizar la data, manipularla y utilizarla. Existen muchos, tales como:

   * Hierarchical
   * Networking
   * Entity-Relationship
   * Relational
   * Object Oriented
   * Flat
   * Semi-Structured
   * .........

### Hierarchical Model

   - Es un modelo obsoleto e ineficiente actualmente. 
   - Funciona jerarquicamente bajo un esquema de arbol (padre e hijos).
   - No tiene manera de relacionar un nodo hijo con el nodo hijo de otro, aún cuando el objeto es el mismo.
   - Un padre tiene multiples hijos pero un hijo solo puede tener un padre.
   - Si un nodo padre es eliminado, el resto de hijos se eliminaran también. (Tight Couple)

### Networking Model

   - Se deriva del modelo jerárquico.
   - Permite "Many to many relationships", es decir, un hijo puede tener varios padres.

### Relational Model

   - La data no se relaciona mediante un esquema padre/hijo, sino mediante una estructura de tabla de datos.
   - La lógica de como se relaciona la data es manipulada por un DBMS.

Nota: Cada modelo tiene su conjunto de reglas bases sobre que trabajar, y esto es posible de manejar eficazmente a través de un DBMS.

--------------------------------------------------------------------------------------------------------------------------------------

## WHAT IS A DBMS?

Se encarga de manipular, supervisar, asegurar la data, según las reglas y planteamientos del modelo.

El software DBMS es el mediador entre el lenguaje SQL y la base de datos.

DMBS manage, supervise and secure your data, it allows transactions management too.

### CRUD operation (DMBS functionality)

   * Create
   * Read
   * Update
   * Delete

Los distintos softwares (DMBS) existentes aunque tengan ciertas diferencias entre ellos, todos buscan hacer lo mismo pero de maneras más eficientes. Una analogía sería ir a distintos restaurantes y pedir exactamente el mismo plato, el cliente es SQL y el chef es el DBMS, aunque el cliente pida el mismo plato, la manera de cocinarlo y el sabor será distinto.

--------------------------------------------------------------------------------------------------------------------------------------

## RDBMS (Relational DBMS)

Se trata de un DBMS especializado en Relational Models, y posee 13 reglas de uso dictadas por su creador para que un DBMS pueda ser considerado un RDBMS, sin embargo, seguir todas las reglas es dificil de conseguir.

### 13 Rules of Codd 	----->	 https://www.w3resource.com/sql/sql-basic/codd-12-rule-relation.php

### Términos fundamentales de un RDBMS:

   * Tables

   		Cada tabla tiene un nombre, que debe relacionarse con la data que se almacena en dicha tabla.

   * Column

   		Cada columna representa un tipo de dato específico. 
   		
   * Attribute
   
   		Es otra forma de referirse a columnas.

   * Degree

   		Un Degree (de una relación) es una colección de columnas.

   * Domain/Constraint

   		Se refiere al tipo de data que puede almacenar una columna. (Attributes Domain)

   * Tuples/Rows

   		Cada fila es una pieza de data de la tabla. Insertar una fila es insertar data a la tabla.
   		Una tupla es una fila de data. La data insertada sigue el constraint de las columnas. 

   * Cardinality

   		Es una colección de filas/tuplas.

   * Primary Key

   		Es lo que identifica de manera "única" a cada fila de una tabla. Se ubica al inicio de la fila. 
   		No puede ser eliminada.	Por ejemplo: un ID.

   * Foreign Key

 		   Hace referencia al Primary Key de otra tabla, permitiendo que se forje una relación entre la data.

   * Relation Instance

   * Relation Key

   * Relation Schema

Ejemplos: 

   Tengo una tabla con X domain/constraint en las columnas.
   Tengo una tabla con un degree de relación.
   Tengo una tabla con tales atributos.

--------------------------------------------------------------------------------------------------------------------------------------

## OLTP vs OLAP

* OLTP (Online Transaction Processing) ---> Support Day to Day

	Ejemplo: Una base de datos utilizada para cargar pedidos y clientes.
			 Una base de datos utilizada para seguir los inicio de sesión de los usuarios.

* OLAP (Online Analytical Processing) ---> Support Analysis

	Ejemplo: Una base de datos utilizada para definir los nuevos productos que deben ser ofrecidos.
			 Una base de datos utilizada para proveer estadísticas que reportar a los ejecutivos.

--------------------------------------------------------------------------------------------------------------------------------------

## WHY POSTGRESQL?

https://www.2ndquadrant.com/en/blog/postgresql-is-the-worlds-best-database/#:~:text=PostgreSQL%20just%20does%20it.,response%20times%20can%20be%20managed.

### Command Line 101    ----->     http://ifoundthemeaningoflife.com/learntocode/cmd101win

Instalamos PostgreSQL y luego el software Valentina (para el aprendizaje).

--------------------------------------------------------------------------------------------------------------------------------------

### Database Dump

   Así se llama a la data extraida de una base de datos, y se carga al software "load dump".
