/* CLUES

    Clue #1: It was an inside job.
    Clue #2: It was done on 2020-06-23
    Clue #3: You had to be on location to steal the data and Keiko is located in the heart of Downtown New York.
        * Keiko Corp Latitude: -74.997 to -74.9968
        * Keiko Corp Longitude: 40.5 to 40.6
*/
------------------------------------------------------------------------------------------------

-- Vistazo rápido a la data.
-- SELECT * FROM "public"."promo_codes";
-- SELECT * FROM "public"."rides";
-- SELECT * FROM "public"."user_promo_codes";
-- SELECT * FROM "public"."users"; 
-- SELECT * FROM "public"."vehicle_location_histories";
-- SELECT * FROM "public"."vehicles";


-- vehicle_location_histories posee ciudad, ride_id, fecha, latencia y longitud.
-- CREATE VIEW suspected_rides AS
/*
SELECT * 
FROM vehicle_location_histories AS vlh
WHERE city = 'new york' AND
      vlh.timestamp::DATE = '2020-06-23'::DATE AND
      (lat BETWEEN -74.997 AND -74.9968) AND
      (long BETWEEN 40.5 AND 40.6);
*/

 --CREATE VIEW suspicious_drivers AS
 --DROP VIEW suspicious_drivers 
/*
SELECT    
    DISTINCT rides.vehicle_id AS vehicle_id,    -- vehicle_id
    users.name AS owner_name,                   -- owner_name
    users.address,                              -- address
    vehicles.status,                            -- status
    vehicles.current_location                   -- current location      
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id           -- Unión mediante el id del ride
JOIN vehicles ON vehicles.id = rides.vehicle_id     -- Unión mediante el id del vehiculo
JOIN users ON users.id = vehicles.owner_id          -- Unión mediante el id del usuario
*/

-- SELECT * FROM suspicious_drivers

------------------------------------------------------------------------------------------------
--    Clue #4: It's not the drivers. It's mostly one of the riders.
------------------------------------------------------------------------------------------------

-- CREATE VIEW suspicious_riders AS
/*
SELECT 
    DISTINCT rides.vehicle_id AS vehicle_id,
    users.name AS "Rider Name",
    users.address AS "Address"
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id           -- Unión mediante el id del ride
JOIN users ON users.id = rides.rider_id             -- Unión mediante el id del usuario
*/

-- SELECT * FROM suspicious_riders

------------------------------------------------------------------------------------------------
--    Clue #5: It's not the riders.
--    Clue #6: It was an inside job. There are 2 persons who worked together.
------------------------------------------------------------------------------------------------

-- Ya tenemos ambas vistas. Debemos relacionarlas.
-- SELECT * FROM suspicious_riders
-- SELECT * FROM suspicious_drivers

--CREATE VIEW suspect_rider_names AS
/*
SELECT DISTINCT
    split_part( users.name, ' ', 1) AS "first_name",
    split_part( users.name, ' ', 2) AS "last_name"
FROM suspected_rides
JOIN rides ON rides.id = suspected_rides.ride_id
JOIN users ON users.id = rides.rider_id
*/

-- SELECT * FROM suspect_rider_names        -- Para correlacionarlo con Employees

-- SE LLEVA A CABO EL DBLINK ENTRE DOS BASES DE DATOS
-- create extension dblink; -- run this to run queries across databases
/*
SELECT DISTINCT
    CONCAT(t1.first_name, ' ', t1.last_name) AS "employee",
    CONCAT(u.first_name, ' ', u.last_name) AS "rider"
FROM dblink('host=localhost user=postgres password=root dbname=Movr_Employees',
            'select first_name, last_name FROM employees;')
AS t1(first_name NAME, last_name NAME)
JOIN suspect_rider_names AS u ON t1.last_name = u.last_name
order by "rider"
*/

-- DE ESTA ULTIMA SE ENCUENTRAN 3 RIDERS, DOS DE ELLOS SON LOS CULPABLES. FINALIZADO EL MISTERIO.