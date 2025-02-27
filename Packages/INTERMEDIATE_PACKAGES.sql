-- Intermediate Packages


--1. Create a function that returns the total salary of all employees 
--in a given department. Use this function in a procedure that fetches the department name
--and total salary for that department.
SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE PKG_TOTAL_SALARY IS
    PROCEDURE FETCH_DETAILS(P_DEPTNO IN NUMBER);
    FUNCTION GET_TOTAL_SALARY(P_DEPTNO IN NUMBER) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY PKG_TOTAL_SALARY IS
    V_TOTAL_SALARY NUMBER;
    -- Function Used to calculate and return Total Salary based on DEPTNO.
    FUNCTION GET_TOTAL_SALARY(P_DEPTNO IN NUMBER)
    RETURN NUMBER IS
    BEGIN
        SELECT SUM(SALARY) INTO V_TOTAL_SALARY FROM PACKAGE_EMPLOYEES WHERE DEPTNO=P_DEPTNO GROUP BY DEPTNO ;
        RETURN V_TOTAL_SALARY;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    END;
    
    -- Fetching DEPT_NAME from DEPT Table based on DEPTNO
    PROCEDURE FETCH_DETAILS(P_DEPTNO IN NUMBER) IS
    VAR_TOTAL_SALARY NUMBER;
    VAR_DEPT_NAME VARCHAR2(255);
    
    BEGIN
       -- Calling the Function and PAssing DEPTNO to it
        VAR_TOTAL_SALARY := GET_TOTAL_SALARY(P_DEPTNO);
        SELECT DEPT_NAME INTO VAR_DEPT_NAME FROM PACKAGE_DEPT WHERE DEPTNO= P_DEPTNO;
        DBMS_OUTPUT.PUT_LINE('Total Salary for dept no :  ' || P_DEPTNO || 
        ' EMPLOYEES ARE : ' || V_TOTAL_SALARY  ||
        ' .DEPT NAME IS : ' || VAR_DEPT_NAME);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No Data Found !');
    END;
END;
/

BEGIN
   PKG_TOTAL_SALARY.FETCH_DETAILS(20);
END;
/



-- 2.Write a package that declares two cursors: 
-- one for fetching employee details (EMPID, EMP_NAME) and  another for fetching department details (DEPTNO, DEPT_NAME). 
-- Create a procedure that displays employee and department information for all employees, showing each employee’s department name.

-- Two cursors in single PROCEDURE

CREATE OR REPLACE PACKAGE PKG_EMP_DEPT_DETAILS IS
PROCEDURE EMP_DEPT_DETAILS;
END;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMP_DEPT_DETAILS IS

    -- Cursor to fetch Employee Details
    CURSOR EMP_DETAILS_CURSOR IS SELECT EMPID,EMP_NAME,SALARY,DEPTNO FROM PACKAGE_EMPLOYEES;
    CURSOR DEPT_DETAILS_CURSOR IS SELECT DEPTNO,DEPT_NAME FROM PACKAGE_DEPT;  -- Cursor to Fetch DEPT Details
    
    -- Variables to hold Employee Table columns
    V_EMP_EMPID         PACKAGE_EMPLOYEES.EMPID%TYPE;
    V_EMP_NAME          PACKAGE_EMPLOYEES.EMP_NAME%TYPE;
    V_EMP_SALARY        PACKAGE_EMPLOYEES.SALARY%TYPE;
    V_EMP_DEPTNO        PACKAGE_EMPLOYEES.DEPTNO%TYPE;
    
    -- Variables to hold DEPT Table Columns
    V_DEPT_DEPTNO       PACKAGE_DEPT.DEPTNO%TYPE;
    V_DEPT_DEPTNAME     PACKAGE_DEPT.DEPT_NAME%TYPE;
    
    IS_DEPTNO_MATCH    BOOLEAN := FALSE;  -- To check whether Employee_Table.DEPTNO and DEPT_Table.DEPTNO are matched or not
    
    PROCEDURE EMP_DEPT_DETAILS IS
    BEGIN
        OPEN EMP_DETAILS_CURSOR;
            LOOP
                FETCH EMP_DETAILS_CURSOR INTO V_EMP_EMPID,V_EMP_NAME,V_EMP_SALARY,V_EMP_DEPTNO;
                EXIT WHEN EMP_DETAILS_CURSOR%NOTFOUND;
                
                IS_DEPTNO_MATCH := FALSE; -- Reset Department Match Flag (Saying that Both tables Deptno doesnot match)
                
                -- Opening DEPT cursor inside EMP cursor
                OPEN DEPT_DETAILS_CURSOR;
                LOOP
                    FETCH DEPT_DETAILS_CURSOR INTO V_DEPT_DEPTNO,V_DEPT_DEPTNAME;
                    EXIT WHEN DEPT_DETAILS_CURSOR%NOTFOUND;
                    
                    -- Checking If both Tables DEPTNO are matched or not. 
                    IF V_EMP_DEPTNO=V_DEPT_DEPTNO THEN
                        IS_DEPTNO_MATCH := TRUE;
                        EXIT;
                    END IF;
                END LOOP;
                CLOSE DEPT_DETAILS_CURSOR;
                
                
                IF IS_DEPTNO_MATCH THEN
                DBMS_OUTPUT.PUT_LINE('DETAILS WHOSE DEPT_NAME IS FOUND : ');
                    DBMS_OUTPUT.PUT_LINE('Employee ID is : '|| V_EMP_EMPID ||
                    ' .EMP NAME IS : ' || V_EMP_NAME 
                    || ' .SALARY IS : '|| V_EMP_SALARY || ' .DEPT NO IS:' || V_EMP_DEPTNO || 
                    ' . DEPT NAME IS :' || V_DEPT_DEPTNAME);
                ELSE
                    DBMS_OUTPUT.PUT_LINE('DETAILS WHOSE DEPT_NAME IS NOT FOUND !');
                               DBMS_OUTPUT.PUT_LINE('DETAILS WHOSE DEPT_NAME IS FOUND : ');
                    DBMS_OUTPUT.PUT_LINE('Employee ID is : '|| V_EMP_EMPID ||
                    ' .EMP NAME IS : ' || V_EMP_NAME 
                    || ' .SALARY IS : '|| V_EMP_SALARY || ' .DEPT NO IS:' || V_EMP_DEPTNO || 
                    ' . DEPT NAME IS NOT FOUND ');
                END IF;
            END LOOP;
        CLOSE EMP_DETAILS_CURSOR;
    END EMP_DEPT_DETAILS;
 END PKG_EMP_DEPT_DETAILS;
 /
 
 BEGIN
 PKG_EMP_DEPT_DETAILS.EMP_DEPT_DETAILS;
 END;
 /
 
 

 -- Using Function to Return Employee Info
