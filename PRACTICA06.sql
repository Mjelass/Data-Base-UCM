-- -------------------------------------------------------------------------
-- LAB SESSION 6. PL/SQL STORED PROCEDURES AND TRIGGERS 2.
-- -------------------------------------------------------------------------

-- This script contains part of the database definition used by a chain of
-- department stores. It contains tables with the following information:
--  * The stores that compose the chain.
--  * The departments of each store.
--  * The sales offers available in each department of each store.
--  * The purchase of products by customers (DSSale).
-- Inspect the structure of the database to learn how the information is
-- stored.

-- Execute the script on a database session to create the database and
-- write your ansers tho the questions placed at the end of this file.

-- It is very important to check that your code works using several
-- test cases (with valid and non-valid parameters).

-- -------------------------------------------------------------------------
set linesize 300;
SET SERVEROUTPUT ON;
alter session set nls_date_format='DD-MM-YYYY';

DROP TABLE DSSale CASCADE CONSTRAINTS;
DROP TABLE DSSaleOffer CASCADE CONSTRAINTS;
DROP TABLE DSDept CASCADE CONSTRAINTS;
DROP TABLE DSStore CASCADE CONSTRAINTS;

CREATE TABLE DSStore (
  IdStore VARCHAR2(5) PRIMARY KEY,
  Address VARCHAR2(40)
);

CREATE TABLE DSDept (
  IdStore VARCHAR2(5) REFERENCES DSStore,
  IdDept NUMBER(3),
  Descr VARCHAR2(40),
  DateSalesOffers DATE,
  NumSalesOffers NUMBER(6,0),
  PRIMARY KEY (IdStore, IdDept)
);

CREATE TABLE DSSaleOffer (
  IdOffer VARCHAR2(5) PRIMARY KEY,
  IdStore VARCHAR2(5),
  IdDept NUMBER(3),
  startDate DATE,
  endDate DATE,
  Product VARCHAR2(40),
  OfferedItems NUMBER(4) NOT NULL,
  SoldItems NUMBER(4) DEFAULT 0 NOT NULL,
  FOREIGN KEY (IdStore, IdDept) REFERENCES DSDept,
  CHECK (OfferedItems > 0),
  CHECK (OfferedItems >= SoldItems)
);

CREATE TABLE DSSale (
  IdSale VARCHAR2(5) PRIMARY KEY,
  IdOffer VARCHAR2(5) REFERENCES DSSaleOffer,
  SaleDate DATE,
  Customer VARCHAR2(40),
  NumItems NUMBER(4),
  CHECK (NumItems > 0)
);

INSERT INTO DSStore VALUES ('37','Conde de Peñalver, 44');
INSERT INTO DSStore VALUES ('44','Princesa, 25');

INSERT INTO DSDept VALUES ('37',1, 'Stationery',null,0);
INSERT INTO DSDept VALUES ('37',2, 'Computers',null,0);
INSERT INTO DSDept VALUES ('37',3, 'TV and Home Audio',null,0);
INSERT INTO DSDept VALUES ('44',1, 'Computers',null,0);
INSERT INTO DSDept VALUES ('44',2, 'Bookshop',null,0);

INSERT INTO DSSaleOffer VALUES ('o01', '37', 1, TO_CHAR('01-02-2020'), TO_CHAR('01-02-2020'), 'SuperDestroyer 60', 50, 0);
INSERT INTO DSSaleOffer VALUES ('o02', '37', 2, TO_CHAR('15-03-2020'), TO_CHAR('15-04-2020'), 'Victor Computer i7 16Gb 1Tb HD', 15, 0);
INSERT INTO DSSaleOffer VALUES ('o03', '37', 2, TO_CHAR('15-03-2020'), TO_CHAR('15-04-2020'), 'Monitor 27in 4K', 15, 0);
INSERT INTO DSSaleOffer VALUES ('o04', '37', 3, TO_CHAR('01-02-2020'), TO_CHAR('15-05-2020'), 'Soundbar Speaker Megatron', 20, 0);
INSERT INTO DSSaleOffer VALUES ('o05', '44', 1, TO_CHAR('01-02-2020'), TO_CHAR('15-04-2020'), 'Compaq Computer i5 8Gb 1Tb HD', 84, 0);
INSERT INTO DSSaleOffer VALUES ('o06', '44', 1, TO_CHAR('01-02-2020'), TO_CHAR('15-02-2020'), 'Saikushi Printer 3000', 20, 0);
INSERT INTO DSSaleOffer VALUES ('o07', '44', 2, TO_CHAR('01-02-2020'), TO_CHAR('15-02-2020'), 'Tetralogy The Ring', 25, 0);

commit;

