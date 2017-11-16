# eliteserien_fantasy
Analyser og data for Eliteserien Fantasy, skrevet i R. Fungerte helt middels, kan sikkert forbedres både resultatmessig og kodemessig. Koden ble over tid vanskelig å vedlikeholde, og krevde en del plunder og manuelt arbeid for å kjøres hvis noe uventa skjedde.

Systemet fungerer ved at 1) data lastes ned fra det åpne APIet til fantasy.vg.no, 2) et eller annet forsøk på å predikere poengsum i neste runde kjøres, basert på historiske data og annet jeg måtte ha liggende, 3) prediksjonen kjøres gjennom en lineær optimering, som setter sammen teamet med maksimal predikert poengsum i neste runde, gitt begrensningene i reglene, tilgjengelige penger og antall bytter, 4) jeg bestemmer meg for hva jeg gjør, og oppdaterer laget og dataene deretter.

##Steg 1: Data
- [datagrabbing_function.R](https://github.com/gardenberg/eliteserien_fantasy/blob/master/scripts/datagrabbing_function.R): en funksjon for å hente data fra APIet til fantasy.vg.no, etter mønster fra [FPL-APIet](https://github.com/bobbymond/FantasyPremierLeagueAPI).
- [kampdatagrabber.R](https://github.com/gardenberg/eliteserien_fantasy/blob/master/scripts/kampdatagrabber.R): en funksjon for å hente informasjon om spilte kamper fra [NIFS.no](www.nifs.no) - deriblant odds.
- [spillerdata_function.R](https://github.com/gardenberg/eliteserien_fantasy/blob/master/scripts/kampdatagrabber.R): lager en tidsserie om skader o.l. for hver enkelt spiller-runde. Baseres seg på filene fra APIet som oppdateres etter hver kamp, men som jeg lagret lokalt hver gang algoritmen ble kjørt.
- sample_data-folderen har noen eksempeldata.

##steg 2: Prediksjon
- Har prøvd naive tilnærminger som "totalt antall poeng til nå = framtidige poeng", "antall poeng i forrige kamp = framtidige poeng", ulike varianter av lineær regresjon, flernivåmodellering og Support Vector Machine. 
- [Her er kode](https://github.com/gardenberg/eliteserien_fantasy/blob/master/md/prediksjon_v2.md) for SVM.
- [ML](https://github.com/gardenberg/eliteserien_fantasy/blob/master/md/prediksjon_3.Rmd).

##Steg 3: Velge lag
- [teamchooser_function](https://github.com/gardenberg/eliteserien_fantasy/blob/master/scripts/teamchooser_function.R).

##Steg 4: Gjør noe lurt
- [dashboard](https://github.com/gardenberg/eliteserien_fantasy/blob/master/md/dashboard.md): For å få et overblikk over hvordan laget så ut, brukte jeg litt grafikk.