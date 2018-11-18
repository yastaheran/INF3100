/* A. Skriv ut serietittel, produksjonsår og antall episoder for de yngste TVseriene i filmdatabasen 
(dvs. de med størst verdi i attributtet firstprodyear). */

select s.maintitle, s.firstprodyear, count(e.seriesid) as antEpisodes
from series s left outer join episode e on s.seriesid = e.seriesid, (select max(firstprodyear) as 	yr from series) fpy
where s.firstprodyear = fpy.yr
group by s.maintitle, s.firstprodyear;

/* B. Lag en liste over alle deltakelsestyper og hvor mange personer som prosentvis faller inn under hver deltakelsestype. 
Listen skal være sortert etter fallende prosentpoeng. Ta med ett siffer etter desimaltegnet.  */
create view totantall as (select  count(personid) as totAntall from filmparticipation);
select fp.parttype, round(count(fp.personid)*100.0/max(totAntall), 1) as prosent
from filmparticipation fp, film f, totantall
where f.filmid = fp.filmid
group by parttype
order by prosent desc;

/* C. Finn for- og etternavn på alle mannlige regissører som har laget mer enn 50 filmer, og der det er minst én kvinnelig 
skuespiller som har vært med i samtlige filmer av denne regissøren.  */

select p.firstname, p.lastname
from Person p natural join filmparticipation fp
where p.gender = 'M' and fp.parttype = 'director' and fp.filmid IN (select fp2.filmid
    	      	 from person p2 natural join filmparticipation fp2
		 where p2.gender = 'F' and fp2.parttype = 'cast')
group by p.firstname, p.lastname
having count(fp.filmid) > 50
order by p.lastname, p.firstname; 
