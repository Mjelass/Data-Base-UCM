-- -------------------------------------------------------------------------
-- Lab Session 5. PL/SQL stored procedures and triggers.
-- -------------------------------------------------------------------------

-- This script contains part of the database definition for an airline
-- company. It contains tables with the following information:
--  * The models of airplanes that conform the fleet of the company.
--  * The company employees.
--  * The certificates of employees to pilot plane models.
--  * The flights operated by the company.
-- Inspect the structure of the database to learn how the information is
-- stored.

-- Execute the script on a database session to create the database and
-- write the stored procedures and trigger requested at the end of
-- this file.

-- It is very important to check that your code works using several
-- test cases (with valid and non-valid parameters).

-- -------------------------------------------------------------------------
SET SERVEROUTPUT ON;
ALTER SESSION SET nls_date_format='DD/MM/YYYY';

drop table FWCertificate cascade constraints;
drop table FWEmpl cascade constraints;
drop table FWPlane cascade constraints;
drop table FWFlight cascade constraints;

create table FWFlight(
	flno number(4,0) primary key,
	deptAirport varchar2(20),
	destAirport varchar2(20),
	distance number(6,0),
	 -- distance, measured in miles.
	deptDate date,
	arrivDate date,
	price number(7,2));

create table FWPlane(
	pid number(9,0) primary key,
	name varchar2(30),
	maxFlLength number(6,0)
	 -- Maximum flight length, measured in miles.
	);

create table FWEmpl(
	eid number(9,0) primary key,
	name varchar2(30),
	salary number(10,2));

create table FWCertificate(
	eid number(9,0),
	pid number(9,0),
	primary key(eid,pid),
	foreign key(eid) references FWEmpl,
	foreign key(pid) references FWPlane); 



INSERT INTO FWFlight  VALUES (99,'Los Angeles','Washington D.C.',2308,to_date('04/12/2005 09:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:40', 'dd/mm/yyyy HH24:MI'),235.98);

