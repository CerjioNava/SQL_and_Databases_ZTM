# DATABASE MANAGEMENT

# SUMMARY:

   - TYPES OF DATABASES (POSTGRES, TEMPLATE0, TEMPLATE1)
   - CREATING A DATABASE
   - POSTGRES SCHEMA
   - ROLES (ATTRIBUTES AND PRIVILEGES)
   - DATA TYPES
   - DATA MODELS
   - CREATING TABLES
   - CONSTRAINTS (COLUMN & TABLE CONSTRAINTS)
   - UUID AND EXTENSIONS
   - CUSTOM DATATYPES
   - EJEMPLO ZTM (CREACIÓN DE TABLAS, INSERCIÓN DE DATOS, ETC) -- MUY COMPLETO
   - BACKUPS
   - TRANSACTIONS


--------------------------------------------------------------------------------------------------------------------------------------

## TYPES OF DATABASES IN A RDBMS

   * REGULAR DATABASE: Ya ordenadas en tablas (por ejemplo).

   * TEMPLATE DATABASE: Son los planos (blueprints) según lo que se modela el regular database.

When you setup your postgres, 3 databases were created:

   * POSTGRES
   * TEMPLATE0
   * TEMPLATE1

### POSTGRES DATABASE

This is the default database that is created when you setup postgres (INITDB).
La primera vez que inicializas Postgres, puedes conectarte a la base de datos de postgres para así configurar tu primera base de datos.

   > ~ psql -U <user> <database>

Aun si no se otorga un database, Postgres por default asumirá una conexión a un database con el mismo nombre que el usuario.
Ejemplo:

   > ~ psql -U postgres

Para mostrar la conexión actual (connection info):

   > \conninfo

   		-- You are connected to database "postgres" as user "postgres" via socket in "/tmp" at port "5432".

### TEMPLATE0 DATABASE

Este es el template utilizado para crear el Template1 (NUNCA DEBE CAMBIARSE).
En esencia, es un template de respaldo.

### TEMPLATE1 DATABASE

Este es el template utilizado para crear nuevas bases de datos (default).
Cualquier cambio que se haga en el template, son aplicados automáticamente en todas las nuevas bases de datos.

Ya que Template1 es el template por default, si nos conectamos o accedemos a el, ninguna nueva base de datos puede ser creada hasta que la conexión se cierre o haya terminado.

   > ~ psql -U postgres template1
   > \conninfo
   > exit

Puedes crear tu propio template database para crear otros databases con el mismo, pero no es algo común.

   CREATE DATABASE mysuperdupertemplate;
   -- connect to superdupertemplate and run
   CREATE TABLE superdupertable ();
   -- after creating the database connect to it and you will see superdupertable
   CREATE DATABASE mysuperduperdatabase WITH TEMPLATE mysuperdupertemplate;

--------------------------------------------------------------------------------------------------------------------------------------

## CREATING A DATABASE

   CREATE DATABASE name
   		[ [WITH] ] [OWNER] [=] user_name ]			-- Quien es el dueño del database.
   			[ TEMPLATE [=] template ]				-- Podemos especificar el template.
   			[ ENCODING [=] encoding ]				-- Refiere a como se almacena la información.
   			[ LC_COLLATE [=] lc_collate ]
   			[ LC_CTYPE [=] lc_ctype ]
   			[ TABLESPACE [=] tablespace ]
   			[ CONNECTION LIMIT [=] connlimit ]		-- Limite de conexiones.

   Settings     		Default

   TEMPLATE 			template01
   ENCODING 			UTF8
   CONNECTION_LIMIT 	100
   OWNER 				Current User

More information: https://www.postgresql.org/docs/9.0/sql-createdatabase.html

### Example: Database to store ZTM courses

   > CREATE DATABASE ztm
   > DROP DATABASE ztm

###  Database Organization

Las bases de datos suelen contener muchas tablas, views, etc. Y es importante organizarla de una manera lógica.

--------------------------------------------------------------------------------------------------------------------------------------

## POSTGRES SCHEMA

Es una "caja" donde puedes organizar tablas, views, indexes, etc.   					   
Por default, cada database posee un "schema" "public". A menos que especifiques el esquema, el default siempre se asume como público.

   SELECT * FROM employees
   -- is the same as
   SELECT * FROM public.employees

