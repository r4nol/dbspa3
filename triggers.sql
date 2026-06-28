-- Order total refreshing trigger

CREATE OR REPLACE FUNCTION trigger_update_order_total()

RETURNS TRIGGER AS $$

BEGIN

    IF TG_OP = 'DELETE' THEN

        UPDATE orders

        SET total_amount = calculate_order_total(OLD.order_id)

        WHERE order_id = OLD.order_id;

        RETURN OLD;

    ELSE

        UPDATE orders

        SET total_amount = calculate_order_total(NEW.order_id)

        WHERE order_id = NEW.order_id;

        RETURN NEW;

    END IF;

END;

$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_update_order_total

AFTER INSERT OR UPDATE OR DELETE ON order_items

FOR EACH ROW EXECUTE FUNCTION trigger_update_order_total();



-- Logging trigger

CREATE OR REPLACE FUNCTION trigger_order_audit_log()

RETURNS TRIGGER AS $$

BEGIN

    INSERT INTO order_log (order_id, customer_id, action, log_date)

    VALUES (NEW.order_id, NEW.customer_id, 'ORDER_CREATED', CURRENT_TIMESTAMP);

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_order_audit_log

AFTER INSERT ON orders

FOR EACH ROW EXECUTE FUNCTION trigger_order_audit_log();
