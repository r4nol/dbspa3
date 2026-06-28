-- Inserting mock data
INSERT INTO customers (full_name, email, balance) VALUES ('John Doe', 'john@example.com', 100.00);
INSERT INTO products (product_name, price, stock_quantity) VALUES ('Laptop', 1000.00, 5);
INSERT INTO products (product_name, price, stock_quantity) VALUES ('Mouse', 50.00, 20); 

-- 1. Create order test
CALL create_order(1);

-- 2. Loggin test
SELECT * FROM order_log;

-- 3. Order products adding test
CALL add_product_to_order(1, 1, 1);
CALL add_product_to_order(1, 2, 2);

-- 4. Checking warehouse balances (Laptop will be 4, Mouse - 18)
SELECT * FROM products;

-- 5. Checking order total (will be 1100.00)
SELECT * FROM orders WHERE order_id = 1;
