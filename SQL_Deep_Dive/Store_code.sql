-- Exercise: Filtering Data
-- SELECT count(*) FROM customers WHERE gender='F' AND (state='OR' or state='NY')

-- Exercise: NOT 
-- SELECT count(*) FROM customers WHERE NOT age=55 AND NOT age=52;

-- Exercise: Comparison Operators
-- SELECT count(income) from customers where age>44 AND income >= 100000;

-- Exercise: Dates
-- SELECT DATE_TRUNC('month', orderdate) from orders
-- SELECT COUNT(orderid) FROM orders WHERE DATE_TRUNC('month', orderdate) = date '2004-01-01';                      -- Opcion 1: DATE_TRUNC
-- SELECT COUNT(*) FROM orders WHERE EXTRACT(YEAR FROM orderdate) = 2004 AND EXTRACT(MONTH FROM orderdate) = 01;    -- Opcion 2: EXTRACT
