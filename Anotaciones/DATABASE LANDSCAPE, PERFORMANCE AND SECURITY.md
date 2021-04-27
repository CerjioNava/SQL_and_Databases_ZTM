# DATABASE LANDSCAPE, PERFORMANCE AND SECURITY

# SUMMARY

   - SCALABILITY
   - SHARDING
   - REPLICATION
   - BACKUPS
   - DISTRIBUTED VS CENTRALIZED DATABASES
   - SECURITY
   - SQL INJECTION
   - RELATIONAL VS NOSQL
   - NEWSQL, ELASTICSEARCH, AMAZON S3.
   - TOP DATABASES TO USE

-------------------------------------------------------------------------------------------------------------------------------------

## Scalability

Se refiere a la capacidad de la database para manejar un crecimiento de data constante.
Hay dos tipos de estrategia:

   1. Vertical Scalability: Añadir más capacidad o almacenamiento a una sola base de datos.

   2. Horizontal Scalability: Añadir más capacidad mediante más bases de datos.

Añadir de manera horizontal puede ser bueno pero puede generar complicaciones.
Si una data debe actualizarse en ambas bases de datos, el tiempo de actualización varía y son operaciones simultaneas. 
La manera de comunicarse entre si también debe ser robusta y coherente, algo que es dificil.

A medida que la data crece más y más, es probable que se trabaje con Horizontal Scaling. Entonces Sharding es esencial.

-------------------------------------------------------------------------------------------------------------------------------------

## Sharding

Sharding se trata de dividir la data entre distintas bases de datos.
En este caso, es necesario un sistema que señale la localización de la data distribuida.

Por ejemplo, en facebook quizá separan la data de usuarios en distintas database por iniciales tipo A-J, K-T, U-Z.
Entonces, mediante un sistema de distribución puedes buscar un dato específico en la database correcta de una vez.

La data puede dividirse de muchas distintas maneras lógicas, por cantidad de data, según el tipo de data, etc.

-------------------------------------------------------------------------------------------------------------------------------------

## Replication

Consta de replicar la data en multiples máquinas para asegurar que no se pierda. 
Claro, esto implica consistencia entre la data compartida entre las máquinas.
Esto ayuda mucho también en el Horizontal Scaling.

Por ejemplo, si una máquina que posea una base de datos sufra algún daño, se corrompa, etc, no se pierda la data.
Por otro lado, se puede acceder a la misma data desde distintas direcciones, agilizando el proceso.

Hay dos tipos de estrategias:

   1. Synchronize: Un cambio en la data de una máquina no se realiza hasta que se apruebe en el resto de máquinas.
   				   Una desventaja es el tiempo de actualización y respuesta.

   2. Asynchronize: Luego del cambio en la data de una máquina, se actualizará en el resto de máquinas.
   					Una desventaja es que si ocurre un error, puede perjudicar el resto de la data.

Estas estrategias dependerán del sistema que se quiere optimizar, si es data consistente o inconsistente.

-------------------------------------------------------------------------------------------------------------------------------------

## Backups

Similar a Replication, pero a diferencia que los Backups no funcionan a tiempo real.
Lleva mucho tiempo hacer un backup, por eso se hace cada cierto período de tiempo (diario, semanal, mensual, etc).

El backup normalmente se realiza mediante un "dump" de la data en un archivo (usualmente .SQL).
Es importante hacer el backup con fecha y hora (i.e. database backup 2021-04-15 12:00:00), de esta manera mantener un control de backups.

-------------------------------------------------------------------------------------------------------------------------------------

## Distributed vs Centralized Databases

* Centralized: Usualmente se guarda en una localización única de una red o es controlada por una compañia.
			   La integridad de data es más facil y consistente.
			   Sin embargo, tiene la desventaja de ser data almacenada en un solo lugar.

* Distributed: Multiples databases almacenadas en distintas localizaciones físicas o controladas por distintas compañias.
			   Aún así, la database principal puede ser centralizada aún estado distribuida.

**NOTA: Buscar Blockchain**

-------------------------------------------------------------------------------------------------------------------------------------

## Security

Entre las prácticas más comunes de seguridad tenemos:

   * Que los usuarios solo vean la data que estan autorizados a ver.
   * Mantener en la raya a usuarios sin autorización acceder a la base de datos.
   * Prevenir la corrupción de data (base de datos en un lugar seguro y funcional, que no se dañe).
   * Que la disponibilidad de la data siempre funcione y no se crashee. 

Todo esto del nivel de seguridad de una compañia. 
En esencial, se debe crear una base de datos que adquiera la data necesaria y que los distintos accesos los posean solo quienes deben.

-------------------------------------------------------------------------------------------------------------------------------------

## SQL INJECTION (IMPORTANTE)

Inyectar comandos SQL a una base de datos para fines malvados.

**NOTA: Este es un tema extenso y opcional, pero importante**

Let's learn about one of the most common ways attackers can affect a Database: SQL Injections!

**INTERESANTE**
First, let's learn how it works by actually performing it on a database. 
Go to this link to try the interactive exercise: https://www.hacksplaining.com/exercises/sql-injection	

**INTERESANTE**
Once done, you can learn about how to prevent this sort of attack here: https://www.hacksplaining.com/prevention/sql-injection

How to Store User Passwords: https://rangle.io/blog/how-to-store-user-passwords-and-overcome-security-threats-in-2017/

-------------------------------------------------------------------------------------------------------------------------------------

## Relational vs NoSQL (PostgreSQL vs MongoDB)

Depende de la situación. **BUSCAR**

-------------------------------------------------------------------------------------------------------------------------------------

## Future of Relational Databases

### NewSQL

Es un nuevo SQL que está surgiendo al igual que otras DBMS.

### ElasticSearch

Mejor para busquedas en databases.

**NOTA: Es bueno tener distintas bases de datos para distintos problemas y necesidades.**

### Amazon S3 (Object Storage)

Sirve para almacenar objects de gran tamaño.
Objects pueden ser bloques grandes de data (como videos por ejemplo). 

-------------------------------------------------------------------------------------------------------------------------------------

## TOP DATABASES TO USE (Recommendation)

   * PostgreSQL
   * MongoDB
   * Amazon DocumentDB
   * Firebase
   * ElasticSearch
   * Redis
   * Amazon S3

-------------------------------------------------------------------------------------------------------------------------------------