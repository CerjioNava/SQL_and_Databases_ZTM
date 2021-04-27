# DATABASE DESIGN

# SUMMARY

   - SYSTEM DESIGN AND SDLC
   - SDLC (SOFTWARE DEVELOPMENT LIFE CYCLE)
   - TOP-DOWN VS BOTTON-UP 

   - TOP-DOWN DESIGN (DRIVEME ACADEMY EXAMPLE)
   - REQUIREMENTS & METHODS (ERD & NORMALIZATION) 
   - ER-MODEL/ERD (TOP-DOWN MODEL)
   - UML
   - 5 STEPS (ENTITIES, ATTRIBUTES, RELATIONSHIPS, MANY TO MANY, SUBJECT AREAS)
   - EXERCISE: PAINTINGS
   - EXERCISE: MOVIE THEATRE
   
   - BOTTOM-UP DESIGN
   - ANOMALIES 
   - NORMALIZATION
   - FUNCTIONAL DEPENDENCIES
   - NORMAL FORMS (0NF, 1NF, 2NF, 3NF, BCNF, 4NF, 5NF, 6NF)
   - WHY 4NF, 5NF AND 6NF AREN'T USED

---------------------------------------------------------------------------------------------------------------------------------------

## SYSTEM DESIGN AND SDLC

### SDLC (Software Development Life Cycle)

   * Phase 1: System Planning and Selection.

   		Esta fase se trata de conseguir información de lo que se necesita lograr (Scope).

   * Phase 2: System Analysis.

   		Tomar los requerimientos y analizar si puede llevarse a cabo a tiempo y dentro del presupuesto.

   * Phase 3: System Design. 	**Aquí se enfoca esta sección**

   		Diseñar la arquitectura del sistema para todos los componentes relacionados: Databases, apps, etc.

   * Phase 4: System Implementation and Operation.

   		Crear el software. (Todo lo que hicimos anteriormente con SQL y manejo de base de datos)

**NOTA: Pueden añadirse más fases como Testing, Mantenimiento, etc.**

El objetivo de este proceso es para diseñar sistemas robustos.

El proceso puede ser implementado de distintas maneras: 

   * Agile
   * Waterfall (NO HACER ESTE)
   * V-Model
   * ...								**(BUSCAR ESTO)**

Distintos modelos recorren el ciclo (fases) a un ritmo diferente.

---------------------------------------------------------------------------------------------------------------------------------------

## SYSTEM DESIGN DEEP DIVE

### From Chaos to Structure

System Design se trata de crear una estructura que pueda ser entendida y comunicada.
Queremos que el diseño refleje los requerimentos que tiene el sistema.
En cualquier sistema hay data. 

Hay diferentes tecnicas para diseñar base de datos. Hay dos muy populares:

### TOP-DOWN VS BOTTOM-UP

   * TOP-DOWN (De arriba hacia abajo)

   		Empiezas desde cero, no existe data, nada. 
   		Definir cuales son los requerimientos y la meta. (Fase 1 y 2 primero)
   		Top-Down es la opción óptima cuando se crea una nueva base de datos basada en los requerimientos.
   		   		
   * BOTTOM-UP (De abajo hacia arriba)

   		Ya existe un sistema o una data específica en su lugar.
   		Debes crear un nuevo sistema en base a la data ya existente.
   		Bottom-Up es la opción óptima cuando se migra una base de datos existente.

NOTA: Es muy frecuente que se utilicen un poco de ambas.

### METHODS

Métodos principales en:

   * Top-Down  ----->   ER-MODELLING
   * Bottom-Up ----->   NORMALIZATION

NOTA: Aunque estas dos metodologías sean específicas para distintos casos, no significa que no puedan utilizarse simultaneamente.
      Por ejemplo, utilizar Top-Down para diseñar de cero una base de datos, y luego aplicar Bottom-Up para validarla.
      O utilizar Bottom-Up primero y luego realizar diagramas Top-Down para verificar y visualizar la data.

---------------------------------------------------------------------------------------------------------------------------------------

## TOP-DOWN DESIGN

## DRIVEME Academy (EJEMPLO PARA DISEÑAR UNA BASE DE DATOS)

DRIVEME es una escuela de manejo donde las personas pueden tomar lecciones en USA.

