-- Basic Trigger Questions

--Insert Audit Trigger
-- Write a trigger that logs every new employee inserted into the EMPLOYEE table 
--into a separate audit table called EMPLOYEE_AUDIT (columns: EMP_ID, NAME, ACTION_DATE, ACTION).

-- This is the primary table where all operations (INSERT, UPDATE, DELETE) will occur.
CREATE TABLE EMPLOYEE_TRIGGER (
    EMP_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100),
    DESIGNATION VARCHAR2(50),
    SALARY NUMBER(10, 2),
    BONUS NUMBER(10, 2),
    HIRE_DATE DATE,
    TOTAL_COMPENSATION NUMBER(10, 2),
    LAST_MODIFIED_BY VARCHAR2(50)
);


--Used to log every new employee inserted into the EMPLOYEE table.
CREATE TABLE EMPLOYEE_AUDIT_TRIGGER (
    AUDIT_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    EMP_ID NUMBER,
    NAME VARCHAR2(100),
    ACTION_DATE DATE,
    ACTION VARCHAR2(50)
);


-- Inserting Salary < 1000 data into this LESS_SALARY TABLE
CREATE TABLE LESS_SALARY_THAN_10K (
EMPID NUMBER PRIMARY KEY,
NAME VARCHAR2(1000),
SALARY NUMBER);



SET SERVEROUTPUT ON;
-- Create Trigger to Log Insert Operations
CREATE OR REPLACE TRIGGER NEW_INSERTED_EMP_DATA 
BEFORE INSERT ON EMPLOYEE_TRIGGER
FOR EACH ROW
BEGIN
    -- Dynamically calculate TOTAL_COMPENSATION
    :NEW.TOTAL_COMPENSATION := :NEW.SALARY + :NEW.BONUS;
    
    -- Log a message to the output
    DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE WITH EMPID ' || :NEW.EMP_ID || ' IS INSERTED!');
    
    -- Insert the audit record into EMPLOYEE_AUDIT_TRIGGER
    INSERT INTO EMPLOYEE_AUDIT_TRIGGER (EMP_ID, NAME, ACTION_DATE, ACTION)
    VALUES (:NEW.EMP_ID, :NEW.NAME, SYSDATE, 'Insert');
END;
/

INSERT INTO EMPLOYEE_TRIGGER(EMP_ID,NAME,DESIGNATION,SALARY,BONUS,HIRE_DATE,TOTAL_COMPENSATION,LAST_MODIFIED_BY)
VALUES(101,'Ganesh','Oracle Apps Technical',34000,1000,TO_DATE('09-12-2024','DD-MM-YYYY'),NULL,'Ganesh');

INSERT INTO EMPLOYEE_TRIGGER(EMP_ID,NAME,DESIGNATION,SALARY,BONUS,HIRE_DATE,TOTAL_COMPENSATION,LAST_MODIFIED_BY)
VALUES(102,'KANISHK',' MANAGER',57000,0,TO_DATE('09-12-2024','DD-MM-YYYY'),NULL,'Kanishk');

INSERT INTO EMPLOYEE_TRIGGER(EMP_ID,NAME,DESIGNATION,SALARY,BONUS,HIRE_DATE,TOTAL_COMPENSATION,LAST_MODIFIED_BY)
VALUES(103,'Ramesh','MANAGER',76540,NULL,TO_DATE('09-02-2021','DD-MM-YYYY'),NULL,'Ramesh');
-- NOTE : The TOTAL_COMPENSATION column in the INSERT statement is set to NULL because the trigger dynamically calculates and updates it.




--Q2. Before Insert Validation Trigger
--Create a trigger to ensure the SALARY column of the EMPLOYEE_TRIGGER table is not less than 10,000. If the salary is lower, raise an exception.
CREATE OR REPLACE TRIGGER SALARY_CHECK 
BEFORE INSERT ON EMPLOYEE_TRIGGER 
FOR EACH ROW
DECLARE
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    -- Insert into LESS_SALARY_THAN_10K if salary is less than 10,000
    IF :NEW.SALARY < 10000 THEN
        INSERT INTO LESS_SALARY_THAN_10K (EMPID, NAME, SALARY) 
        VALUES (:NEW.EMP_ID, :NEW.NAME, :NEW.SALARY);
        COMMIT;
    END IF;

    -- Raise an exception if salary is less than 10,000
    IF :NEW.SALARY < 10000 THEN
        RAISE_APPLICATION_ERROR(-20003,'Salary must be greater than 10000 /- ');
    ELSE
        :NEW.TOTAL_COMPENSATION := :NEW.SALARY + NVL(:NEW.BONUS, 0);
        DBMS_OUTPUT.PUT_LINE('NEW EMPLOYEE WITH EMPID ' || :NEW.EMP_ID || ' IS INSERTED!');
    END IF;
