-- PRAGMA AUTONOMOUS TRANSACTION

-- PRAGMA AUTONOMOUS_TRANSACTION is a directive in Oracle PL/SQL that allows a block of code (such as a procedure, function, or anonymous block) to execute as an independent transaction. 
-- This means that the operations in the autonomous transaction are committed or rolled back independently of the main transaction from which it is called.

CREATE TABLE PRAGMA_EMPLOYEES
(EMPID NUMBER PRIMARY KEY,
EMPNAME VARCHAR2(100),
EMP_JOB VARCHAR2(100),
SALARY NUMBER
);


CREATE TABLE PRAGMA_ERROR_LOG
(LOG_ID NUMBER PRIMARY KEY,
ERROR_MESSAGE VARCHAR2(100)
);

INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (1, 'John Doe', 'Manager', 75000);
INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (2, 'Jane Smith', 'Developer', 65000);
INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (3, 'Sam Wilson', 'Analyst', 55000);
INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (4, 'Sally Brown', 'HR Specialist', 60000);
INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (5, 'Tom White', 'Support Engineer', 48000);


INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (101,'First Error !');
INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (102,'Second Error !');


-- without Using PRAGMA AUTONOMOUS TRANSACTION

CREATE OR REPLACE PROCEDURE WITHOUT_PRAGMA_PROC_ERROR IS
BEGIN

    -- This will insert an error log entry
    INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (201,'First procedure Error !');
    
      -- Simulate an error (to show rollback effect)
      -- In Oracle, when a RAISE_APPLICATION_ERROR is encountered, it rolls back the entire transaction.
    RAISE_APPLICATION_ERROR(-20001, 'Simulating an error in PROC_ERROR');
    
     -- This will not execute if the above error is raised
    INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (202,'Second procedure  Error !');
END;
/


CREATE OR REPLACE PROCEDURE WITHOUT_PRAGMA_PROC_EMPLOYEES IS
BEGIN
    INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (301, 'Lucy Green', 'Marketing Manager', 70000);
    INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (302, 'David King', 'Product Owner', 80000);
    INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) VALUES (303, 'Emily Clark', 'Software Engineer', 75000);
    WITHOUT_PRAGMA_PROC_ERROR;  -- Calling the "WITHOUT_PRAGMA_PROC_ERROR" Procedure.
END;
/

BEGIN
WITHOUT_PRAGMA_PROC_EMPLOYEES;
END;
/

-- Explanation: WHEN the "RAISE_APPLICATION_ERROR " Occured means, then the whole transaction (like parent transaction and child transaction) both will be roll backed, and it does not commited, so the data is not inserted into those tables



SELECT * FROM PRAGMA_EMPLOYEES;
SELECT * FROM PRAGMA_ERROR_LOG;
-- USING PRAGMA AUTONMOUS TRANSACTION

CREATE OR REPLACE PROCEDURE WITH_PRAGMA_ERROR_LOG IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (501,'WITH PRAGMA, FIRST procedure Error !');
    INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (502,'WITH PRAGMA, SECOND procedure Error !');
    
    COMMIT;
    -- Simulate an error (to show that only error logs will be committed)
    RAISE_APPLICATION_ERROR(-20001, 'Simulating an error in PROC_ERROR');
    INSERT INTO PRAGMA_ERROR_LOG (LOG_ID,ERROR_MESSAGE) VALUES (503,'WITH PRAGMA, THIRD procedure Error !');
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE WITH_PRAGMA_PROC_EMPLOYEES IS
BEGIN
INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) 
VALUES (501, 'Alex Turner', 'Software Engineer', 72000);

INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) 
VALUES (502, 'Jessica Adams', 'Product Manager', 80000);

INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) 
VALUES (503, 'Michael Brown', 'Business Analyst', 67000);

INSERT INTO PRAGMA_EMPLOYEES (EMPID, EMPNAME, EMP_JOB, SALARY) 
VALUES (504, 'Sarah Mitchell', 'HR Specialist', 60000);

WITH_PRAGMA_ERROR_LOG;  -- calling procedure "WITH_PRAGMA_ERROR_LOG"
    -- This line will execute even if an error occurs in PROC_ERROR
    
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An Unexpected Error Occured ! : ' || SQLERRM);
END;
/

begin 
WITH_PRAGMA_PROC_EMPLOYEES;
end;
/

ROLLBACK;
-- Here in this Example, If we execute "ROLLBACK" Command also, the Data is stored permanently in "ERROR_LOG_TABLE" bcoz it is commited independently before, but data is ROLLBACKED to "PRAGMA_EMPLOYEES" table .