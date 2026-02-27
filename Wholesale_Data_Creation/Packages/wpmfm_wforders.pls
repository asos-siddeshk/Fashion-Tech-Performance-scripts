
SET FEEDBACK OFF
SET ECHO OFF
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
CREATE OR REPLACE PACKAGE WPMFM_WFORDER AUTHID CURRENT_USER AS

/*--- message type parameters ---*/
HDR_ADD     CONSTANT  VARCHAR2(64) := 'XWFOrderCre';
HDR_UPD     CONSTANT  VARCHAR2(64) := 'XWFOrderMod';
HDR_DEL     CONSTANT  VARCHAR2(64) := 'XWFOrderDel';
DTL_ADD     CONSTANT  VARCHAR2(64) := 'XWFOrderDtlCre';
DTL_UPD     CONSTANT  VARCHAR2(64) := 'XWFOrderDtlMod';
DTL_DEL     CONSTANT  VARCHAR2(64) := 'XWFOrderDtlDel';

FAMILY      CONSTANT  RIB_SETTINGS.FAMILY%TYPE := 'NBXWFOrder';

TYPE wp_order_msg_rectype IS RECORD
                    (header_rec                WP_ORDER_HEAD%ROWTYPE);
-- --------------------------------------------------------------------------------
FUNCTION ADDTOQ(O_error_message         OUT VARCHAR2,
                I_message_type          IN  wp_order_mfqueue.MESSAGE_TYPE%TYPE,
                I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE,
                I_order_type            IN  wp_order_head.ORDER_TYPE%TYPE,
                I_order_header_status   IN  wp_order_head.STATUS%TYPE,
                I_item                  IN  wp_order_detail.ITEM%TYPE,
                I_location              IN  wp_order_detail.SOURCE_LOC_ID%TYPE,
                I_loc_type              IN  wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                I_custom_message_type   IN  VARCHAR2 DEFAULT 'N')
RETURN BOOLEAN;
--------------------------------------------------------------------------------
PROCEDURE GETNXT(O_status_code      OUT  VARCHAR2,
                 O_error_msg        OUT  VARCHAR2,
                 O_message_type     OUT  VARCHAR2,
                 O_message          OUT  RIB_OBJECT,
                 O_bus_obj_id       OUT  RIB_BUSOBJID_TBL,
                 O_routing_info     OUT  RIB_ROUTINGINFO_TBL,
                 I_num_threads   IN      NUMBER DEFAULT 1,
                 I_thread_val    IN      NUMBER DEFAULT 1);
--------------------------------------------------------------------------------
PROCEDURE PUB_RETRY(O_status_code         OUT      VARCHAR2,
                    O_error_msg           OUT      VARCHAR2,
                    O_message_type    IN  OUT      VARCHAR2,
                    O_message             OUT      RIB_OBJECT,
                    O_bus_obj_id      IN  OUT      RIB_BUSOBJID_TBL,
                    O_routing_info    IN  OUT      RIB_ROUTINGINFO_TBL,
                    I_REF_OBJECT      IN           RIB_OBJECT);
--------------------------------------------------------------------------------
END WPMFM_WFORDER;
/
