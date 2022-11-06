-- -------------------------------------------------------------
-- EVALUATION TEST GROUP I. 30.11.2018
-- -------------------------------------------------------------
alter session set nls_date_format = 'DD/MM/YYYY';

-- Execute this script to create the database for this test.

-- This database contains information regarding trips organized by a
-- shipping company and the captains that pilot the company ships.
-- 
-- Answer the questions at the end of this file writing SQL queries
-- next to each comment block. 

drop table ex_trip cascade constraints;
drop table ex_captain cascade constraints;
drop table ex_boat cascade constraints;

create table ex_boat(
    IdBoat integer primary key,
    Name varchar2(50),
    Category varchar2(10) -- 'Luxury', 'Business', 'Economy'
);

create table ex_captain(
    IdCaptain integer primary key,
    Name varchar2(30)
);

create table ex_trip(
    IdTrip integer primary key,
    IdBoat references ex_boat,
    IdCaptain references ex_captain,
    TripDate date,
    NumPassengers integer
);


INSERT INTO ex_boat VALUES (1, 'The Intrepid', 'Luxury');
INSERT INTO ex_boat VALUES (2, 'Princess of the Lake', 'Economy');
INSERT INTO ex_boat VALUES (3, 'New Calypso', 'Business');
INSERT INTO ex_boat VALUES (4, 'Holiday Ferry', 'Economy');
INSERT INTO ex_boat VALUES (5, 'Pond Star', 'Luxury');
INSERT INTO ex_boat VALUES (6, 'Queen of the River', 'Economy');

insert into ex_captain values (201,'Margarita Sanchez');
insert into ex_captain values (203,'Pedro Santillana');
insert into ex_captain values (204,'Rosa Prieto');
insert into ex_captain values (206,'Lola Arribas');

INSERT INTO ex_trip VALUES (101, 1,204, TO_DATE('01/06/2018'), 370);
INSERT INTO ex_trip VALUES (102, 1,204, TO_DATE('01/06/2018'), 150);
INSERT INTO ex_trip VALUES (103, 3,201, TO_DATE('01/06/2018'), 540);
INSERT INTO ex_trip VALUES (104, 2,203, TO_DATE('01/06/2018'), 45);
INSERT INTO ex_trip VALUES (105, 2,203, TO_DATE('01/11/2018'), 69);
INSERT INTO ex_trip VALUES (106, 2,204, TO_DATE('01/11/2018'), 84);

