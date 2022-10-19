alter session set nls_date_format = 'DD/MM/YYYY';

drop table Client cascade constraints;
drop table Orders cascade constraints;
drop table Author cascade constraints;
drop table Author_Book cascade constraints;
drop table Book cascade constraints;
drop table Books_Order cascade constraints;

create table Client
(IdClient CHAR(10) PRIMARY KEY,
 Name VARCHAR(40) NOT NULL,
 Address VARCHAR(60) NOT NULL,
 NumCC CHAR(16) NOT NULL);
 
create table Orders
(IdOrder CHAR(10) PRIMARY KEY,
 IdClient CHAR(10) NOT NULL REFERENCES Client on delete cascade,
 OrderDate DATE NOT NULL,
 ShippingDate DATE);

create table Author
( idAuthor NUMBER PRIMARY KEY,
  Name VARCHAR(40));

create table Book
(ISBN CHAR(15) PRIMARY KEY,
Title VARCHAR(60) NOT NULL,
Year CHAR(4) NOT NULL,
PurchasePrice NUMBER(6,2) DEFAULT 0, -- Publisher price
SalePrice NUMBER(6,2) DEFAULT 0);    -- Retail price

create table Author_Book
(ISBN CHAR(15),
Author NUMBER,
CONSTRAINT alA_PK PRIMARY KEY (ISBN, Author),
CONSTRAINT BookA_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
CONSTRAINT AuthorA_FK FOREIGN KEY (Author) REFERENCES Author);


create table Books_Order(
ISBN CHAR(15),
IdOrder CHAR(10),
Quantity NUMBER(3) CHECK (Quantity >0),
CONSTRAINT lpB_PK PRIMARY KEY (ISBN, idOrder),
CONSTRAINT BookB_FK FOREIGN KEY (ISBN) REFERENCES Book on delete cascade,
CONSTRAINT pedidoB_FK FOREIGN KEY (IdOrder) REFERENCES Orders on delete cascade);

insert into Client values ('0000001','James Smith', 'Picadilly 2','1234567890123456');
insert into Client values ('0000002','Laura Jones', 'Holland Park 13', '1234567756953456');
insert into Client values ('0000003','Peter Doe', 'High Street 42', '1237596390123456');
insert into Client values ('0000004','Rose Johnson', 'Notting Hill 46', '4896357890123456');
insert into Client values ('0000005','Joseph Clinton', 'Leicester Square 1', '1224569890123456');
insert into Client values ('0000006','Betty Fraser', 'Whitehall 32', '2444889890123456' );
insert into Client values ('0000007','Jack the Ripper', 'Tottenham Court Road 3', '2444889890123456' );
insert into Client values ('0000008','John H. Watson', 'Tottenham Court Road 3', '2444889890123456' );



insert into Orders values ('0000001P','0000001', TO_DATE('01/10/2020'),TO_DATE('03/10/2020'));
insert into ORDERS values ('0000002P','0000001', TO_DATE('01/10/2020'),null);
insert into Orders values ('0000003P','0000002', TO_DATE('02/10/2020'),TO_DATE('03/10/2020'));
insert into Orders values ('0000004P','0000004', TO_DATE('02/10/2020'),TO_DATE('05/10/2020'));
insert into Orders values ('0000005P','0000005', TO_DATE('03/10/2020'),TO_DATE('03/10/2020'));
insert into Orders values ('0000006P','0000003', TO_DATE('04/10/2020'),null);
insert into Orders values ('0000007P','0000006', TO_DATE('05/09/2012'),NULL);
insert into Orders values ('0000008P','0000006', TO_DATE('05/09/2012'),TO_DATE('05/10/2012'));
insert into Orders values ('0000009P','0000007', TO_DATE('05/09/2012'),NULL);

insert into Author values (1,'Jane Austin');
insert into Author values (2,'George Orwell');
insert into Author values (3,'J.R.R Tolkien');
insert into Author values (4,'Antoine de Saint-Exup?ry');
insert into Author values (5,'Bram Stoker');
insert into Author values (6,'Plato');
insert into Author values (7,'Vladimir Nabokov');

insert into Book values ('8233771378567', 'Pride and Prejudice', '2008', 9.45, 13.45);
insert into Book values ('1235271378662', '1984', '2009', 12.50, 19.25);
insert into Book values ('4554672899910', 'The Hobbit', '2002', 19.00, 33.15);
insert into Book values ('5463467723747', 'The Little Prince', '2000', 49.00, 73.45);
insert into Book values ('0853477468299', 'Dracula', '2011', 9.45, 13.45);
insert into Book values ('1243415243666', 'The Republic', '1997', 10.45, 15.75);
insert into Book values ('0482174555366', 'Lolita', '1998', 4.00, 9.45);


