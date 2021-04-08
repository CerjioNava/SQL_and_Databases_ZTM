
-- UNION 
/*
SELECT NULL AS "prod_id", sum(ol.quantity)
FROM orderlines AS ol

UNION

SELECT prod_id AS "prod_id", sum(ol.quantity)
FROM orderlines AS ol 
GROUP BY prod_id
ORDER BY prod_id DESC;
*/

-- GROUPING SETS
/*
 SELECT prod_id AS "prod_id", sum(ol.quantity)
 FROM orderlines AS ol 
 GROUP BY 
 	GROUPING SETS (
   		(),
   		(prod_id)
   	)
ORDER BY prod_id DESC;
*/
/*
SELECT prod_id AS "prod_id", orderlineid, sum(ol.quantity)
FROM orderlines AS ol 
GROUP BY 
  	GROUPING SETS (
   		(),											-- Sin agrupar nada, expresa solo la suma total.
   		(prod_id),									-- Agrupando por prod_id, expresa la suma por grupo.
   		(orderlineid)                               -- Agregamos otro set, y esto se verá unido.
   	)
ORDER BY prod_id DESC, orderlineid DESC;
*/

-- ROLL UP 
-- EJEMPLO CON ROLL UP:
/*
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
*/
 
 
 