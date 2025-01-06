-- LOOPS

-- WHILE Loop 
-- FOR Loop
-- Loop with Exit / Simple Loop


-- IN "Loop with Exit" (or) "Simple Loop" condition 'we have to write EXIT Condition at end .'
-- SIMPLE LOOP EXAMPLE  {WITH NUMBERS}
SET SERVEROUTPUT ON;
DECLARE
START_VALUE NUMBER :=1;
END_VALUE NUMBER :=5;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE('NUMBER INSIDE LOOP IS : ' || START_VALUE);
    START_VALUE := START_VALUE +1;
    EXIT WHEN START_VALUE >=  END_VALUE;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('NUMBER AFTER EXITING LOOP IS : ' || START_VALUE);
END;
/


-- SIMPLE LOOP EXAMPLE (WITH ALPHABETICAL NUMBER)
DECLARE
VAR_NAME VARCHAR2(40) := 'GANESH';
VAR_TOTAL_LENGTH NUMBER ;  -- Assigning total Length of word to this
VAR_ITERATOR NUMBER :=0;   
VAR_CHAR VARCHAR2(1);  
BEGIN
    VAR_TOTAL_LENGTH := LENGTH(VAR_NAME);  -- Assigning "VAR_NAME" Length using LENGTH() Function.
    LOOP
    VAR_ITERATOR := VAR_ITERATOR + 1;  -- Increment
    VAR_CHAR := SUBSTR(VAR_NAME,VAR_ITERATOR,1);  -- Accesing single value using "SUBSTR()" Function.
    -- SUBSTR(String, Position, Length)
        DBMS_OUTPUT.PUT_LINE('VAR Iterator is : ' || VAR_ITERATOR || ' === ' || 'Letter is : ' || VAR_CHAR);
    EXIT WHEN VAR_ITERATOR >= VAR_TOTAL_LENGTH;
    END LOOP;
END;
/


-- WHILE Loop Condition:
-- Getting Month Names dynamically using "WHILE Loop" and "SYSDATE()".
DECLARE
VAR_ITERATOR NUMBER :=1;
VAR_CURRENT_MONTH NUMBER;
VAR_MONTH_NAME VARCHAR2(30);
BEGIN
    -- Getting the current Month in Number like "12 for December"
    VAR_CURRENT_MONTH := TO_NUMBER(TO_CHAR(SYSDATE,'MM'));
    WHILE (VAR_ITERATOR <= VAR_CURRENT_MONTH)  -- Condition
    LOOP   -- Loop Starts
        -- Getting the Month Name
        VAR_MONTH_NAME := TO_CHAR(TO_DATE(VAR_ITERATOR,'MM'),'MONTH');
        DBMS_OUTPUT.PUT_LINE('This ' || VAR_ITERATOR ||  '  : Month is  :  = ' || VAR_MONTH_NAME);
        VAR_ITERATOR := VAR_ITERATOR +1;
    END LOOP;
END;
/


-- FOR Loop Condition
-- Getting Month Names dynamically using "FOR Loop" and "SYSDATE()".
-- No need to initialize "Iterator Variable Name" and "Increment" Condition in this "FOR Loop"
DECLARE
 VAR_CURRENT_MONTH NUMBER;
 VAR_MONTH_NAME VARCHAR2(30);
BEGIN
    VAR_CURRENT_MONTH := TO_NUMBER(TO_CHAR(SYSDATE,'MM'));
    DBMS_OUTPUT.PUT_LINE('Printing ALL Values :: ');
    FOR VAR_ITERATOR IN 1..VAR_CURRENT_MONTH
    LOOP
    VAR_MONTH_NAME := TO_CHAR(TO_DATE(VAR_ITERATOR,'MM'),'MONTH');
    --  DBMS_OUTPUT.PUT_LINE('This Month : ' || VAR_ITERATOR || ' IS :' || VAR_MONTH_NAME);


     IF mod(VAR_ITERATOR,2)=0 THEN
        DBMS_OUTPUT.PUT_LINE('Printing Even Months  :: ' || VAR_MONTH_NAME);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Printing ODD Months :: ' || VAR_MONTH_NAME);
        END IF;

END LOOP;
END;
/