Para mostrar todos los esquemas:
	
   > mysuperduperdatabase=> \dn

Crear un esquema:

   > mysuperduperdatabase=> CREATE SCHEMA sales;

### Reasons to use schemas

- Para permitir a muchos usuarios utilizar una database sin interferir entre ellos.

- Para organizar database objects en grupos logicos para hacerlos más manejables.

- Third-party applications pueden colocarse en esquemas separados, de manera que no colisionen con los nombres de otros objetos.

NOTA: Crear bases de datos es una acción restringida que no todos estan permitidos hacer.

--------------------------------------------------------------------------------------------------------------------------------------

## ROLES IN POSTGRES

Un rol puede ser de un usuario o grupo de usuarios, dependiendo como tu configures ese rol y para quienes.
Los roles tienen la habilidad de otorgar membresías a otro rol.
Los roles son vitales en cualquier DBMS ya que determinan lo que está permitido.

Los roles poseen:

   * Atributos 

   * Privilegios

### ATRIBUTOS

Cuando un rol es creado, se le dan ciertos atributos y los privilegios de un rol son determinados en parte, por sus atributos.

   * CREATEDB | NOCREATEDB
   * CREATEROLE | NOCREATEROLE
   * LOGIN | NOLOGIN
   * SUPERUSER | NOSUPERUSER

Atributos comunes:

   * LOGIN PRIVILEGE: A role with the LOGIN attribute can be considered the same thing as a "database user".

   * SUPERUSER STATUS: A database superuser bypasses all permission checks.

   * DATABASE CREATION: A role must be explicitly given permission to create databases.
   
   * ROLE CREATION: A role must be explicitly given permission to create more roles.
   
   * PASSWORD: A password is only significant if you give LOGIN privilege.

   * ...

#### Creating a role

   > CREATE ROLE readonly WITH LOGIN ENCRYPTED PASSWORD 'readonly'

NOTA: Siempre encriptar cuando almacenar un rol que puede hacer log in.

Para ver los roles disponibles:

   > Database=> \du

Por default, solo el creador de la database o superuser tiene acceso a sus objetos.

#### Creating Users
	
   -- Opcion 1:
   > CREATE ROLE test_role_with_login WITH LOGIN ENCRYPTED PASSWORD 'password';
   > \du

   > CREATE USERS test_user_with_login WITH ENCRYPTED PASSWORD 'password';
   > \du

   -- Opción 2:
   > createuser --interactive  
   -- Pregunta varias preguntas sobre el nuevo usuario como el nombre del rol (test_interactive) y que rol tendrá.

   -- No le añadimos password antes, así que:
   > ALTER ROLE test_interactive WITH ENCRYPTED PASSWORD 'password';

NOTA: Aún colocándole una clave erronea al acceder, igual entra a la base de datos. Por que? 

Esto sucede debido a que en los archivos siguientes, el método del "Password Authentication" esta en "Trust" (pg_hba.conf).

* pg_hba.conf 						-- En estos archivos poseen la configuración de Postgres.
* postgresql.conf

Deberemos cambiar "trust" por el método que más convenga para nuestra base de datos (REVISAR DOCUMENTACIÓN.)
En el curso se cambio por "scram-sha-256".

También es necesario cambiar el método de encriptación en "postgresql.conf".

   > password_encryption = md5		-- md5 cambiamos por scram-sha-256 

**PRUEBAS QUE HICE**

Paso a paso:

CREATE ROLE rol1 WITH PASSWORD 'root';                         -- Aún no tiene un rol.
ALTER ROLE rol1 WITH SUPERUSER PASSWORD 'root';                -- Role superuser. No puede conectarse.
ALTER ROLE rol1 WITH LOGIN PASSWORD 'root';                    -- Role superuser y ahora si puede conectarse.
ALTER ROLE rol1 WITH CREATEDB CREATEROLE PASSWORD 'root';      -- Añado Crear DB y Crear Role.

CREATE ROLE cerjio WITH LOGIN CREATEDB CREATEROLE SUPERUSER PASSWORD 'root';