/* 1.  Write a stored procedure StoreOffers that, given a store id and
a date received as parameters, display on the console the address of
the store and the sales offers available in its departments on that
date. It must display the departments of the store and, for each
department, it must display a list with the sales offers for that
department: idOffer, product description, offer end date, and the
number of items available. If there are no offers for a given
department, the procedure must display 'No sales offers in this
department'. If there is no store with that id, the procedure must
show an error message.
The procedure must also update the columns DateSalesOffers and
NumSalesOffers (table _DSDept_) with the date received as a parameter
and the total number of offers for that department, respectively.
For example, if the procedure is invoked for the sales offers on 1st
April 2020 in Store 37, the result should be as follows:
-----------------------------------------------------------------------
SALES OFFERS ON 01-04-2020 IN STORE 37 -- Conde de Peñalver, 44
-----------------------------------------------------------------------
Department:    1 -- Stationery
  No sales offers in this department.
Department:    2 -- Computers
  o03    Monitor 27in 4K                      15-04-2020    15 items
  o02    Victor Computer i7 16Gb 1Tb HD       15-04-2020    15 items
Department:    3 -- TV and Home Audio
  o04    Soundbar Speaker Megatron            15-05-2020    20 items
*/

CREATE OR REPLACE PROCEDURE StoreOffers(STORE_ID VARCHAR2, DATE_RECEIVED DATE) IS

V_ADDRESS DSSTORE.ADDRESS%TYPE;

CURSOR CR_DEPT IS
    SELECT IDDEPT, DESCR FROM DSDEPT WHERE IDSTORE = STORE_ID;
    
V_DEPT_ID DSSALEOFFER.IDDEPT%TYPE;

CURSOR CR_OFFER IS
    select idOffer, product, endDate, offereditems
    from dssaleoffer
    where idstore = STORE_ID and iddept = V_DEPT_ID AND ENDDATE > DATE_RECEIVED;

V_NUM NUMBER;

BEGIN
    SELECT ADDRESS
    INTO V_ADDRESS
    FROM DSSTORE
    WHERE IDSTORE =  STORE_ID;
    
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('SALES OFFERS ON '||TO_CHAR(DATE_RECEIVED)||' IN STORE '||STORE_ID||' -- '||V_ADDRESS);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
    
    FOR R_DEPT IN CR_DEPT LOOP
        V_DEPT_ID := R_DEPT.IDDEPT;
        DBMS_OUTPUT.PUT_LINE('Department:    '||V_DEPT_ID||' -- '||R_DEPT.DESCR);
        
        V_NUM := 0;
        
        FOR R_OFFER IN CR_OFFER LOOP
            V_NUM := V_NUM + 1;
            DBMS_OUTPUT.PUT_LINE('  '||TO_CHAR(R_OFFER.idOffer)||'    '||RPAD(R_OFFER.product,25)||'                      '||R_OFFER.endDate||'    '||R_OFFER.offereditems||' items');
            
            UPDATE DSDEPT SET DATESALESOFFERS = DATE_RECEIVED WHERE IDSTORE = STORE_ID AND IDDEPT = V_DEPT_ID;
            UPDATE DSDEPT SET NUMSALESOFFERS = R_OFFER.offereditems WHERE IDSTORE = STORE_ID AND IDDEPT = V_DEPT_ID;
            
        END LOOP;
        
        IF V_NUM = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No sales offers in this department');
        END IF;
        
    END LOOP;
    
END;
/

BEGIN
    StoreOffers('37','01-04-2020');
END;
/

SELECT * FROM DSDEPT;

/* 2. Write a trigger UpdateSoldItems that fires on _any_ change of
table DSSales (any operation: insert, update or delete). It must
update the value of the column SoldItems. It must be able to work
correctly for any change to any column of DSSales, including
IdOffer (for example, if an UPDATE sentence changes the offer of a
sale).
Besides, if the date of the sale is earlier than the current date, the
trigger must automatically change it to the current date.  Include in
your answer some sentences to test the trigger for all types of
modification sentences.  */





/* 3. Consider the following Oracle script that is executed on a fresh session:
SAVEPOINT Pzero;
ROLLBACK TO SAVEPOINT Pzero;
CREATE TABLE Tab1(key1 INT PRIMARY KEY, total INT DEFAULT 0);
SAVEPOINT Pone;
INSERT INTO Tab1 VALUES (1, 100);
CREATE TABLE TabX(keyX INT PRIMARY KEY, totalX INT DEFAULT 0);
SAVEPOINT Ptwo;
INSERT INTO Tab1 VALUES (2, 200);
ROLLBACK TO SAVEPOINT Pone;
UPDATE Tab1 SET total = total + 2000 where key1 = 2; 
ROLLBACK;
Select * from Tab1;
COMMIT;  
INSERT INTO Tab1 VALUES (3, 300);
COMMIT;  
INSERT INTO TabX VALUES (4, 400);
DELETE FROM  Tab1 WHERE key1 = 3;
a) Identify the transaction control sentences thar are unnecessary and
the ones that issue an error message, explaining why.
b) What are the tables and their contents that remain at the end of
the script?
c) How many transactions have been executed? Write the starting and
ending line numbers of each transaction.
*/






/* 4. (Bonus question) Create the following table:
CREATE TABLE testTable (code INTEGER PRIMARY KEY, descr VARCHAR2(30));
Supposing that testTable is initially empty, write a sequence of DML
sentences operating on testTable that must be executed in two separate
sessions A and B so that session B ends up waiting for session A to
finish its transaction. State clearly the order of the sentences and
the session on which they execute. */