Cada escuela tiene instructores en nómina y un inventario de carros, camiones y motocicles para enseñar.

Luego de una exhaustiva fase de obtención de requerimientos con los accionistas iniciales (CEO, CTO, BA'S,
CLIENTES, ETC), es posible entender la empresa, su posición y crecimiento.

   * Core Mission: Convertirse en una empresa de renombre para el aprendizaje de manejo.

   * Current Situation: Actualmente, DRIVEME tiene un sitio web obsoleto y su adquisición de clientes es mayormente mediante
   						Word of Mouth. Quieren comenzar a ganar una cuota de mercado a traves de la presencia online.

   * Core Requirements: Usualmente los requerimientos principales son un documento bien planificado con secciones de funcionalidad.
   						Para este ejemplo ya se encuentran resumidos los requerimientos.

   		1. Hay un inventario de vehículos para que los estudiantes puedan rentar.
   		2. Hay empleados en cada sucursal.
   		3. Hay mantenimiento para los vehículos.
   		4. Hay un examen opcional al final de las lecciones.
   		5. Solo puedes tomar el examen dos veces. Si fallas dos veces deberás tomar más lecciones. (CONSTRAINT)

El objetivo es crear un modelo para la data, basado en los requerimientos.

### Requerimientos

Cuando hablamos de requerimientos, nos referimos a:

   * High-Level Requirements. 	(Cosas que el cliente pide, sea específico o implícito)
   * User Interviews.			(Opinión de los usuarios, sus experiencias, etc)
   * Data Collection.			(Con que data se va a trabajar y como)
   * Deep Understanding.		(Entender el negocio y la función de la empresa)

---------------------------------------------------------------------------------------------------------------------------------------

## ER-MODEL/ERD (Entity Relationship Model/Diagram)

Es un diagrama que funciona como una manera de estructurar High-Level Requirements.

Véase el ejemplo del curso ZTM, donde existen entidades (Course, Enrollment, Student, Subject and Teacher) y la relación entre ellas.

Vamos a seguir algunos pasos para crear un modelo.

   1. Determine Entities.
   2. Determine Attributes.
   3. Determine Relationships.
   4. Resolve Many to Many Relationships.
   5. Subject Areas.

Estos pasos pueden variar en orden, dependiendo del sistema.
Para realizar los diagramas, utilizamos herramientas UML.

## UML (Unify Modelling Language)

Es el lenguaje utilizado para crear diagramas. Puede utilizarse cualquiera con UML.

**Tooling for Diagramming:** 

https://www.umlet.com/	
https://www.lucidchart.com/pages/es       (Usare este para el ejemplo, pero solo se pueden hacer 3 documentos gratis)

---------------------------------------------------------------------------------------------------------------------------------------

## STEP 1: Entities

Determinar que entidades existen en el sistemas.

¿Qué es y qué posee una entidad?

   - Una persona, lugar o cosa.
   - Tiene un nombre singular.
   - Tiene un identificador.
   - Debe contener más de una instancia de data.

### DRIVEME Academy Entities

Es importante nombrar las entidades según lo requiera la empresa. Seguir su lenguaje.

   * Student
   * School 
   * Vehicle
   * Instructor
   * Maintenance (Que tipo, fecha, quien lo hizo, lugar, etc)
   * Exam 
   * Lessons

El diagrama y las relaciones entre las entidades dependen de la organización que nosotros les demos al diseño.
Puedes decir:

   - *The students takes lessons* pero también *The school has lessons*

Pero es importante mantener un orden de derivación, de manera que por ejemplo:

   - School se relaciona con instructor y student.
   - Student se relaciona con lesson y exam. Quizá vehicle.
   - Instructor se relaciona con lesson y quizá algo más.
   - Etc...

**Diferentes requerimientos implican distintas relaciones.**

---------------------------------------------------------------------------------------------------------------------------------------

## STEP 2: Attributes

Se refieren a la información/columnas que las entidades van a almacenar. 
Son las columnas que las tablas poseen.

   - Deben ser propiedad de la entidad.
   - Deben ser atómicos (solo pueden almacenar un solo valor). Se refiere a ATOMICITY.
   - Single/Multivalued (Phone NR).
   - Keys.

**Véase Relational Schema, Instance and Keys en SQL & Databases Fundamental**

### DRIVEME Academy Attributes

