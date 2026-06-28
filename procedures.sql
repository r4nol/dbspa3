CREATE OR REPLACE PROCEDURE create_order(p_customer_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = p_customer_id) THEN
        RAISE EXCEPTION 'Customer % does not exist', p_customer_id;
    END IF;

    INSERT INTO orders (customer_id, order_date, total_amount)
    VALUES (p_customer_id, CURRENT_TIMESTAMP, 0);
END;
$$;


CREATE OR REPLACE PROCEDURE add_product_to_order(
    p_order_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_price NUMERIC(10,2);
    v_stock INT;
BEGIN
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be greater than zero';
    END IF;

    SELECT price, stock_quantity INTO v_price, v_stock
    FROM products 
    WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Not enough stock for product %', p_product_id;
    END IF;

    INSERT INTO order_items (order_id, product_id, quantity, price)
    VALUES (p_order_id, p_product_id, p_quantity, v_price);

    UPDATE products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;
END;
$$;
