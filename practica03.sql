------------------------------------------------------------------------
-- Lab Session 3. SQL QUERIES: OUTER JOINS, EXTENDED SELECT (GROUP BY, HAVING)
-- -------------------------------------------------------------------------

-- This script contains the database definition for a network of
-- electronic newspapers, articles published and journalists. Inspect the
-- structure of the database to learn how the information is stored.

-- Execute the script on a database session to create the database and
-- write SQL SELECT sentences next to the questions that are included
-- as comments at the end of this file.

-- It is very important to check that the results of your queries are
-- correct with respect to the data in the tables.

-- -------------------------------------------------------------------------

SET LINESIZE 500;
SET PAGESIZE 500;
alter session set nls_date_format = 'DD/MM/YYYY';

drop table article cascade constraints;
drop table journalist cascade constraints;
drop table newspaper cascade constraints;

create table newspaper(
    idNewspaper integer primary key,
    Name varchar2(50),
    url varchar2(200),
    Language varchar2(3)
    -- Language can be 'en' (English), 'es' (Spanish), 'fr', etc.
);

create table journalist(
    idJournalist integer primary key,
    Name varchar2(30)
);

create table article(
    idArticle integer primary key,
    headline varchar2(100),
    url varchar2(200),
    idNewspaper references newspaper,
    idJournalist references journalist,
    pubDate date,
    numVisits integer
);


INSERT INTO newspaper VALUES (1, 'El Noticiero', 'http://www.newstoday.com','es');
INSERT INTO newspaper VALUES (2, 'El Diario de Zaragoza', 'http://www.diariozaragoza.es','es');
INSERT INTO newspaper VALUES (3, 'The Gazette', 'http://www.gacetaguadalajara.es','en');
INSERT INTO newspaper VALUES (4, 'Toledo Tribune', 'http://www.toledotribune.es','en');
INSERT INTO newspaper VALUES (5, 'Alvarado Times', 'http://www.alvaradotimes.es','en');
INSERT INTO newspaper VALUES (6, 'El Retiro Noticias', 'http://www.elretironoticias.es','es');

insert into journalist values (201,'Margarita Sanchez');
insert into journalist values (203,'Pedro Santillana');
insert into journalist values (204,'Rosa Prieto');
insert into journalist values (206,'Lola Arribas');
insert into journalist values (207,'Antonio Lopez');

