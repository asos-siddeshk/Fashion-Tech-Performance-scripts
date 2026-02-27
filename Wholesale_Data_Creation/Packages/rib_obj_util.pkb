--------------------------------------------------------
-- Copyright (c) 2000, Retek Inc.  All rights reserved.
-- $Workfile:$
-- $Revision: 1.1 $
-- $Modtime:$
--------------------------------------------------------

CREATE OR REPLACE package body RIB_obj_util as

--------------------------------------------------------------------------------
-- Forward declarations
--------------------------------------------------------------------------------
procedure extract_values(i_first_part  in      varchar2,
                         i_remainder   in      varchar2,
                         i_value_list  in out  RIB_element_values);
--
procedure extract_values2(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values);
--
procedure extract_values3(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values);
--
procedure extract_values4(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values);
--
procedure extract_values5(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values);
--
procedure extract_values6(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values);

--------------------------------------------------------------------------------
g_RIB_mapped_node_names RIB_element_list; -- associative array storage of mapped names
g_node_count            integer := 0;
g_values_size           integer;
g_values_count          integer;

--------------------------------------------------------------------------------
-- new_message_init(): used to initialize all tables for a new message
--------------------------------------------------------------------------------
procedure new_message_init(i_RIB_obj      in out  RIB_object,
                           i_date_format  in      varchar2)
is
begin
   --dbms_output.put_line('new message init starting');
    g_RIB_element_values.delete();
   ----dbms_output.put_line('before mapped node names delete');
   --g_RIB_mapped_node_names.delete();
   ----dbms_output.put_line('before date format save');
   g_date_format := i_date_format;
   g_node_count := 0;
   ----dbms_output.put_line('before recursion');
   i_RIB_obj.appendNodeValues('');
end new_message_init;

--------------------------------------------------------------------------------
-- get_next_mapping(): function that returns the next mapping value
-- handles up to 26^2 (676) distinct node mappings
-- assumes the current mapping is NOT mapped
--------------------------------------------------------------------------------
function get_next_mapping
return varchar2 is
   l_first_value integer;
   l_second_value integer;
   l_return varchar2(20);
begin
   g_node_count := g_node_count + 1;
   l_first_value := mod(g_node_count, 26);
   l_return := CHR( 64 + l_first_value);
   if( g_node_count > 26) then
      l_second_value := g_node_count / 26;
      if( l_second_value > 26) then
         raise too_many_rows;
      end if;
      l_return := l_return || CHR( 64 + l_first_value);
   end if;
   return l_return;
end get_next_mapping;

--------------------------------------------------------------------------------
-- get_next_prefix: used in the RIB_object for calling insert_tbl_node_values
-- correctly
--------------------------------------------------------------------------------
procedure get_next_prefix(i_node_name       in   varchar2,
                          i_current_prefix  in   varchar2,
                          o_new_prefix      out  varchar2)
is
   l_mapped_name  varchar2(100);
begin
    --get_mapped_name( i_node_name, l_mapped_name);
    o_new_prefix := i_current_prefix||'.'||i_node_name;
end get_next_prefix;

--------------------------------------------------------------------------------
-- get_mapped name: gets a mapped node from from the input node name.
-- an associative array maintains this mapping
--------------------------------------------------------------------------------
procedure get_mapped_name(i_node_name    in   varchar2,
                          o_mapped_name  out  varchar2)
is
   l_mapped_name  varchar2(4000);
begin
    o_mapped_name := i_node_name;
   --o_mapped_name := g_RIB_mapped_node_names(i_node_name);
exception
   when NO_DATA_FOUND then
      declare
         l_temp_name varchar2(100);
      begin
         l_temp_name := get_next_mapping();
         g_RIB_mapped_node_names(i_node_name) := l_temp_name;
         o_mapped_name := l_temp_name;
         return;
      end;
end get_mapped_name;

--------------------------------------------------------------------------------
-- insert_tbl_node_values: used to form a table of nodes
-- input is a single node from the table
--------------------------------------------------------------------------------
procedure insert_tbl_node_values(i_RIB_obj  in out  RIB_object,
                                 i_name     in      varchar2,
                                 i_indx     in      integer,
                                 i_prefix   in      varchar2)
is
   l_new_pre varchar2(4000);
