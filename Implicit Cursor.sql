-- Implicit Cursor
-- We use "FOR Loop" and Loop through all rows in the EMPLOYEES table   
-- NOTE: Implicit cursor always uses “FOR Loop”, and stores that value in “Iterator Variable”


DESC EMPLOYEES;
SELECT * FROM EMPLOYEES;

-- Using Implicit Cursor. 
-- Using "%TYPE" TO STORE SINGLE VALUES INDIVIDUALLY.
--  %TYPE is an attribute used to declare a variable with the same data type as a database column or another variable. 
SET SERVEROUTPUT ON;
DECLARE
VAR_EMPID       EMPLOYEES.EMPID%TYPE;
VAR_EMPNAME     EMPLOYEES.EMP_NAME%TYPE;
VAR_SALARY      EMPLOYEES.SALARY%TYPE;
VAR_ADDRESS     EMPLOYEES.ADDRESS%TYPE;
VAR_MOBILE      EMPLOYEES.MOBILE%TYPE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Before Fetching Data using Implicit Cursor  "%TYPE"');
    FOR IMPLICIT_CURSOR_NAME IN (SELECT EMPID,EMP_NAME,SALARY,ADDRESS,MOBILE FROM EMPLOYEES)
    LOOP
    -- Assigning the Table Columns to these variable Names
    VAR_EMPID       := IMPLICIT_CURSOR_NAME.EMPID;
    VAR_EMPNAME     := IMPLICIT_CURSOR_NAME.EMP_NAME;
    VAR_SALARY      := IMPLICIT_CURSOR_NAME.SALARY;
    VAR_ADDRESS     := IMPLICIT_CURSOR_NAME.ADDRESS;
    VAR_MOBILE      := IMPLICIT_CURSOR_NAME.MOBILE;
        DBMS_OUTPUT.PUT_LINE('EMPID IS : ' || VAR_EMPID  || ' .EMP NAME IS : ' || VAR_EMPNAME || ' .SALARY IS : ' || VAR_SALARY || ' Mobile is : ' || VAR_MOBILE);
    END LOOP;
END;
/




-- Implicit Cursor Example with "%ROWTYPE" 
--  %ROWTYPE is an attribute that allows declaring a record (a composite variable) with the same structure as a row in a database table or cursor.
DECLARE
VAR_EMPLOYEES  EMPLOYEES%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before Fetching Data using Implicit Cursor  "%ROWTYPE"');
    FOR IMPLICIT_CURSOR_NAME_ROW_TYPE IN ( SELECT * FROM EMPLOYEES )
    LOOP
    -- Assigning the Table Columns to these  single variable Names 
    VAR_EMPLOYEES  := IMPLICIT_CURSOR_NAME_ROW_TYPE;
    DBMS_OUTPUT.PUT_LINE('EMPID IS : ' || VAR_EMPLOYEES.EMPID   || ' .EMP NAME IS : ' || VAR_EMPLOYEES.EMP_NAME || 
    ' .SALARY IS : ' || VAR_EMPLOYEES.SALARY || ' Mobile is : ' || VAR_EMPLOYEES.MOBILE);
    END LOOP;
END;
/