CREATE OR REPLACE PACKAGE BODY WPMFM_WFORDER AS
--------------------------------------------------------
--Globals
TYPE rowid_TBL  is table of ROWID INDEX BY BINARY_INTEGER;

TYPE odp_order_no_TBL  is table of wp_order_details_published.SALES_ORDER_NO%TYPE INDEX BY BINARY_INTEGER;
TYPE odp_item_TBL  is table of wp_order_details_published.item%TYPE INDEX BY BINARY_INTEGER;
TYPE odp_location_TBL  is table of wp_order_details_published.SOURCE_LOC_ID%TYPE INDEX BY BINARY_INTEGER;
TYPE odp_loc_type_TBL  is table of wp_order_details_published.SOURCE_LOC_TYPE%TYPE INDEX BY BINARY_INTEGER;


LP_num_threads NUMBER(4):=NULL;
LP_max_count NUMBER(4):=NULL;

-- depending upon the message type, there will come a point in the publication process
-- when error retry will no longer be possible.  this variable will track whether or
-- not that point has been reached.
LP_error_status varchar2(1):=NULL;
LP_collection_date_lag NUMBER(10);

  NO_MSG            CONSTANT VARCHAR2(1)  := 'N'; -- No more messages to process
  UNHANDLED_ERROR   CONSTANT VARCHAR2(1)  := 'E'; -- Unclassified (fatal) Error
  NEW_MSG           CONSTANT VARCHAR2(1)  := 'S'; -- Successfully retrieved new message.
  OUT_OF_SEQUENCE   CONSTANT VARCHAR2(1)  := 'P'; -- Program Error
  SUCCESS           CONSTANT VARCHAR2(1)  := 'S'; -- Success
  LOCKED            CONSTANT VARCHAR2(1)  := 'L'; -- Table is Locked, send message later.
  DELETED           CONSTANT VARCHAR2(1)  := 'X'; -- Retrieved record has been deleted
  DONE              CONSTANT VARCHAR2(1)  := 'D'; -- Application is done processing
  HOSPITAL          CONSTANT VARCHAR2(1)  := 'H'; -- A non-fatal error has occurred.  Send the current
                                                  -- message to the hospital and continue processing messages.
  INCOMPLETE_MSG    CONSTANT VARCHAR2(1)  := 'I'; -- Successfully retrieved new message.  However,
                                                  -- because of size constraints, only part of the message can be sent
                                                  -- for the current procedure call.  Rerun the current procedure call
                                                  -- with the same parameters to get the rest of the message.

-----------------------------------------------------------------------
--Local Specs
---
FUNCTION PROCESS_QUEUE_RECORD(O_error_message         OUT        VARCHAR2,
                              O_break_loop            OUT        BOOLEAN,
                              O_message           IN  OUT nocopy RIB_OBJECT,
                              O_routing_info      IN  OUT nocopy RIB_ROUTINGINFO_TBL,
                              O_bus_obj_id        IN  OUT nocopy RIB_BUSOBJID_TBL,
                              O_message_type      IN  OUT        VARCHAR2,
                              I_sales_order_no    IN             wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                              I_hdr_published     IN             wp_order_pub_info.published%TYPE,
                              I_item              IN             wp_order_mfqueue.item%TYPE,
                              I_location          IN             wp_order_mfqueue.source_loc_id%TYPE,
                              I_loc_type          IN             wp_order_mfqueue.source_loc_type%TYPE,
                              I_pub_status        IN             wp_order_mfqueue.pub_status%TYPE,
                              I_seq_no            IN             wp_order_mfqueue.seq_no%TYPE,
                              I_rowid             IN             ROWID)
RETURN BOOLEAN;
---
FUNCTION MAKE_CREATE(O_error_message    IN OUT VARCHAR2,
                     O_message          IN OUT nocopy RIB_OBJECT,
                     O_routing_info     IN OUT nocopy RIB_ROUTINGINFO_TBL,
                     I_sales_order_no         IN     wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                     I_seq_no           IN     wp_order_mfqueue.seq_no%TYPE,
                     I_rowid            IN     ROWID)
RETURN BOOLEAN;
---
FUNCTION DELETE_QUEUE_REC(O_text      OUT VARCHAR2,
                          I_seq_no IN     wp_order_mfqueue.seq_no%TYPE)
RETURN BOOLEAN;
---
FUNCTION BUILD_HEADER_OBJECT(O_error_message   IN OUT          VARCHAR2,
                             O_message         IN OUT NOCOPY   RIB_OBJECT,
                             I_sales_order_no  IN              wp_order_mfqueue.SALES_ORDER_NO%TYPE)
RETURN BOOLEAN;
---

------ If to_loc is passed as NULL all detail records will be returned.  If
------ to_loc is passed only that detail will be returned.
FUNCTION BUILD_DETAIL_OBJECTS(O_error_message         IN OUT          VARCHAR2,
                              O_message               IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_TBL",
                              O_wp_order_mfqueue_rowid IN OUT NOCOPY   ROWID_TBL,
                              O_wp_order_mfqueue_size IN OUT          BINARY_INTEGER,
                              O_routing_info          IN OUT NOCOPY   RIB_ROUTINGINFO_TBL,                            
                              IO_message_type         IN OUT          wp_order_mfqueue.MESSAGE_TYPE%TYPE,
                              I_sales_order_no        IN              wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                              I_item                  IN              wp_order_mfqueue.ITEM%TYPE,
                              I_location              IN              wp_order_mfqueue.source_loc_id%TYPE)
RETURN BOOLEAN;
---
FUNCTION BUILD_SINGLE_DETAIL ( O_error_message                IN OUT          VARCHAR2,
                               O_message                      IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_TBL",
                               IO_order_mfqueue_rowid         IN OUT NOCOPY   ROWID_TBL,
                               IO_order_mfqueue_size          IN OUT          BINARY_INTEGER,
                               IO_routing_info                IN OUT NOCOPY   RIB_ROUTINGINFO_TBL,
                               IO_rib_podtl_rec               IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_REC",
                               IO_rib_routing_rec             IN OUT NOCOPY   RIB_ROUTINGINFO_REC,
                               IO_prev_item                   IN OUT          wp_order_mfqueue.ITEM%TYPE,
                               IO_prev_location               IN OUT          wp_order_mfqueue.source_loc_id%TYPE,
                               IO_current_qty                 IN OUT          wp_order_detail.current_qty%TYPE,
                               IO_odp_ins_sales_order_no      IN OUT NOCOPY   ODP_ORDER_NO_TBL,
                               IO_odp_ins_item                IN OUT NOCOPY   ODP_ITEM_TBL,
                               IO_odp_ins_source_loc_id       IN OUT NOCOPY   ODP_LOCATION_TBL,
                               IO_odp_ins_source_loc_type     IN OUT NOCOPY   ODP_LOC_TYPE_TBL,
                               IO_odp_ins_size                IN OUT          BINARY_INTEGER,
                               IO_odp_upd_rowid               IN OUT NOCOPY   ROWID_TBL,
                               IO_odp_upd_size                IN OUT          BINARY_INTEGER,
                               I_detail_exists_ind            IN              VARCHAR2,
                               IO_extend                      IN OUT          BOOLEAN,
                               I_item                         IN              wp_order_detail.ITEM%TYPE,
                               I_location                     IN              wp_order_detail.SOURCE_LOC_ID%TYPE,
                               I_loc_type                     IN              wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                               I_customer_loc                 IN              wp_order_detail.CUSTOMER_LOC%TYPE,
                               I_original_qty                 IN              wp_order_detail.ORIGINAL_QTY%TYPE,
                               I_current_qty                  IN              wp_order_detail.CURRENT_QTY%TYPE,
                               I_original_partner_price       IN              wp_order_detail.ORIGINAL_PARTNER_PRICE%TYPE,
                               I_current_partner_price        IN              wp_order_detail.CURRENT_PARTNER_PRICE%TYPE,
                               I_original_window_start        IN              wp_order_detail.original_window_start_date%TYPE,
                               I_current_window_start         IN              wp_order_detail.current_window_start_date%TYPE,
                               I_original_window_end          IN              wp_order_detail.original_window_end_date%TYPE,
                               I_current_window_end           IN              wp_order_detail.current_window_end_date%TYPE,
                               I_cancel_reason                IN              wp_order_detail.cancel_reason%TYPE,
                               I_cancel_date                  IN              wp_order_detail.cancel_date%TYPE,
                               I_rrp_gbp                      IN              wp_order_detail.rrp_gbp%type,
                               I_rrp_eur                      IN              wp_order_detail.rrp_eur%type,
                               I_rrp_usd                      IN              wp_order_detail.rrp_usd%type,
                               I_rrp_cad                      IN              wp_order_detail.rrp_cad%type,
                               I_cancelled_qty                IN              wp_order_detail.cancelled_qty%type,
                               I_partner_dc_id                IN              wp_order_detail.partner_dc_id%type,
                               I_partner_store_id             IN              wp_order_detail.partner_store_id%type,
                               I_create_id                    IN              wp_order_detail.create_id%TYPE,
                               I_last_update_id               IN              wp_order_detail.last_update_id%TYPE,
                               I_oq_rowid                     IN              ROWID,
                               I_odp_rowid                    IN              ROWID,
                               I_sales_order_no               IN              wp_order_detail.sales_order_no%TYPE,
                               I_message_type                 IN              wp_order_mfqueue.MESSAGE_TYPE%TYPE DEFAULT NULL)
RETURN BOOLEAN;
---
FUNCTION BUILD_DETAIL_CHANGE_OBJECTS(O_error_message     IN OUT VARCHAR2,
                                     O_message           IN OUT nocopy RIB_OBJECT,
                                     O_routing_info      IN OUT nocopy RIB_ROUTINGINFO_TBL,
                                     IO_message_type     IN OUT wp_order_mfqueue.message_type%TYPE,
                                     I_sales_order_no    IN     wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                                     I_item              IN     wp_order_detail.ITEM%TYPE,
                                     I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE)
RETURN BOOLEAN;
---
FUNCTION BUILD_DETAIL_DELETE(O_error_message     IN OUT        VARCHAR2,
                             O_message_type      IN OUT        VARCHAR2,
                             O_message           IN OUT nocopy RIB_OBJECT,
                             O_break_loop        IN OUT        BOOLEAN,
                             I_sales_order_no    IN     wp_order_detail.sales_order_no%TYPE,
                             I_item              IN     wp_order_detail.ITEM%TYPE,
                             I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE,
                             I_loc_type          IN     wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                             I_rowid             IN            ROWID)
