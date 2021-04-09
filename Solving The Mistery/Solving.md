# SOLVING THE MISTERY

# BIG DATA BREACH AT KEIKO CORP

It's time to setup your environment for the great theft of Keiko Corp! Given we're SQL masters at this point it's time to put on our Sherlock Holmes hat and try to sniff out who did it!

We have two solid clues so far:

### Clue #1: It was an inside job.

### Clue #2: It was done on 2020-06-23

With the assumption that it could be an inside job, Keiko Corp has given us full access to their Employee database and their number 1 product: Movr the ride-sharing platform that has taken the globe by storm!  Bruno's hoping that by sifting through all of the data we may uncover some connection with the breach!

For this part of the course you'll need 2 databases:

   1. Movr_Employees: This database contains all relevant information about the Employees of Keiko Corp.

   Note: this database is slightly different than the Employees database you've been using throughout the course. You will see me reference the "Employees" database in the solution videos, however, this is an altered version of the data for the purpose of solving the mystery!

   2. Movr: A ride-sharing product that Keiko offers to consumers.

To restore the Movr backup make sure to do the following steps in order!

   1. Create a database named Movr

   2. Restore the schema.sql first to the Movr database

   3. Restore the data.sql next

To restore the Movr_Employees backup make sure to do the following steps in order!

   1. Create a database named Movr_Employees

   2. Restore the movr_employees.sql

### Clue #3: You had to be on location to steal the data.

Keiko employees and their family travel for free with the Movr platform and since **Keiko is located in the heart of Downtown New York**, he's thinking they may have used the platform to get around.

With what we know now, we should be able to deduce some information from the Movr database. Let's try to figure out what vehicles were at the location of Keiko Corp, and let's not forget our very first clue!

   - Date of incident: 2020-06-23

   - Keiko Corp Latitude: -74.997 to -74.9968

   - Keiko Corp Longitude: 40.5 to 40.6

1. With this information we should be able to figure out which Movr rides happened that day around the office!
Try to sift through the database and figure out what table we need to query and what our query would be!

2. Once you figure out what rides occurred around the office that day, Bruno asks you to find the vehicle and owner info linked to those rides. Make sure you don't have duplicates! (see image below for expected columns)

Now that we know which vehicles were linked to those rides we use their current location to go and interrogate them for more information!

### Clue #4: It's not the drivers. It's mostly one of the riders.

So with our current setup, we go ahead and filter out all of the unique riders that were on those suspected rides on that horrible day of the theft.

Make sure to rename the column to "rider name"

### Clue #5: It's not the riders.

### Clue #6: It was an inside job. There are 2 persons who worked together.

For this part of the mystery, we're going to have to do something special. We're going to have to cross-reference data between 2 separate databases. That's crazy! How do we do that?

Not to worry, it's simpler than it sounds. Just like when we generated those UUID's we need to add a new extension to our database and so we need to install it!

   > create extension dblink; -- run this to run queries across databases

This will install a special utility called dblink that we can then use to query and filter across databases.

Here's an example on how to use dblink:

   SELECT *
   FROM dblink('host=localhost user=postgres password=postgres dbname=Employees', 'SELECT <column> FROM employees;') AS t1(<column> NAME) 

   - In the above query, you must be aware that the AS clause in the from statement is extremely important to be able to correctly refer to and work with the selected data

   - Also note that it is a bit different than the normal syntax we've seen as with dblink. You must return an alias that maps the columns returned and the NAME identifier you see is doing just that

   - Try to write a query with the above that returns the first and last name, but make sure you're running this query from the Movr database

Now that we're dblink masters, let's get on to the more interesting query.

1. We need to create a view that solely contains the first and last name separated of the suspected riders, as their name field contains both first and last name combined. Use the SQL function split_part to split the rider's name into two segments (first_name, last_name)!

2. Then we need to write a query that connects to the Employee database with dblink and cross-reference the first and last names of the riders against the names of the Employees

With the information from this query, we should be able to narrow down who did it!

------------------------------------------------------------------------------------------------------------------------------------

## SOLUCION PASO A PASO:

-- Vistazo rápido a la data.
-- SELECT * FROM "public"."promo_codes";
-- SELECT * FROM "public"."rides";
-- SELECT * FROM "public"."user_promo_codes";
-- SELECT * FROM "public"."users"; 
-- SELECT * FROM "public"."vehicle_location_histories";
-- SELECT * FROM "public"."vehicles";

------------------------------------------------------------

-- vehicle_location_histories posee ciudad, ride_id, fecha, latencia y longitud.

CREATE VIEW suspected_rides AS
SELECT * 
FROM vehicle_location_histories AS vlh
WHERE city = 'new york' AND
      vlh.timestamp::DATE = '2020-06-23'::DATE AND
      (lat BETWEEN -74.997 AND -74.9968) AND
      (long BETWEEN 40.5 AND 40.6);

-- SELECT * FROM suspected_rides

------------------------------------------------------------

-- Obtención de tabla exigida con drivers.

CREATE VIEW suspicious_drivers AS
SELECT    
    DISTINCT rides.vehicle_id AS vehicle_id,    -- vehicle_id
    users.name AS owner_name,                   -- owner_name
    users.address,                              -- address
    vehicles.status,                            -- status
    vehicles.current_location                   -- current location      
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id    -- Unión mediante el id del ride
JOIN vehicles ON vehicles.id = rides.vehicle_id     -- Unión mediante el id del vehiculo
JOIN users ON users.id = vehicles.owner_id          -- Unión mediante el id del usuario

-- SELECT * FROM suspicious_drivers

------------------------------------------------------------------------------------------------
--    Clue #4: It's not the drivers. It's mostly one of the riders.
------------------------------------------------------------------------------------------------

-- Se observan los riders.

CREATE VIEW suspicious_riders AS
SELECT 
    DISTINCT rides.vehicle_id AS vehicle_id,
    users.name AS "Rider Name",
    users.address AS "Address"
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id           -- Unión mediante el id del ride
JOIN users ON users.id = rides.rider_id             -- Unión mediante el id del usuario

-- SELECT * FROM suspicious_riders

------------------------------------------------------------------------------------------------
--    Clue #5: It's not the riders.
--    Clue #6: It was an inside job. There are 2 persons who worked together.
------------------------------------------------------------------------------------------------

-- Ya tenemos ambas vistas. Debemos relacionarlas.
-- SELECT * FROM suspicious_riders
-- SELECT * FROM suspicious_drivers

CREATE VIEW suspect_rider_names AS
SELECT DISTINCT
    split_part( users.name, ' ', 1) AS "first_name",
    split_part( users.name, ' ', 2) AS "last_name"
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id
JOIN users ON users.id = rides.rider_id

-- SELECT * FROM suspect_rider_names        -- Para correlacionarlo con Employees

-- SE LLEVA A CABO EL DBLINK ENTRE DOS BASES DE DATOS
create extension dblink; 		-- run this to run queries across databases

SELECT DISTINCT
    CONCAT(t1.first_name, ' ', t1.last_name) AS "employee",
    CONCAT(u.first_name, ' ', u.last_name) AS "rider"
FROM dblink('host=localhost user=postgres password=root dbname=Movr_Employees',
            'select first_name, last_name FROM employees;')
AS t1(first_name NAME, last_name NAME)
JOIN suspect_rider_names AS u ON t1.last_name = u.last_name
order by "rider"

-- DE ESTA ULTIMA SE ENCUENTRAN 3 RIDERS, DOS DE ELLOS SON LOS CULPABLES. FINALIZADO EL MISTERIO.