INSERT INTO FWFlight  VALUES (13,'Los Angeles','Chicago',1749,to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (346,'Los Angeles','Dallas',1251,to_date('04/12/2005 11:50', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),225-43);

INSERT INTO FWFlight  VALUES (387,'Los Angeles','Boston',2606,to_date('04/12/2005 07:03', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 05:03', 'dd/mm/yyyy HH24:MI'),261.56);

INSERT INTO FWFlight  VALUES (7,'Los Angeles','Sydney',7487,to_date('04/12/2005 05:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:10', 'dd/mm/yyyy HH24:MI'),278.56);

INSERT INTO FWFlight  VALUES (2,'Los Angeles','Tokyo',5478,to_date('04/12/2005 06:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:55', 'dd/mm/yyyy HH24:MI'),780.99);

INSERT INTO FWFlight  VALUES (33,'Los Angeles','Honolulu',2551,to_date('04/12/2005 09:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:15', 'dd/mm/yyyy HH24:MI'),375.23);

INSERT INTO FWFlight  VALUES (34,'Los Angeles','Honolulu',2551,to_date('04/12/2005 12:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:18', 'dd/mm/yyyy HH24:MI'),425.98);

INSERT INTO FWFlight  VALUES (76,'Chicago','Los Angeles',1749,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:03', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (68,'Chicago','New York',802,to_date('04/12/2005 09:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:02', 'dd/mm/yyyy HH24:MI'),202.45);

INSERT INTO FWFlight  VALUES (7789,'Madison','Detroit',319,to_date('04/12/2005 06:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:19', 'dd/mm/yyyy HH24:MI'),120.33);

INSERT INTO FWFlight  VALUES (701,'Detroit','New York',470,to_date('04/12/2005 08:55', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:26', 'dd/mm/yyyy HH24:MI'),180.56);

INSERT INTO FWFlight  VALUES (702,'Madison','New York',789,to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),202.34);

INSERT INTO FWFlight  VALUES (4884,'Madison','Chicago',84,to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:02', 'dd/mm/yyyy HH24:MI'),112.45);

INSERT INTO FWFlight  VALUES (2223,'Madison','Pittsburgh',517,to_date('04/12/2005 08:02', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:01', 'dd/mm/yyyy HH24:MI'),189.98);

INSERT INTO FWFlight  VALUES (5694,'Madison','Minneapolis',247,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:33', 'dd/mm/yyyy HH24:MI'),120.11);

INSERT INTO FWFlight  VALUES (304,'Minneapolis','New York',991,to_date('04/12/2005 10:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 01:39', 'dd/mm/yyyy HH24:MI'),101.56);

INSERT INTO FWFlight  VALUES (149,'Pittsburgh','New York',303,to_date('04/12/2005 09:42', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:09', 'dd/mm/yyyy HH24:MI'),1165.00);



Insert into FWPlane  values ('1','Boeing 747-400','8430');
Insert into FWPlane  values ('3','Airbus A340-300','7120');
Insert into FWPlane  values ('4','British Aerospace Jetstream 41','1502');
Insert into FWPlane  values ('5','Embraer ERJ-145','1530');
Insert into FWPlane  values ('7','Piper Archer III','520');


Insert into FWEmpl  values ('567354612','Lisa Walker',256481);
Insert into FWEmpl  values ('254099823','Patricia Jones',223000);
Insert into FWEmpl  values ('355548984','Angela Martinez',212156);
Insert into FWEmpl  values ('310454876','Joseph Thompson',212156);
Insert into FWEmpl  values ('269734834','George Wright',289950);
Insert into FWEmpl  values ('552455348','Dorthy Lewis',251300);
Insert into FWEmpl  values ('486512566','David Anderson',43001);
Insert into FWEmpl  values ('573284895','Eric Cooper',114323);
Insert into FWEmpl  values ('574489457','Milo Brooks',2000);


Insert into FWCertificate values ('269734834','1');
Insert into FWCertificate values ('269734834','3');
Insert into FWCertificate values ('269734834','4');
Insert into FWCertificate values ('269734834','5');
Insert into FWCertificate values ('269734834','7');
Insert into FWCertificate values ('567354612','1');
Insert into FWCertificate values ('567354612','3');
Insert into FWCertificate values ('567354612','4');
Insert into FWCertificate values ('567354612','5');
Insert into FWCertificate values ('567354612','7');
Insert into FWCertificate values ('573284895','3');
Insert into FWCertificate values ('573284895','4');
Insert into FWCertificate values ('573284895','5');
Insert into FWCertificate values ('574489457','7');

commit;

select * from FWFlight;
select * from fwplane;
select * from fwempl;
select * from fwcertificate;


-- -------------------------------------------------------------------------
-- Lab Session 5 exercises.
-- Write your answers next to each comment. DO NOT delete any comment.
-- -------------------------------------------------------------------------

/* 1. Write a PL/SQL stored procedure named PrintFlightInfo that
receives a flight number as a parameter and writes on the console the
information related to that flight. If the flight does not exist, it
must print an error message on the console.

For example, if it is invoked with the flight number 7789, the result
should be something like:

-------------------------------------------------------------
Flight information: 7789-Madison-Detroit (319 miles)
-------------------------------------------------------------

If this procedure is invoked with a non-existent flight number, as for
example 9999, the result on the console should be something like: 

Flight number not found!

Check that the stored procedure written works properly with several
test cases.

Hint: you should use a SELECT...INTO sentence to retrieve the flight
information from the database. You should handle an exception if the
flight does not exist. */

create or replace procedure PrintFlightInfo(p_flno FWFlight.flno%type) is
v_deptAirport FWFlight.deptAirport%type;
v_destAirport FWFlight.destAirport%type;
v_distance FWFlight.distance%type;
begin

select FWFlight.deptAirport, FWFlight.destAirport, FWFlight.distance
into v_deptAirport, v_destAirport, v_distance
from FWFlight
where FWFlight.flno = p_flno;

dbms_output.put_line('-------------------------------------------------------------');
dbms_output.put_line('Flight information: '|| p_flno ||'-'|| v_deptAirport ||'-'|| v_destAirport ||' ('|| v_distance ||' miles)');
dbms_output.put_line('-------------------------------------------------------------');

Exception
    when no_data_found then
        dbms_output.put_line('Flight number not found!');


end;
/


begin
    PrintFlightInfo(99);
end;
/

/* 2. Now write another procedure PlanesForFlight based on the code of
Exercise 1: use the same code, but rename it to PlanesForFlight and
extend it so that it must now print on the console all plane models
that can operate the flight (i.e., the planes that have a maximum
flight length that allows them to operate that flight). For each plane
model, the following information must be displayed: plane identifier,
model name, number of pilots certified for that plane, and their
average salary.  If there is no flight with that number, it must print
an error message on the console. For example, if it is invoked with
the flight number 7789, the result would be:

-------------------------------------------------------------
Planes for flight: 7789-Madison-Detroit (319 miles)
-------------------------------------------------------------
PID Plane model                    Num.emp.    Average salary
-------------------------------------------------------------
  1 Boeing 747-400                        2       273,215.50
  3 Airbus A340-300                       3       220,251.33
  4 British Aerospace Jetstream 41        3       220,251.33
  5 Embraer ERJ-145                       3       220,251.33
  7 Piper Archer III                      3       182,810.33
-------------------------------------------------------------

If it is invoked with a non-existing flight number as 9999, the result
should be something like this:

Flight number 9999 not found!

Hint: In addition to SELECT...INTO sentence as in Exercise 1, you
should now use a cursor to retrieve the planes information from the
database.  You can use string-handling functions to properly format
the output, for example RPAD or TO_CHAR. Check the slides to see how
they are used.*/


create or replace procedure PlanesForFlight(p_flno FWFlight.flno%type) is

v_deptAirport FWFlight.deptAirport%type;
v_destAirport FWFlight.destAirport%type;
v_distance FWFlight.distance%type;

cursor info_planes is
    select FWplane.pid "PID" , FWplane.name "NAMEPLANE", count(FWEmpl.name) "NUMEMPL", avg(FWEmpl.salary) "AVGSAL"
    from FWplane
    join FWCertificate on FWCertificate.pid = FWplane.pid
    join FWEmpl on FWEmpl.eid = FWCertificate.eid
    where FWplane.maxFlLength >= v_distance
    group by FWplane.pid, FWplane.name 
    order by PID asc;
    
row_info info_planes%ROWTYPE;

begin

select FWFlight.deptAirport, FWFlight.destAirport, FWFlight.distance
into v_deptAirport, v_destAirport, v_distance
from FWFlight
where FWFlight.flno = p_flno;

dbms_output.put_line('-----------------------------------------------------------------------');
dbms_output.put_line('Flight information: '|| p_flno ||'-'|| v_deptAirport ||'-'|| v_destAirport ||' ('|| v_distance ||' miles)');
dbms_output.put_line('-----------------------------------------------------------------------');
dbms_output.put_line('PID Plane model                                Num.emp.  Average salary');
dbms_output.put_line('-----------------------------------------------------------------------');


open info_planes;
    loop
        fetch info_planes into row_info;
        exit when info_planes%NOTFOUND;
        dbms_output.put_line('  '|| TO_CHAR(row_info.PID) ||' '|| RPAD(row_info.NAMEPLANE, 25)||LPAD(row_info.NUMEMPL,25) ||'  '||TO_CHAR(round(row_info.AVGSAL,2),'999999'));
    end loop;
    dbms_output.put_line('-----------------------------------------------------------------------');
close info_planes;



Exception
    when no_data_found then
        dbms_output.put_line('Flight number' || p_flno || 'not found!');


end;
/


begin
    PlanesForFlight(7789);
end;
/




/* 3. Once you have finished the previous procedure, copy its source
code again to create a third procedure PilotsForFlight that extends the
previous one as follows: For each plane model, it must print the name
and salary of all employees that are certified to pilot that model, in
alphabetical order. For example, if it is invoked with Flight 2, it
must show:

-------------------------------------------------------------
Planes for flight 2-Los Angeles-Tokyo (5478 miles)
-------------------------------------------------------------
PID Plane model                    Num.emp.    Average salary
-------------------------------------------------------------
  1 Boeing 747-400                        2       273,215.50
    Pilots:
     George Wright                                289,950.00
     Lisa Walker                                  256,481.00
-------------------------------------------------------------
  3 Airbus A340-300                       3       220,251.33
    Pilots:
     Eric Cooper                                  114,323.00
     George Wright                                289,950.00
     Lisa Walker                                  256,481.00
-------------------------------------------------------------

Hint: For this procedure you can use two cursors: one for the planes
(the one used in Exercise 2), and another cursor for displaying the
pilots certified for that flight. The cursors must be traversed using
nested FOR loops. You can use local variables to provide information
from one cursor to the other one. */


create or replace procedure PilotsForFlight(p_flno FWFlight.flno%type) is

v_deptAirport FWFlight.deptAirport%type;
v_destAirport FWFlight.destAirport%type;
v_distance FWFlight.distance%type;

cursor info_planes is
    select FWplane.pid "PID" , FWplane.name "NAMEPLANE", count(FWEmpl.name) "NUMEMPL", avg(FWEmpl.salary) "AVGSAL"
    from FWplane
    join FWCertificate on FWCertificate.pid = FWplane.pid
    join FWEmpl on FWEmpl.eid = FWCertificate.eid
    where FWplane.maxFlLength >= v_distance
    group by FWplane.pid, FWplane.name 
    order by PID asc;
    
v_PID FWplane.pid%type;
v_NAMEPLANE FWplane.name%type;
v_NUMEMPL FWplane.pid%type;
v_AVGSAL FWplane.pid%type;

cursor info_empl is
        select distinct FWEmpl.name, FWEmpl.salary
        from FWplane
        join FWCertificate on FWCertificate.pid = FWplane.pid
        join FWEmpl on FWEmpl.eid = FWCertificate.eid
        where FWplane.maxFlLength >= v_distance and FWplane.name = v_NAMEPLANE ;


v_Empl FWEmpl.name%type;
v_SalEmpl FWEmpl.salary%type;      
    

begin

select FWFlight.deptAirport, FWFlight.destAirport, FWFlight.distance
into v_deptAirport, v_destAirport, v_distance
from FWFlight
where FWFlight.flno = p_flno;

dbms_output.put_line('-----------------------------------------------------------------------');
dbms_output.put_line('Planes for flight '|| p_flno ||'-'|| v_deptAirport ||'-'|| v_destAirport ||' ('|| v_distance ||' miles)');
dbms_output.put_line('-----------------------------------------------------------------------');
dbms_output.put_line('PID Plane model                                Num.emp.  Average salary');
dbms_output.put_line('-----------------------------------------------------------------------');


open info_planes;
    loop
        fetch info_planes into v_PID, v_NAMEPLANE, v_NUMEMPL, v_AVGSAL;
        exit when info_planes%NOTFOUND;
        dbms_output.put_line('  '|| TO_CHAR(v_PID) ||' '|| RPAD(v_NAMEPLANE, 25)||LPAD(v_NUMEMPL,25) ||'  '||TO_CHAR(round(v_AVGSAL,2),'999999'));
        dbms_output.put_line('    '||'Pilots:');
        
        open info_empl;
            loop
                fetch info_empl into v_Empl, v_SalEmpl;
                exit when info_empl%NOTFOUND;
                dbms_output.put_line('      '||RPAD(v_Empl,45)|| '  ' ||LPAD(v_SalEmpl,10));
            end loop;
        close info_empl; 
        dbms_output.put_line('-----------------------------------------------------------------------');
    end loop;
close info_planes;



Exception
    when no_data_found then
        dbms_output.put_line('Flight number' || p_flno || 'not found!');


end;
/


begin
    PilotsForFlight(2);
end;
/




/* 
4. Create a trigger with name payRaise that, whenever a pilot obtains
   a new certificate for piloting another plane model, increments 3%
   their salary. Include some DML sentences for testing the trigger.
*/

create or replace TRIGGER payRaise
after insert 
on fwcertificate
FOR EACH ROW
begin

    update FWEmpl
    set FWEmpl.salary = FWEmpl.salary * 1.03
    where FWEmpl.eid = :NEW.eid;
    
    dbms_output.put_line('Salario de eid = ' || :NEW.eid || 'ha aumentado 3% ');
    
end;
/
select salary from FWEmpl where eid = '573284895';
select pid from  FWCertificate where eid = '573284895';
Insert into FWCertificate values ('573284895','7');