RETURN BOOLEAN;
---
FUNCTION ROUTING_INFO_ADD(O_error_message         OUT        VARCHAR2,
                          O_routing_info      IN  OUT nocopy RIB_ROUTINGINFO_TBL,
                          I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE,
                          I_loc_type          IN     wp_order_detail.SOURCE_LOC_TYPE%TYPE)
RETURN BOOLEAN;
---
FUNCTION GET_ROUTING_TO_LOCS(O_error_message IN OUT        VARCHAR2,
                             I_sales_order_no    IN     wp_order_detail.sales_order_no%TYPE,
                             O_routing_info  IN OUT nocopy RIB_ROUTINGINFO_TBL)
RETURN BOOLEAN;
---
FUNCTION LOCK_THE_BLOCK(O_error_msg        OUT VARCHAR2,
                        O_queue_locked     OUT BOOLEAN,
                        I_sales_order_no   IN     wp_order_detail.sales_order_no%TYPE)
RETURN BOOLEAN;
---
PROCEDURE HANDLE_ERRORS(O_status_code       IN OUT         VARCHAR2,
                        O_error_message     IN OUT         VARCHAR2,
                        O_message           IN OUT  nocopy RIB_OBJECT,
                        O_bus_obj_id        IN OUT  nocopy RIB_BUSOBJID_TBL,
                        O_routing_info      IN OUT  nocopy RIB_ROUTINGINFO_TBL,
                        I_seq_no            IN             wp_order_mfqueue.seq_no%TYPE,
                        I_sales_order_no    IN             wp_order_detail.sales_order_no%TYPE,
                        I_item              IN             wp_order_mfqueue.item%TYPE,
                        I_location          IN             wp_order_detail.SOURCE_LOC_ID%TYPE,
                        I_loc_type          IN             wp_order_detail.SOURCE_LOC_TYPE%TYPE);
---
-----------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION ADDTOQ(O_error_message         OUT VARCHAR2,
                I_message_type          IN  wp_order_mfqueue.MESSAGE_TYPE%TYPE,
                I_sales_order_no        IN  wp_order_head.sales_order_no%TYPE,
                I_order_type            IN  wp_order_head.ORDER_TYPE%TYPE,
                I_order_header_status   IN  wp_order_head.STATUS%TYPE,
                I_item                  IN  wp_order_detail.ITEM%TYPE,
                I_location              IN  wp_order_detail.SOURCE_LOC_ID%TYPE,
                I_loc_type              IN  wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                I_custom_message_type   IN  VARCHAR2 DEFAULT 'N')
RETURN BOOLEAN IS

   L_program            VARCHAR2(64) := 'WPMFM_WFORDER.ADDTOQ';
   L_status_code        VARCHAR2(1) := NULL;

   L_thread_no          rib_settings.num_threads%TYPE:=NULL;
   L_num_threads        rib_settings.num_threads%TYPE:=NULL;
   L_order_type         WP_ORDER_PUB_INFO.ORDER_TYPE%TYPE := NULL;
   L_published          WP_ORDER_PUB_INFO.PUBLISHED%TYPE := NULL;

   -- L_exists             VARCHAR2(1):='N';
   L_initial_approval   VARCHAR2(1):='N';

   cursor C_HEAD is
      select opi.thread_no,
             opi.initial_approval_ind,
             opi.published,
             opi.order_type
        from wp_order_pub_info opi
       where opi.sales_order_no = I_sales_order_no;


BEGIN

   if I_message_type != HDR_ADD then
      open C_HEAD;
      fetch C_HEAD into L_thread_no,
                        L_initial_approval,
                        L_published,
                        L_order_type;
      ---
      if C_HEAD%NOTFOUND then
         close C_HEAD;
         /*O_error_message := SQL_LIB.CREATE_MSG('PUB_INFO_NOT_FOUND',
                                               'wp_order_pub_info',
                                               I_order_no,
                                               NULL);*/
         O_error_message := 'PUB_INFO_NOT_FOUND - '||L_program||' - wp_order_pub_info - '||I_sales_order_no;
         return FALSE;
      end if;
      ---
      close C_HEAD;
   end if;
   ---
   -- If the order has not been approved,
   -- no messages will be added to the queue.
   ---
   if I_message_type in(DTL_ADD,DTL_UPD,DTL_DEL,HDR_DEL,HDR_UPD) then
      ---
      -- The indicator to keep track of whether the order has been inititally approved
      -- gets updated here.
      ---
      if I_message_type = HDR_UPD and
         I_order_header_status = 'A' and
         L_initial_approval = 'N' then

         update wp_order_pub_info
            set initial_approval_ind = 'Y'
          where sales_order_no = I_sales_order_no;
         ---
         L_initial_approval := 'Y';
      end if;

      if L_initial_approval = 'N' then
         if I_message_type = HDR_DEL then
            delete from wp_order_pub_info
             where sales_order_no = I_sales_order_no;
         end if;
         return TRUE;
      end if;
   end if;

   ---
   -- If the message is a detail delete message, all previous records
   -- on the queue relating to the detail record can be deleted.
   ---

   if I_message_type = DTL_DEL then
      delete from wp_order_mfqueue
       where sales_order_no = I_sales_order_no
         and item     = I_item
         and source_loc_id = I_location;

   ---
   -- If the message is a detail update message, all previous DTL_UPD
   -- messages on the queue relating to the detail record can be deleted.
   ---
   elsif I_message_type = DTL_UPD then
      delete from wp_order_mfqueue
       where sales_order_no = I_sales_order_no
         and item     = I_item
         and source_loc_id = I_location
         and message_type = DTL_UPD;

   ---
   -- If the message is a header delete, all previous records on the queue
   -- relating to the order can be deleted.
   ---
   elsif I_message_type = HDR_DEL then
      delete from wp_order_mfqueue
       where sales_order_no = I_sales_order_no;

   ---
   -- If the message is a header update, all previous HDR_UPD
   -- messages on the queue relating to the header record can be deleted.
   ---
   elsif I_message_type = HDR_UPD then
      delete from wp_order_mfqueue
       where sales_order_no = I_sales_order_no
         and custom_message_type = I_custom_message_type
         and message_type = HDR_UPD;
   end if;
   ---
   -- HDR_ADD messages do not get added to the queue.  Instead, a record gets inserted
   -- into the wp_order_pub_info table.
   ---
   -- The wp_order_pub_info table keeps track of the order_no,
   -- thread_no for all messages associated with the order,
   -- an indicator to keep track of whether the order has been initially approved,
   -- and an indicator to keep track of whether or not the initial create message
   -- for the order has been published.
   ---
   if I_message_type = HDR_ADD then
      
      SELECT num_threads
         into L_num_threads
      from RIB_SETTINGS 
         where upper(family) = upper(WPMFM_WFORDER.FAMILY);
      ---
      insert into wp_order_pub_info( sales_order_no,
                                  thread_no,
                                  initial_approval_ind,
                                  published,
                                  order_type )
                         values ( I_sales_order_no,
                                  MOD(I_sales_order_no, L_num_threads)+1,
                                  DECODE(I_order_header_status, 'A', 'Y', 'N'),
                                  'N',
                                  I_order_type );
   else

      insert into wp_order_mfqueue ( seq_no,
                                   sales_order_no,
                                   item,
                                   SOURCE_LOC_ID,
                                   SOURCE_LOC_TYPE,
                                   message_type,
                                   thread_no,
                                   family,
                                   custom_message_type,
                                   pub_status,
                                   transaction_number,
                                   transaction_time_stamp )
                          values ( wp_order_mfsequence.NEXTVAL,
                                   I_sales_order_no,
                                   I_item,
                                   I_location,
                                   I_loc_type,
                                   I_message_type,
                                   L_thread_no,
                                   WPMFM_WFORDER.FAMILY,
                                   I_custom_message_type,
                                   'U',
                                   I_sales_order_no,
                                   SYSDATE);

   end if;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;

END ADDTOQ;
--------------------------------------------------------------------------------
PROCEDURE GETNXT(O_status_code      OUT  VARCHAR2,
                 O_error_msg        OUT  VARCHAR2,
                 O_message_type     OUT  VARCHAR2,
                 O_message          OUT  RIB_OBJECT,
                 O_bus_obj_id       OUT  RIB_BUSOBJID_TBL,
                 O_routing_info     OUT  RIB_ROUTINGINFO_TBL,
                 I_num_threads   IN      NUMBER DEFAULT 1,
                 I_thread_val    IN      NUMBER DEFAULT 1)
IS

   L_break_loop         BOOLEAN := TRUE;
   L_message_type       wp_order_mfqueue.message_type%TYPE:=NULL;

   L_sales_order_no     wp_order_mfqueue.sales_order_no%TYPE := NULL;
   L_item               wp_order_mfqueue.item%TYPE := NULL;
   L_location           wp_order_mfqueue.source_loc_id%TYPE := NULL;
   L_loc_type           wp_order_mfqueue.source_loc_type%TYPE := NULL;

   L_seq_no             wp_order_mfqueue.seq_no%TYPE:=NULL;

   L_pub_status         wp_order_mfqueue.pub_status%TYPE:=NULL;
   L_rowid              ROWID  :=NULL;

   L_hdr_published      wp_order_pub_info.published%TYPE:=NULL;
   L_hospital_found     VARCHAR2(1) := 'N';

   L_queue_locked       BOOLEAN := FALSE;
   L_seq_limit          wp_order_mfqueue.seq_no%TYPE := 0;

   ---
   -- DRIVING CURSOR - selects ONE message from the queue
   ---
   cursor C_QUEUE is
      select q.sales_order_no,
             q.item,
             q.source_loc_id,
             q.source_loc_type,
             q.message_type,
             q.pub_status,
             q.seq_no,
             q.rowid
        from wp_order_mfqueue q
       where q.seq_no = (select min(q2.seq_no)
                           from wp_order_mfqueue q2
                          where q2.thread_no = I_thread_val
                            and q2.pub_status = 'U'
                            and q2.seq_no > L_seq_limit)
         and q.thread_no = I_thread_val;

   cursor C_CHECK_HDR_PUBLISHED is
      select opi.published
        from wp_order_pub_info opi
       where opi.sales_order_no = L_sales_order_no;

   cursor C_CHECK_FOR_HOSPITAL_MSGS is
      select 'Y'
        from wp_order_mfqueue
       where sales_order_no = L_sales_order_no
         and pub_status = 'H';

