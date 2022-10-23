-- -------------------------------------------------------------------------
-- Lab Session 4. SQL QUERIES: NESTED QUERIES, CORRELATED NESTED QUERIES
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
			   1,204, TO_DATE('01/06/2018'), 1940);
INSERT INTO article VALUES (103, 'Madrid Central starts tomorrow',
			   'http://www.gacetaguadalajara.es/nacional24',
			   3,201, TO_DATE('01/06/2018'), 490);
INSERT INTO article VALUES (104, 'El Ayuntamiento prepara diez nuevos carriles bici',
			   'http://www.diariozaragoza.es/movilidad33',
			   2,203, TO_DATE('01/06/2018'), 2300);
INSERT INTO article VALUES (105, 'Un aragon?s cruzar? Siberia, de punta a punta en bici',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,203, TO_DATE('01/11/2018'), 2300);
INSERT INTO article VALUES (106, 'Hecatombe financiera ante un Brexit duro',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,204, TO_DATE('01/11/2018'), 2220);

INSERT INTO article VALUES (107, 'Fomento anuncia una estrategia nacional para fomentar la intermodalidad y el uso de la bicicleta',
			   'http://www.elnoticiero.es/ibex9001',
			   1,206, TO_DATE('22/06/2018'), 390);
INSERT INTO article VALUES (108, 'As? ser? el carril bici que pasar? por la puerta del Cl?nico',
			   'http://www.diariozaragoza.es/nacional22062018',
			   2,206, TO_DATE('13/11/2018'), 1230);
INSERT INTO article VALUES (109, 'How will traffic constraints affect you? The Gazette answers your questions',
			   'http://www.gacetaguadalajara.es/deportes33',
			   3,204, TO_DATE('22/11/2018'), 123);
