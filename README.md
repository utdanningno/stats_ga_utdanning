# stats\_ga\_utdanning

(English summary) Data sets and scripts for analyzing and visualizing page view statistics from Norwegian web site [utdanning.no](https://utdanning.no/tema/om_utdanning.no/about_utdanning.no). Data downloaded from utdanning.no's Google Analytics account. Current data set from 2013 to 2021. 

Årlig besøksstatistikk fra utdanning.no. Sidevisningsstatistikk er lastet ned fra Google Analytics og bearbeidet. Datasett for antall sidevisninger pr nettside for hvert år fra 01.01.20XX til 09.03.20XX for hvert år. 

Datasettet har tall for 57 millioner sidevisninger siden 2013, 41 millioner unike sidevisninger og 14 millioner innganger. 

# Spørsmål en kan finne ut av datasettet 

*   **Hva er trendene i besøkstallet**? Hvilke utdanninger er brukerne mer/mindre interessert i, i følge besøkstallet? For yrker, utdanningskategorier og utdanningstilbud? Sikkert endel støy som følge av sidenes google-ranking.
*   Hvordan lage visualiseringer som gjør det lett å vise utviklingen pǻ et yrke/utdanning slik at alle interesserte kunne kikket på tallene? Kunne dette vært vist ved å lage enkle visualiseringer i [plot.ly](https://plotly.com/r/) eller [Ggplot2](https://ggplot2.tidyverse.org/)?
*   **Er det korrelasjon mellom søkertall for en utdanning og besøkstall på utdanning.no for det samme**? Interessant å se hvor det er størst korrelasjon eller misforhold. Undersøsker elever en utdanning, men blir skremt fra å søke den (pga. lønn/status/utdanningslengde etc)? For å finne ut dette må dataene kobles til søknadstallene fra Samordna opptak [tilgjengelig fra DBHs datavarehus](https://dbh.nsd.uib.no/statistikk/rapport.action?visningId=132&visKode=false&admdebug=false&columns=arstall&index=1&formel=294&hier=insttype!9!instkode!9!fakkode!9!ufakkode!9!progkode&sti=&param=arstall%3D2021!8!2020!8!2019!9!dep_id%3D1!9!nivakode%3DB3!8!B4!8!HK!8!YU!8!AR!8!LN!8!M2!8!ME!8!MX!8!HN!8!M5!8!PR).

# Feltoppsett i datasett

I tillegg til felt for besøksstatisitikk for enkeltsider, er det rader med `page_url` satt til `ALLE20XX`, hvor årstall er summen av alle besøk dette året. 

| Feltnavn | Datatype | Forklaring |
| --- | --- | --- |
| `page_url` | varchar | Nettsidens url (kan ha endret seg) |
| `page_title` | varchar | Nettsidens tittel, dvs. det som står innenfor \<title>-taggen. |
| `page_type` | varchar | Kategorisering av siden for personer som ikke er så kjent med strukturen på utdanning.no. Tagget ved hjelp av sql-skriptet `ga_data_cleaning.sql` |
| `year` | int | Årstall statistikken er fra. |
| `page_views` | int | Antall sidevisninger i løpet av året ( `year`). |
| `page_views_pst` | float | Hvor stor andel av dette årets sidevisninger som besøket av denne nettsiden utgjorde |
| `unique_page_views` | int | Antall unike sidevisninger i løpet av året ( `year`). Hvis bruker går tilbake til en side hun har vært på før, telles de bare én gang innen et visst tidsintervall. |
| `unique_page_views_pst` | float | Hvor stor andel av dette årets unike sidevisninger som besøket av denne nettsiden utgjorde |
| `entrances` | int | Antall ganger en bruker har landet på nettstedet gjennom denne nettsiden. |
| `entrances_pst` | float | Andel av alle innganger i løpet av året på nettstedet som har kommet gjennom denne nettsiden. |
| `bounce_rate_pst` | float | Fluktfrekvens, andel brukere som bare besøker denne ene siden, og ikke går videre på nettstedet |
| `exit_pst` | float | Andel som forlater nettstedet på denne siden. |
| `avg_time_on_page` | time | Gjennomsnittlig tid en bruker har brukt på denne siden. NB vanskelig å vite når et besøk er avsluttet. |

# Automatisering?

Dette datasettet er statisk (lasta ned en gang). Men det er mulig å skripte uthenting av et slikt datasett fra Google Analytics, hvis en har en OAuth-pålogging (i R med pakken googleAnalyticsR, andre språk har løsninger for det.)

# Kobling til andre datasett?

Sidene er tagget med
