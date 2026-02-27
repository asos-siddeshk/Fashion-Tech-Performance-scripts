--------------------------------------------------------
-- Copyright (c) 2000, Retek Inc.  All rights reserved.
-- $Workfile:$
-- $Revision: 1.1 $
-- $Modtime:$
--------------------------------------------------------

CREATE OR REPLACE package RIB_obj_util as
--------------------------------------------------------------------------------

type RIB_element_list   is table of varchar2(4000) index by varchar2(1000);
type RIB_element_values is table of varchar2(4000) index by binary_integer;

g_date_format        varchar2(100) := 'YYYYMMDDHH24MISS';
g_RIB_element_values RIB_element_list; -- associative array storage of message elements
g_RIB_table_names    RIB_element_list; -- associative array of names of tables

--------------------------------------------------------------------------------
procedure new_message_init(i_RIB_obj      in out  RIB_object,
                           i_date_format  in      varchar2  DEFAULT 'YYYYMMDDHH24MISS');

--------------------------------------------------------------------------------
procedure get_next_prefix(i_node_name       in   varchar2,
                          i_current_prefix  in   varchar2,
                          o_new_prefix      out  varchar2);

--------------------------------------------------------------------------------
procedure get_mapped_name(i_node_name    in   varchar2,
                          o_mapped_name  out  varchar2);

--------------------------------------------------------------------------------
procedure insert_tbl_node_values(i_RIB_obj  in out  RIB_object,
                                 i_name     in      varchar2,
                                 i_indx     in      integer,
                                 i_prefix   in      varchar2 );

--------------------------------------------------------------------------------
procedure insert_node_values(i_RIB_obj  in out  RIB_object,
                             i_name     in      varchar2,
                             i_prefix   in      varchar2);

--------------------------------------------------------------------------------
procedure get_element_values(i_element_spec  in      varchar2,
                             o_value_list    in out  RIB_element_values);

--------------------------------------------------------------------------------
procedure dump_rib_object(i_rib_object   in out  RIB_object,
                          i_date_format  in      varchar2 default 'YYYYMMDDHH24MISS');

--------------------------------------------------------------------------------
procedure dump_rib_object;

--------------------------------------------------------------------------------
end RIB_obj_util;
/