Escribimos los atributos requeridos primero antes de entrar directamente al diagrama.

   * School:

      - school_id
      - street_name
      - street_number
      - postal_code
      - state
      - city

   * Instructor:

      - teacher_id
      - first_name
      - last_name
      - hiring_date
      - school_id

   * Student:

      - student_id
      - first_name
      - last_name
      - date_of_birth
      - enrollment_date    (Elimino esto ya que se encuentra en Lesson)
      - school_id

   * Exam:

      - student_id
      - teacher_id
      - date_taken
      - passed
      - lesson_id

   * Lesson:

      - lesson_id
      - date_of_enrollment
      - package
      - student_id

   * Vehicle:

      -
      -

   * Maintenance:

      -
      -

---------------------------------------------------------------------------------------------------------------------------------------

## STEP 3: Relationships

Determinar las relaciones entre las entidades.

   - Representa la asosiación entre dos entidades.
   - Tiene una entidad de padre e hijo.
   - Se describe con un verbo.
   - Tiene cardinalidad (1:1, 1:N, M:N).
   - Tiene modalidad (NULL, NOT NULL).
   - Puede ser dependiente o independiente.

Pueden ser:

   - 1 TO 1          (i.e: Un estudiante tiene un carro)
   - 1 TO MANY       (i.e: Un instructor tiene varios estudiantes)
   - MANY TO MANY    (i.e: Multiples películas mostrandose en distintas salas en un cine)

Las entidades se conectan mediante una linea que representa la relación. (CROWSFEET)