NOTA: Usar usuario 'postgres'.

### PRIVILEGIOS

Los atributos otorgan privilegios predeterminados.
Por default, los objetos solo están disponibles para el usuario que los creó.
Los privilegios específicos deben ser otorgados a nuevos roles y usuarios para acceder a cierta data específica.

#### Granting Privileges

   GRANT ALL PRIVILEGES ON <table> TO <user>                                        -- Privilegio en cierta tabla a un usuario.
   GRANT ALL ON ALL TABLES [IN SCHEMA <schema>] TO <user>;                          -- Privilegio a todas las tablas de un esquema.
   GRANT [SELECT, UPDATE, INSERT, ...] ON <table> [IN SCHEMA <schema>] TO <user>;   -- Cierto privilegio en una tabla de un esquema.

### Privilege example (step by step)

   CREATE USER privilegetest;
   psql -U postgres Employees;            -- postgres como usuario admin
   psql -U privilegetest Employees;       -- En otro cmd, abrimos el nuevo usuario de prueba.

   -- En postgres cmd
   GRANT SELECT ON titles TO privilegetest;                       -- Otorgamos privilegio de usar SELECT
   REVOKE SELECT ON titles FROM privilegetest;                    -- Revocamos privilegio de usar SELECT
   GRANT ALL ON ALL TABLES IN SCHEMA public TO privilegetest      -- Otorgamos todos los privilegios
   REVOKE ALL ON ALL TABLES IN SCHEMA public FROM privilegetest

   -- Creando un rol donde solo se permita leer
   CREATE ROLE employee_read;
   GRANT SELECT ON ALL TABLES IN SCHEMA public TO employee_read   -- Aun no puede leer
   GRANT employee_read TO privilegetest                           -- Se le otorga el rol employee_read a privilegetest

**IMPORTANTE: Se pueden crear roles con opciones específicas de lo que pueden y no pueden hacer, y otorgarle esos roles a usuarios.
              De esta forma, no es necesario crear un set de reglas repetidas para cada usuario, simplemente le otorgas el rol.**

### Principle of Least Privilege

Cuando se manipulan roles y permisos, SIEMPRE debemos iniciar con el "Principio del menor privilegio". 
Es decir, empezar desde NINGUN privilegio. Solo otorgar permiso a lo que necesitan.
No usar por default ADMIN/SUPERUSER.

Haciendo \dt observamos el listado de relaciones de la base de datos, y solo el usuario dueño "postgres" puede acceder a la data.
Lista de comandos psql: https://www.postgresql.org/docs/10/app-psql.html

--------------------------------------------------------------------------------------------------------------------------------------

## DATA TYPES

Cada tipo de data es básicamente una restricción en un campo para solo permitir que cierto tipo de data pueda rellenarlo.
Es importante definir el tipo de data, para que el sistema como manejar dicha data.
También es lo que permite al DBMS optimizar su algoritmo para procesar la data, sabiendo el tipo.

¿Que tipo de data se puede almacenar en una base de datos?

   * Numeric
   * Arrays
   * Character
   * Date/Time
   * Boolean
   * UUID (Universally Unique Identifiers)
   * Binary
   * ...

Veremos solo unos pocos tipos de data a continuación.
Para ver todos los tipos de data: https://www.postgresql.org/docs/9.5/datatype.html

### Boolean

Puede set TRUE, FALSE, o NULL.
Sirve también para hacer conversiones inteligentes como:

   * TRUE values: 1, yes, y, t, true, ...
   * FALSE values: 0, no, f, false, ...

### Character

PostgreSQL provee tres tipos:

   * CHAR(N)           

      Tienen longitud con relleno de espacio.
      (N) es para almacenar caracteres de N longitud.
      (10) por ejemplo: si escribimos 'hola', será 'hola      '. 
      Se rellenan el resto de caracteres con espacios en blanco.

   * VARCHAR(N)         -- Variable Character

      Tiene longitud variable sin relleno de espacio.
      (10) por ejemplo: si escribimos 'mo', será 'mo'.

   * TEXT

      Tiene longitud infinita de texto.

NOTA: Restringir la longitud de texto permite controlar el almacenamiento de la data deseada.
      Por ejemplo, los twitts en Twitter.

