set serveroutput on;
set timing on;
BEGIN
 split_file ('EXPDIR', 'export_item.csv');
END;
/


CREATE OR REPLACE PROCEDURE split_file (p_db_dir IN VARCHAR2,p_file_name IN VARCHAR2)
IS
 read_file UTL_FILE.file_type;
 write_file UTL_FILE.file_type;
 v_string VARCHAR2 (32767);
 j NUMBER := 1;
BEGIN
 read_file := UTL_FILE.fopen (p_db_dir, p_file_name, 'r');

WHILE j > 0
 LOOP
 write_file := UTL_FILE.fopen (p_db_dir,p_file_name, 'w');
  
FOR i IN 1 .. 1000
 LOOP -- example to dividing into 1000 rows for each file.. 
 UTL_FILE.get_line (read_file, v_string);
 UTL_FILE.put_line (write_file, v_string);
 END LOOP;

UTL_FILE.fclose (write_file);
 j := J + 1;
 END LOOP;
EXCEPTION
 WHEN OTHERS
 THEN
 -- this will handle if reading source file contents finish
 UTL_FILE.fclose (read_file);
 UTL_FILE.fclose (write_file);
END;
/