INSERT INTO article VALUES (110, 'How will traffic constraints affect you? Toledo Tribune answers your questions',
			   'http://www.toledotribune.es/deportes33',
			   4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO article VALUES (111, 'Financial havoc if there is a hard Brexit',
			   'http://www.toledotribune.es/deportes44',
			   4,201, TO_DATE('22/11/2018'), 110);
INSERT INTO article VALUES (112, 'Financial havoc if there is a hard Brexit',
			   'http://www.alvaradotimes.es/deportes44',
			   5,204, TO_DATE('22/10/2018'), 130);
INSERT INTO article VALUES (113, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   5,201, TO_DATE('22/10/2019'), 820);
INSERT INTO article VALUES (114, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   4,204, TO_DATE('25/08/2019'), 1425);

COMMIT;

-- -------------------------------------------------------------------------
-- Lab Session 4. QUESTIONS
-- Write your answers next to each comment.
-- -------------------------------------------------------------------------

/* 1. Display the list of journalists who have NOT published any article in 
the newspaper with Id 4.
Schema: (Journalist_Id, Journalist_Name).*/

select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name"
from journalist 
where journalist.idjournalist not in (
    --todos os journalist que han escrito article in the newspaper with id 4
    select distinct journalist.idjournalist 
    from journalist 
    join article on article.idjournalist =journalist.idjournalist
    where idnewspaper = 4
);




/* 2. Display the list  of journalists who have NOT published any article in 
the newspaper 'The Gazette'. The result must only include journalists that have
published at least one article.
Schema: (Journalist_Id, Journalist_Name).*/

--todos os journalist que no han escrito articles in the newspaper with id 4
select journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name"
from journalist 
where journalist.idjournalist not in (
    --todos os journalist que han escrito article in the newspaper with id 4
    select distinct journalist.idjournalist 
    from journalist 
    join article on article.idjournalist =journalist.idjournalist
    join newspaper on newspaper.idnewspaper = article.idnewspaper
    where newspaper.name = 'The Gazette'
)

intersect

--journalists that have published at least one article
select distinct journalist.idjournalist "Journalist_Id",journalist.name "Journalist_Name"
from  journalist
join article on article.idjournalist = journalist.idjournalist;


/* 3. Display the list of the newspapers that in 2018 received more
visits than 'The Gazette'.
Schema: (Newspaper_Name, Num_Visits)  */

select newspaper.name "Newspaper_Name",sum(article.numvisits) "Num_Visits"
from newspaper 
join article on article.idnewspaper = newspaper.idnewspaper
where pubdate between TO_DATE('01/01/2018') and TO_DATE('31/12/2018') 
group by newspaper.name
having sum(article.numvisits) >(
--total number of visits of the newspaper 'The Gazette' in 2018
    select sum(article.numvisits) "Num_Visits"
    from newspaper
    join article on newspaper.idnewspaper =article.idnewspaper
    where newspaper.name = 'The Gazette' and pubdate between TO_DATE('01/01/2018') and TO_DATE('31/12/2018') 
    group by newspaper.name
);




/* 4. Display the headlines of articles written by authors that in 2019 DID
NOT write ANY article in English.
Schema: (Article_Id, Article_Headline, Journalist_Name)
*/

select article.idarticle "Article_Id",article.headline "Article_Headline",journalist.name "Journalist_Name"
from journalist 
join article on article.idjournalist = journalist.idjournalist
where journalist.idjournalist in (
    --authors that in 2019 DID NOT write ANY article in English
    select journalist.idjournalist "IDJOURNALIST" 
    from journalist 
    where idjournalist not in (
        select journalist.idjournalist "IDJOURNALIST"
        from journalist 
        join article on article.idjournalist = journalist.idjournalist
        join newspaper on newspaper.idnewspaper = article.idnewspaper
        where pubdate between TO_DATE('01/01/2019') and TO_DATE('31/12/2019') and language = 'en'
    )
);




/* 5. Display the headlines of the articles written by journalists
that in 2018 wrote for English newspapers ONLY.
Schema: (Article_Id, Headline, PubDate, Journalist_Name)
*/

select article.idarticle "Article_Id",article.headline "Headline",article.pubdate "PubDate",journalist.name "Journalist_Name"
from journalist 
join article on article.idjournalist = journalist.idjournalist
where journalist.idjournalist in (
    select journalist.idjournalist "IDJOURNALIST"
    from journalist 
    where idjournalist not in (
        select journalist.idjournalist "IDJOURNALIST"
        from journalist 
        join article on article.idjournalist = journalist.idjournalist
        join newspaper on newspaper.idnewspaper = article.idnewspaper
        where language != 'en' and  pubdate between TO_DATE('01/01/2018') and TO_DATE('31/12/2018')
    )
);




  
/* 6. Display the most visited articles in each newspaper.  
Schema: (Newspaper_Id, Article_Id, Headline, Num_visits) */

select newspaper.idnewspaper "Newspaper_Id",article.idarticle "Article_Id",article.headline "Headline",sum(article.numvisits) "Num_visits"
from article 
join newspaper on newspaper.idnewspaper = article.idnewspaper


/* 7. Name of the authors that have published articles in ALL newspapers in 
English.
Schema: (Journalist_Id, Journalist_Name)*/



/* 8. Show the name and number of visits of the most famous
journalist(s) (the journalist(s) whose articles have the greatest number of 
visits in total).
Schema: (Journalist_Id, Journalist_Name, TotalVistits) */



/* 9. List the years on which ALL English newspapers have published at least one
article, the total number of articles published on each year and total
number of visits received by those newspapers.
(Hints: (a) you can use GROUP BY clauses with expressions, as for example 
function calls;
(b) you can check the universal condition ("ALL") by checking that the number
of English newspapers that have published articles in some year is equal to the 
total number of English newspapers.)
Schema: (Year, Num_Articles, Num_Visits)*/



/* 10. For each Journalist, obtain the difference between the total number of visits 
received by their articles and the average number of visits received by 
all journalists.
(Hard! this query requires querying two different sets of rows from table 
article: on one hand, the rows grouped by journalist, in order to compute
the sum of visits for each journalist; on the other hand, all rows from all 
journalists in order to compute the average total number of visits for all 
journalists. Then you can compute the difference. This requires two queries.
Hint: think about having subqueries in the FROM clause, one for 
obtaining the total number of visits for each journalist, and another one for 
obtaining the average number of visits received by all journalists.
Finally, the subtraction of these two numbers can be performed.)
Schema: (Journalist_Id, Journalist_Name, Deviation)*/



/* 11. Display the articles that received more visits than the average visits
of the newspaper where they were published.
(Hint: try it with a correlated subquery that computes the average number
of visits for each newspaper)
Schema: (Newspaper_Id, Article_Id, Headline, Num_visits) */



/* 12. Display the articles that received more visits than the average visits
of the newspaper where they were published.
Schema: (Newspaper_Id, Article_Id, Headline, Num_visits, Avg_visits_Newspaper) 
(Hard, because the avg number of visits of the newspaper must be included in the 
result. You can use a subquery in the FROM clause that obtains the newspaper id 
and the average number of visits for each newspaper, and join it with the 
articles to check that the number of visits is greater than the average.)
*/