begin
   -- figure out the prefix to send to the table
   l_new_pre := i_prefix||i_indx||i_name||'.';
   i_RIB_obj.appendNodeValues( l_new_pre);
   g_RIB_table_names(i_prefix||i_name) := i_indx;
   ----dbms_output.put_line('insert_tbl_node_values: g_RIB_table_names('||i_prefix||i_name||'), l_new_pre : '||l_new_pre);
   return;
end;

--------------------------------------------------------------------------------
-- insert_node_values: append an element value from a specific node
--------------------------------------------------------------------------------
procedure insert_node_values(i_RIB_obj  in out  RIB_object,
                             i_name     in      varchar2,
                             i_prefix   in      varchar2)
is
   l_new_pre      varchar2(4000);
   l_mapped_name  varchar2(100);
begin
   if( i_RIB_obj is null) then
      return;
   end if ;
   --get_mapped_name( i_name, l_mapped_name);
   --l_new_pre := i_prefix||'.'||l_mapped_name;
   l_new_pre := i_prefix||i_name||'.';

   g_RIB_table_names(i_prefix||i_name) := 0;
   i_RIB_obj.appendNodeValues( l_new_pre);
   return;
end;

--------------------------------------------------------------------------------
procedure get_element_values(i_element_spec  in      varchar2,
                             o_value_list    in out  RIB_element_values)
is
   l_first_delim  number;
   l_first_part   varchar2(4000);
   l_remainder    varchar2(4000);
   l_loop_count   integer;
begin
   --dbms_output.put_line('get_element_values: starting on '||i_element_spec);
   --o_value_list := RIB_element_values();
   l_first_delim := instr( i_element_spec,'.');
   if( l_first_delim = 0) then
      --o_value_list.extend(1);
      o_value_list(1) := g_RIB_element_values(i_element_spec);
      return;
   end if;
   o_value_list.delete();
   g_values_size := 0;
   g_values_count := 0;
   extract_values('', i_element_spec, o_value_list);
   --if( g_values_size > g_values_count) then
      --dbms_output.put_line('get_element_values: trim to '||g_values_count);
      --o_value_list.trim(g_values_count);
   --end if;
end;