BEGIN

   -- status of 'H'ospital
   LP_error_status := HOSPITAL;

   LOOP
      L_sales_order_no := NULL;
      O_message  := NULL;
      ---
      open C_QUEUE;
      fetch C_QUEUE into L_sales_order_no,
                         L_item,
                         L_location,
                         L_loc_type,
                         L_message_type,
                         L_pub_status,
                         L_seq_no,
                         L_rowid;
      close C_QUEUE;

      if L_sales_order_no is NULL then
         O_status_code := NO_MSG;
         return;
      end if;

      if LOCK_THE_BLOCK(O_error_msg,
                        L_queue_locked,
                        L_sales_order_no) = FALSE then
         raise PROGRAM_ERROR;
      end if;

      if L_queue_locked then
         L_seq_limit := L_seq_no;
         O_error_msg := NULL;
      else

         open  C_CHECK_HDR_PUBLISHED;
         fetch C_CHECK_HDR_PUBLISHED into L_hdr_published;
         close C_CHECK_HDR_PUBLISHED;

         open  C_CHECK_FOR_HOSPITAL_MSGS;
         fetch C_CHECK_FOR_HOSPITAL_MSGS into L_hospital_found;
         close C_CHECK_FOR_HOSPITAL_MSGS;

         if L_hospital_found = 'Y' then
            /*O_error_msg := SQL_LIB.CREATE_MSG('SEND_TO_HOSP',
                                           NULL,
                                           NULL,
                                           NULL);*/
            O_error_msg := 'SEND_TO_HOSP';
            raise PROGRAM_ERROR;
         end if;

         if PROCESS_QUEUE_RECORD(O_error_msg,
                                 L_break_loop,
                                 O_message,
                                 O_routing_info,
                                 O_bus_obj_id,
                                 L_message_type,
                                 L_sales_order_no,
                                 L_hdr_published,
                                 L_item,
                                 L_location,
                                 L_loc_type,
                                 L_pub_status,
                                 L_seq_no,
                                 L_rowid) = FALSE then
            raise PROGRAM_ERROR;
         end if;

         if L_break_loop = TRUE then
            O_message_type   := L_message_type;
            EXIT;
         end if;

      end if; -- if L_queue_locked

   END LOOP;

   if O_message IS NULL then
      O_status_code := NO_MSG;
   else
      O_status_code := NEW_MSG;
      O_bus_obj_id := RIB_BUSOBJID_TBL(L_sales_order_no);
   end if;

EXCEPTION
   when OTHERS then
      HANDLE_ERRORS(O_status_code,
                    O_error_msg,
                    O_message,
                    O_bus_obj_id,
                    O_routing_info,
                    L_seq_no,
                    L_sales_order_no,
                    L_item,
                    L_location,
                    L_loc_type);
END GETNXT;
--------------------------------------------------------------------------------

PROCEDURE PUB_RETRY(O_status_code         OUT   VARCHAR2,
                    O_error_msg           OUT   VARCHAR2,
                    O_message_type    IN  OUT   VARCHAR2,
                    O_message             OUT   RIB_OBJECT,
                    O_bus_obj_id      IN  OUT   RIB_BUSOBJID_TBL,
                    O_routing_info    IN  OUT   RIB_ROUTINGINFO_TBL,
                    I_REF_OBJECT      IN        RIB_OBJECT)
IS

   L_seq_no             wp_order_mfqueue.seq_no%TYPE:=NULL;

   L_break_loop         BOOLEAN := FALSE;

   L_sales_order_no     wp_order_mfqueue.sales_order_no%TYPE:=NULL;
   L_hdr_published      wp_order_pub_info.published%TYPE:=NULL;

   L_item               wp_order_mfqueue.item%TYPE := NULL;
   L_location           wp_order_mfqueue.source_loc_id%TYPE := NULL;
   L_loc_type           wp_order_mfqueue.source_loc_type%TYPE := NULL;

   L_pub_status         wp_order_mfqueue.pub_status%TYPE:=NULL;
   L_rowid              ROWID:=NULL;
   L_queue_locked       BOOLEAN := FALSE;

cursor C_RETRY_QUEUE is
   select q.sales_order_no,
          oho.published,
          q.item,
          q.source_loc_id,
          q.source_loc_type,
          q.message_type,
          q.pub_status,
          q.rowid
     from wp_order_mfqueue q,
          wp_order_pub_info oho
    where q.seq_no = L_seq_no
      and oho.sales_order_no = q.sales_order_no;

BEGIN

   -- status of 'H'ospital
   LP_error_status := HOSPITAL;

   --get info from routing info
   ---assuming the only thing in the routing info is the seq_no
   L_seq_no := O_routing_info(1).value;

   --get info from queue table
   open C_RETRY_QUEUE;
   fetch C_RETRY_QUEUE into L_sales_order_no,
                            L_hdr_published,
                            L_item,
                            L_location,
                            L_loc_type,
                            O_message_type,
                            L_pub_status,
                            L_rowid;
   close C_RETRY_QUEUE;

   if L_sales_order_no is NULL then
      O_status_code := NO_MSG;
      return;
   end if;

   if LOCK_THE_BLOCK(O_error_msg,
                     L_queue_locked,
                     L_sales_order_no) = FALSE then
      raise PROGRAM_ERROR;
   end if;

   if L_queue_locked then
      O_status_code := HOSPITAL;
   else
      if PROCESS_QUEUE_RECORD(O_error_msg,
                              L_break_loop,
                              O_message,
                              O_routing_info,
                              O_bus_obj_id,
                              O_message_type,
                              L_sales_order_no,
                              L_hdr_published,
                              L_item,
                              L_location,
                              L_loc_type,
                              L_pub_status,
                              L_seq_no,
                              L_rowid) = FALSE then
         raise PROGRAM_ERROR;
      end if;
      ---
      if O_message IS NULL then
         O_status_code := NO_MSG;
      else        
         ---
         O_status_code := NEW_MSG;
         O_bus_obj_id := RIB_BUSOBJID_TBL(L_sales_order_no);
      end if;

   end if; -- if L_queue_locked

EXCEPTION
   when OTHERS then
      HANDLE_ERRORS(O_status_code,
                    O_error_msg,
                    O_message,
                    O_bus_obj_id,
                    O_routing_info,
                    L_seq_no,
                    L_sales_order_no,
                    L_item,
                    L_location,
                    L_loc_type);

END PUB_RETRY;

--------------------------------------------------------------------------------

FUNCTION PROCESS_QUEUE_RECORD(O_error_message         OUT        VARCHAR2,
                              O_break_loop            OUT        BOOLEAN,
                              O_message           IN  OUT nocopy RIB_OBJECT,
                              O_routing_info      IN  OUT nocopy RIB_ROUTINGINFO_TBL,
                              O_bus_obj_id        IN  OUT nocopy RIB_BUSOBJID_TBL,
                              O_message_type      IN  OUT        VARCHAR2,
                              I_sales_order_no    IN             wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                              I_hdr_published     IN             wp_order_pub_info.published%TYPE,
                              I_item              IN             wp_order_mfqueue.item%TYPE,
                              I_location          IN             wp_order_mfqueue.source_loc_id%TYPE,
                              I_loc_type          IN             wp_order_mfqueue.source_loc_type%TYPE,
                              I_pub_status        IN             wp_order_mfqueue.pub_status%TYPE,
                              I_seq_no            IN             wp_order_mfqueue.seq_no%TYPE,
                              I_rowid             IN             ROWID)

RETURN BOOLEAN IS

   L_program            VARCHAR2(64) := 'WPMFM_WFORDER.PROCESS_QUEUE_RECORD';
   L_status_code        VARCHAR2(1) := NULL;

   L_max_details        rib_settings.max_details_to_publish%TYPE:=NULL;
   L_num_threads        rib_settings.num_threads%TYPE:=NULL;

   L_rib_wppodesc_rec     "RIB_ExtOfNBXWFOrderDesc_REC"      := NULL;
   L_rib_wpporef_rec      "RIB_ExtOfNBXWFOrderRef_REC"       := NULL;

   L_rib_routing_rec     RIB_ROUTINGINFO_REC := NULL;
   L_custom_message_type WP_ORDER_MFQUEUE.CUSTOM_MESSAGE_TYPE%TYPE;

   CURSOR C_custom_message_type IS
    SELECT CUSTOM_MESSAGE_TYPE
      FROM WP_ORDER_MFQUEUE
     WHERE SEQ_NO = I_seq_no;

