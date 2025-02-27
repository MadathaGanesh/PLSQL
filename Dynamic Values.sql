-- Taking Values as input dynamically
-- Without taking static values or hard-coding values we can take values as dynamically before.



SELECT * FROM EMPLOYEES;
DESC EMPLOYEES;

--  1: Using Substitution Values  :: Used to accept user input at runtime.
SET SERVEROUTPUT ON;
-- We are giving the below prompt "to enter correct Employee ID: "
ACCEPT EMPLOYEE_ID NUMBER PROMPT 'ENTER CORRECT EMPLOYEE ID : ';
DECLARE
    VAR_EMP_ID      EMPLOYEES.EMPID%TYPE;
    VAR_EMP_NAME    EMPLOYEES.EMP_NAME%TYPE;
    VAR_MOBILE      EMPLOYEES.MOBILE%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Using Substitution Variables => to accept user input at runtime');
    SELECT EMPID,EMP_NAME,MOBILE INTO VAR_EMP_ID,VAR_EMP_NAME,VAR_MOBILE FROM EMPLOYEES WHERE EMPID = &EMPLOYEE_ID;
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE ID is : ' || VAR_EMP_ID || ' .EMP NAME is : ' || VAR_EMP_NAME || ' .EMP MOBILE IS :' || VAR_MOBILE);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NO Data Found !');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_lINE('Some Unknown Error Occured ! ');
END;
/





-- 2: Using BInd variable (:) -> colon sign
SET SERVEROUTPUT ON;
VARIABLE EMPLOYEE_ID1 NUMBER;   -- Defining the Bind Variable

--EXEC :EMPLOYEE_ID1 := 103;    -- Assigning value to bind variable

DECLARE
    VAR_EMP_NAME1   EMPLOYEES.emp_name%type;
    VAR_EMP_ID1     EMPLOYEES.empid%type;
    VAR_MOBILE1     EMPLOYEES.mobile%type;
BEGIN
    SELECT EMPID,EMP_NAME,MOBILE INTO VAR_EMP_ID1,VAR_EMP_NAME1,VAR_MOBILE1 FROM EMPLOYEES WHERE EMPID = :EMPLOYEE_ID1;
    DBMS_OUTPUT.PUT_LINE('EMP ID IS : ' || VAR_EMP_ID1 ||
                         '.EMP NAME IS : ' || VAR_EMP_NAME1 ||
                         '.MOBILE IS : ' || VAR_MOBILE1);   
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No Employee Data Found Dude !');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Something went Wrong ! ');
END;
/



-- 3 : Passing Parameters to Procedures or Functions USING "IN" and "OUT" Parameter.
-- First create the Procedure.
CREATE OR REPLACE PROCEDURE GET_EMPLOYEES_DATA
(P_EMPID IN NUMBER,P_EMP_NAME OUT VARCHAR2,P_ADDRESS OUT VARCHAR2) AS
BEGIN
    SELECT EMP_NAME,ADDRESS INTO P_EMP_NAME,P_ADDRESS FROM EMPLOYEES WHERE EMPID=P_EMPID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            P_EMP_NAME := 'NO Emp Name FOUND';
            P_ADDRESS := 'NO Address Found !';
END;
/

--Then second write Anonymous Block
DECLARE
    VAR_EMP_NAME_3      EMPLOYEES.EMP_NAME%TYPE;
    VAR_ADDRESS_3       EMPLOYEES.ADDRESS%TYPE;   
BEGIN
    GET_EMPLOYEES_DATA(103,VAR_EMP_NAME_3,VAR_ADDRESS_3);
        DBMS_OUTPUT.PUT_LINE('Employee Name is : '|| VAR_EMP_NAME_3  || ' .Address is : ' || VAR_ADDRESS_3);
END;
/


-- 4. Using Dynamic SQL with EXECUTE IMMEDIATE
--  Dynamic SQL enables the execution of SQL statements that are constructed at runtime.
-- When Used: For constructing queries dynamically or executing DDL statements.
-- Usage: Dynamic SQL is constructed using string concatenation and placeholders (:1, :2, etc.).
SET SERVEROUTPUT ON;
DECLARE
    VAR_TABLE_NAME      VARCHAR2(30) := 'EMPLOYEES';   -- Writing "Table Name" and passing it dynamically.    Stores the name of the table (EMPLOYEES) in a variable.
    VAR_EMP_ID          NUMBER := 103;                 -- Giving EMP_ID as input          Holds the employee ID (101) to use as a filter in the SQL query.
    VAR_EMP_NAME        EMPLOYEES.EMP_NAME%TYPE;
    VAR_ADDRESS         EMPLOYEES.ADDRESS%TYPE;
BEGIN
    -- Below we are passing "Table Name" and "EMP ID" values dynamically.
    -- Constructs the SQL query dynamically at runtime by concatenating the table name (VAR_TABLE_NAME) into the query string.
    -- EXECUTE IMMEDIATE:  Executes the constructed query dynamically.
    -- USING VAR_EMP_ID:   Supplies the value of VAR_EMP_ID (101) to the bind variable :1 in the query.
    EXECUTE IMMEDIATE 'SELECT EMP_NAME, ADDRESS FROM ' || VAR_TABLE_NAME || ' WHERE EMPID = :1' INTO VAR_EMP_NAME, VAR_ADDRESS USING VAR_EMP_ID;
    DBMS_OUTPUT.PUT_LINE('Employee Name is: ' || VAR_EMP_NAME  || ' .Address is : ' || VAR_ADDRESS);
END;
/


-- 5. Using Anonymous Blocks with Parameters
-- Description: Anonymous PL/SQL blocks can accept values through bind variables when executed.
-- When Used: For ad-hoc script execution.

BEGIN
    DECLARE
    VAR_EMP_ID      NUMBER := :EMPLOYEE_ID;
    VAR_EMP_NAME    EMPLOYEES.EMP_NAME%TYPE;
    BEGIN
        SELECT EMP_NAME INTO VAR_EMP_NAME FROM EMPLOYEES WHERE EMPID = VAR_EMP_ID;
        DBMS_OUTPUT.PUT_LINE('EMP ID IS : ' || VAR_EMP_ID || ' AND EMP NAME IS : ' || VAR_EMP_NAME);
    END;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No Data is there with this EMPLOYEE ID !');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected Error occured !');    
END;
/


select * from v$version;













DECLARE
    CURSOR_ID       INTEGER;
    VAR_EMP_NAME    VARCHAR2(50);
BEGIN
    CURSOR_ID := DBMS_SQL.OPEN_CURSOR;       -- Open a dynamic SQL cursor
    
    -- Parse the dynamic SQL query
    DBMS_SQL.PARSE(CURSOR_ID,'SELECT EMP_NAME FROM EMPLOYEES WHERE EMPID = :1',DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(CURSOR_ID, ':1', 101);       -- Bind the value 101 to the bind variable :1
    DBMS_SQL.DEFINE_COLUMN(CURSOR_ID,1,VAR_EMP_NAME);       -- Define the first column to map to VAR_EMP_NAME
    IF DBMS_SQL.EXECUTE_AND_FETCH_ROWS(CURSOR_ID) > 0 THEN       -- Execute the query and check if rows are fetched
        DBMS_SQL.COLUMN_VALUE(CURSOR_ID,1,VAR_EMP_NAME);             -- Retrieve the value of the first column
        DBMS_OUTPUT.PUT_LINE('Employee ID is : ' || VAR_EMP_NAME);
    END IF;
    
    DBMS_SQL.CLOSE_CURSOR(CURSOR_ID); -- Close the cursor to free resources
END;
/















