CREATE OR REPLACE PACKAGE WP_ORDER_APPROVAL_SQL AUTHID CURRENT_USER AS

/*--- message type parameters ---*/
APPROVED      CONSTANT  VARCHAR2(1) := 'A';
WORKSHEET     CONSTANT  VARCHAR2(1) := 'W';
CANCELLED     CONSTANT  VARCHAR2(1) := 'C';
-- --------------------------------------------------------------------------------
FUNCTION APPROVE_ORDER(O_error_message         OUT VARCHAR2,
                       I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE)
RETURN BOOLEAN;
--------------------------------------------------------------------------------
FUNCTION CANCEL_ORDER(O_error_message         OUT VARCHAR2,
                       I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE)
RETURN BOOLEAN;
--------------------------------------------------------------------------------
END WP_ORDER_APPROVAL_SQL;
/
