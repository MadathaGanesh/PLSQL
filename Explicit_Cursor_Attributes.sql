-- EXPLICIT CURSOR ATTRIBUTES

-- %ISOPEN;
-- %FOUND
-- %NOTFOUND
-- %ROWCOUNT

DESC EMPLOYEES;

SELECT * FROM EMPLOYEES;

SET SERVEROUTPUT ON;
DECLARE
    VAR_EMP_ATTRIBUTES   EMPLOYEES%ROWTYPE;
    CURSOR ATTRIBUTES_CURSOR IS SELECT * FROM EMPLOYEES;  -- To work with ALL Cursor Attributes
    
BEGIN
    -- Checking before closing the cursor
    IF ATTRIBUTES_CURSOR%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('ATTRIBUTES_CURSOR Cursor is Opened !');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ATTRIBUTES_CURSOR Cursor is Not Opened ! So, you need to open it now');
    END IF;
    
    
    OPEN ATTRIBUTES_CURSOR;
        LOOP
            FETCH ATTRIBUTES_CURSOR INTO VAR_EMP_ATTRIBUTES;
            EXIT WHEN ATTRIBUTES_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('EMP ID is : ' || VAR_EMP_ATTRIBUTES.EMPID || '  .EMP NAME IS : ' || VAR_EMP_ATTRIBUTES.EMP_NAME || 
            '  .SALARY IS : ' || VAR_EMP_ATTRIBUTES.SALARY || '  .MOBILE IS : ' || VAR_EMP_ATTRIBUTES.MOBILE);
            
            DBMS_OUTPUT.PUT_LINE('ROWCOUNT till Now is : ' || ATTRIBUTES_CURSOR%ROWCOUNT );
        END LOOP;
    CLOSE ATTRIBUTES_CURSOR;
    

    -- Checking after closing the cursor
    IF ATTRIBUTES_CURSOR%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('ATTRIBUTES_CURSOR Cursor is Opened !');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ATTRIBUTES_CURSOR Cursor is Not Opened ! bcoz the cursor is closed ');
    END IF;
END;
/



