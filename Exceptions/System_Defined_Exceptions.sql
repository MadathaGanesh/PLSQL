-- System Defined Exceptions

CREATE TABLE EXCEPTION_EMPLOYEE (EMP_ID NUMBER,EMP_NAME VARCHAR2(255),SALARY NUMBER, EMP_DEPTID NUMBER);

CREATE TABLE EXCEPTION_DEPT (DEPT_DEPTID NUMBER, DEPT_NAME VARCHAR2(255),LOCATION VARCHAR2(255));

-- Insert data into EXCEPTION_EMPLOYEE table
INSERT INTO EXCEPTION_EMPLOYEE (EMP_ID, EMP_NAME, SALARY, EMP_DEPTID) VALUES (101, 'Alice', 5000, 1);
INSERT INTO EXCEPTION_EMPLOYEE (EMP_ID, EMP_NAME, SALARY, EMP_DEPTID) VALUES (102, 'Bob', 6000, 2);
INSERT INTO EXCEPTION_EMPLOYEE (EMP_ID, EMP_NAME, SALARY, EMP_DEPTID) VALUES (103, 'Charlie', 4000, 3);

-- Insert data into EXCEPTION_DEPT table
INSERT INTO EXCEPTION_DEPT (DEPT_DEPTID, DEPT_NAME, LOCATION) VALUES (1, 'HR', 'New York');
INSERT INTO EXCEPTION_DEPT (DEPT_DEPTID, DEPT_NAME, LOCATION) VALUES (2, 'Finance', 'London');
INSERT INTO EXCEPTION_DEPT (DEPT_DEPTID, DEPT_NAME, LOCATION) VALUES (3, 'IT', 'San Francisco');
INSERT INTO EXCEPTION_DEPT (DEPT_DEPTID, DEPT_NAME, LOCATION) VALUES (3, 'Recruiting', 'India');



--1. Write a PL/SQL block that fetches an employee's name based on a given EMP_ID. 
--Handle the case where no employee exists for the given ID

SET SERVEROUTPUT ON;
DECLARE
    V_EMPNAME EXCEPTION_EMPLOYEE.EMP_NAME%TYPE;
    V_EMPID NUMBER :=123;
BEGIN
    SELECT EMP_NAME INTO V_EMPNAME FROM EXCEPTION_EMPLOYEE WHERE EMP_ID= V_EMPID;
    DBMS_OUTPUT.PUT_LINE('Employee Name is:  ' || V_EMPNAME);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('No Employee FOund with this EMPID -  ' || V_EMPID);
END;
/

-- 2. Write a PL/SQL block that retrieves a department name based on DEPT_ID, assuming it should return only one row. Handle the error if more than one department matches the DEPT_ID.
DECLARE
V_DEPT_NAME  EXCEPTION_DEPT.DEPT_NAME%TYPE;
v_dept_id    NUMBER := 3;
BEGIN
    SELECT DEPT_NAME INTO V_DEPT_NAME from EXCEPTION_DEPT WHERE DEPT_DEPTID=v_dept_id;
    DBMS_OUTPUT.PUT_LINE('DEPT NAME FOR '|| v_dept_id || ' IS = ' || V_DEPT_NAME);
   
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        -- Handle the case where more than one department matches the DEPT_ID
        DBMS_OUTPUT.PUT_LINE('Error: Multiple departments found for DEPT_ID = ' || v_dept_id || '.');

    WHEN NO_DATA_FOUND THEN
        -- Handle the case where no department matches the DEPT_ID
        DBMS_OUTPUT.PUT_LINE('Error: No department found for DEPT_ID = ' || v_dept_id || '.');
END;
/


-- Write a PL/SQL block that calculates the average salary by dividing the total salary by the number of employees. Handle the division by zero error when there are no employees in a department.
-- How do you avoid or handle the error caused by dividing a number by zero in PL/SQL?
SET SERVEROUTPUT ON;
DECLARE
    V_DEPT_NUM                NUMBER := 1;
    V_TOTAL_SALARY             EXCEPTION_EMPLOYEE.EMP_ID%TYPE;
    V_TOTAL_EMPLOYEES          EXCEPTION_EMPLOYEE.EMP_NAME%TYPE;
    V_AVG_SALARY               NUMBER;