INSERT INTO article VALUES (101, 'El Banco de Inglaterra advierte de los peligros del Brexit',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2018'), 370);
INSERT INTO article VALUES (102, 'La UE acabar? con el 100% de las emisiones de CO2 para 2050',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2019'), 1940);
INSERT INTO article VALUES (103, 'Madrid 360 starts tomorrow',
			   'http://www.gacetaguadalajara.es/nacional24',
			   3,201, TO_DATE('01/06/2018'), 490);
INSERT INTO article VALUES (104, 'El Ayuntamiento prepara diez nuevos carriles bici',
			   'http://www.diariozaragoza.es/movilidad33',
			   2,203, TO_DATE('01/06/2018'), 2300);
INSERT INTO article VALUES (105, 'Un aragon?s cruzar? Siberia, de punta a punta en bici',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,203, TO_DATE('01/11/2019'), 2300);
INSERT INTO article VALUES (106, 'Hecatombe financiera ante un Brexit duro',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,204, TO_DATE('01/11/2018'), 2220);

INSERT INTO article VALUES (107, 'Fomento anuncia una estrategia nacional para fomentar la intermodalidad y el uso de la bicicleta',
			   'http://www.elnoticiero.es/ibex9001',
			   1,206, TO_DATE('22/06/2018'), 390);
INSERT INTO article VALUES (108, 'As? ser? el carril bici que pasar? por la puerta del Cl?nico',
			   'http://www.diariozaragoza.es/nacional22062018',
			   2,206, TO_DATE('13/11/2018'), 230);
INSERT INTO article VALUES (109, 'How will traffic constraints affect you? The Gazette answers your questions',
			   'http://www.gacetaguadalajara.es/deportes33',
			   3,204, TO_DATE('22/11/2018'), 123);
INSERT INTO article VALUES (110, 'How will traffic constraints affect you? Toledo Tribune answers your questions',
			   'http://www.toledotribune.es/deportes33',
			   4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO article VALUES (111, 'Financial havoc if there is a hard Brexit',
			   'http://www.toledotribune.es/Business',
			   4,201, TO_DATE('22/01/2019'), 1105);
INSERT INTO article VALUES (112, 'Financial havoc if there is a hard Brexit',
			   'http://www.alvaradotimes.es/deportes44',
			   5,204, TO_DATE('22/10/2018'), 130);
INSERT INTO article VALUES (113, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   5,201, TO_DATE('22/10/2019'), 820);
INSERT INTO article VALUES (114, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.toledotribune.es/politics',
			   4,204, TO_DATE('25/08/2019'), 1425);
INSERT INTO article VALUES (115, 'Nuestro representante en Eurovision queda en el puesto 22',
			   'http://www.elnoticiero.es/eurovision2019',
			   1,204, TO_DATE('01/06/2019'), 34750);
INSERT INTO article VALUES (116, 'Editorial: Most relevant news 2019',
			   'http://www.gacetaguadalajara.es/editorial2019',
            5,null, TO_DATE('31/12/2019'), 44501);

COMMIT;

select * from article where idjournalist = 203 ;
select * from newspaper;
select * from journalist;


-- -------------------------------------------------------------------------
-- Lab Session 3. QUESTIONS
-- Write your answers next to each comment.
-- -------------------------------------------------------------------------

/* 1. Display the newspapers that have published articles in 2019, the number 
of articles published and the average number of visits received by articles 
published in each newspaper. 
Schema: (Newspaper_Id, Newspaper_Name, Num_Articles, Avg_visits) */
select newspaper.idnewspaper "NEWSPAPER_ID" ,name "NEWSPAPER_NAME" , count(*) "NUM_ARTICLES", avg(article.numvisits) "AVG_VISITS"
from newspaper, article
where newspaper.idnewspaper = article.idnewspaper and article.pubdate between to_Date(TO_DATE('01/01/2019')) AND to_Date(TO_DATE('31/12/2019')) 
GROUP BY newspaper.idnewspaper, name ;



/* 2. Display summarized information for journalists and the languages
they use for writing articles:
Display the list of journalists that have published articles and the
language in which they were written, and the following statistical
information: number of newspapers in which each journalist has
published articles in each language, the total number of visits to
their articles in each language, and the maximum number of visits
received by an article written by each journalist in each language.
Schema: (Journalist_id, Journalist_Name, Language, Num_newspapers,
Total_visits, Max_visits).*/


select journalist.idJournalist "JOURNALIST_ID", journalist.name "JOURNALIST_NAME", newspaper.language "LAN", count(distinct newspaper.idnewspaper) "NUM_NEWSPAPERS", sum(article.numvisits) "TOTAL_VISITS", max(article.numvisits)"MAX_VISITS"
from newspaper, journalist ,article
where journalist.idJournalist=article.idJournalist and newspaper.idnewspaper = article.idnewspaper
group by  journalist.idJournalist,  journalist.name,  newspaper.language;

/* 3. Display the list of ALL journalists, and the name of the
newspapers for which each journalist has written articles. If a
journalist has not written any article for any newspaper, it must
display '(none)' instead of the name of the newspaper.
Schema: (Journalist_Id, Journalist_Name, Newspaper_Name)
*/
select distinct journalist.idjournalist "Journalist_Id", journalist.name "Journalist_Name", newspaper.name "Newspaper_Name"
from journalist
LEFT outer join article on journalist.idjournalist = article.idjournalist
LEFT outer join newspaper on newspaper.idnewspaper = article.idnewspaper;

  
/* 4. Display the list of ALL newspapers that have published articles in 2019, 
and the journalists that have written articles for them in 2019. If no 
journalist has written any article for a newspaper in 2019, it 
must display '(none)' instead of the name of the journalist.
Schema: (Newspaper_Id, Newspaper_Name, Journalist_Id, Journalist_Name)
*/
select distinct newspaper.idnewspaper "Newspaper_Id",newspaper.name "Newspaper_Name",journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name"
from newspaper
left outer join article on article.idnewspaper = newspaper.idnewspaper
left outer join journalist on journalist.idjournalist = article.idjournalist
where article.pubdate between to_Date(TO_DATE('01/01/2019')) AND to_Date(TO_DATE('31/12/2019'));
  

/* 5. Display the list of ALL journalists, the number of articles written
by each journalist, and the number of newspapers where those articles have
been published.
If a journalist has written no articles, 0 must be displayed on those columns. 
Schema: (Journalist_Id, Journalist_Name, Num_Articles, Num_Newspapers)
*/

select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name",count(article.idarticle) "Num_Articles",count(distinct newspaper.idnewspaper) "Num_Newspapers"
from journalist 
left outer join article on article.idjournalist = journalist.idjournalist
left outer join newspaper on newspaper.idnewspaper = article.idnewspaper
group by journalist.idjournalist, journalist.name;



/* 6. Answer the previous query (5) using set-theory operations instead of outer 
joins or nested queries.*/



/* 7. Display the list of newspapers that have published more than 2
articles with less than 2000 visits received by each article. The
query must display the number of articles published and the total
number of visits to those articles.  
Schema: (Newspaper_Id, Newspaper_Name, Num_Articles, Total_Visits)*/


--el enunciado le falta "more or equal to 2 articles" para que me sale como en la correccion
select newspaper.idnewspaper "Newspaper_Id",newspaper.name "Newspaper_Name",count(*) "Num_Articles",sum(article.numvisits) "Total_Visits"  
from newspaper
join article on newspaper.idnewspaper = article.idnewspaper and article.numvisits<2000
group by newspaper.idnewspaper, newspaper.name
having count(*)>=2;


/* 8. Display the list of ALL journalists, the number of newspapers for which 
they have written articles and the total number of visits to those articles.
If a journalist has not published any article, it must display 0 in those
columns.
Schema: (Journalist_Id, Journalist_Name, Num_Newspapers, Total_Visits*/

select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name",count(DISTINCT newspaper.name) "Num_Newspapers",nvl(sum(article.numvisits),0) "Total_Visits"
from journalist
left outer join article on article.idjournalist = journalist.idjournalist
left outer join newspaper on article.idnewspaper = newspaper.idnewspaper
group by journalist.idjournalist, journalist.name;

--en la correccion ha puesto  NUM_ARTICLES al lugar de Num_Newspapers y da esto
select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name",count(article.idarticle) "NUM_ARTICLES",nvl(sum(article.numvisits),0) "Total_Visits"
from journalist
left outer join article on article.idjournalist = journalist.idjournalist
left outer join newspaper on article.idnewspaper = newspaper.idnewspaper
group by journalist.idjournalist, journalist.name;


/* 9. Answer the previous query (8), but sorting the results by Num_Articles
in descending order and then, if there are several rows with the same value, by 
Total_Visits in ascending order.*/

select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name",count(article.idarticle) "NUM_ARTICLES",nvl(sum(article.numvisits),0) "Total_Visits"
from journalist
left outer join article on article.idjournalist = journalist.idjournalist
left outer join newspaper on article.idnewspaper = newspaper.idnewspaper
group by journalist.idjournalist, journalist.name
order by count(article.idarticle) desc, nvl(sum(article.numvisits),0) asc ;