--EJEMPLO:   
   CREATE TABLE test_text (
      fixed CHAR(4),
      variable VARCHAR(20),
      unlimited TEXT
   );
   INSERT INTO test_text VALUES (
      'mo'                        -- Si 'momomo', devolvería error, solo permite 4 caracteres.
      'momomomomo',
      'I have unlimited space'
   )

### Numbers

Hay dos tipos de data numérica en Postgres:

   * INTEGER: Es un número redondo, sin decimales. Hay tres tipos de Integer:

      * SMALLINT: Almacena entre -2^15 hasta 2^15-1.
      * INT:      Almacena entre -2^31 hasta 2^31-1.
      * BIGINT:   Almacena entre -2^63 hasta 2^63-1.

   * FLOAT: Es un número con decimales. Hay dos tipos de Float:

      * FLOAT4/FLOAT8:     Precisión singular o doble. Precisión de 6 o 15 dígitos luego del punto decimal.
      * DECIMAL/NUMERIC:   Más de 131072 dígitos antes del punto decimal. Más de 16383 dígitos después del punto decimal.

EJEMPLO:
   CREATE TABLE test_text (
      four FLOAT4,
      eight FLOAT8,
      big DECIMAL
   );
   INSERT INTO test_text VALUES (
      1.123456789,                                 -- Devuelve 1.1234568, redondea el 789
      1.123456789123456789123456789,               -- Devuelve 1.1234567891234568, redondea el 789123...
      1.1234567891234567891234567892189372189...   -- Devuelve TODO el número
   )

### Arrays

Es un grupo de elementos del MISMO tipo. 
Se denota con corchetes [].
Cada data type tiene un array equivalente.

EJEMPLO:
   CREATE TABLE test_text (
      four CHAR(2)[],
      eight TEXT[],
      big FLOAT4[]
   );
   INSERT INTO test_text VALUES (
      ARRAY ['mo', 'm', 'm', 'd'],
      ARRAY ['test', 'long text', 'longer text'],
      ARRAY [1.23, 2.11, 3.4123214, 1.5]
   );

--------------------------------------------------------------------------------------------------------------------------------------

## DATA MODELS 

Un modelo es un diseño utilizado para visualizar que vamos a crear.
Antes de crear una base de datos, creamos un modelo.

### Entity Relationship Diagram (Luego se ve en Database Design)

## Naming Conventions

   - Los nombres de las tablas deben escribirse en SINGULAR.            (student, no students)
   - Las columnas deben estar en minúscula con underscores.             (an_example)
   - Las columnas con mayús y minúsculas combinadas, son "aceptables".  (student_ID)
   - Las columnas con solo mayúsculas son "inaceptables".

--------------------------------------------------------------------------------------------------------------------------------------

## CREATING TABLES
   
Sintaxis:
   CREATE TABLE <name> (
      <col1> TYPE [CONSTRAINT],              -- Los constraint son restricciones. Véase más adelante.
      table_constraint [CONSTRAINT]          -- Table constraints. Más adelante.
   ) [INHERITS <existing_table>];

### Normal Tables

Por default, CREATE TABLE genera un objeto en el "public schema", a menos que especifiques algo distinto.
El diseño de una base de datos son como los planos de una casa, determinan como se verá la casa.

### Temporary Tables

Son un tipo de tabla que existe en un "special schema".
No puedes definir un nombre para el schema cuando declaras una tabla temporal.
Estas tablas se eliminan al final de tu sesión y solo son visibles para el creador.

   > CREATE TEMPORARY TABLE <name> (<columns>);

Se utilizan por distintos motivos:

   - Las tablas temporales se comportan como una normal.
   - Postgres aplicará menos "reglas" a una tabla temporal para que se ejecute más rápido.
   - Tienes acceso total a la data que quizá antes no tenías, entonces puedes probar distintas cosas.

Ejercicio:
   CREATE TABLE student (
      student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  -- Primary Key como el Constraint. Por default, genera identificador.
      first_name VARCHAR(255) NOT NULL,                        -- No pueden ser NULL.
      last_name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      date_of_birth DATE NOT NULL
   );
   -- Ejecutamos esta query en el cmd.
   -- Dice que "uuid_generate_v4()" no está disponible, debemos crear una extensión.
   -- Postgres permite instalar extensiones. Escribimos:
   create extension if not exist "uuid-ossp";
   -- Verificamos con "\dt" y observamos las especificaciones de la tabla con "\d student".
   \dt
   \d student

