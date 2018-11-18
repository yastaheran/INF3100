/* Selskapsinfo(selskap, rolle, person) 

A. Finn ved hjelp av en rekursiv SQL-spørring hvor mange personer det er på den korteste stien mellom Olav Thorsen og Celina Monsen 
i grafen. */

with recursive stien (forste, siste, psti) as (
select s1.person, s2.person, array[s1.person, s2.person]
from selskapsinfo s1, selskapsinfo s2
where s1.person = 'Olav Thorsen' and s1.person <> s2.person and s1.selskap = s2.selskap
union all
select s.forste, s2.person, s.psti || s2.person
from selskapsinfo s1, selskapsinfo s2, sti s
where cardinality(s.psti) < 5 and s.siste <> 'Celina Monsen' 
	and s.siste = s1.person and s1.person <> s2.person and s2.person <> all(s.psti)
)
select cardinality(psti)-1 as imellom
from stien 
where siste = 'Celina Monsen'
limit 1;

/* B. Finn ved hjelp av en rekursiv SQL-spørring alle sykler som inneholder 3, 4 eller 5 personer, og der hver person har rollen 
‘daglig leder’ i ett selskap og en av rollene ‘styreleder’, ‘nestleder’ eller ‘styremedlem’ i neste selskap i sykelen. Skriv for 
hver slik sykel ut personene og selskapene i sykelen. */

with recursive sykler(forste, siste, personer, selskaper) as (
select s1.person, s2.person, array[s2.person], array[s2.selskap]
from Selskap s1, Selskap s2
where s1.rolle = 'daglig leder' and (s2.rolle = 'styreleder' or s2.rolle = 'nestleder' or s2.rolle = 	'styremedlem') and s1.selskap = s2.selskap and s1.person <> s2.person
union all
select s.pforste, s2.person, s.personer || s2.person, s.selskaper || s2.selskap
from Selskap s1, Selskap s2, sykel s
where s1.rolle = 'daglig leder' and (s2.rolle = 'styreleder' or s2.rolle = 'nestleder' 
	or s2.rolle = 	'styremedlem') and s.siste = s1.person and s1.selskap = s2.selskap 
	and s1.person <> s2.person and s2.selskap <> all(s.selskaper) 
	and s2.person <> all(s.personer)
)
select forste || personer as Personer, selskaper
from sykler
where caridnality(personer) between 3 and 5 and forste = siste;