BEGIN

   O_break_loop := TRUE;

   SELECT num_threads
      into L_num_threads
   from RIB_SETTINGS 
      where upper(family) = upper(WPMFM_WFORDER.FAMILY);

   if O_message_type = HDR_DEL and I_hdr_published = 'N' then
      O_break_loop := FALSE;
      ---
      LP_error_status := UNHANDLED_ERROR;
      ---
      delete from wp_order_pub_info
       where sales_order_no     = I_sales_order_no;
      ---
      if DELETE_QUEUE_REC(O_error_message,
                          I_seq_no) = FALSE then
         return FALSE;
      end if;
      ---
   elsif O_message_type = HDR_DEL then
      O_message := "RIB_ExtOfNBXWFOrderRef_REC"(0,
                                 I_sales_order_no,
                                 NULL); -- ExtOfNBXWFOrderDtlRef_TBL
      ---
      if GET_ROUTING_TO_LOCS(O_error_message,
                             I_sales_order_no,
                             O_routing_info) = FALSE then
         return FALSE;
      end if;
      ---
      LP_error_status := UNHANDLED_ERROR;
      ---
      delete from wp_order_pub_info
       where sales_order_no     = I_sales_order_no;
      ---
      delete from wp_order_details_published
       where sales_order_no     = I_sales_order_no;
      ---
      if DELETE_QUEUE_REC(O_error_message,
                          I_seq_no) = FALSE then
         return FALSE;
      end if;
      ---
   elsif I_hdr_published ='N' then
      O_message_type := HDR_ADD;
      -- publish the entire order             --PODesc (all details)
      if MAKE_CREATE(O_error_message,
                     O_message,
                     O_routing_info,
                     I_sales_order_no,
                     I_seq_no,
                     I_rowid) = FALSE then
         return FALSE;
      end if;
   -- write the current record (anything but HDR_ADD)
   elsif O_message_type = HDR_UPD then          --PODesc (no details)

      if BUILD_HEADER_OBJECT( O_error_message,
                              O_message,
                              I_sales_order_no) = FALSE then
         return FALSE;
      end if;

      L_rib_wppodesc_rec := TREAT(O_message AS "RIB_ExtOfNBXWFOrderDesc_REC");

      LP_error_status := UNHANDLED_ERROR;

      update wp_order_pub_info
         set published = 'Y'
       where sales_order_no = I_sales_order_no;
      ---
      if GET_ROUTING_TO_LOCS(O_error_message,
                             I_sales_order_no,
                             O_routing_info) = FALSE then
         return FALSE;
      end if;
      ---

      OPEN C_custom_message_type;
      FETCH C_custom_message_type INTO L_custom_message_type;
      CLOSE C_custom_message_type;

      L_rib_routing_rec := RIB_ROUTINGINFO_REC('custom_message_type',
                                               L_custom_message_type,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL);

      if O_routing_info is NULL then
        O_routing_info := RIB_ROUTINGINFO_TBL();
      end if;

      O_routing_info.EXTEND();
      O_routing_info(O_routing_info.LAST) := L_rib_routing_rec;

      if DELETE_QUEUE_REC(O_error_message,
                          I_seq_no) = FALSE then
         return FALSE;
      end if;

   elsif O_message_type in (DTL_ADD, DTL_UPD) then       --PODesc (one or more details)

      if BUILD_DETAIL_CHANGE_OBJECTS(O_error_message,
                                     O_message,
                                     O_routing_info,
                                     O_message_type,
                                     I_sales_order_no,
                                     I_item,
                                     I_location) = FALSE then
         return FALSE;
      end if;

   elsif O_message_type = DTL_DEL then       --PODtlRef

      if BUILD_DETAIL_DELETE(O_error_message,
                             O_message_type,
                             O_message,
                             O_break_loop,
                             I_sales_order_no,
                             I_item,
                             I_location,
                             I_loc_type,
                             I_rowid) = FALSE then
         return FALSE;
      end if;

      if O_break_loop = TRUE then
         ------ add physical loc to routing info
         if ROUTING_INFO_ADD(O_error_message,
                             O_routing_info,
                             I_location,
                             I_loc_type) = FALSE then
            return FALSE;
         end if;

      end if; -- O_break_loop = TRUE

   end if; -- O_message_type = HDR_UPD

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;

END PROCESS_QUEUE_RECORD;

---------------------------------------------------------------------------------

FUNCTION MAKE_CREATE(O_error_message    IN OUT VARCHAR2,
                     O_message          IN OUT nocopy RIB_OBJECT,
                     O_routing_info     IN OUT nocopy RIB_ROUTINGINFO_TBL,
                     I_sales_order_no         IN     wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                     I_seq_no           IN     wp_order_mfqueue.seq_no%TYPE,
                     I_rowid            IN     ROWID)

RETURN BOOLEAN IS

   L_program               VARCHAR2(64) := 'WPMFM_WFORDER.MAKE_CREATE';

   L_rib_wppodesc_rec        "RIB_ExtOfNBXWFOrderDesc_REC" := NULL;
   L_rib_wppodtl_tbl         "RIB_ExtOfNBXWFOrderDtl_TBL" := NULL;

   L_wp_order_mfqueue_rowid   rowid_TBL;
   L_wp_order_mfqueue_size    BINARY_INTEGER := 0;

   L_message_type          WP_ORDER_MFQUEUE.MESSAGE_TYPE%TYPE := WPMFM_WFORDER.HDR_ADD;

   PROGRAM_ERROR           EXCEPTION;

BEGIN

   
   if BUILD_HEADER_OBJECT( O_error_message,
                           L_rib_wppodesc_rec,
                           I_sales_order_no) = FALSE then
      return FALSE;
   end if;

   if BUILD_DETAIL_OBJECTS(O_error_message,
                           L_rib_wppodtl_tbl,
                           L_wp_order_mfqueue_rowid,
                           L_wp_order_mfqueue_size,
                           O_routing_info,
                           L_message_type,
                           I_sales_order_no,
                           null,        --- I_item
                           null         --- I_location
                           ) = FALSE then
      return FALSE;
   end if;

  --- add rowid to L_order_mfqueue_rowid table to delete the current mfqueue record
  
   L_wp_order_mfqueue_size := L_wp_order_mfqueue_size + 1;
   L_wp_order_mfqueue_rowid(L_wp_order_mfqueue_size) := I_rowid;
  

   LP_error_status := UNHANDLED_ERROR;

   update wp_order_pub_info
      set published = 'Y'
    where sales_order_no  = I_sales_order_no;

   -- add the detail to the header
   L_rib_wppodesc_rec.ExtOfNBXWFOrderDtl_TBL := L_rib_wppodtl_tbl;

   if L_wp_order_mfqueue_size > 0 then
      FORALL i IN 1..L_wp_order_mfqueue_size
         delete from wp_order_mfqueue where rowid = L_wp_order_mfqueue_rowid(i);
   end if;

   O_message := L_rib_wppodesc_rec;

   return TRUE;

EXCEPTION
   when OTHERS then
     /* O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END MAKE_CREATE;

------------------------------------------------------------------------------------------

FUNCTION ROUTING_INFO_ADD(O_error_message         OUT        VARCHAR2,
                          O_routing_info      IN  OUT nocopy RIB_ROUTINGINFO_TBL,
                          I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE,
                          I_loc_type          IN     wp_order_detail.SOURCE_LOC_TYPE%TYPE)
RETURN BOOLEAN IS

   L_program           VARCHAR2(64) := 'WPMFM_WFORDER.ROUTING_INFO_ADD';

   L_rib_routing_rec   RIB_ROUTINGINFO_REC := NULL;

BEGIN

   if O_routing_info is NULL then
      O_routing_info := RIB_ROUTINGINFO_TBL();
   end if;

   L_rib_routing_rec := RIB_ROUTINGINFO_REC('to_loc', I_location,
                                            'to_loc_type',I_loc_type,
                                            null,null);

   O_routing_info.EXTEND;
   O_routing_info(O_routing_info.COUNT) := L_rib_routing_rec;

   return TRUE;

EXCEPTION
   when OTHERS then
     /* O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END ROUTING_INFO_ADD;

------------------------------------------------------------------------------------------

FUNCTION DELETE_QUEUE_REC(O_text      OUT VARCHAR2,
                          I_seq_no IN     wp_order_mfqueue.seq_no%TYPE)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'WPMFM_WFORDER.DELETE_QUEUE_REC';

BEGIN

   LP_error_status := UNHANDLED_ERROR;

   delete from wp_order_mfqueue
    where seq_no = I_seq_no;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_text := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                   SQLERRM,
                                   L_program,
                                   NULL);*/
    O_text := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END DELETE_QUEUE_REC;

------------------------------------------------------------------------------------------
FUNCTION BUILD_HEADER_OBJECT(O_error_message   IN OUT          VARCHAR2,
                             O_message         IN OUT NOCOPY   RIB_OBJECT,
                             I_sales_order_no  IN              wp_order_mfqueue.SALES_ORDER_NO%TYPE)
RETURN BOOLEAN IS

   L_program         VARCHAR2(64) := 'WPMFM_WFORDER.BUILD_HEADER_OBJECT';

   L_header_struct       WPMFM_WFORDER.wp_order_msg_rectype;

   L_rib_wppodesc_rec  "RIB_ExtOfNBXWFOrderDesc_REC" := NULL;

   L_partner_group_id      NUMBER(10);
   L_partner_group_name    VARCHAR2(120);

   PROGRAM_ERROR     EXCEPTION;

   cursor C_GET_COLLECTION_DAY_LAG is
      select value_1 as collection_days
         from WP_SYSTEM_PARAMETERS
         where func_area='PICK_DATA'
         and parameter  ='COLLECTION_DAYS';

   cursor C_GET_DELIVERY_TYPE(I_customer_id VARCHAR2) is
      select delivery_type
         from WP_CUSTOMER_ATTRIB
         where customer_id = I_customer_id;

   cursor C_ORDER_HEAD is
      select   oh.sales_order_no,
               oh.external_order_no,
               oh.customer_id,
               cust.wf_customer_group_id,
               cust.wf_customer_group_name,
               oh.sales_order_type,
               oh.order_no,
               oh.order_row_code,
               oh.status,
               oh.order_type,
               oh.currency_code,
               oh.exchange_rate,
               oh.comments,
               oh.hold_ind,
               oh.redist_ind,
               oh.partner_order_no,
               oh.partner_dept_no,
               oh.context_type,
               oh.context_value,
               oh.release_ind,
               oh.release_date,
               oh.cancel_reason,
               oh.cancel_date,
               oh.freight,
               oh.create_id,
               oh.create_datetime,
               oh.last_update_id,
               oh.last_update_datetime
        from wp_order_head oh,
             (
                select  wc.wf_customer_group_id,
                        wcg.wf_customer_group_name,
                        wc.wf_customer_id
                from wf_customer wc, 
                     wf_customer_group wcg
                where
                  wcg.wf_customer_group_id = wc.wf_customer_group_id
             ) cust
       where oh.sales_order_no = I_sales_order_no
             and cust.wf_customer_id = oh.customer_id;
   
   L_collection_date DATE;
   L_delivery_type   VARCHAR2(6);