CREAR TABLAS: https://www.postgresql.org/docs/12/sql-createtable.html

--------------------------------------------------------------------------------------------------------------------------------------

## CONSTRAINTS

Son herramientas para aplicar métodos de validación contra la data que será insertada.

### Column Constraint

Es una parte de la definición de una columna.
Véase los siguientes Column Constraints:
   
   * NOT NULL: No puede ser NULL.

   * PRIMARY KEY: La columna será la primary key.
   
   * UNIQUE: Solo puede contener valores únicos (NULL es único).
   
   * CHECK: Aplica una verificación de condición especial contra valores de la columna. (Como una secuencia para un número de tlf)
   
   * REFERENCES: Restringe los valores de la columna a solo ser valores que existan en una columna de otra tabla (Foreign Key).

### Table Constraints

No esta unido a una columna en particular, y puede abarcar más de una sola columna.
Véase los siguientes Table Constraints:

   * UNIQUE (column_list): Solo pueden contener valores únicos (NULL es único).

   * PRIMARY KEY (column_list): Columnas que serán las Primary Key.

   * CHECK (condition): Una condición para verificar cuando se inserte o actualice data.

   * REFERENCES: Relación de una Foreign Key con una columna.

Ejemplo:
   CREATE TABLE student (
      student_id UUID DEFAULT uuid_generate_v4(),
      first_name VARCHAR(255) NOT NULL,
      last_name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,
      date_of_birth DATE NOT NULL,
      CONSTRAINT pf_student_id PRIMARY KEY (student_id)     -- Table constraint
   );

NOTA: Cada Column Constraint puede ser escrita como una Table Constraint.

#### Ejemplo:
* SCHEMA SQL
   CREATE TABLE category (
      cat_id SMALLINT PRIMARY KEY,
      type TEXT
   );

   CREATE TABLE column_constraints (
      cc_id SMALLINT PRIMARY KEY,
      something TEXT NOT NULL,
      email TEXT CHECK (email ~ * '^[A-Za-z0-9._ %-]+@[A-Za-z-0-9.-]+[.][A-Za-z]+$'),     -- REGEX
      cat_id SMALLINT REFERENCES category(cat_id)
   )

   CREATE TABLE table_constraints (
      cc_id SMALLINT,
      something TEXT NOT NULL,
      email TEXT,
      cat_id SMALLINT REFERENCES category (cat_id),
      CONSTRAINT pk_table_constraints PRIMARY KEY (cc_id),
      CONSTRAINT valid_email CHECK (email ~ * '^[A-Za-z0-9._ %-]+@[A-Za-z-0-9.-]+[.][A-Za-z]+$')     -- REGEX
   );

* QUERY SQL
   INSERT INTO category VALUES (
      1,
      'category 1'
   );
   INSERT INTO table_constraints VALUES(
      1,
      'something',
      'mo@binni.io',
      1
   );
   SELECT * FROM column_constraints;

NOTA: Para el ejemplo anterior, table_constraints funciona igual que column_constraints.
      REGEX refiere a Regular Expressions.


Importance of Database Constraints: 
https://www.longdom.org/open-access/on-the-paramount-importance-of-database-constraints-2165-7866-1000e125.pdf

--------------------------------------------------------------------------------------------------------------------------------------

## UUID explained

UUID significa "Universally Unique Identifier".
Es una extensión que permite generar identificadores únicos para Primary Keys.
Como por ejemplo: 'a9839alf-edf5-4a77-9fde-b0dac8ea32d5'

Es necesario instalar la extensión:

   > CREATE extension IF NOT EXISTS "uuid-ossp";

### Extensions

Son piezas de software que permiten expandir lo que Postgres puede hacer, o expandir como se ejecuta un proceso.

   > SELECT * FROM pg_available_extensions;     -- Para ver que extensiones están disponibles en postgres (?)

### Pros y Contras del UUID