END;
/

-- Inserting below 2 rows to test correct Logic
INSERT INTO EMPLOYEE_TRIGGER(EMP_ID, NAME, DESIGNATION, SALARY, BONUS, HIRE_DATE, TOTAL_COMPENSATION, LAST_MODIFIED_BY)
VALUES (151, 'Sunny', 'AR Dev', 15000, 100, TO_DATE('09-07-2022','DD-MM-YYYY'), NULL, 'Ramesh');

INSERT INTO EMPLOYEE_TRIGGER(EMP_ID, NAME, DESIGNATION, SALARY, BONUS, HIRE_DATE, TOTAL_COMPENSATION, LAST_MODIFIED_BY)
VALUES (154, 'Rocky', 'web Dev', 18400, 500, TO_DATE('09-10-2019','DD-MM-YYYY'), NULL, 'Rocky');


-- Insert BELOW 2 rows data with a salary less than 10,000 to test
INSERT INTO EMPLOYEE_TRIGGER(EMP_ID, NAME, DESIGNATION, SALARY, BONUS, HIRE_DATE, TOTAL_COMPENSATION, LAST_MODIFIED_BY)
VALUES (153, 'Nikki', 'HR', 8000, 500, TO_DATE('09-01-2020', 'DD-MM-YYYY'), NULL, 'Nikki');

INSERT INTO EMPLOYEE_TRIGGER(EMP_ID, NAME, DESIGNATION, SALARY, BONUS, HIRE_DATE, TOTAL_COMPENSATION, LAST_MODIFIED_BY)
VALUES (152, 'Bunny', 'VR Dev', 4000, 100, TO_DATE('09-07-2012','DD-MM-YYYY'), NULL, 'Bunny');

SELECT * FROM LESS_SALARY_THAN_10K;
SELECT * FROM EMPLOYEE_TRIGGER;
SELECT * FROM EMPLOYEE_AUDIT_TRIGGER;


-- This Table "UPDATED_SALARY_LOG" is used to store UPDATED salary details
CREATE TABLE UPDATED_SALARY_LOG (
    LOG_ID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    EMP_ID NUMBER,
    OLD_SALARY NUMBER(10, 2),
    NEW_SALARY NUMBER(10, 2),
    UPDATED_DATE DATE
);


-- Q3. After Update Logging Trigger (Inserting Updated Salary data into "SALARY_LOG" Table)
-- Write a trigger to log every update on the SALARY column of the EMPLOYEE table into an audit table SALARY_LOG (columns: EMP_ID, OLD_SALARY, NEW_SALARY, UPDATED_DATE).
CREATE OR REPLACE TRIGGER UPDATED_SALARY 
AFTER UPDATE ON EMPLOYEE_TRIGGER 
FOR EACH ROW
BEGIN
    INSERT INTO UPDATED_SALARY_LOG (EMP_ID,OLD_SALARY,NEW_SALARY,UPDATED_DATE) 
    VALUES (:OLD.EMP_ID,:OLD.SALARY,:NEW.SALARY,SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Salary Updated for EMPID - ' || :OLD.EMP_ID || ' . OLD SALARY IS : '|| :OLD.SALARY || ' .  NEW Salary is : '|| :NEW.SALARY);
END;
/

-- Updating salary for EMPID :103  from zero(0) to 18000
UPDATE EMPLOYEE_TRIGGER SET SALARY=18000 WHERE EMP_ID=103;
UPDATE EMPLOYEE_TRIGGER SET SALARY=90000 WHERE EMP_ID=102;  -- 3000 TO 90000
SELECT * FROM UPDATED_SALARY_LOG;


-- Restrict Delete Trigger
-- Create a trigger to prevent deletion of employees from the EMPLOYEE table if their DESIGNATION is 'Manager'.
CREATE OR REPLACE TRIGGER PREVENT_DELETE_MGR_EMP 
BEFORE DELETE ON EMPLOYEE_TRIGGER 
FOR EACH ROW
BEGIN
    IF :OLD.DESIGNATION='MANAGER' THEN
        RAISE_APPLICATION_ERROR(-20034,'WE CANT DELETE WHOSE DESIGNATION IS MANAGER');
    END IF;
END;
/

DELETE FROM EMPLOYEE_TRIGGER WHERE DESIGNATION='MANAGER';