BEGIN

   open C_ORDER_HEAD;
   fetch C_ORDER_HEAD into L_header_struct.header_rec.sales_order_no,
                           L_header_struct.header_rec.external_order_no,
                           L_header_struct.header_rec.customer_id,
                           L_partner_group_id,
                           L_partner_group_name,
                           L_header_struct.header_rec.sales_order_type,
                           L_header_struct.header_rec.order_no,
                           L_header_struct.header_rec.order_row_code,
                           L_header_struct.header_rec.status,
                           L_header_struct.header_rec.order_type,
                           L_header_struct.header_rec.currency_code,
                           L_header_struct.header_rec.exchange_rate,
                           L_header_struct.header_rec.comments,
                           L_header_struct.header_rec.hold_ind,
                           L_header_struct.header_rec.redist_ind,
                           L_header_struct.header_rec.partner_order_no,
                           L_header_struct.header_rec.partner_dept_no,
                           L_header_struct.header_rec.context_type,
                           L_header_struct.header_rec.context_value,
                           L_header_struct.header_rec.release_ind,
                           L_header_struct.header_rec.release_date,
                           L_header_struct.header_rec.cancel_reason,
                           L_header_struct.header_rec.cancel_date,
                           L_header_struct.header_rec.freight,
                           L_header_struct.header_rec.create_id,
                           L_header_struct.header_rec.create_datetime,
                           L_header_struct.header_rec.last_update_id,
                           L_header_struct.header_rec.last_update_datetime;

   if C_ORDER_HEAD%NOTFOUND then
      close C_ORDER_HEAD;
      /*O_error_message := SQL_LIB.CREATE_MSG('NO_ORDHEAD_PUB',
                                             I_sales_order_no, NULL, NULL);*/
      O_error_message := 'NO_ORDHEAD_PUB - '||L_program||' - '||I_sales_order_no;
      return FALSE;
   end if;
   close C_ORDER_HEAD;

   if L_header_struct.header_rec.release_ind = 'Y' and L_header_struct.header_rec.release_date IS NOT NULL
   then
      if LP_collection_date_lag is null
      then
         OPEN C_GET_COLLECTION_DAY_LAG;
         FETCH C_GET_COLLECTION_DAY_LAG INTO LP_collection_date_lag;
         CLOSE C_GET_COLLECTION_DAY_LAG;

         IF LP_collection_date_lag IS NULL
         then
            O_error_message := 'Unable to get PICK_DATA - COLLECTION_DAYS from WP_SYSTEM_PARAMETERS - '||L_program||' - '||I_sales_order_no;
            return FALSE;
         end if;
      end if;

      L_collection_date := L_header_struct.header_rec.release_date + LP_collection_date_lag;

      --
      OPEN C_GET_DELIVERY_TYPE(L_header_struct.header_rec.customer_id);
      FETCH C_GET_DELIVERY_TYPE INTO L_delivery_type;
      CLOSE C_GET_DELIVERY_TYPE;
      --

      IF L_delivery_type IS NULL
      then
         O_error_message := 'Unable to get delivery_type for customer '||L_header_struct.header_rec.customer_id||' - '||L_program||' - '||I_sales_order_no;
         return FALSE;
      end if;
      --
   else
      L_collection_date := null;
      L_delivery_type   := null;
   end if;

   L_rib_wppodesc_rec := "RIB_ExtOfNBXWFOrderDesc_REC"(
         0, --  rib_oid number
         L_header_struct.header_rec.sales_order_no,
         L_header_struct.header_rec.external_order_no,
         L_header_struct.header_rec.customer_id,
         L_header_struct.header_rec.sales_order_type,
         L_header_struct.header_rec.order_no,
         L_header_struct.header_rec.order_row_code,
         L_header_struct.header_rec.status,
         L_header_struct.header_rec.order_type,
         L_header_struct.header_rec.currency_code,
         L_header_struct.header_rec.exchange_rate,
         L_header_struct.header_rec.comments,
         L_header_struct.header_rec.hold_ind,
         L_header_struct.header_rec.redist_ind,
         L_header_struct.header_rec.partner_order_no,
         L_header_struct.header_rec.partner_dept_no,
         L_header_struct.header_rec.context_type,
         L_header_struct.header_rec.context_value,
         L_header_struct.header_rec.release_ind,
         L_header_struct.header_rec.release_date,
         L_collection_date,
         L_delivery_type,
         L_header_struct.header_rec.cancel_reason,
         L_header_struct.header_rec.cancel_date,
         L_header_struct.header_rec.freight,
         L_partner_group_id,
         L_partner_group_name,
         L_header_struct.header_rec.create_id,
         L_header_struct.header_rec.create_datetime,
         L_header_struct.header_rec.last_update_id,
         L_header_struct.header_rec.last_update_datetime,
         null --, ExtOfNBXWFOrderDtl_TBL "RIB_ExtOfNBXWFOrderDtl_TBL" 
   );                                            

   O_message  := L_rib_wppodesc_rec;

   return TRUE;