Pros:
   
   - Siempre son únicos.
   - Es más facil de fragmentar.
   - Es más facil de unir/duplicar.
   - Expones menos información de tu sistema.

Contras:
   
   - Valores más grandes por almacenar.
   - Puede tener un impacto en el performance.
   - Más dificil de depurar (debug).

--------------------------------------------------------------------------------------------------------------------------------------

## CUSTOM DATA TYPES & DOMAINS

Postgres permite crear custom data types para almacenar formas de data que es más compleja.
No es muy recomendable.

Un domain es un tipo específico de data que puede tener un check. Es un alias para un tipo ya existente.

--------------------------------------------------------------------------------------------------------------------------------------

### EJEMPLO ZTM (Creating tables and adding the data)

   -- Creamos una base de datos ZTM donde dentro del esquema "public", generaremos las tablas correspondientes.
   -- Para el ejemplo completo, seguimos el "Entity Relationship Diagram" del curso. Con esto nos guiamos para las tablas.

-- Dominio y feedback
   CREATE DOMAIN Rating SMALLINT CHECK (VALUE > 0 AND VALUE <= 5);      -- Domain para el rating del curso 0-5
   CREATE TYPE feedback AS (
      student_id UUID,                                                  -- El id del estudiante
      rating RATING,                                                    -- El rating del curso
      feedback TEXT                                                     -- El texto u opinión
   );
   -- El feedback lo da un estudiante que este cursando el curso.
   
   -- Añadimos la extensión del UUID la primera vez.
   CREATE extension IF NOT EXISTS "uuid-ossp";

-- Tabla 1: Student
   CREATE TABLE student (
      student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  
      first_name VARCHAR(255) NOT NULL,                        
      last_name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL,                -- Aquí se puede aplicar REGEX
      date_of_birth DATE NOT NULL
   );


   -- Para añadir una columna a una tabla existente:
   ALTER TABLE student ADD COLUMN email TEXT;

-- Tabla 2: Subject
   CREATE TABLE subject (
      subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      subject TEXT NOT NULL,
      description TEXT
   );

-- Tabla 3: Teacher
   CREATE TABLE teacher (
      teacher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      first_name VARCHAR(255) NOT NULL,
      last_name VARCHAR(255) NOT NULL,
      date_of_birth DATE NOT NULL,        
      email TEXT                                  -- Aquí se puede aplicar REGEX 
   );

-- Tabla 4: Course
   CREATE TABLE course (
      course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      "name" TEXT NOT NULL,
      description TEXT,
      subject_id UUID REFERENCES subject(subject_id),
      teacher_id UUID REFERENCES teacher(teacher_id),
      feedback feedback[]                                -- Feedback (lo dará un estudiante)
   );

-- Tabla 5: Enrollment (inscripción)
   CREATE TABLE enrollment(
      course_id UUID REFERENCES course(course_id),
      student_id UUID REFERENCES student(student_id),
      enrollment_date DATE NOT NULL,
      CONSTRAINT pk_enrollment PRIMARY KEY (course_id, student_id)
   );

   -- FINALIZADO EL MODELO DE DATA

### ALTER

El comando ALTER permite cambiar especificaciones de una tabla y columnas, cambiar sus definiciones, añadir o eliminar.
Permite cambiar:

   * El esquema de una tabla.
   * Añade o remueve constraints.
   * Cambia constraints a nivel de columna o tabla. 
   * Etc...

Documentación para ALTER: https://www.postgresql.org/docs/12/sql-altertable.html

### Adding Students and Teachers

-- AÑADIENDO DATA A STUDENT
   INSERT INTO student (
      first_name, 
      last_name,
      email,
      date_of_birth
   ) VALUES (
      'Mo',
      'Binni',
      'mo@binni.io',
      '1992-11-13'::DATE
   );

-- AÑADIENDO DATA A TEACHER
   INSERT INTO teacher (
      first_name, 
      last_name,
      email,
      date_of_birth
   ) VALUES (
      'Mo',
      'Binni',
      'mo@binni.io',
      '1992-11-13'::DATE
   );

