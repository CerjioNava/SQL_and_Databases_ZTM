
-- EJEMPLO ZTM
-- Creamos una base de datos ZTM donde dentro del esquema "public", generaremos las tablas correspondientes.
-- Para el ejemplo completo, seguimos el "Entity Relationship Diagram" del curso. Con esto nos guiamos para las tablas.

/*
CREATE DOMAIN Rating SMALLINT CHECK (VALUE > 0 AND VALUE <= 5);
CREATE TYPE feedback AS (
    student_id UUID,
    rating RATING,
    feedback TEXT
);
*/

-- Añadimos la extensión del UUID la primera vez.
-- CREATE extension IF NOT EXISTS "uuid-ossp";

-- Tabla 1: Student
/*
CREATE TABLE student (
    student_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),  
    first_name VARCHAR(255) NOT NULL,                        
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,                -- Aquí se puede aplicar REGEX
    date_of_birth DATE NOT NULL
);
*/

-- Para añadir una columna a una tabla existente:
-- ALTER TABLE student ADD COLUMN email TEXT;

-- Tabla 2: Subject
/*
CREATE TABLE subject (
    subject_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subject TEXT NOT NULL,
    description TEXT
);
*/

-- Tabla 3: Teacher
/*
CREATE TABLE teacher (
    teacher_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,        
    email TEXT                                  -- Aquí se puede aplicar REGEX 
);
*/

-- Tabla 4: Course
/*
CREATE TABLE course (
    course_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "name" TEXT NOT NULL,
    description TEXT,
    subject_id UUID REFERENCES subject(subject_id),
    teacher_id UUID REFERENCES teacher(teacher_id),
    feedback feedback[]
);
*/

-- Tabla 5: Enrollment
/*
CREATE TABLE enrollment(
    course_id UUID REFERENCES course(course_id),
    student_id UUID REFERENCES student(student_id),
    enrollment_date DATE NOT NULL,
    CONSTRAINT pk_enrollment PRIMARY KEY (course_id, student_id)
);
*/

-- FINALIZADO EL MODELO DE DATA
-- ES HORA DE AÑADIR DATA

-- AÑADIENDO DATA A STUDENT Y TEACHER
/*
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
)
*/
/*
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
*/

-- Creating a course

-- AÑADIENDO DATA A SUBJECT
/*
INSERT INTO subject (
    subject,
    description
) VALUES (
    'SQL Zero to Mastery',          -- Nos equivocamos, pusimos el subject en la descripción :V
    'The Art of SQL Mastery'        -- Pero podemos eliminar e insertar nuevamente
)   
*/
-- DELETE FROM subject WHERE subject='SQL Zero to Mastery'
/*
INSERT INTO subject (
    subject,
    description
) VALUES (
    'SQL',                   
    'A database management language'
) 
*/

-- AÑADIENDO EL CURSO
/*
INSERT INTO course (
    "name",
    description
) VALUES (
    'SQL Zero to Mastery',                   
    'The #1 resource for SQL mastery'
) 
*/
-- Pero no especificamos el subject_id ni el teacher_id, son NULL. Entonces...
-- No debemos cambiar una columna de manera arbitraria si ya tenemos data. Debemos migrar información.
-- Rellenamos el vacio.
/*
UPDATE course 
SET subject_id = '58484afc-dedc-47ed-ae76-67e41e96e32c'
WHERE subject_id IS NULL;
*/
-- ALTER TABLE course ALTER COLUMN subject_id SET NOT NULL
-- Ya que alteramos course.subject_id para no permitir NULL, es necesario especificarlo al insertar la data.
-- Hacemos lo mismo para teacher.
/*
UPDATE course 
SET teacher_id = '72c53605-2340-4680-ab70-9e2f4caa08e7'
WHERE teacher_id IS NULL;
*/
-- ALTER TABLE course ALTER COLUMN teacher_id SET NOT NULL

-- AÑADIENDO ENROLLMENT
/*
INSERT INTO enrollment (
    student_id, 
    course_id, 
    enrollment_date
) VALUES (
    'df40553b-60f0-4f72-b917-ce88902928ac',
    'b80b4ba6-bb0c-45cd-88ab-0ed897ba2384',
    NOW()::DATE
);
*/

-- AÑADIENDO UN FEEDBACK
/*
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
*/
-- El query debe ser más complejo para poder añadir más feedbacks y no solo update el mismo feedback o la misma fila en Course.
-- Para eso, deberíamos cambiar el modelo de la data.
-- Véase el nuevo modelo de diagrama.

-- Creamos la tabla Feedback
-- Para crear la tabla feedback, primero debemos eliminar el Type Feedback creado anteriormente, o cambiarle el nombre.
-- Lo hacemos desde el "design" del type feedback. Esto cambia automaticamente el tipo del feedback en course.
-- Le cambiamos también el nombre a feedback_deprecated en course.
-- Ahora podemos ejecutar el query.
/*
CREATE TABLE feedback (
    student_id UUID not null REFERENCES student(student_id),
    course_id UUID NOT NULL REFERENCES course(course_id),
    feedback TEXT,
    rating Rating,
    CONSTRAINT pf_feedback PRIMARY KEY (student_id, course_id)
);
*/

-- Sin querer escribi mal feedback, lo renombramos:
-- ALTER TABLE feedback RENAME feedack TO feedback


-- Añadimos el feedback a la tabla Feedback
/*
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
*/






