insert into Author_Book values ('8233771378567',1);
insert into Author_Book values ('1235271378662',2);
insert into Author_Book values ('4554672899910',3);
insert into Author_Book values ('5463467723747',4);
insert into Author_Book values ('0853477468299',5);
insert into Author_Book values ('1243415243666',6);
insert into Author_Book values ('0482174555366',7);

insert into Books_Order values ('8233771378567','0000001P', 1);
insert into Books_Order values ('5463467723747','0000001P', 2);
insert into Books_Order values ('0482174555366','0000002P', 1);
insert into Books_Order values ('4554672899910','0000003P', 1);
insert into Books_Order values ('8233771378567','0000003P', 1);
insert into Books_Order values ('1243415243666','0000003P', 1);
insert into Books_Order values ('8233771378567','0000004P', 1);
insert into Books_Order values ('4554672899910','0000005P', 1);
insert into Books_Order values ('1243415243666','0000005P', 1);
insert into Books_Order values ('5463467723747','0000005P', 3);
insert into Books_Order values ('8233771378567','0000006P', 5); 
insert into Books_Order values ('0853477468299','0000007P', 2);
insert into Books_Order values ('1235271378662','0000008P', 7);
insert into Books_Order values ('8233771378567','0000009P', 1);
insert into Books_Order values ('5463467723747','0000009P', 7);

commit;

--ejercicios

select * from client; 
select * from Orders; 
select * from author;
select * from book;
select * from books_order;


--ejercicio01

SELECT ISBN, Title, year, saleprice
FROM book;


--ejercicio02
SELECT IDORDER,  ORDERDATE, orders.IDCLIENT, Name
FROM client, orders
where orders.idclient = client.idclient;

--ejercicio03
SELECT client.IDCLIENT, NAME, TITLE
FROM client
JOIN  orders ON client.idclient = orders.idclient
JOIN books_order ON orders.idorder = books_order.idorder
JOIN book ON book.isbn = books_order.isbn
WHERE NAME LIKE '%Jo%';

--ejercicio04
SELECT DISTINCT client.IDCLIENT, NAME    --Distinct para parecer solo una vez
FROM client
JOIN  orders ON client.idclient = orders.idclient
JOIN books_order ON orders.idorder = books_order.idorder 
JOIN book ON book.isbn = books_order.isbn
where book.saleprice > 10 ;

--ejercicio05
SELECT client.IDCLIENT, NAME, IDORDER,  ORDERDATE
FROM client 
JOIN orders ON client.idclient = orders.idclient
WHERE orders.shippingdate is NULL ;

--ejercicio06
--el query interior es para todos que han comprado libros 
SELECT distinct client.IDCLIENT, client.NAME
from client
where client.IDCLIENT  not in (select distinct client.IDCLIENT from client, orders where client.IDCLIENT = orders.idclient) ;

--ejercicio07
select IDCLIENT, Name
from (
--query para todos los que han comprado al menos un libro
SELECT distinct *
from client
where client.IDCLIENT   in (select distinct client.IDCLIENT from client, orders where client.IDCLIENT = orders.idclient)
) 
where IDCLIENT not in (
--este es el query interior de todos que han comprado libros de precio  mayor a 20 
select client.IDCLIENT
from client
join orders on client.idclient = orders.idclient
join books_order on orders.idorder = books_order.idorder
join book on book.isbn = books_order.isbn
where book.saleprice >= 20 );



--ejercicio08
select distinct book.ISBN, book.TITLE, book.SALEPRICE
from book
join books_order on books_order.isbn = book.isbn
where book.saleprice > 30 or  books_order.quantity>5;


--ejercicio09
select client.IDCLIENT, NAME, ORDERDATE
from client, orders  
where orders.idclient = client.idclient
group by client.IDCLIENT, NAME, ORDERDATE 
having  count(*) > 1;


--ejercicio10
select client.idclient, client.name
from client
join orders on orders.idclient = client.idclient
join books_order on books_order.idorder = orders.idorder
join book on book.isbn = books_order.isbn
where book.title = 'Dracula' or book.title = '1984' ;

--ejercicio11
--hacer un intersect entre los que han comprado el primer libro y el segundo
select client.idclient "IDCLIENT",client.name "NAME"
from client 
join orders on client.idclient = orders.idclient
join books_order on orders.idorder = books_order.idorder
join book on books_order.isbn = book.isbn
where book.title = 'Pride and Prejudice'
--los que han comprado el libro 'Pride and Prejudice'
intersect
--los que han comprado el libro 'The Little Prince'
select client.idclient "IDCLIENT",client.name "NAME"
from client 
join orders on client.idclient = orders.idclient
join books_order on orders.idorder = books_order.idorder
join book on books_order.isbn = book.isbn
where book.title = 'The Little Prince';

--ejercicio12
select client.name, book.title, (saleprice-purchaseprice)*quantity "PROFIT"
from client
join orders on orders.idclient = client.idclient
join books_order on books_order.idorder = orders.idorder
join book on book.isbn = books_order.isbn
where (saleprice-purchaseprice)*quantity >= 50;