--------------------------------------------------------------------------------
procedure extract_values(i_first_part  in      varchar2,
                         i_remainder   in      varchar2,
                         i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);

      --dbms_output.put_line('extract_values: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values2(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in 1..l_loop_count loop
            --dbms_output.put_line('extract_values: get '||l_loop_first||indx||i_remainder);
               i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;

      else
         --dbms_output.put_line('extract_values: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values2(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values: returning single value');
   end if;
exception
   when no_data_found then
        --dbms_output.put_line('extract_values: no data found at all');
       return;
end extract_values;

--------------------------------------------------------------------------------
procedure extract_values2(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values2: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values2: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);

      --dbms_output.put_line('extract_values2: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values2: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values3(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in 1..l_loop_count loop
               i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;

      else
         --dbms_output.put_line('extract_values2: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values3(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values2: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values2: returning single value');
   end if;
exception
   when no_data_found then
      --dbms_output.put_line('extract_values2: no data found at all');
      return;
end extract_values2;

--------------------------------------------------------------------------------
procedure extract_values3(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values3: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values3: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);
      --dbms_output.put_line('extract_values3: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values3: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values4(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in 1..l_loop_count loop
               i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;

      else
         --dbms_output.put_line('extract_values: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values4(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values3: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values3: returning single value');
   end if;
exception
   when no_data_found then
      --dbms_output.put_line('extract_values3: no data found at all');
      return;
end extract_values3;

--------------------------------------------------------------------------------
procedure extract_values4(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values4: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values4: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);
      --dbms_output.put_line('extract_values4: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values4: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values5(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in 1..l_loop_count loop
               i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;

      else
         --dbms_output.put_line('extract_values4: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values5(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values4: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values4: returning single value');
   end if;
exception
   when no_data_found then
      --dbms_output.put_line('extract_values4: no data found at all');
      return;
end extract_values4;

--------------------------------------------------------------------------------
procedure extract_values5(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values5: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values5: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);
      --dbms_output.put_line('extract_values5: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values5: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values6(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in g_values_count+1..(g_values_count + l_loop_count) loop
                  i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;

      else
         --dbms_output.put_line('extract_values5: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values6(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values5: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values5: returning single value');
   end if;
exception
   when no_data_found then
      --dbms_output.put_line('extract_values5: no data found at all');
      return;
end extract_values5;

--------------------------------------------------------------------------------
procedure extract_values6(i_first_part  in      varchar2,
                          i_remainder   in      varchar2,
                          i_value_list  in out  RIB_element_values)
is
   l_loop_first       varchar2(4000);
   l_loop_count       integer;
   l_first_remainder  varchar2(4000);
   l_last_remainder   varchar2(4000);
   l_more             integer;
   l_values_size      integer;
   l_single_value     varchar2(4000);
begin
   --dbms_output.put_line('extract_values6: starting');
   l_more := instr(i_remainder, '.');
   --dbms_output.put_line('extract_values6: l_more: '||l_more||', i_remainder: ' ||i_remainder);
   if( l_more > 0 ) then -- nested structure or table specified
      -- check if the next part is a table
      l_first_remainder := substr(i_remainder, 1, l_more);
      l_last_remainder  := substr(i_remainder, l_more+1);
      l_loop_first := upper(i_first_part);
      --dbms_output.put_line('extract_values6: g_RIB_table_names('||l_loop_first||l_first_remainder||')');
      l_loop_count := g_RIB_table_names(l_loop_first||l_first_remainder);
      --dbms_output.put_line('extract_values6: loop count of '||l_loop_count);
      -- if a loop count of zero exists, then we have a single structure defined
      if( l_loop_count > 0 ) then
         -- deal with the table of fields
         if( instr(l_last_remainder, '.') > 0 ) then
            for indx in 1..l_loop_count loop
               extract_values(l_loop_first||indx||l_first_remainder, l_last_remainder, i_value_list);
            end loop;
         else
            for indx in g_values_count+1..(g_values_count + l_loop_count) loop
                  i_value_list(indx) := g_RIB_element_values(l_loop_first||indx||i_remainder);
            end loop;
            g_values_count := g_values_count + l_loop_count;
         end if;
      else
         --dbms_output.put_line('extract_values6: nested struct, not table');
         -- we are not dealing with a table situation.  recursively call this routine
         extract_values(l_loop_first||l_first_remainder, l_last_remainder, i_value_list);
      end if;
   else
      -- no more segments found, extract the first_part.remainder
      --dbms_output.put_line('extract_values6: simple field spec'||i_first_part||i_remainder);
      l_single_value := g_RIB_element_values(i_first_part||i_remainder);
      g_values_count := g_values_count + 1;
      i_value_list(g_values_count) := l_single_value;
      --dbms_output.put_line('extract_values6: returning single value');
   end if;
exception
   when no_data_found then
      --dbms_output.put_line('extract_values6: no data found at all');
      return;
end extract_values6;

--------------------------------------------------------------------------------
PROCEDURE DUMP_RIB_OBJECT
IS
   L_IDX_LENGTH  INTEGER;
   L_IDX         VARCHAR2(4000);
   L_IDX_STRING  VARCHAR2(4000);
BEGIN
   l_IDX := g_RIB_element_values.FIRST();
   WHILE L_IDX IS NOT NULL LOOP
      L_IDX_STRING := L_IDX||' :  ';
      L_IDX_LENGTH := LENGTH(L_IDX_STRING);
      L_IDX_LENGTH := L_IDX_LENGTH + 8 - MOD(L_IDX_LENGTH, 8);
      L_IDX_STRING := RPAD(L_IDX_STRING,L_IDX_LENGTH);
      DBMS_OUTPUT.PUT_LINE(L_IDX_STRING||''''||G_RIB_ELEMENT_VALUES(L_IDX)||'''');
      L_IDX := G_RIB_ELEMENT_VALUES.NEXT(L_IDX);
   END LOOP;
END DUMP_RIB_OBJECT;

--------------------------------------------------------------------------------
PROCEDURE DUMP_RIB_OBJECT(I_RIB_OBJECT  IN OUT  RIB_OBJECT,
                          I_DATE_FORMAT  IN     VARCHAR2 DEFAULT 'YYYYMMDDHH24MISS')
IS
BEGIN
   IF( I_RIB_OBJECT IS NULL ) THEN
      DBMS_OUTPUT.PUT_LINE('DUMP_RIB_OBJECT: NULL RIB OBJECT');
      RETURN;
   END IF;
   new_message_init(i_RIB_OBJECT, I_DATE_FORMAT);
   DUMP_RIB_OBJECT;
END DUMP_RIB_OBJECT;

--------------------------------------------------------------------------------
end RIB_obj_util;
/