EXCEPTION
   when OTHERS then
     /* O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END BUILD_HEADER_OBJECT;
------------------------------------------------------------------------------------------

FUNCTION BUILD_DETAIL_OBJECTS(O_error_message         IN OUT          VARCHAR2,
                              O_message               IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_TBL",
                              O_wp_order_mfqueue_rowid IN OUT NOCOPY  ROWID_TBL,
                              O_wp_order_mfqueue_size IN OUT          BINARY_INTEGER,
                              O_routing_info          IN OUT NOCOPY   RIB_ROUTINGINFO_TBL,                            
                              IO_message_type         IN OUT          wp_order_mfqueue.MESSAGE_TYPE%TYPE,
                              I_sales_order_no        IN              wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                              I_item                  IN              wp_order_mfqueue.ITEM%TYPE,
                              I_location              IN              wp_order_mfqueue.source_loc_id%TYPE)
RETURN BOOLEAN IS

   L_program                    VARCHAR2(64) := 'WPMFM_WFORDER.BUILD_DETAIL_OBJECTS';

   L_rib_wppodtl_rec            "RIB_ExtOfNBXWFOrderDtl_REC" := NULL;
   L_rib_wppodtl_tbl            "RIB_ExtOfNBXWFOrderDtl_TBL" := NULL;

   L_prev_location              WP_ORDER_DETAIL.SOURCE_LOC_ID%TYPE := -1;
   L_prev_item                  WP_ORDER_DETAIL.ITEM%TYPE     := -1;

   L_quantity                   WP_ORDER_DETAIL.CURRENT_QTY%TYPE := 0;

   L_odp_ins_order_no           odp_order_no_TBL;
   L_odp_ins_item               odp_item_TBL;
   L_odp_ins_location           odp_location_TBL;
   L_odp_ins_loc_type           odp_loc_type_TBL;
   L_odp_ins_size               BINARY_INTEGER := 0;

   L_odp_upd_rowid              rowid_TBL;
   L_odp_upd_size               BINARY_INTEGER := 0;

   L_extend                     BOOLEAN := FALSE;
   L_records_found              BOOLEAN := FALSE;   
   L_exists                     VARCHAR2(1) := NULL;

   L_rib_routing_rec            RIB_ROUTINGINFO_REC :=NULL;

   cursor C_CHECK_FOR_INITAL_ADD_MSG is
      select 'x'
        from wp_order_details_published odp
       where odp.sales_order_no = I_sales_order_no
         and odp.item           = I_item
         and odp.source_loc_id  = I_location
         and odp.detail_exists_ind = 'Y';

   cursor C_GET_DETAIL_MSG_INFO_ADD is
      select
            ol.sales_order_no,
            ol.item,
            ol.source_loc_type,
            ol.source_loc_id,
            ol.customer_loc,
            ol.original_qty,
            ol.current_qty,
            ol.original_partner_price,
            ol.current_partner_price,
            ol.original_window_start_date,
            ol.current_window_start_date,
            ol.original_window_end_date,
            ol.current_window_end_date,
            ol.cancel_reason,
            ol.cancel_date,
            ol.rrp_gbp,
            ol.rrp_eur,
            ol.rrp_usd,
            ol.rrp_cad,
            ol.cancelled_qty,
            ol.partner_dc_id,
            ol.partner_store_id,
            ol.create_id,
            ol.create_datetime,
            ol.last_update_id,
            ol.last_update_datetime,
            oq.rowid oq_rowid,
            odp.rowid odp_rowid,
            odp.detail_exists_ind
         from wp_order_detail ol,
            wp_order_mfqueue oq,
            wp_order_details_published odp
         where
                  ol.sales_order_no        = I_sales_order_no
                  and ol.sales_order_no    = oq.sales_order_no
                  and oq.item              = ol.item
                  and oq.message_type      in (DTL_ADD, DTL_UPD)
                  and oq.source_loc_id     =  ol.source_loc_id
                  and odp.sales_order_no (+)     = ol.sales_order_no
                  and odp.item     (+)           = ol.item
                  and odp.source_loc_id (+)      = ol.source_loc_id
                  and not exists(select 'x'
                                 from wp_order_details_published odp
                                 where odp.sales_order_no = ol.sales_order_no
                                    and odp.item     = ol.item
                                    and odp.source_loc_id = oq.source_loc_id
                                    and odp.detail_exists_ind = 'Y')
         order by 5,3;

   cursor C_GET_DETAIL_MSG_INFO_UPD is
      select
            ol.sales_order_no,
            ol.item,
            ol.source_loc_type,
            ol.source_loc_id,
            ol.customer_loc,
            ol.original_qty,
            ol.current_qty,
            ol.original_partner_price,
            ol.current_partner_price,
            ol.original_window_start_date,
            ol.current_window_start_date,
            ol.original_window_end_date,
            ol.current_window_end_date,
            ol.cancel_reason,
            ol.cancel_date,
            ol.rrp_gbp,
            ol.rrp_eur,
            ol.rrp_usd,
            ol.rrp_cad,
            ol.cancelled_qty,
            ol.partner_dc_id,
            ol.partner_store_id,
            ol.create_id,
            ol.create_datetime,
            ol.last_update_id,
            ol.last_update_datetime,
            oq.rowid oq_rowid,
            odp.rowid odp_rowid,
            odp.detail_exists_ind
         from wp_order_detail ol,
            wp_order_mfqueue oq,
            wp_order_details_published odp
         where
                  ol.sales_order_no        = I_sales_order_no
                  and ol.sales_order_no    = oq.sales_order_no
                  and oq.item              = ol.item
                  and oq.message_type      in (DTL_ADD, DTL_UPD)
                  and oq.source_loc_id     =  ol.source_loc_id
                  and odp.sales_order_no (+)     = ol.sales_order_no
                  and odp.item     (+)           = ol.item
                  and odp.source_loc_id (+)      = ol.source_loc_id
                  and exists(select 'x'
                                 from wp_order_details_published odp
                                 where odp.sales_order_no = ol.sales_order_no
                                    and odp.item     = ol.item
                                    and odp.source_loc_id = oq.source_loc_id
                                    and odp.detail_exists_ind = 'Y')
         order by 5,3;

   cursor C_GET_DETAIL_MSG_INFO_MC is
         select
            ol.sales_order_no,
            ol.item,
            ol.source_loc_type,
            ol.source_loc_id,
            ol.customer_loc,
            ol.original_qty,
            ol.current_qty,
            ol.original_partner_price,
            ol.current_partner_price,
            ol.original_window_start_date,
            ol.current_window_start_date,
            ol.original_window_end_date,
            ol.current_window_end_date,
            ol.cancel_reason,
            ol.cancel_date,
            ol.rrp_gbp,
            ol.rrp_eur,
            ol.rrp_usd,
            ol.rrp_cad,
            ol.cancelled_qty,
            ol.partner_dc_id,
            ol.partner_store_id,
            ol.create_id,
            ol.create_datetime,
            ol.last_update_id,
            ol.last_update_datetime,
            NULL      oq_rowid
        from wp_order_detail ol
       where ol.sales_order_no          = I_sales_order_no
   order by 5,3;

BEGIN

   L_rib_wppodtl_rec := "RIB_ExtOfNBXWFOrderDtl_REC"(
           0, null,null,null,null,null,null,null,
              null,null,null,null,null,null,null,
              null,null,null,null,null,
              null,null,null,null,null);

   if O_message is NULL then
      L_rib_wppodtl_tbl := "RIB_ExtOfNBXWFOrderDtl_TBL"();
   else
      L_rib_wppodtl_tbl := O_message;
   end if;

   L_rib_routing_rec := RIB_ROUTINGINFO_REC('to_loc',null,null,null,null,null);

   if IO_message_type in (HDR_ADD)then

      FOR rec IN C_GET_DETAIL_MSG_INFO_MC LOOP

         L_records_found := TRUE;

         if BUILD_SINGLE_DETAIL ( O_error_message,
                                  L_rib_wppodtl_tbl,
                                  O_wp_order_mfqueue_rowid,
                                  O_wp_order_mfqueue_size,
                                  O_routing_info,
                                  L_rib_wppodtl_rec,
                                  L_rib_routing_rec,
                                  L_prev_item,
                                  L_prev_location,
                                  L_quantity,
                                  L_odp_ins_order_no,
                                  L_odp_ins_item,
                                  L_odp_ins_location,
                                  L_odp_ins_loc_type,
                                  L_odp_ins_size,
                                  L_odp_upd_rowid,
                                  L_odp_upd_size,
                                  NULL,
                                  L_extend,
                                  rec.item,
                                  rec.source_loc_id,
                                  rec.source_loc_type,
                                  rec.customer_loc,
                                  rec.original_qty,
                                  rec.current_qty,
                                  rec.original_partner_price,
                                  rec.current_partner_price,
                                  rec.original_window_start_date,
                                  rec.current_window_start_date,
                                  rec.original_window_end_date,
                                  rec.current_window_end_date,
                                  rec.cancel_reason,
                                  rec.cancel_date,
                                  rec.rrp_gbp,
                                  rec.rrp_eur,
                                  rec.rrp_usd,
                                  rec.rrp_cad,
                                  rec.cancelled_qty,
                                  rec.partner_dc_id,
                                  rec.partner_store_id,
                                  rec.create_id,
                                  rec.last_update_id,
                                  rec.oq_rowid,
                                  NULL,
                                  I_sales_order_no,
                                  IO_message_type) = FALSE then
            return FALSE;         
         end if;

      END LOOP;
   else

      --- if a DTL_ADD message for the current order_no/item/physical location
      --- has already been sent, we need to send a DTL_UPD message
      if IO_message_type = DTL_ADD then
         open C_CHECK_FOR_INITAL_ADD_MSG;
         fetch C_CHECK_FOR_INITAL_ADD_MSG into L_exists;
         ---
         if C_CHECK_FOR_INITAL_ADD_MSG%NOTFOUND then
            IO_message_type := DTL_ADD;
         else
            IO_message_type := DTL_UPD;
         end if;
         ---
         close C_CHECK_FOR_INITAL_ADD_MSG;
      end if;

      if IO_message_type = DTL_ADD then

         FOR rec IN C_GET_DETAIL_MSG_INFO_ADD LOOP

            L_records_found := TRUE;

                     if BUILD_SINGLE_DETAIL ( O_error_message,
                                  L_rib_wppodtl_tbl,
                                  O_wp_order_mfqueue_rowid,
                                  O_wp_order_mfqueue_size,
                                  O_routing_info,
                                  L_rib_wppodtl_rec,
                                  L_rib_routing_rec,
                                  L_prev_item,
                                  L_prev_location,
                                  L_quantity,
                                  L_odp_ins_order_no,
                                  L_odp_ins_item,
                                  L_odp_ins_location,
                                  L_odp_ins_loc_type,
                                  L_odp_ins_size,
                                  L_odp_upd_rowid,
                                  L_odp_upd_size,
                                  rec.detail_exists_ind,
                                  L_extend,
                                  rec.item,
                                  rec.source_loc_id,
                                  rec.source_loc_type,
                                  rec.customer_loc,
                                  rec.original_qty,
                                  rec.current_qty,
                                  rec.original_partner_price,
                                  rec.current_partner_price,
                                  rec.original_window_start_date,
                                  rec.current_window_start_date,
                                  rec.original_window_end_date,
                                  rec.current_window_end_date,
                                  rec.cancel_reason,
                                  rec.cancel_date,
                                  rec.rrp_gbp,
                                  rec.rrp_eur,
                                  rec.rrp_usd,
                                  rec.rrp_cad,
                                  rec.cancelled_qty,
                                  rec.partner_dc_id,
                                  rec.partner_store_id,
                                  rec.create_id,
                                  rec.last_update_id,
                                  rec.oq_rowid,
                                  rec.odp_rowid,
                                  I_sales_order_no,
                                  IO_message_type) = FALSE then
                        return FALSE;
                     end if;
         END LOOP;

      else
         FOR rec IN C_GET_DETAIL_MSG_INFO_UPD LOOP

            L_records_found := TRUE;

            if BUILD_SINGLE_DETAIL ( O_error_message,
                           L_rib_wppodtl_tbl,
                           O_wp_order_mfqueue_rowid,
                           O_wp_order_mfqueue_size,
                           O_routing_info,
                           L_rib_wppodtl_rec,
                           L_rib_routing_rec,
                           L_prev_item,
                           L_prev_location,
                           L_quantity,
                           L_odp_ins_order_no,
                           L_odp_ins_item,
                           L_odp_ins_location,
                           L_odp_ins_loc_type,
                           L_odp_ins_size,
                           L_odp_upd_rowid,
                           L_odp_upd_size,
                           rec.detail_exists_ind,
                           L_extend,
                           rec.item,
                           rec.source_loc_id,
                           rec.source_loc_type,
                           rec.customer_loc,
                           rec.original_qty,
                           rec.current_qty,
                           rec.original_partner_price,
                           rec.current_partner_price,
                           rec.original_window_start_date,
                           rec.current_window_start_date,
                           rec.original_window_end_date,
                           rec.current_window_end_date,
                           rec.cancel_reason,
                           rec.cancel_date,
                           rec.rrp_gbp,
                           rec.rrp_eur,
                           rec.rrp_usd,
                           rec.rrp_cad,
                           rec.cancelled_qty,
                           rec.partner_dc_id,
                           rec.partner_store_id,
                           rec.create_id,
                           rec.last_update_id,
                           rec.oq_rowid,
                           rec.odp_rowid,
                           I_sales_order_no,
                           IO_message_type) = FALSE then
               return FALSE;
            end if;

         END LOOP;
      end if;

   end if;

   -- insert PODtl info
   if L_extend then
      L_rib_wppodtl_tbl.EXTEND;
      L_rib_wppodtl_tbl(L_rib_wppodtl_tbl.COUNT)  := L_rib_wppodtl_rec;
   end if;

   -- if no data found in cursor, raise error
   if not L_records_found then
      /*O_error_message := SQL_LIB.CREATE_MSG('NO_ORD_DETAIL_PUB',
                                             I_sales_order_no, NULL, NULL);*/
      O_error_message := 'NO_ORD_DETAIL_PUB - '||L_program||' - '||I_sales_order_no;
      raise PROGRAM_ERROR;
   end if;

   if L_odp_ins_size > 0 then

      LP_error_status := UNHANDLED_ERROR;

      FORALL i IN 1..L_odp_ins_size
         insert into wp_order_details_published (sales_order_no,
                                              item,
                                              source_loc_id,
                                              source_loc_type,
                                              detail_exists_ind)
                                       values(L_odp_ins_order_no(i),
                                              L_odp_ins_item(i),
                                              L_odp_ins_location(i),
                                              L_odp_ins_loc_type(i),
                                              'Y');

   end if;

   if L_odp_upd_size > 0 then

      LP_error_status := UNHANDLED_ERROR;

      FORALL i IN 1..L_odp_upd_size
         update wp_order_details_published
            set detail_exists_ind = 'Y'
          where rowid = L_odp_upd_rowid(i);

   end if;

   if L_rib_wppodtl_tbl.COUNT > 0 then
      O_message := L_rib_wppodtl_tbl;
   else
      O_message := NULL;
   end if;

   return TRUE;

