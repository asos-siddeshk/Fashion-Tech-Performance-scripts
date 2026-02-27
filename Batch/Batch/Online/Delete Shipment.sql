DECLARE
  O_ERROR_MESSAGE VARCHAR2(255);
  I_ASN VARCHAR2(30);
  v_Return BOOLEAN;



BEGIN
  O_ERROR_MESSAGE := NULL;
  I_ASN := NULL;

  v_Return := RMS.ASN_SQL.DELETE_ASN(
    O_ERROR_MESSAGE => O_ERROR_MESSAGE,
    I_ASN => I_ASN
  );
 IF (v_Return) THEN 
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'Deleted ');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || 'failed');
    DBMS_OUTPUT.PUT_LINE('Error = ' || O_ERROR_MESSAGE);
  END IF;
END;
/