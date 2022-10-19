drop table books;
drop table loans;
drop table members;

--Ejercicio 01

create table books (
    ISBN VARCHAR2(13) primary key,
    title VARCHAR2(50) UNIQUE,
    author VARCHAR2(50),
    numCopies INTEGER
);



create table members (
    memberId INTEGER primary key NOT NULL,
    memberName VARCHAR2(50) NOT NULL,
    memberEmail VARCHAR2(50) NOT NULL,
    memberNif VARCHAR2(50) UNIQUE NOT NULL
);

create table loans (
    lendingDate DATE ,
    numDaysLoan INTEGER ,
    returnDate DATE,
    ISBN VARCHAR2(13),
    memberId INTEGER,
    check( returnDate <= lendingDate +  numDaysLoan),
    FOREIGN KEY(ISBN) REFERENCES books,
    FOREIGN KEY(memberId) REFERENCES members,
    PRIMARY KEY (ISBN, memberId,lendingDate)
);




--Ejercicio 02

SELECT * FROM books;
SELECT * FROM loans;
SELECT * FROM members;

ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

INSERT INTO books VALUES('0071151109','Database Management Systems', 'A. Silberschatz , H. F. Korth, S. Sudarshan',2);


INSERT INTO books VALUES('9788478290857','Fundamentals of Database Systems', 'R. Elmasri, S.B. Navathe',3);

INSERT INTO members VALUES(1, 'Mehdi', 'mjelassi@ucm.es', 'Y6635732Q');

INSERT INTO members VALUES(2, 'Slouma', 'slouma@ucm.es', '24321291');


INSERT INTO loans VALUES(TO_DATE('25-08-2021'), 10, TO_DATE('30-08-2021'), '0071151109', 1);

INSERT INTO loans VALUES(TO_DATE('27-08-2021'), 10, TO_DATE('30-08-2021'), '9788478290857', 1);



INSERT INTO loans VALUES(TO_DATE('12-09-2021'), 5, NULL, '0071151109', 2);

INSERT INTO loans VALUES(TO_DATE('24-09-2021'), 30, NULL, '9788478290857', 2);


--ejercicio03:

--1)
select MEMBERID, ISBN, LENDINGDATE, NUMDAYSLOAN, RETURNDATE from loans where loans.numdaysloan < 10;

--2)
select MEMBERID, ISBN, loans.lendingdate + loans.numdaysloan "due_date" from loans;

--3)
select memberid, ISBN, loans.lendingdate + loans.numdaysloan "due_date" 
from loans
where loans.lendingdate + loans.numdaysloan < TO_DATE('27-09-2021');

--4)
SELECT MEMBERID, ISBN, LENDINGDATE, NUMDAYSLOAN, RETURNDATE, loans.lendingdate + loans.numdaysloan "due_date"
from loans
where loans.returndate > loans.lendingdate + loans.numdaysloan;

--5)
--falta por hacer

--6)
select ISBN, LENDINGDATE, loans.lendingdate + loans.numdaysloan "due_date", RETURNDATE
from loans
where loans.lendingdate < sysdate
ORDER by loans.lendingdate;

--7)
select ISBN, LENDINGDATE, loans.lendingdate + loans.numdaysloan "due_date", RETURNDATE
from loans
where loans.returndate is not null
Order BY loans.lendingdate + loans.numdaysloan DESC;

--8)
select title 
from books
join loans on books.isbn = loans.isbn
where  to_char(loans.lendingdate, 'Month' ) = 'Septiembre' ;

--9)
select memberName 
from members 
JOIN loans on members.memberid = loans.memberid 
WHERE isbn = '9788478290857';

--10)


-- ejercicio 04

--1)
SELECT * FROM Members;

update members 
set memberemail= 'nuevo@ucm.es'
where memberid = 1;

--2)
select * from loans;

update loans 
set numdaysloan = numdaysloan * 2
where isbn = '9788478290857';

--3) No me funciona 
DELETE   FROM Members;