EXCEPTION
   when OTHERS then
     /* O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END BUILD_DETAIL_OBJECTS;

------------------------------------------------------------------------------------------
-----
FUNCTION BUILD_SINGLE_DETAIL ( O_error_message                IN OUT          VARCHAR2,
                               O_message                      IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_TBL",
                               IO_order_mfqueue_rowid         IN OUT NOCOPY   ROWID_TBL,
                               IO_order_mfqueue_size          IN OUT          BINARY_INTEGER,
                               IO_routing_info                IN OUT NOCOPY   RIB_ROUTINGINFO_TBL,
                               IO_rib_podtl_rec               IN OUT NOCOPY   "RIB_ExtOfNBXWFOrderDtl_REC",
                               IO_rib_routing_rec             IN OUT NOCOPY   RIB_ROUTINGINFO_REC,
                               IO_prev_item                   IN OUT          wp_order_mfqueue.ITEM%TYPE,
                               IO_prev_location               IN OUT          wp_order_mfqueue.source_loc_id%TYPE,
                               IO_current_qty                 IN OUT          wp_order_detail.current_qty%TYPE,
                               IO_odp_ins_sales_order_no      IN OUT NOCOPY   ODP_ORDER_NO_TBL,
                               IO_odp_ins_item                IN OUT NOCOPY   ODP_ITEM_TBL,
                               IO_odp_ins_source_loc_id       IN OUT NOCOPY   ODP_LOCATION_TBL,
                               IO_odp_ins_source_loc_type     IN OUT NOCOPY   ODP_LOC_TYPE_TBL,
                               IO_odp_ins_size                IN OUT          BINARY_INTEGER,
                               IO_odp_upd_rowid               IN OUT NOCOPY   ROWID_TBL,
                               IO_odp_upd_size                IN OUT          BINARY_INTEGER,
                               I_detail_exists_ind            IN              VARCHAR2,
                               IO_extend                      IN OUT          BOOLEAN,
                               I_item                         IN              wp_order_detail.ITEM%TYPE,
                               I_location                     IN              wp_order_detail.SOURCE_LOC_ID%TYPE,
                               I_loc_type                     IN              wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                               I_customer_loc                 IN              wp_order_detail.CUSTOMER_LOC%TYPE,
                               I_original_qty                 IN              wp_order_detail.ORIGINAL_QTY%TYPE,
                               I_current_qty                  IN              wp_order_detail.CURRENT_QTY%TYPE,
                               I_original_partner_price       IN              wp_order_detail.ORIGINAL_PARTNER_PRICE%TYPE,
                               I_current_partner_price        IN              wp_order_detail.CURRENT_PARTNER_PRICE%TYPE,
                               I_original_window_start        IN              wp_order_detail.original_window_start_date%TYPE,
                               I_current_window_start         IN              wp_order_detail.current_window_start_date%TYPE,
                               I_original_window_end          IN              wp_order_detail.original_window_end_date%TYPE,
                               I_current_window_end           IN              wp_order_detail.current_window_end_date%TYPE,
                               I_cancel_reason                IN              wp_order_detail.cancel_reason%TYPE,
                               I_cancel_date                  IN              wp_order_detail.cancel_date%TYPE,
                               I_rrp_gbp                      IN              wp_order_detail.rrp_gbp%type,
                               I_rrp_eur                      IN              wp_order_detail.rrp_eur%type,
                               I_rrp_usd                      IN              wp_order_detail.rrp_usd%type,
                               I_rrp_cad                      IN              wp_order_detail.rrp_cad%type,
                               I_cancelled_qty                IN              wp_order_detail.cancelled_qty%type,
                               I_partner_dc_id                IN              wp_order_detail.partner_dc_id%type,
                               I_partner_store_id             IN              wp_order_detail.partner_store_id%type,
                               I_create_id                    IN              wp_order_detail.create_id%TYPE,
                               I_last_update_id               IN              wp_order_detail.last_update_id%TYPE,
                               I_oq_rowid                     IN              ROWID,
                               I_odp_rowid                    IN              ROWID,
                               I_sales_order_no               IN              wp_order_detail.sales_order_no%TYPE,
                               I_message_type                 IN              wp_order_mfqueue.MESSAGE_TYPE%TYPE DEFAULT NULL)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'WPMFM_WFORDER.BUILD_SINGLE_DETAIL';

   L_RIB_ExtOfNBXWFOrderAddrDtl_TBL "RIB_ExtOfNBXWFOrderAddrDtl_TBL" := "RIB_ExtOfNBXWFOrderAddrDtl_TBL"();

   cursor C_GET_ADDR_INFO is
         select "RIB_ExtOfNBXWFOrderAddrDtl_REC"(
                  0,
                  addr_type,
                  ADD_1,
                  ADD_2,
                  ADD_3,
                  CITY,
                  STATE,
                  (select description From state ss 
                        where ss.country_id  = aa.country_id
                              and ss.state   = aa.state),
                  COUNTRY_ID,
                  POST,
                  CONTACT_NAME,
                  CONTACT_PHONE,
                  CONTACT_TELEX,
                  CONTACT_FAX,
                  CONTACT_EMAIL,
                  COUNTY)
            from addr aa,
               V_CFA_ADDR_G cfa
            where addr_type    = 50
            and aa.addr_key    = cfa.addr_key
            and cfa.wp_dc_id   = I_partner_dc_id
            and aa.module      = 'WFST'
            and aa.key_value_1 = I_customer_loc;

BEGIN
   ---
   if (I_loc_type is NOT NULL) and
      (
         (I_item              != IO_prev_item) or
         (I_location          != IO_prev_location)  
       ) then

      IO_prev_location := I_location;

      if (I_item              != IO_prev_item) then

         if (I_location != IO_prev_location) then

            if ROUTING_INFO_ADD(O_error_message,
                                IO_routing_info,
                                I_location,
                                I_loc_type) = FALSE then
               return FALSE;
            end if;

         end if;
         IO_prev_location                    := I_location;
         IO_prev_item                        := I_item;

         if IO_extend then
            O_message.EXTEND;
            O_message(O_message.COUNT) := IO_rib_podtl_rec;
         else
            IO_extend := TRUE;
         end if;

         IO_rib_podtl_rec.item                           := I_item;
         IO_rib_podtl_rec.source_loc_type                := I_loc_type;
         IO_rib_podtl_rec.source_loc_id                  := I_location;
         IO_rib_podtl_rec.customer_loc                   := I_customer_loc;
         IO_rib_podtl_rec.partner_dc_id                  := I_partner_dc_id;
         IO_rib_podtl_rec.partner_store_id               := I_partner_store_id;
         IO_rib_podtl_rec.original_qty                   := I_original_qty;
         IO_rib_podtl_rec.current_qty                    := I_current_qty;
         IO_rib_podtl_rec.cancelled_qty                  := I_cancelled_qty;
         IO_rib_podtl_rec.rrp_gbp                        := I_rrp_gbp;
         IO_rib_podtl_rec.rrp_eur                        := I_rrp_eur;
         IO_rib_podtl_rec.rrp_usd                        := I_rrp_usd;
         IO_rib_podtl_rec.rrp_cad                        := I_rrp_cad;
         IO_rib_podtl_rec.original_partner_price         := I_original_partner_price;
         IO_rib_podtl_rec.current_partner_price          := I_current_partner_price;
         IO_rib_podtl_rec.original_window_start_date     := I_original_window_start;
         IO_rib_podtl_rec.current_window_start_date      := I_current_window_start;
         IO_rib_podtl_rec.original_window_end_date       := I_original_window_end;
         IO_rib_podtl_rec.current_window_end_date        := I_current_window_end;
         IO_rib_podtl_rec.cancel_reason                  := I_cancel_reason;
         IO_rib_podtl_rec.cancel_date                    := I_cancel_date;
         IO_rib_podtl_rec.create_id                      := I_create_id;
         IO_rib_podtl_rec.last_update_id                 := I_last_update_id;

         open C_GET_ADDR_INFO;
         fetch C_GET_ADDR_INFO bulk collect into L_RIB_ExtOfNBXWFOrderAddrDtl_TBL;
         close C_GET_ADDR_INFO;

         IO_rib_podtl_rec.ExtOfNBXWFOrderAddrDtl_TBL     := L_RIB_ExtOfNBXWFOrderAddrDtl_TBL;

      end if;   -- if loc or item has changed

      ------ the order_detail_published record for the current order/item/loc combination
      ------ does not currently exist in the queue,
      ------ so it should be added to the queue
      if I_odp_rowid is NULL then

         IO_odp_ins_size := IO_odp_ins_size + 1;
         IO_odp_ins_sales_order_no(IO_odp_ins_size)          := I_sales_order_no;
         IO_odp_ins_item(IO_odp_ins_size)              := I_item;
         IO_odp_ins_source_loc_id(IO_odp_ins_size)          := I_location;
         IO_odp_ins_source_loc_type(IO_odp_ins_size)          := I_loc_type;

      elsif I_detail_exists_ind = 'N' then

         IO_odp_upd_size := IO_odp_upd_size + 1;
         IO_odp_upd_rowid(IO_odp_upd_size)             := I_odp_rowid;

      end if;

   end if; -- if item or loc has changed

   if I_oq_rowid is null and I_message_type = HDR_ADD then
      select rowid bulk collect into IO_order_mfqueue_rowid
        from wp_order_mfqueue 
       where sales_order_no = I_sales_order_no;

      if IO_order_mfqueue_rowid is NULL then
         IO_order_mfqueue_size := 0;
      else
         IO_order_mfqueue_size := IO_order_mfqueue_rowid.COUNT;
      end if;
   elsif I_oq_rowid is not null then
      IO_order_mfqueue_size := IO_order_mfqueue_size + 1;
      IO_order_mfqueue_rowid(IO_order_mfqueue_size) := I_oq_rowid;
   end if;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END BUILD_SINGLE_DETAIL;

------------------------------------------------------------------------------------------

FUNCTION BUILD_DETAIL_CHANGE_OBJECTS(O_error_message     IN OUT VARCHAR2,
                                     O_message           IN OUT nocopy RIB_OBJECT,
                                     O_routing_info      IN OUT nocopy RIB_ROUTINGINFO_TBL,
                                     IO_message_type     IN OUT wp_order_mfqueue.message_type%TYPE,
                                     I_sales_order_no    IN     wp_order_mfqueue.SALES_ORDER_NO%TYPE,
                                     I_item              IN     wp_order_detail.ITEM%TYPE,
                                     I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE)
RETURN BOOLEAN IS

   L_program              VARCHAR2(64) := 'WPMFM_WFORDER.BUILD_DETAIL_CHANGE_OBJECTS';

   L_rib_wppodesc_rec       "RIB_ExtOfNBXWFOrderDesc_REC" := NULL;

   
   L_wp_order_mfqueue_rowid  rowid_TBL;
   L_wp_order_mfqueue_size   BINARY_INTEGER := 0;

  
   PROGRAM_ERROR          EXCEPTION;

BEGIN

   if O_message is NULL then
      if BUILD_HEADER_OBJECT( O_error_message,
                              L_rib_wppodesc_rec,
                              I_sales_order_no) = FALSE then
      return FALSE;
   end if;

   else
      L_rib_wppodesc_rec := treat (O_message as "RIB_ExtOfNBXWFOrderDesc_REC");
   end if;

   if BUILD_DETAIL_OBJECTS( O_error_message,
                            L_rib_wppodesc_rec.ExtOfNBXWFOrderDtl_TBL,
                            L_wp_order_mfqueue_rowid,
                            L_wp_order_mfqueue_size,
                            O_routing_info,
                            IO_message_type,
                            I_sales_order_no,
                            I_item,
                            I_location) = FALSE then
      return FALSE;
   end if;

   LP_error_status := UNHANDLED_ERROR;

   if L_wp_order_mfqueue_size > 0 then
      FORALL i IN 1..L_wp_order_mfqueue_size
         delete from wp_order_mfqueue where rowid = L_wp_order_mfqueue_rowid(i);
   end if;

   O_message := L_rib_wppodesc_rec;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END BUILD_DETAIL_CHANGE_OBJECTS;
------------------------------------------------------------------------------------------
FUNCTION BUILD_DETAIL_DELETE(O_error_message     IN OUT        VARCHAR2,
                             O_message_type      IN OUT        VARCHAR2,
                             O_message           IN OUT nocopy RIB_OBJECT,
                             O_break_loop        IN OUT        BOOLEAN,
                             I_sales_order_no    IN     wp_order_detail.sales_order_no%TYPE,
                             I_item              IN     wp_order_detail.ITEM%TYPE,
                             I_location          IN     wp_order_detail.SOURCE_LOC_ID%TYPE,
                             I_loc_type          IN     wp_order_detail.SOURCE_LOC_TYPE%TYPE,
                             I_rowid             IN            ROWID)
RETURN BOOLEAN IS

   L_program              VARCHAR2(64) := 'WPMFM_WFORDER.BUILD_DETAIL_DELETE';

   L_odp_rowid            ROWID := NULL;

   L_rib_wppodesc_rec       "RIB_ExtOfNBXWFOrderDesc_REC"      := NULL;
   L_rib_wppodtl_tbl        "RIB_ExtOfNBXWFOrderDtl_TBL"       := NULL;

   L_wp_order_mfqueue_rowid  ROWID_TBL;
   L_wp_order_mfqueue_size   BINARY_INTEGER := 0;
   L_odp_rowid_tbl        ROWID_TBL;
   L_odp_size             BINARY_INTEGER := 0;

   cursor C_ORDER_DETAIL_PUBLISHED is
      select rowid
        from wp_order_details_published odp
       where odp.sales_order_no     = I_sales_order_no
         and odp.item               = I_item
         and odp.source_loc_id      = I_location;

BEGIN

   open C_ORDER_DETAIL_PUBLISHED;
   fetch C_ORDER_DETAIL_PUBLISHED into L_odp_rowid;
   close C_ORDER_DETAIL_PUBLISHED;

   if L_odp_rowid is NULL then
      O_break_loop := FALSE;
      ---
      LP_error_status := UNHANDLED_ERROR;
      delete from wp_order_mfqueue
       where rowid = I_rowid;
      ---
      return TRUE;
   end if;

   ---
   -- If it turns out that the message on the queue actually corresponds to a DTL_DEL
   -- message, the ref object for the message is created.
   ---
   if O_message_type = DTL_DEL then
      O_message := "RIB_ExtOfNBXWFOrderRef_REC"(
           0,                        -- rib_oid number
           I_sales_order_no,               -- order_no            NUMBER(12),
           "RIB_ExtOfNBXWFOrderDtlRef_TBL"("RIB_ExtOfNBXWFOrderDtlRef_REC"(0,
                                             I_item,                -- item
                                             I_location)));
   ---
   -- If it turns out that the message on the queue actually corresponds to a DTL_UPD
   -- message, the header object for the message is created, and the detail and header
   -- object are merged together.
   ---
   else
      if BUILD_HEADER_OBJECT( O_error_message,
                              L_rib_wppodesc_rec,
                              I_sales_order_no) = FALSE then
         return FALSE;
      end if;
      ---
      L_rib_wppodesc_rec.ExtOfNBXWFOrderDtl_TBL := L_rib_wppodtl_tbl;
      O_message := L_rib_wppodesc_rec;
   end if;

   -- Include current rowid in list of rowid's on queue table
   -- to delete.
   if L_wp_order_mfqueue_size = 0 then
      L_wp_order_mfqueue_size := L_wp_order_mfqueue_size + 1;
      L_wp_order_mfqueue_rowid(L_wp_order_mfqueue_size) := I_rowid;
   end if;

   if L_odp_size = 0 then
      L_odp_size := L_odp_size + 1;
      L_odp_rowid_tbl(L_odp_size) := L_odp_rowid;
   end if;

   LP_error_status := UNHANDLED_ERROR;

   ---
   -- delete record(s) from order_details_published and order_mfqueue
   ---
   FORALL i IN 1..L_odp_size
      update wp_order_details_published
         set detail_exists_ind = 'N'
       where rowid = L_odp_rowid_tbl(i);

   FORALL i IN 1..L_wp_order_mfqueue_size
      delete from wp_order_mfqueue
       where rowid = L_wp_order_mfqueue_rowid(i);

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
    O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;

END BUILD_DETAIL_DELETE;
------------------------------------------------------------------------------------------
FUNCTION GET_ROUTING_TO_LOCS(O_error_message IN OUT        VARCHAR2,
                             I_sales_order_no    IN     wp_order_detail.sales_order_no%TYPE,
                             O_routing_info  IN OUT nocopy RIB_ROUTINGINFO_TBL)
RETURN BOOLEAN IS

   L_program       VARCHAR2(64) := 'RMSMFM_ORDER.GET_ROUTING_TO_LOCS';

   cursor C_TO_LOCS is
      select distinct source_loc_id,
                      source_loc_type
        from wp_order_details_published
       where sales_order_no = I_sales_order_no;

BEGIN

   FOR rec IN C_TO_LOCS LOOP

      if ROUTING_INFO_ADD(O_error_message,
                          O_routing_info,
                          rec.source_loc_id,
                          rec.source_loc_type) = FALSE then
         return FALSE;
      end if;

   END LOOP;

   return TRUE;

EXCEPTION
   when OTHERS then
      /*O_error_message := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            NULL);*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);
      return FALSE;
END GET_ROUTING_TO_LOCS;

------------------------------------------------------------------------------------------
FUNCTION LOCK_THE_BLOCK(O_error_msg        OUT VARCHAR2,
                        O_queue_locked     OUT BOOLEAN,
                        I_sales_order_no   IN     wp_order_detail.sales_order_no%TYPE)
RETURN BOOLEAN IS

   L_table             VARCHAR2(30)  := 'WP_ORDER_MFQUEUE';
   L_key1              VARCHAR2(100) := I_sales_order_no;
   L_key2              VARCHAR2(100) := NULL;
   RECORD_LOCKED       EXCEPTION;
   PRAGMA              EXCEPTION_INIT(Record_Locked, -54);

   cursor C_LOCK_QUEUE is
      select 'x'
        from wp_order_mfqueue oq
       where oq.sales_order_no = I_sales_order_no
        for update nowait;

BEGIN

   O_queue_locked := FALSE;

   open C_LOCK_QUEUE;
   close C_LOCK_QUEUE;

   return TRUE;

EXCEPTION
   when RECORD_LOCKED then
      /*O_error_msg := SQL_LIB.CREATE_MSG('TABLE_LOCKED',
                                        L_table,
                                        L_key1,
                                        L_key2);*/
      O_error_msg := 'TABLE_LOCKED - '||L_table||', '||L_key1||', '||L_key2;
      O_queue_locked := TRUE;
      return TRUE;
   when OTHERS then
      /*O_error_msg := SQL_LIB.CREATE_MSG('PACKAGE_ERROR',
                                        SQLERRM,
                                        'WPMFM_WFORDER.LOCK_THE_BLOCK',
                                        TO_CHAR(SQLCODE)); */
      O_error_msg := SQLERRM||' - WPMFM_WFORDER.LOCK_THE_BLOCK - '||to_char(SQLCODE);
      return FALSE;