-- AÑADIENDO DATA A SUBJECT
   INSERT INTO subject (
      subject,
      description
   ) VALUES (
      'SQL Zero to Mastery',          -- Nos equivocamos, pusimos el subject en la descripción :V
      'The Art of SQL Mastery'        -- Pero podemos eliminar e insertar nuevamente
   )   
   -- DELETE FROM subject WHERE subject='SQL Zero to Mastery'
   -- De nuevo:
   INSERT INTO subject (
      subject,
      description
   ) VALUES (
      'SQL',                   
      'A database management language'
   ) 

-- AÑADIENDO EL CURSO
   INSERT INTO course (
      "name",
      description
   ) VALUES (
      'SQL Zero to Mastery',                   
      'The #1 resource for SQL mastery'
   ) 

   -- Pero no especificamos el subject_id ni el teacher_id, son NULL. Entonces...
   -- No debemos cambiar una columna de manera arbitraria si ya tenemos data. Debemos migrar información.
   
   -- Rellenamos el vacio.
   UPDATE course 
   SET subject_id = '58484afc-dedc-47ed-ae76-67e41e96e32c'
   WHERE subject_id IS NULL;
   -- ALTER TABLE course ALTER COLUMN subject_id SET NOT NULL
   
   -- Ya que alteramos course.subject_id para no permitir NULL, es necesario especificarlo al insertar la data.
   -- Hacemos lo mismo para teacher.
   UPDATE course 
   SET teacher_id = '72c53605-2340-4680-ab70-9e2f4caa08e7'
   WHERE teacher_id IS NULL;
   -- ALTER TABLE course ALTER COLUMN teacher_id SET NOT NULL

NOTA: Añadiendo la misma persona en distintas tablas, les otorga distintas ID como si fueran distintas personas.
      Esto puede arreglarse expandiendo el modelo con una tabla de USER donde se habilite alguna bandera de Student o Teacher.
      Esto lo veremos más adelante en Database Design.

Documentación para INSERT: https://www.postgresql.org/docs/12/sql-insert.html

-- AÑADIENDO ENROLLMENT
   INSERT INTO enrollment (
      student_id, 
      course_id, 
      enrollment_date
   ) VALUES (
      'df40553b-60f0-4f72-b917-ce88902928ac',
      'b80b4ba6-bb0c-45cd-88ab-0ed897ba2384',
      NOW()::DATE
   );
   
-- AÑADIENDO UN FEEDBACK
   UPDATE course
   SET feedback = array_append(
      feedback,                                           -- El mismo feedback array, le añadimos un ROW
      ROW(                                                -- Definimos un custom row de cualquier tipo para añadir al array
         'df40553b-60f0-4f72-b917-ce88902928ac',         -- Student ID
         5,                                              -- Rating
         'Great Course'                                  -- Feedback
      )::feedback
   )
   WHERE course_id = 'b80b4ba6-bb0c-45cd-88ab-0ed897ba2384';   -- El curso donde haremos el feedback
   
   -- El query debe ser más complejo para poder añadir más feedbacks y no solo update el mismo feedback o la misma fila en Course.
   -- Para eso, deberíamos cambiar el modelo de la data.
   -- Véase el nuevo modelo de diagrama.

-- Creamos la tabla Feedback
   -- Para crear la tabla feedback, primero debemos eliminar el Type Feedback creado anteriormente, o cambiarle el nombre.
   -- Lo hacemos desde el "design" del type feedback. Esto cambia automaticamente el tipo del feedback en course.
   -- Le cambiamos también el nombre a feedback_deprecated en course.
   -- Ahora podemos ejecutar el query.
   CREATE TABLE feedback (
      student_id UUID not null REFERENCES student(student_id),
      course_id UUID NOT NULL REFERENCES course(course_id),
      feedback TEXT,
      rating Rating,
      CONSTRAINT pf_feedback PRIMARY KEY (student_id, course_id)
   );

   -- Sin querer escribi mal feedback, lo renombramos:
   -- ALTER TABLE feedback RENAME feedack TO feedback

-- Añadimos el feedback a la tabla Feedback
   INSERT INTO feedback (
      student_id,
      course_id,
      feedback,
      rating
   ) VALUES (
      'df40553b-60f0-4f72-b917-ce88902928ac',
      'b80b4ba6-bb0c-45cd-88ab-0ed897ba2384',
      'This was really great!',
      5
   );