INSERT INTO ex_trip VALUES (107, 1,206, TO_DATE('22/06/2018'), 144);
INSERT INTO ex_trip VALUES (108, 2,201, TO_DATE('13/11/2018'), 64);
INSERT INTO ex_trip VALUES (109, 3,204, TO_DATE('22/11/2018'), 440);
INSERT INTO ex_trip VALUES (110, 4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO ex_trip VALUES (111, 4,201, TO_DATE('22/11/2018'), 110);
INSERT INTO ex_trip VALUES (112, 5,206, TO_DATE('22/10/2018'), 110);

COMMIT;

alter session set nls_date_format='DD/MM/YYYY';

SET LINESIZE 500;
SET PAGESIZE 500;

/* 1. Summarized information regarding passengers transported by
  captain and boat category: this query must show the list of captains
  and the categories of the boats they have driven.  The following
  data must be shown: Captain name, boat category, number of trips
  driven by that captain for that category, total number of passengers
  transported by captain and category, and the greatest amount of
  passengers transported in a single trip by captain and category. */

select ex_captain.name "NAME",ex_boat.category "CATEGORY",count(idtrip) "NUM_TRIPS",sum(ex_trip.numpassengers) "NUM_PASSENGERS", max(numpassengers) "MAX_PASSENGERS"
from ex_boat
join ex_trip on ex_boat.idboat = ex_trip.idboat
join ex_captain on ex_captain.idcaptain = ex_trip.idcaptain
group by ex_captain.name, ex_boat.category;

/* 2. List of the boats (name and total number of passengers
  transported in that boat) that transported more passengers than 'The
  Intrepid' in 2018.  */




select ex_boat.name "NAME",sum(numpassengers) "TOTAL"
from ex_boat 
join ex_trip on ex_boat.idboat = ex_trip.idboat
group by ex_boat.name
having sum(numpassengers) > (select sum(numpassengers)
                            from ex_trip
                            join ex_boat on ex_trip.idboat = ex_boat.idboat
                            where name = 'The Intrepid' and tripdate between TO_DATE('01/01/2018') and TO_DATE('31/12/2018')
                            group by ex_boat.name);

/* 3. List of all boats in the company and the captains that have
  driven them in november 2018.  It must show the name of the boat and
  the name of the captain (or '(none)' if the boat has not
  been driven by any captain in that month). Note: At least
  one of the resulting rows should contain the text '(none)'.
  */
  select ex_boat.idboat "IDBOAT",ex_boat.name "NAME",NVL(ex_captain.name,'(none)') "CAPTAIN_NAME"  
  from ex_boat
  left outer join (ex_trip join ex_captain on ex_trip.idcaptain = ex_captain.idcaptain and tripdate between TO_DATE('01/11/2018') and TO_DATE('30/11/2018'))
  on ex_boat.idboat = ex_trip.idboat;
  
  --Otra manera de hacerlo 
select ex_boat.idboat "IDBOAT",ex_boat.name "NAME",NVL(ex_captain.name,'(none)') "CAPTAIN_NAME"  
  from ex_boat
  left outer join ex_trip  on ex_trip.idboat = ex_boat.idboat and tripdate between TO_DATE('01/11/2018') and TO_DATE('30/11/2018')
  left outer join ex_captain on ex_captain.idcaptain = ex_trip.idcaptain;


/* 4. Show the trips driven by captains that have not driven any boat
  of category 'Luxury' in 2018.  */

select ex_trip.idtrip "IDTRIP",ex_trip.idboat "IDBOAT",ex_trip.idcaptain  "IDCAPTAIN",ex_trip.tripdate "TRIPDATE",ex_trip.numpassengers "NUMPASSENGERS"
from ex_trip
where idcaptain in (
                    select ex_captain.idcaptain
                    from ex_captain
                    where idcaptain not in (
                                            select distinct ex_trip.idcaptain 
                                            from ex_trip
                                            join ex_boat on ex_boat.idboat = ex_trip.idboat
                                            where tripdate  between TO_DATE('01/01/2018') and TO_DATE('31/12/2018') and ex_boat.category = 'Luxury'
                                            )
                    );




/* 5. Show the trips driven by captains that have only driven 'Luxury'
  boats in 2018.  */
  
  select ex_trip.idtrip "IDTRIP",ex_trip.idboat "IDBOAT",ex_trip.idcaptain  "IDCAPTAIN",ex_trip.tripdate "TRIPDATE",ex_trip.numpassengers "NUMPASSENGERS"
  from ex_trip
  where idcaptain in (
                      select ex_captain.idcaptain
                      from ex_captain
                      where idcaptain not in (
                                              select distinct ex_trip.idcaptain 
                                              from ex_trip
                                              join ex_boat on ex_boat.idboat = ex_trip.idboat
                                              where tripdate  between TO_DATE('01/01/2018') and TO_DATE('31/12/2018') and ex_boat.category != 'Luxury'
                                              )
                      );
  
  
  
  


/* 6. Name of the captains that have driven all Luxury boats.*/

 select name 
 from ex_captain
 where idcaptain not in (
                         select distinct idcaptain 
                         from ex_trip 
                         left outer join ex_boat on ex_boat.idboat = ex_trip.idboat and category = 'Luxury'
                         where name is  null
                         );
 


/* 7. For each boat, list the trips that have transported the greatest
  number of passengers.  It must show the boat name, the trip id and
  the number of passengers transported. */
  select ex_boat.name "NAME",e.idtrip "IDTRIP",ex_boat.idboat "IDBOAT",e.idcaptain  "IDCAPTAIN",e.tripdate "TRIPDATE",e.numpassengers  "NUMPASSENGERS"
  from ex_trip e
  join ex_boat on ex_boat.idboat = e.idboat
  where numpassengers = (
                           select max(numpassengers)
                          from ex_trip
                          where idboat = e.idboat
                          );
  
  

