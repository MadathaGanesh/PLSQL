SHOW USER;   -- Answer is : "SYSTEM" 

SELECT * FROM TAB;  -- To see all tables which are there

DESC EMPLOYEES;

SELECT * FROM EMPLOYEES;

-- Storing Single ROW data from Table to PLSQL Variables.
-- Retrieving only single ROW Data at a time
SET SERVEROUTPUT ON;
DECLARE
V_EMPID  NUMBER;
V_EMP_NAME  VARCHAR2(100);
V_SALARY NUMBER(10);
V_ADDRESS  VARCHAR2(255);
V_MOBILE NUMBER(10);
BEGIN
    SELECT EMPID,EMP_NAME,SALARY,ADDRESS,MOBILE INTO
    V_EMPID,V_EMP_NAME,V_SALARY,V_ADDRESS,V_MOBILE FROM EMPLOYEES WHERE EMPID=101;  
    
    DBMS_OUTPUT.PUT_LINE('EMP ID IS :' || V_EMPID  || CHR(10) || 
    'Emp Name is :: ' || V_EMP_NAME || CHR(10) || 'MOBILE NUMER IS: ' || V_MOBILE);
END;
/


-- CONDITIONAL STATEMENTS
-- IF STATEMENTS
-- IF-ELSE STATEMENTS
-- IF-ELSIF-ELSE STATEMENTS
-- CASE STATEMENT (Searched CASE)  ::: Conditions
-- CASE STATEMENT (Simple CASE) ::: Values
-- Nested Conditional Statements.

-- ONLY IF STATEMENTS
SET SERVEROUTPUT ON;
DECLARE
EMP_SALARY NUMBER := 5000;
BEGIN
    IF EMP_SALARY >3000 THEN
    DBMS_OUTPUT.PUT_LINE('SALARY IS GREATER THAN 3000');
    END IF;
END;
/


-- IF-ELSE Statements
SET SERVEROUTPUT ON;
DECLARE 
V_SALARY NUMBER := 3400;
BEGIN
    IF V_SALARY >3000 THEN
        DBMS_OUTPUT.PUT_LINE('SALARY IS GREATER THAN 3000');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SALARY IS LESS THAN 3000');
    END IF;
END;
/


-- IF-ELSIF-ELSE
SET SERVEROUTPUT ON;
DECLARE 
MARKS NUMBER := 35;
BEGIN
    IF MARKS >=80 THEN
        DBMS_OUTPUT.PUT_LINE('GRADE IS :: A');
    ELSIF MARKS >=60 AND MARKS <80 THEN
        DBMS_OUTPUT.PUT_LINE('GRADE IS :: B');
    ELSIF MARKS >=50 AND MARKS <60 THEN 
        DBMS_OUTPUT.PUT_LINE('GRADE IS :: C');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('GRADE IS :: F');
    END IF; 
END;
/


-- CASE STATEMENT (SEARCHED CASE ) -- BASED ON CONDITIONS
DECLARE 
MARKS NUMBER := 60;
BEGIN
    CASE 
        WHEN MARKS >=80 THEN
            DBMS_OUTPUT.PUT_LINE('GRADE IS : A');
        WHEN MARKS >=60 AND MARKS <80 THEN
            DBMS_OUTPUT.PUT_LINE('GRADE IS : B');
        WHEN MARKS >=50 AND MARKS <60 THEN
            DBMS_OUTPUT.PUT_LINE('GRADE IS : C');
        ELSE
            DBMS_OUTPUT.PUT_LINE('GRADE IS : F');
    END CASE;
END;
/


-- CASE STATEMENT (Simple CASE) ::: Values
-- Here values like "Grade =A" and "Grade = a" are CASE-SENSITIVE (Different Values)
DECLARE
GRADE VARCHAR2(1) := 'C';   -- Capital "C"
-- GRADE VARCHAR2(1) := 'c';  -- Small Letter "c"
BEGIN
    CASE GRADE
        WHEN 'A' THEN 
            DBMS_OUTPUT.PUT_LINE('GRADE IS : A ');
        WHEN 'B' THEN 
            DBMS_OUTPUT.PUT_LINE('GRADE IS : B');
        WHEN 'C' THEN 
            DBMS_OUTPUT.PUT_LINE('GRADE IS : C ');
        ELSE
            DBMS_OUTPUT.PUT_LINE('GRADE IS : F');
    END CASE;
END;
/



-- NESTED Conditional Statements.
DECLARE 
SALARY NUMBER := 3000;
BEGIN
    IF SALARY >3000 THEN
        IF SALARY >5000 THEN
            DBMS_OUTPUT.PUT_LINE('SALARY IS GREATER THAN 5000');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('SALARY IS GREATER THAN 3000');
         END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('SALARY IS LESS THAN 3000');
        
    END IF;
END;
/


-- Getting Discount according to price.
-- " IF - ELSIF " Conditions
SET SERVEROUTPUT ON;
DECLARE 
V_AMOUNT NUMBER := 6000;
V_DISCOUNT NUMBER;
V_FINAL_AMOUNT NUMBER;
BEGIN
    IF (V_AMOUNT <= 1000) THEN
        V_DISCOUNT :=10;
    ELSIF (V_AMOUNT > 1000 AND V_AMOUNT <=2000) THEN
        V_DISCOUNT := 20;
    ELSIF (V_AMOUNT > 2000 AND V_AMOUNT <= 3000) THEN
        V_DISCOUNT :=30;
    ELSIF (V_AMOUNT > 3000) THEN
        V_DISCOUNT :=40;
    END IF;
    
V_FINAL_AMOUNT := V_AMOUNT - V_DISCOUNT * V_AMOUNT / 100;
DBMS_OUTPUT.PUT_LINE('Final Discount is : ' || V_DISCOUNT);
DBMS_OUTPUT.PUT_LINE('Final Amount is : ' || V_FINAL_AMOUNT);
END;
/



-- NUMBER Datatype with precision value / Floating value (using dot(.))
DECLARE
FLOAT_VALUE NUMBER (5,2) := 324.23;
-- (5,2) means In those "3" values should be there before decimal(.) point and "2" values should be there after decimal(.) point
-- If we exceed the above values afer decimal(.) point means , thern it will truncate the values upto "2" digits in this condition.
-- Ex: "234.344454545533" becomes "234.34"
-- Ex: "2352.54" This number gives error bcoz the values before decimal point is more than "3" digits
BEGIN
    DBMS_OUTPUT.PUT_LINE('Floating Value is : ' || FLOAT_VALUE);
END;
/