--------------------------------------------------------------------------------------------------------------------------------------

Ejercicios de SQL:   https://www.w3schools.com/sql/sql_exercises.asp
Quiz de SQL:         https://www.w3schools.com/sql/sql_quiz.asp

--------------------------------------------------------------------------------------------------------------------------------------

## BACKUPS

Siempre es importante hacer respaldo, porque siempre puede ocurrir un desastre.
La seguridad por delante.

### Es necesario tener al menos 3 cosas en mente:

   1. Backup Plan.               -- Como haces los backups, que tipo de backups, por que?
   2. Disaster Recovery Plan.    -- Como manejar una situación grave?
   3. Test your plans.           -- Verificar que funcione el plan.

### Que puede salir mal? Pues...

   1. Fallos en el hardwares.
   2. Virus.
   3. Cortes de luz.
   4. Hackers.
   5. Errores humanos.

### Como determinar un plan?

   1. Determinar que necesita ser respaldado.   -- Es recomendable siempre tener un backup total.

      1.1. Full Backup.          -- Backup total                                          -- No tan seguido (Lleva tiempo)
      1.2. Incremental.          -- Todo lo que ha cambiado desde el último incremental.  -- Muy seguido
      1.3. Differential.         -- Todo lo que ha cambiado desde el último Full Backup.  -- Seguido
      1.4. Transaction Log.      -- Backup de las transacciones de la base de datos.      -- Mucho más seguido

   2. Cual es la manera más apropiada de hacer un respaldo?

         Se puede trabajar con una estrategia de respaldo por
         Por ejemplo, hacer full backup una vez al mes junto a incremental backups diarios.

   3. Decidir con que frecuencia vas a hacer un respaldo.

         Dependerá del flujo de transacciones y data en la base de datos.

   4. Decidir donde almacenar la data.

         Una de las mejores opciones es en la nube.

   5. Cual es la política de retención para el backup.

         Cuanto tiempo se mantiene almacenada la data?

Documentación del Backup:  https://www.postgresql.org/docs/12/backup.html
Documentación pgBackRest:  https://pgbackrest.org/

### CREATE DUMP (Para crear un backup. En el database "Employee" por ejemplo)

### LOAD DUMP (Para cargar un backup)

--------------------------------------------------------------------------------------------------------------------------------------

## TRANSACTIONS

Una transacción es una unidad de instrucciones (Queries, por ejemplo).
Tiene muchas maneras de ser manejadas, dependiendo de la situación.
Una base de datos es un recurso compartido, así que muchos usuarios accederan a este, constantemente.
El DBMS tiene un mecanismo para manejar transacciones.
 
Para iniciar una transacción:

   > BEGIN;

Para terminar una transacción y hacer commit:

   > END

Para omitir el cambio en tu base de datos.

   > ROLLBACK;

Nota: A veces puede chocar una transacción con otra que esté en progreso.
      Pueden iniciarse varias transacciones en distintas consolas.

### Lifecycle
-
                  -> Partially Commited -> Commited
BEGIN -> Active {            |                      } END
                  ->       Failed       -> Aborted  

Ejemplo:
   BEGIN;
   DELETE FROM employees WHERE emp_no BETWEEN 10000 AND 10005;    -- Partially Commited state. Aún no está en la base de datos.
   SELECT * FROM employees;                                       -- Se observa el cambio pero aún sin subirse a la base de datos.

### ACID

Para mantener la integridad de una base de datos, TODAS las transacciones deben obedecer las "ACID Properties".

ACID refiere a: ATOMICITY, CONSISTENCY, ISOLATION y DURABILITY.

   * ATOMICITY:   O ejecutas la totalidad de la transacción o nada.
   * CONSISTENCY: Cada transacción debe dejar a la base de datos en un "estado de consistencia" (Commit o Rollback).
   * ISOLATION:   Las transacciones deben ser ejecutadas aisladas de otras transacciones.
   * DURABILITY:  Luego de completar la transacción, los cambios en la base de datos deben persistir. Esta hecho.


--------------------------------------------------------------------------------------------------------------------------------------








