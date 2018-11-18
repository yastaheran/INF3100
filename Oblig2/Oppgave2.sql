/* A) kommentar: vi har tre views som inneholder en liste for hver salgsrolle, og dette bruker vi 
for å finne en person som har alle tre rollene for samme bolig */

create view kjopere (personnr, adr, bolignr) as 
select sp.personnr, bs.adr, bs.bolignr
from salgspart sp, Boligsalg bs
where sp.salgsnr = bs.salgsnr and sp.salgsrolle = 'Kjøper';

create view selgere (personnr, adr, bolignr) as
select sp.personnr, bs.adr, bs.bolignr
from salgspart sp, boligsalg sp
where sp.salgsnr = bs.salgsnr and sp.salgsrolle = 'Selger';

create view meglere (personnr, adr, bolignr) as
select sp.personnr, bs.adr, bs.bolignr
from salgspart sp, boligsalg sp
where sp.salgsnr = bs.salgsnr and sp.salgsrolle = 'Megler';

select p.personnr, p.navn, adr, bolignr
from kjopere k, selgere s, meglere me, person p
where k.personnr = s.personnr and s.personnr = me.personnr
	and me.personnr = p.personnr and k.adr = s.adr and s.adr = me.adr
	and k.bolignr = s.bolignr and s.bolignr = me.bolignr;

/* B)kommentar: vi antar at vi skal finne boligene som har hatt flest boligtyper  */
select mnr, count(distinct boligtype) as antallBytter
from boligsalg, (select count(distinct bs1.boligtype) as maks
     		   from boligsalg bs1
		   order by maks desc
		   limit 1) as maks-antall
group by mnr
having count(distinct boligtype) = maks-antall.maks;

/* C)kommentar:  vi har lagd en view som finner alle salg uten megler med salgsnr, og deretter skriver vi ut martikkelnr ved hjelp 
av viewet */

create view salg(salgsnr) as
select salgsnr
from boligsalg bs, salgspart sp
where bs.salgsnr = sp.salgsnr
except
select salgs nr
from boligsalg bs, salgspart sp
where bs.salgsnr = sp.salgsnr and sp.salgsrolle = 'Megler';

select ma.knr, ma.gnr, ma.fnr, ma.snr
from salg s, martikkel ma
where s.mnr = ma.mnr	
