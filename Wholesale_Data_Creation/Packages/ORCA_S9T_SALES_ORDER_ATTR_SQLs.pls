CREATE OR REPLACE PACKAGE ORCA_S9T_SALES_ORDER_ATTR_SQL IS
-------------------------------------------------------------------------------
-- CREATE DATE - 2022/04
-- CREATE USER - Innovation and Technology Center
-- PROJECT     - ORCA
-- DESCRIPTION - Package to manage SALES ORDER ATTRIBUTES template
-------------------------------------------------------------------------------
-- Global Variables
LP_PROGRAM       VARCHAR2(64)  := 'ORCA_S9T_SALES_ORDER_ATTR_SQL'; 
--
-------------------------------------------------------------------------------
FUNCTION ENQUEUE(O_error_message out varchar2,
                 I_process_id    in  number)
RETURN BOOLEAN;
-------------------------------------------------------------------------------
PROCEDURE DEQUEUE(context  raw,
                  reginfo  sys.aq$_reg_info,
                  descr    sys.aq$_descriptor,
                  payload  raw,
                  payloadl number);
-------------------------------------------------------------------------------
FUNCTION VALIDATE(O_error_message          OUT VARCHAR2,
                  IO_orca_s9t_error_tbl IN OUT orca_s9t_error_tbl,
                  I_process_id          IN OUT NUMBER)
RETURN BOOLEAN;
-------------------------------------------------------------------------------
function MERGE_INFO (O_error_message  OUT VARCHAR2,
                     I_process_id     IN  NUMBER)
RETURN BOOLEAN;
-------------------------------------------------------------------------------
FUNCTION PROCESS(O_error_message OUT VARCHAR2,
                 I_process_id    IN  NUMBER)
RETURN BOOLEAN;
-------------------------------------------------------------------------------
END ORCA_S9T_SALES_ORDER_ATTR_SQL;
/
