-- create table customers
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name TEXT
);

-- create table menus
CREATE TABLE menus (
  menu_id INT PRIMARY KEY, 
  menu_name TEXT,
  menu_price INT,
  type_id INT
);

-- create table types
CREATE TABLE types (
  type_id INT PRIMARY KEY,
  type_name TEXT
);

-- create table orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  order_quantity INT,
  order_date DATE,
  customer_id INT,
  menu_id INT 
);

-- insert data
INSERT INTO customers VALUES 
  (1, "Adams"), 
  (2, "Blake"), 
  (3, "Clark"), 
  (4, "Davis"), 
  (5, "Sam"),
  (6, "Su"),
  (7, "Kevin");

INSERT INTO menus VALUES 
  (1, "Pizza", 300, 1),
  (2, "Hamburger", 250, 1),
  (3, "French Fries", 150, 2),
  (4, "Spaghetti", 150, 1),
  (5, "Salad", 80, 2); 

INSERT INTO types VALUES
  (1, "main"),
  (2, "side");

INSERT INTO orders VALUES
  (1, 2, "2022-08-03", 1, 1),
  (2, 1, "2022-08-03", 1, 3),
  (3, 3, "2022-08-03", 1, 2),
  (4, 2, "2022-08-03", 2, 1),
  (5, 1, "2022-08-07", 3, 1),
  (6, 2, "2022-08-07", 3, 5),
  (7, 1, "2022-08-07", 4, 4),
  (8, 3, "2022-08-07", 4, 1),
  (9, 2, "2022-08-10", 5, 5),
  (10, 1, "2022-08-13", 6, 1),
  (11, 1, "2022-08-13", 6, 4),
  (12, 1, "2022-08-15", 7, 3);

-- run code
.mode box 
SELECT * FROM customers;
SELECT * FROM menus;
SELECT * FROM types;
SELECT * FROM orders;

-- Join Function 
SELECT 
  customer_name,
  menu_name,       
  menu_price,         
  order_quantity,  
  order_date,      
  (order_quantity * menu_price) AS total
FROM customers ctm 
JOIN orders ord ON ctm.customer_id = ord.customer_id
JOIN menus mn ON ord.menu_id = mn.menu_id;

-- Aggreate Function
SELECT 
  customer_name, 
  SUM(order_quantity)              AS total_order,
  SUM(menu_price * order_quantity) AS total_price
FROM customers ctm 
JOIN orders ord ON ctm.customer_id = ord.customer_id
JOIN menus mn ON ord.menu_id = mn.menu_id
GROUP BY 1;

-- standard subqueries
SELECT 
  customer_id,
  SUM(order_quantity)
FROM (
  SELECT * FROM customers 
  JOIN orders 
  ON customers.customer_id = orders.customer_id
)
GROUP BY 1
ORDER BY 2 DESC;

 -- with clauses
 WITH menu AS (
   SELECT * FROM menus 
   WHERE menu_name = 'Pizza'
 ), order_customer AS (
   SELECT * FROM orders 
   WHERE order_date BETWEEN '2022-08-03' AND '2022-08-07' 
 )

 SELECT 
   SUM(order_quantity) total_order_pizza_
 FROM menu t1 
 JOIN order_customer t2
 ON t1.menu_id = t2.menu_id;
