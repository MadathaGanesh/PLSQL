-- ADVANCED PROCEDURES 

--Generate employee performance bonuses
--Calculate and update performance bonuses for all employees based on specific criteria (e.g., sales, targets).
--
--Retrieve department-wise salary expenses
--Calculate and return total salary expenses for each department.
--
--Automate salary revisions
--Update salaries for all employees in a specific grade or department based on percentage increments.
--
--Validate employee data
--Check for invalid or missing data in critical columns and generate a report.
-- we need to check whether all Mandatory columns has data or not .
-- If data is not there then it returns " invalid or missing data "
-- else "contains valid data"



--Bulk import employee data
--Import multiple employee records from a staging table, with validations.
-- Ex: create a staging Table, insert data into that staging table with same columns and by following constraints.
-- Then insert that staging table data into "Main Employee table" using "Insert and Select statement."


--Generate an organizational hierarchy
--Create a procedure to build and display a hierarchy/tree structure of employees and their managers.


CREATE TABLE ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID NUMBER PRIMARY KEY, -- Unique employee ID
    EMP_NAME VARCHAR2(100) NOT NULL, -- Employee name
    SALARY NUMBER(10, 2), -- Monthly salary
    BONUS NUMBER(10, 2), -- Performance bonus
    DEPTNO NUMBER NOT NULL, -- Department number
    JOB_TITLE VARCHAR2(50), -- Job title
    MANAGER_ID NUMBER, -- Manager ID (self-referential for hierarchy)
    SALES NUMBER(10, 2), -- Sales made by the employee
    GRADE VARCHAR2(10), -- Employee grade
    MOBILE_NUMBER VARCHAR2(15), -- Mobile number
    EMAIL VARCHAR2(100), -- Email ID
    ADDRESS VARCHAR2(200), -- Employee address
    JOIN_DATE DATE DEFAULT SYSDATE, -- Date of joining
    LAST_UPDATED_DATE DATE DEFAULT SYSDATE, -- Last updated date
    UPDATED_BY VARCHAR2(50) -- User who last updated the record
);

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(1, 'Alice Johnson', 50000, NULL, 10, 'Developer', 5, 120000, 'A', '9876543210', 'alice.johnson@example.com', '123 Main St', SYSDATE - 365, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(2, 'Bob Smith', 60000, NULL, 20, 'Analyst', 6, 80000, 'B', '9876543211', 'bob.smith@example.com', '456 Oak St', SYSDATE - 200, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(3, 'Charlie Brown', 45000, NULL, 30, 'Designer', NULL, 45000, 'C', '9876543212', 'charlie.brown@example.com', '789 Pine St', SYSDATE - 150, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(4, 'Diana Prince', 70000, NULL, 10, 'Manager', NULL, 100000, 'A', '9876543213', 'diana.prince@example.com', '987 Elm St', SYSDATE - 500, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(5, 'Ethan Hunt', 55000, NULL, 10, 'Lead Developer', 4, 110000, 'B', '9876543214', 'ethan.hunt@example.com', '321 Willow St', SYSDATE - 300, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(6, 'Fiona Gallagher', 40000, NULL, 20, 'Junior Analyst', 2, 60000, 'C', '9876543215', 'fiona.g@example.com', '654 Maple St', SYSDATE - 120, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(7, 'George Miller', 38000, NULL, 30, 'Intern', 3, 20000, 'D', '9876543216', 'george.miller@example.com', '111 Birch St', SYSDATE - 60, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(8, 'Hannah Lee', 72000, NULL, 20, 'Senior Analyst', NULL, 140000, 'A', '9876543217', 'hannah.lee@example.com', '222 Cedar St', SYSDATE - 250, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(9, 'Ian Clarke', 48000, NULL, 10, 'Support Engineer', 5, 50000, 'B', '9876543218', 'ian.clarke@example.com', '333 Aspen St', SYSDATE - 180, SYSDATE, 'Admin');

INSERT INTO ADVANCED_PROCEDURE_EMPLOYEES (
    EMPID, EMP_NAME, SALARY, BONUS, DEPTNO, JOB_TITLE, MANAGER_ID, SALES, GRADE, 
    MOBILE_NUMBER, EMAIL, ADDRESS, JOIN_DATE, LAST_UPDATED_DATE, UPDATED_BY
) VALUES
(10, 'Jessica Parker', 62000, 1000, 30, 'Project Manager', NULL, 90000, 'B', '9876543219', 'jessica.parker@example.com', '444 Poplar St', SYSDATE - 220, SYSDATE, 'Admin');



SELECT * FROM ADVANCED_PROCEDURE_EMPLOYEES;
DESC ADVANCED_PROCEDURE_EMPLOYEES;



--Generate employee performance bonuses :
--Calculate and update performance bonuses for all employees based on specific criteria (e.g., sales, targets).
--The DML statement executes first and modifies the data in the table.
---The cursor fetches data after the DML statement has modified the data.


SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE UPDATE_EMPLOYEE_BONUS IS  
---The cursor fetches data after the DML statement has modified the data.
    CURSOR EMPLOYEE_UPDATED_DATA IS 
    SELECT EMPID,EMP_NAME,SALARY,BONUS,SALES FROM ADVANCED_PROCEDURE_EMPLOYEES;
BEGIN  

--The DML statement executes first and modifies the data in the table.
    UPDATE advanced_procedure_employees 
    SET BONUS = CASE 
        WHEN SALES >= 100000 THEN SALARY *0.20
        WHEN SALES >=50000 THEN SALARY * 0.10
        WHEN SALES < 50000 THEN SALARY * 0.050
    END;

    -- Output / Displaying the employees Updated Data
    FOR EMP_DATA_DISPLAY IN EMPLOYEE_UPDATED_DATA
    LOOP
    DBMS_OUTPUT.PUT_LINE('EMP ID IS : ' || EMP_DATA_DISPLAY.EMPID ||
    ' .EMP NAME IS : ' || EMP_DATA_DISPLAY.EMP_NAME ||
    ' .SALES IS : ' || EMP_DATA_DISPLAY.SALES ||
    ' .SALARY IS : ' || EMP_DATA_DISPLAY.SALARY ||
    ' .BONUS IS : ' ||EMP_DATA_DISPLAY.BONUS );
    END LOOP;
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An Error Ocurred ! ' || SQLERRM);
 END;
 /
exec UPDATE_EMPLOYEE_BONUS;


--Retrieve department-wise salary expenses
--Calculate and return total salary expenses for each department.
CREATE OR REPLACE PROCEDURE AUTO_INCREMENT_SAL_ON_GRADE (
    P_GRADE             IN VARCHAR2,
    P_INCREMENT_PERCENT IN NUMBER
) IS
BEGIN
    -- Update salaries based on the grade and increment percentage
    UPDATE advanced_procedure_employees
    SET SALARY = SALARY + (SALARY * P_INCREMENT_PERCENT / 100)
    WHERE GRADE = P_GRADE;

    -- Output updated data for the specific grade
    FOR EMP_CUR IN (
        SELECT EMPID, EMP_NAME, GRADE, SALARY, DEPTNO
        FROM advanced_procedure_employees
        WHERE GRADE = P_GRADE
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'EMP ID IS : ' || EMP_CUR.EMPID   || 
            ' .EMP NAME IS : ' || EMP_CUR.EMP_NAME   ||
            ' .GRADE IS : ' || EMP_CUR.GRADE   ||
            ' .UPDATED SALARY IS : ' || EMP_CUR.SALARY   ||
            ' .DEPT NO IS : ' || EMP_CUR.DEPTNO
        );
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

BEGIN
    -- Call the procedure to increment salaries for grade 'A' by 2%
    AUTO_INCREMENT_SAL_ON_GRADE('A', 2);
END;
/





--Bulk import employee data
--Import multiple employee records from a staging table, with validations.
-- Below is Example Code , Not Exact Code :
-- we have to create a staging table, insert data from staging table to main table.
CREATE OR REPLACE PROCEDURE BULK_IMPORT_EMPLOYEES IS
BEGIN
    INSERT INTO EMPLOYEES (EMPID, EMP_NAME, SALARY, DEPTNO, JOB_TITLE)
    SELECT EMPID, EMP_NAME, SALARY, DEPTNO, JOB_TITLE
    FROM EMPLOYEES_STAGING
    WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEES WHERE EMPLOYEES.EMPID = EMPLOYEES_STAGING.EMPID);

    DBMS_OUTPUT.PUT_LINE('BULK EMPLOYEE IMPORT COMPLETED.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('AN ERROR OCCURRED: ' || SQLERRM);
END;
/

-- Example Execution:
BEGIN
    BULK_IMPORT_EMPLOYEES;
END;
/
