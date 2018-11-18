/* Person(fnr, etternavn, fornavn, adresse) 
Ekteskap(dato, fnr1, fnr2, etternavn1, etternavn2) 
ForrigeNavn(dato, fnr, etternavn, fornavn) 

A. Finn ved hjelp av en SQL-spørring navn og adresse til alle personer som ved en vielse i perioden 2000–2010 skiftet etternavn til et navn som er forskjellig fra ektefellens. 
select p.fnr, p.etternavn, p.fornavn, p.adresse
from MyPerson p, ekteskap e, forrigeNavn fn */

where e.dato between '2000-01-01' 
	and '2010-12-31' 
	and (
		(p.fnr = e.fnr1 and e.dato = fn.dato and e.fnr1 = fn.fnr 
		and e.etternavn1 <> fn.etternavn and e.etternavn1 <> e.etternavn2)
		or (p.fnr = e.fnr2 and e.dato = fn.dato and e.fnr2 = fn.fnr and e.etternavn2 		<> fn.etternavn and e.etternavn2 <> e.etternavn1)
	);

/* B. Finn ved hjelp av en SQL-spørring navn og adresse til alle personer som ved en vielse har reversert etternavnene sine.
select p.fnr, p.etternavn, p.fornavn, p.adresse */

from Person p, Person p2, Ekteskap e, ForrigeNavn fn, ForrigeNavn fn2
where e.dato = fn.dato and e.dato = fn2.dato and p.fnr = e.fnr1 and p2.fnr = e.fnr2 
	and e.fnr1 = fn.fnr and e.fnr2 = fn2.fnr 
	and (e.etternavn1 = fn2.etternavn||'-'||fn.etternavn 
		or e.etternavn1 = fn2.etternavn||' '||fn.etternavn)
	and (e.etternavn2 = fn.etternavn||'-'||fn2.etternavn
		or e.etternavn2 = fn.etternavn||' '||fn2.etternavn)
union all
select p2.fnr, p2.etternavn, p2.fornavn, p2.adresse
from Person p, Person p2, Ekteskap e, ForrigeNavn fn, ForrigeNavn fn2
where e.dato = fn.dato and e.dato = fn2.dato and p.fnr = e.fnr1 and p2.fnr = e.fnr2
	and e.fnr1 = fn.fnr and e.fnr2 = fn2.fnr 
	and (e.etternavn1 = fn2.etternavn||'-'||fn.etternavn 
		or e.etternavn1 = fn2.etternavn||' '||fn.etternavn)
	and (e.etternavn2 = fn.etternavn||'-'||fn2.etternavn 
		or e.etternavn2 = fn.etternavn||' '||fn2.etternavn);