-- Create a function that accepts an employee ID as a parameter and returns the employee’s name, salary, and department number. 
--Create a procedure that calls this function and displays the employee information.  
SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE PKG_GET_EMP_DETAILS_BY_EMPID IS
    FUNCTION FUNC_GET_EMP_DETAILS(P_EMP_ID IN PACKAGE_EMPLOYEES.EMPID%TYPE) RETURN PACKAGE_EMPLOYEES%ROWTYPE;  -- Returning the whole EMP table data with same datatype present in EMP Table.
    PROCEDURE PROC_GET_EMP_DETAILS(P_EMP_ID IN PACKAGE_EMPLOYEES.EMPID%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY PKG_GET_EMP_DETAILS_BY_EMPID IS 
    V_EMP_NAME            PACKAGE_EMPLOYEES.EMPID%TYPE;
    V_EMP_SALARY          PACKAGE_EMPLOYEES.SALARY%TYPE;
    V_EMP_DEPTNO          PACKAGE_EMPLOYEES.DEPTNO%TYPE;
    
    FUNCTION FUNC_GET_EMP_DETAILS(P_EMP_ID IN PACKAGE_EMPLOYEES.EMPID%TYPE)
    RETURN PACKAGE_EMPLOYEES%ROWTYPE IS
    VAR_EMPLOYEE_DETAILS    PACKAGE_EMPLOYEES%ROWTYPE;
    BEGIN
        SELECT * INTO VAR_EMPLOYEE_DETAILS FROM PACKAGE_EMPLOYEES WHERE EMPID=P_EMP_ID;
        RETURN VAR_EMPLOYEE_DETAILS;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO Data Found for this EMPID : ' || P_EMP_ID);
            RETURN NULL;
    END;
    
    
    PROCEDURE PROC_GET_EMP_DETAILS(P_EMP_ID IN PACKAGE_EMPLOYEES.EMPID%TYPE) IS
    VAR_EMP_DETAILS       PACKAGE_EMPLOYEES%ROWTYPE;
    BEGIN
            VAR_EMP_DETAILS := FUNC_GET_EMP_DETAILS(P_EMP_ID);  -- Invoking (or) Calling teh Fucntion
            IF VAR_EMP_DETAILS.EMPID IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('EMP ID IS : ' || VAR_EMP_DETAILS.EMPID || ' .EMP NAME IS : ' || VAR_EMP_DETAILS.EMP_NAME || 
            ' .SALARY IS : ' || VAR_EMP_DETAILS.SALARY || ' .DEPTNO IS : '|| VAR_EMP_DETAILS.DEPTNO  );
--            ELSE
--            DBMS_OUTPUT.PUT_LINE('No data found for this Emp ID .. ' || P_EMP_ID);
            END IF;
        END;
END;
/

BEGIN
    PKG_GET_EMP_DETAILS_BY_EMPID.PROC_GET_EMP_DETAILS(107);
END;
/


-- Cursor with Parameters
-- Create a cursor that accepts a department number as a parameter and fetches all employees in that department. 
-- Write a procedure that opens the cursor, fetches employee details, and displays them.
CREATE OR REPLACE PACKAGE GET_EMP_DETAILS_BY_DEPTID IS
    PROCEDURE EMP_DETAILS_BY_DEPTID(P_DEPT_NO IN PACKAGE_EMPLOYEES.DEPTNO%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY GET_EMP_DETAILS_BY_DEPTID IS 
      CURSOR CURSOR_EMP_DETAILS(P_DEPT_NO IN PACKAGE_EMPLOYEES.DEPTNO%TYPE) 
      IS SELECT EMPID,EMP_NAME,SALARY,DEPTNO FROM PACKAGE_EMPLOYEES WHERE DEPTNO=P_DEPT_NO;
     
      VAR_EMP_EMPID_5         PACKAGE_EMPLOYEES.EMPID%TYPE;
      VAR_EMP_EMPNAME_5       PACKAGE_EMPLOYEES.EMP_NAME%TYPE;
      VAR_SALARY_5            PACKAGE_EMPLOYEES.SALARY%TYPE;
      VAR_DEPTNO_5            PACKAGE_EMPLOYEES.DEPTNO%TYPE;
      
      PROCEDURE EMP_DETAILS_BY_DEPTID(P_DEPT_NO IN PACKAGE_EMPLOYEES.DEPTNO%TYPE ) IS
      BEGIN
        OPEN CURSOR_EMP_DETAILS(P_DEPT_NO);
        LOOP
            FETCH CURSOR_EMP_DETAILS INTO VAR_EMP_EMPID_5,VAR_EMP_EMPNAME_5,VAR_SALARY_5,VAR_DEPTNO_5;
            EXIT WHEN CURSOR_EMP_DETAILS%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('EMP ID IS : ' || VAR_EMP_EMPID_5 || ' .EMP NAME IS : ' || VAR_EMP_EMPNAME_5
                || ' .SALARY IS : ' || VAR_SALARY_5 || ' .DEPTNO IS : '||VAR_DEPTNO_5);
        END LOOP;
        CLOSE CURSOR_EMP_DETAILS;
      END;
        
END;
/

BEGIN
GET_EMP_DETAILS_BY_DEPTID.EMP_DETAILS_BY_DEPTID(10);
END;
/



--Handling NULL Values
-- Write a function that accepts an employee ID and returns the employee’s salary. If the employee ID does not exist, the function should return NULL.
--Handle the NULL case in a procedure and display an appropriate message.

CREATE OR REPLACE PACKAGE PKG_EMP_SALARY IS
    FUNCTION GET_EMP_SALARY(P_EMPID IN PACKAGE_EMPLOYEES.EMPID%TYPE) RETURN NUMBER;
    PROCEDURE DISPLAY_EMP_SALARY(P_EMPID IN PACKAGE_EMPLOYEES.EMPID%TYPE);
END;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMP_SALARY IS
    -- Function to get salary
    FUNCTION GET_EMP_SALARY(P_EMPID IN PACKAGE_EMPLOYEES.EMPID%TYPE) RETURN NUMBER IS
        V_SALARY PACKAGE_EMPLOYEES.SALARY%TYPE;
    BEGIN
        SELECT SALARY INTO V_SALARY
        FROM PACKAGE_EMPLOYEES
        WHERE EMPID = P_EMPID;
        RETURN V_SALARY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END;

    -- Procedure to display salary
    PROCEDURE DISPLAY_EMP_SALARY(P_EMPID IN PACKAGE_EMPLOYEES.EMPID%TYPE) IS
        V_SALARY NUMBER;
    BEGIN
        -- Call the function to get salary
        V_SALARY := GET_EMP_SALARY(P_EMPID);

        -- Handle NULL case
        IF V_SALARY IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with ID: ' || P_EMPID);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee Salary for ID ' || P_EMPID || ': ' || V_SALARY);
        END IF;
    END;

END PKG_EMP_SALARY;
/

-- Test the procedure
BEGIN
    PKG_EMP_SALARY.DISPLAY_EMP_SALARY(1043431); -- Replace 101 with a valid or invalid EMPID from your data
END;
/