END LOCK_THE_BLOCK;
------------------------------------------------------------------------------------------

PROCEDURE HANDLE_ERRORS(O_status_code       IN OUT         VARCHAR2,
                        O_error_message     IN OUT         VARCHAR2,
                        O_message           IN OUT  nocopy RIB_OBJECT,
                        O_bus_obj_id        IN OUT  nocopy RIB_BUSOBJID_TBL,
                        O_routing_info      IN OUT  nocopy RIB_ROUTINGINFO_TBL,
                        I_seq_no            IN             wp_order_mfqueue.seq_no%TYPE,
                        I_sales_order_no    IN             wp_order_detail.sales_order_no%TYPE,
                        I_item              IN             wp_order_mfqueue.item%TYPE,
                        I_location          IN             wp_order_detail.SOURCE_LOC_ID%TYPE,
                        I_loc_type          IN             wp_order_detail.SOURCE_LOC_TYPE%TYPE)
IS

   L_program          VARCHAR2(64) := 'WPMFM_WFORDER.HANDLE_ERRORS';
   -- for error handling
   L_rib_wppodtlref_rec "RIB_ExtOfNBXWFOrderDtlRef_REC";
   L_rib_wppodtlref_tbl "RIB_ExtOfNBXWFOrderDtlRef_TBL";
   L_rib_wpporef_rec    "RIB_ExtOfNBXWFOrderRef_REC";

   L_error_type       VARCHAR2(5) := NULL;
BEGIN

   O_status_code   := LP_error_status;

   if O_status_code = HOSPITAL then

      O_bus_obj_id    := RIB_BUSOBJID_TBL(I_sales_order_no);
      O_routing_info  := RIB_ROUTINGINFO_TBL(RIB_ROUTINGINFO_REC('sequence_no', I_seq_no,null,null,null,null));

      L_rib_wppodtlref_rec := "RIB_ExtOfNBXWFOrderDtlRef_REC"(0,I_item,I_location);
      L_rib_wppodtlref_tbl := "RIB_ExtOfNBXWFOrderDtlRef_TBL"(L_rib_wppodtlref_rec);
      L_rib_wpporef_rec    := "RIB_ExtOfNBXWFOrderRef_REC"(0,
                                          I_sales_order_no,
                                          L_rib_wppodtlref_tbl);
      O_message := L_rib_wpporef_rec;

      update wp_order_mfqueue
         set pub_status = LP_error_status
       where seq_no    = I_seq_no;

   end if;

   /* Pass out parsed error message */
   /*SQL_LIB.API_MSG(L_error_type,
                   O_error_message);*/

EXCEPTION
   when OTHERS then
      O_status_code := UNHANDLED_ERROR;
      ---
      /*O_error_message := sql_lib.create_msg('PACKAGE_ERROR',
                                            SQLERRM,
                                            L_program,
                                            to_char(SQLCODE));*/
      O_error_message := SQLERRM||' - '||L_program||' - '||to_char(SQLCODE);


END HANDLE_ERRORS;
------------------------------------------------------------------------------------------
END WPMFM_WFORDER;
/
