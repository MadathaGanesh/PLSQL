-- Intermediate Triggers - Q4.

-- Username Tracking Trigger
-- Write a trigger that stores the USER who performed the operation (insert, update, delete) into a column named USER_NAME in the STORE_USER_NAME table.

-- Create the table
CREATE TABLE TABLE_STORE_USER_NAME (
    EMP_ID NUMBER PRIMARY KEY,
    NAME VARCHAR2(100) NOT NULL,
    SALARY NUMBER,
    DESIGNATION VARCHAR2(100),
    USER_NAME VARCHAR2(100)
);

-- Create the trigger
CREATE OR REPLACE TRIGGER TRG_STORE_USER_NAME 
AFTER INSERT OR UPDATE OR DELETE ON TABLE_STORE_USER_NAME
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE TABLE_STORE_USER_NAME 
        SET USER_NAME = SYS_CONTEXT('USERENV', 'SESSION_USER') 
        WHERE EMP_ID = :NEW.EMP_ID;
        DBMS_OUTPUT.PUT_LINE('INSERT operation performed by: ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));
    ELSIF DELETING THEN
        UPDATE TABLE_STORE_USER_NAME 
        SET USER_NAME = SYS_CONTEXT('USERENV', 'SESSION_USER') 
        WHERE EMP_ID = :OLD.EMP_ID;
        DBMS_OUTPUT.PUT_LINE('DELETE operation performed by: ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));
    ELSIF UPDATING THEN
        UPDATE TABLE_STORE_USER_NAME 
        SET USER_NAME = SYS_CONTEXT('USERENV', 'SESSION_USER') 
        WHERE EMP_ID = :NEW.EMP_ID;
        DBMS_OUTPUT.PUT_LINE('UPDATE operation performed by: ' || SYS_CONTEXT('USERENV', 'SESSION_USER'));
    END IF;
END;
/

-- Test case 1: Insert a new record
INSERT INTO TABLE_STORE_USER_NAME (EMP_ID, NAME, SALARY, DESIGNATION)
VALUES (101, 'John Doe', 50000, 'Manager');
-- Expect the USER_NAME field to be updated with the current session user.

-- Test case 2: Update an existing record
UPDATE TABLE_STORE_USER_NAME
SET DESIGNATION = 'Senior Team Lead'
WHERE EMP_ID = 101;
-- Expect the USER_NAME field for EMP_ID 101 to be updated with the current session user.

-- Test case 3: Delete a record
DELETE FROM TABLE_STORE_USER_NAME
WHERE EMP_ID = 101;
-- Expect the USER_NAME field for the deleted record to be updated with the current session user.

-- Check the data after operations
SELECT * FROM TABLE_STORE_USER_NAME;
