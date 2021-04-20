# stats\_ga\_utdanning

(English summary) Scripts for analyzing and visualizing utdanning.no web statistics. 

  
Årlig besøksstatistikk fra utdanning.no. Sidevisningsstatistikk er lastet ned fra Google Analytics og bearbeidet. Datasett for antall sidevisninger pr nettside for hvert år fra 01.01.20XX til 09.03.20XX for hvert år. 

| Feltnavn | Datatype | Forklaring |
| --- | --- | --- |
| `page_url` | varchar | Nettsidens url (kan ha endret seg) |
| `page_title` | varchar | Nettsidens tittel, dvs. det som står innenfor \<title>-taggen.  |
| `page_type` | varchar | Kategorisering av siden for personer som ikke er så kjent med strukturen på utdanning.no.   
Tagget ved hjelp av sql-skriptet `ga_data_cleaning.sql` |
| `year` | int | Årstall statistikken er fra.  |
| `page_views` | int | Antall sidevisninger i løpet av året ( `year`).  |
| `page_views_pst` | float | Hvor stor andel av dette årets sidevisninger som besøket av denne nettsiden utgjorde |
| `unique_page_views` | int | Antall unike sidevisninger i løpet av året ( `year`). Hvis bruker går tilbake til en side hun har vært på før, telles de bare én gang innen et visst tidsintervall.  |
| `unique_page_views_pst` | float | Hvor stor andel av dette årets unike sidevisninger som besøket av denne nettsiden utgjorde |
| `entrances` | int | Antall ganger en bruker har landet på nettstedet gjennom denne nettsiden.  |
| `entrances_pst` | float | Andel av alle innganger i løpet av året på nettstedet som har kommet gjennom denne nettsiden.  |
| `bounce_rate_pst` | float | Fluktfrekvens, andel brukere som bare besøker denne ene siden, og ikke går videre på nettstedet  |
| `exit_pst` | float | Andel som forlater nettstedet på denne siden.  |
| `avg_time_on_page` | time | Gjennomsnittlig tid en bruker har brukt på denne siden. NB vanskelig å vite når et besøk er avsluttet.  |