**Véase la imagen de Crowsfeet**.
La primera linea representa la relación.
La segunda linea la restricción (constraint).
Hay distintos estándar para hacer relaciones (IDEF1X, CHEN, CROW'S FOOT).

---------------------------------------------------------------------------------------------------------------------------------------

## STEP 4: Many to Many

En el Relational Model, no es posible almacenar una relación Many to Many.
"Técnicamente" se puede hacer, pero realmente no debes hacerlo, ya que solo trae más complicaciones. 

Al hacerlo, se generan Overhead (gastos generales):

   - Insert Overhead.
   - Update Overhead.
   - Delete Overhead.
   - Potential Redundancy.
   - Duplicated data.

Como regla de oro, siempre intenta resolver los Many to Many (INTERMEDIATE ENTITIES).
Si te encuentras un Many to Many en alguna estructura, es importante preguntar el porqué. Puede tener una razón.

Sin embargo, para resolver Many to Many entre dos entidades, se crea una entidad intermedia que pueda relacionar de manera más coherente y comoda a las dos entidades anteriores.

* Ejemplo Many to Many:

   BOOK >|-----|< AUTHOR      -- Donde un BOOK puede tener multiples AUTHOR, y un AUTHOR puede tener multiples BOOK.

   La solución al problema sería con un **Intermediate Entity**:

   BOOK ||-----|< BOOK_AUTHOR >|-----|| AUTHOR  -- Un BOOK puede tener muchos BOOK_AUTHOR, pero un BOOK_AUTHOR solo tiene un BOOK.
                                                -- Un AUTHOR puede ser el autor de varios BOOK_AUTHOR, pero un BOOK_AUTHOR solo tiene  un AUTHOR.

Otro ejemplo sería la tabla Enrollment en el ejemplo en Database Management.

---------------------------------------------------------------------------------------------------------------------------------------

## STEP 5: Subject Area

Divide entidades en grupos lógicos relacionados entre si. (Think Schemas)

Subject Area Rules:

   - Todas las entidades deben pertenecer a una.
   - Una entidad solo puede pertenecer a una.
   - Puedes anidar subject areas.

En el ejemplo DRIVEME, podemos agrupar de la forma:

   * Administration: School.
   * Education: Student, Instructor, Lesson, Exam.
   * Inventory: Vehicle, Maintenance.

No necesariamente deben agruparse de esta forma, eso depende del arquitecto.

---------------------------------------------------------------------------------------------------------------------------------------

## EXERCISE: Paintings Reservations

A rich business man has tons of paintings.
He wants to build a system to catalog and track where his art is.
He lends it to museums all across the world.
He even wants to see reservations.

Some constraints to note:

   - A painting can only have one artist.

Let's answer some questions about the system:

   - What's the goal of the system?

      > Track painting reservations for a wealthy man.

   - Who are our stakeholders? 

      > Owners, Museums.

Now let's follow our 5 steps of Top-Down to create an ERD of the system.

### Step 1: Entities

   * Museum
   * Painting
   * Artist
   * Reservation

NOTA: Las pegue todas! :D

### Step 2: Attributes

   * Museum:

      - museum_id
      - name
      - address
      - phone_number
      - email

   * Painting

      - painting_id
      - name
      - creation_date
      - style

   * Artist

      - artist_id
      - name
      - birth_date
      - email

   * Reservation

      - reservation_id
      - creation_date
      - date_from
      - date_to
      - accepted


### Step 3: Relationships

   - Artist       ||-----|<   Painting
   - Painting     >|-----0<   Reservation    (Many to Many)
   - Reservation  >0-----||   Museum

### Step 4: Many to Many

   - Artist             ||-----|<   Painting
   - Painting           ||-----0<   Reservation_detail
   - Reservation_detail >|-----||   Reservation
   - Reservation        >0-----||   Museum

### Step 5: Subject Areas

   * Inventory: Artist, Painting.
   * Administration: Reservation_detail, Reservation.
   * Client: Museum.

---------------------------------------------------------------------------------------------------------------------------------------

## EXERCISE: Movie Theatre

Tenemos el siguiente ERD:

   - Movie >|-----|< Auditorium >|-----|| Theater

Debemos arreglar el Many to Many de la manera más simple.
Yo habría agregado algo como "Movie_schedule" como el horario de las películas.

   - Movie ||-----0< Showing >0-----|| Auditorium >|-----|| Theater

---------------------------------------------------------------------------------------------------------------------------------------

## BOTTOM UP DESIGN

Tratamos de crear un Data Model a partir de detalles específicos, sistemas ya existentes, legado de sistemas, etc.

Es necesario:

   - Identificar la data (Atributos).
   - Agruparlos (en Entidades)

**El objetivo es crear un Data Model "perfecto" sin redundancias y anomalias (Al menos, lo menos posible).**

Supongase una tabla con las siguientes entidades:

   > Entidades: customer, balance, branch, address.  

No es correcto, esto genera anomalias y redundancias ya que hay información de dos cosas distintas en una sola tabla.
Además que se repite las direcciones una y otra vez innecesariamente. 

### Anomalies

Anomalias de modificación son problemas que surgen cuando tu base de datos no esta correctamente estructurada.
Es de suma importancia evitar estos problemas.
Hay 3 tipos de anomalías:

   1. Update Anomalies: Debemos asegurarnos que los cambios se apliquen a toda la data relacionada.
                        Por ejemplo, si en una base de datos se cambia una dirección como (100 Front Street a 101 Front Street).
                        Si en la base de datos esta dirección se repite en multiples filas, ese cambio es un Update Anomalie.

   2. Insert Anomalies: Debemos asegurarnos que no perdamos data importante y evitar dependencias funcionales.
                        Por ejemplo, que en una tabla al eliminar un cliente, no se pierda la información de una sucursal. 
                        Para este caso deberían ser dos tablas distintas.

   3. Delete Anomalies: Debemos verificar que la data sea consistente.
                        Por ejemplo, si alguien añadió a la base de datos una dirección incorrecta, que esto no afecte.

Es necesario evitar dependencias entre la data que genere problemas para el resto de la data. 
Esto es fundamental para el diseño de base de datos.

### Normalization

Es el proceso que se sigue en Bottom-Up Design para obtener una estructura de datos robusta y correcta.
Es un proceso fundamental para evitar o disminuir anomalias y redundancias. 

Para la tabla ejemplar anterior, se puede separar en dos tablas aisladas tal que:

   > Customer: customer, balance, branch_id.
   > Branch: branch_id, branch, address.

Para entender el proceso de Normalization, es necesario saber de:

   * Functional Dependencies
   * Normal Forms

### Functional Dependencies

Una functional dependency representa una relación entre atributos.
Existe cuando una relación entre dos atributos permite determinar de manera única el valor del atributo correspondiente.

NOTA: A continuación se refiere a las entidades como "R" y a los atributos como "A" y "B". Véase el siguiente ejemplo:

   Se dice que "A" es funcional dependiente de "B", si un valor de "B" determina un valor de "A".  
   Es decir, basado en el valor de "B", se puede determinar el valor de "A".

   > B ---> A

Ejemplos:
   
   > DETERMINANT   --->   DEPENDANT
   > student_id    --->   birth_date
   > emp_no        --->   first_name
   > composite_key --->   dep_key 

### Normal Forms

La normalización sucede a través de un proceso de "ejecutar" atributos mediante los Normal Forms.

   > Normal Forms: 0NF, 1NF, 2NF, 3NF, BCNF, 4NF, 5NF, 6NF.

Las normal form desde 0NF hasta BCNF (Boyce-Codd o 3.5 NF) son las más comunes de ejecutar.
Las normal form 4 y 5 existen para reducir anomalias en escenarios muy específicos. 
La 6ta aún no está estandarizada.

**NOTA: 
Cada Normal Form apunta tanto a separar aún más las relaciones en pequeñas instancias, como a crear menos redundancias y anomalias.**

#### 0NF TO 1NF

La data está en 0NF cuando "no está normalizada". Puede tener:
   
   1. Se repiten grupos de campos.        ---> Cuando una tabla contiene dos o más columnas demasiado relacionadas.
   2. Hay dependencia posicional de data.
   3. Data no atómica.

Para saltar a 1NF, tratamos de normalizar la data de manera que:

   1. Se eliminen las columnas repetidas de la misma data.
   2. Cada atributo deba contener un valor único.
   3. Determinar una Primary Key.

#### 1NF TO 2NF

Para saltar a 2NF, es necesario que:

   1. Se encuentre en 1NF.
   2. Todos los atributos que no son Key son completamente funcional dependiente de la Primary Key.

#### 2NF TO 3NF

En este punto, la data ya ha tomado forma. Sin embargo, aún puede normalizarse más. 
Para saltar a 3NF, es necesario que:

   1. Se encuentre en 2NF.
   2. No hayan Transitive Dependencies. Debemos evitar este tipo de relaciones.

Transitive Dependencies refiere a que:

   > A es funcional dependiente de B, y B es funcional dependiente de C, 
   > Es decir, C es "transitivo dependiente" de A a través de B.

   > C ---> B ---> A , es decir, A ~ > C.

#### BOYCE-CODD NF

Difiere solo un poco de 3NF. Es decir, la mayoría de las relaciones en 3NF ya se encuentran en BCNF, pero no todas.
3NF permite a los atributos ser parte de una Candidate Key, pero eso no es una Primary Key!
Para saltar a BCNF, es necesario que:

   1. Se encuentre en 3NF.
   2. Para cualquier dependencia "A ---> B", "A" debe ser una Super Key. 

Una relación NO está en BCNF si:

   1. La Primary Key es una Composite Key.
   2. Hay más de un Candidate Key.
   3. Algunos atributos tienes Keys en común.

NOTA: Basta con que se cumpla la 2 de estas 3 condiciones.

#### WHY 4NF AND 5NF ARE NOT USEFUL

En la gran mayoría de los casos, ni siquiera se pasa de 3NF. BCNF es poco. El resto casi no se usa.

4NF: https://www.studytonight.com/dbms/fourth-normal-form.php
5NF: https://www.studytonight.com/dbms/fifth-normal-form.php

---------------------------------------------------------------------------------------------------------------------------------------

### Ejemplo de Normal Forms anterior:

0NF               1NF               2NF               3NF                  BCNF

book              BOOK              BOOK
title             book_id*          book_id*
author            title             title
author_name
author_address
author_email      BOOK_AUTHOR       BOOK_AUTHOR
                  book_id*          book_id*
                  author_id*        author_id*
                  author_name       
                  author_address    AUTHOR
                  author_email      author_id
                                    author_name
                                    author_address
                                    author_email

NOTA: Le añadi * a las primary key.

- En 0NF todo está demasiado mal estructurado. Muchos valores repetidos para libros de multiples autores.
- En 1NF aún existe una Many to Many Relation con BOOK_AUTHOR. Para el mismo book_id se repiten multiples autores.
- En 2NF por fin se limpia el Many to Many. Se aseguró que los atributos que no son key, sean funcional dependientes por completo.

**NOTA: Véase el segundo ejemplo guardado en imagen "Normal Form A/B".**

---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------