BEGIN           
    SELECT NVL(SUM(SALARY),0) , COUNT(*) INTO V_TOTAL_SALARY,V_TOTAL_EMPLOYEES FROM EXCEPTION_EMPLOYEE WHERE EMP_DEPTID=V_DEPT_NUM;
    V_AVG_SALARY := V_TOTAL_SALARY / V_TOTAL_EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE('AVG SALARY FOR DEPTNO ' || V_DEPT_NUM || ' IS : ' || V_AVG_SALARY);
    EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('nNumber cant be divide by zero');
END;
/


-- VALUE_ERROR :
-- Write a PL/SQL block that converts a user-provided string into a number. Handle errors if the string cannot be converted to a valid number.
-- What exception is raised when there is a numeric or character conversion error, and how do you handle it in PL/SQL?
DECLARE
V_INPUT_CHAR   VARCHAR2(225) := 'ABS123';
V_NUMBER  NUMBER;
BEGIN
    V_NUMBER := TO_NUMBER(V_INPUT_CHAR);
    DBMS_OUTPUT.PUT_LINE(' Converted Number is : ' ||V_NUMBER );
    EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Incorrect Value Data type ! ' || SQLERRM);
END;
/


-- DUP_VAL_ON_INDEX (ORA-00001)
--Write a PL/SQL block that attempts to insert a duplicate value into a table with a unique constraint. Handle the exception when this occurs.
--How can you handle the error raised when inserting duplicate values into a table with a unique constraint?
DECLARE
V_EMPID         NUMBER := 103;
V_EMP_NAME      VARCHAR2(255) := 'Rama Krishna';
V_SALARY        NUMBER := 10000;
V_DEPTID        NUMBER := 5;
BEGIN
INSERT INTO EXCEPTION_EMPLOYEE(EMP_ID,EMP_NAME,SALARY,EMP_DEPTID) VALUES (V_EMPID,V_EMP_NAME,V_SALARY,V_DEPTID);
DBMS_OUTPUT.PUT_LINE('Inserted One Record Data --  :: EmpID id : ' || V_EMPID || ' .EMP NAME is : ' || V_EMP_NAME || ' . SALARY IS : '||V_SALARY || ' . DEPT ID IS : '||V_DEPTID );
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Inserted Duplicated Value -- ' || SQLERRM);
END;
/

--6. INVALID_CURSOR (ORA-01001)
--Write a PL/SQL block that performs operations on a cursor. Handle errors when trying to fetch from a cursor that is not open.
--What causes the INVALID_CURSOR exception, and how can you handle it in PL/SQL?
DECLARE
    V_EMP_DATA  EXCEPTION_EMPLOYEE%ROWTYPE;
    CURSOR CURSOR_EMP_DATA IS SELECT EMP_ID,EMP_NAME,SALARY,EMP_DEPTID FROM EXCEPTION_EMPLOYEE;
BEGIN
--     OPEN CURSOR_EMP_DATA;
    LOOP
        FETCH CURSOR_EMP_DATA INTO V_EMP_DATA ;
        EXIT WHEN CURSOR_EMP_DATA%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('EMP_ID IS : ' || V_EMP_DATA.EMP_ID || ' . EMP NAME IS : ' || V_EMP_DATA.EMP_NAME || ' . SALARY IS : ' || V_EMP_DATA.SALARY );
    END LOOP;
    CLOSE CURSOR_EMP_DATA;
    
EXCEPTION   
    WHEN INVALID_CURSOR THEN
        dbms_output.put_line('Cursor Error Occured -- Cursor Not opened ! '|| SQLERRM);
END;
/




DESC EXCEPTION_EMPLOYEE;

SELECT * FROM EXCEPTION_EMPLOYEE;
SELECT * FROM EXCEPTION_DEPT;