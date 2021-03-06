
  

library(readr)
library(tidyverse)
library(ggthemes)
library(plotly)


#### Henter inn bes�kstatistikk fra statisk fil hentet fra Google Analytics. Antall ansatte hentes fra statisk fil fra Arbeidstakerregisteret(via Stryk-08)

setwd("C:\\Users\\torm\\OneDrive - Kompetanse Norge\\Dokumenter\\GitHub\\stats_ga_utdanning")

# Importere TSV-fil i R 
ga_pw_utdanningno_data <- as_tibble(read_delim("./data/ga_pw_utdanningno_data.tsv", "\t", 
                                               na = "NULL",
                                               escape_double = FALSE, 
                                               col_types = cols(
                                                 year = col_integer(),
                                                 page_views = col_integer(), 
                                                 unique_page_views = col_integer(),
                                                 entrances = col_integer(), 
                                                 avg_time_on_page = col_time(format = "%H:%M:%S")
                                               ), 
                                               locale = locale(date_names = "nb"), 
                                               trim_ws = TRUE))

#View(ga_pw_utdanningno_data)

#Henter inn data fra arbeidstakerregisteret
employment <- as_tibble(read_delim("./data/yrkesbeskrivelse_antall_ansatte.tsv", "\t"))
emp <- employment %>%
  select(page_title, antall_ansatte) %>%
  mutate(rank_ansatte= percent_rank(antall_ansatte)*100, rank_ansatte_gruppe = ifelse(percent_rank(antall_ansatte)>.8, "H�yt antall ansatte", ifelse(percent_rank(antall_ansatte)>.3, "Middels antall ansatte", "Lavt antall ansatte")))

ga_pw_utdanningno_data <- left_join(ga_pw_utdanningno_data, emp, by= "page_title")


### Finner de mest bes�kte yrkessidene i 2013 og 2021




df.21 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2021, page_type == "yrke") %>%
  slice_max(page_views_pst, n=10) %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))

df.13 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2013, page_type == "yrke") %>%
  slice_max(page_views_pst, n=10) %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))

#### 2013

(top10.13 <- df.13$page_title)

#### 2021

(top10.21 <- df.21$page_title)


#Sykepleier, ingeni�r, psykolog, lege, advokat og helefagarbeider g�r igjen blant de 10 mest bes�kte yrkene b�de i 2013 og 2021. Fellesnevneren er at dette er statusyrker og/eller knyttet til helse. 


### Utviklingen i bes�kssandel fra 2013 til 2021 for de mest bes�kte yrkene i 2021 og 2013

#Sykepleier er det klart mest bes�kte yrket (med untak av i 2014 der ingeni�r l� h�yest). I 2021 har 67 400 (0,85 prosent av alle sidevisninger) bes�kt yrketbeskrivelsen. Neste p� lista er psykolog med 36 300 (0,46 prosent). Sykepleier har nesten dobbelt s� mange bes�k som psykolog. 



df.1 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, page_type == "yrke") %>%
  select(page_title, year, page_views_pst, page_views, rank_ansatte, rank_ansatte_gruppe) %>%
  arrange(desc(page_views_pst))

df.2 <- df.1[df.1$page_title %in% top10.21,]

# df.2 %>%
#   select(page_title, year, rank_ansatte, rank_ansatte_gruppe) %>%
#   filter(year == 2021) %>%
#   rename(Yrke = page_title)

a <- ggplot(df.2, aes(x=as.character(year), y=page_views_pst*100, group= page_title, text= paste("Yrke:", page_title))) 
a <- a + geom_line(aes(color= page_title, label=rank_ansatte_gruppe, label2= rank_ansatte), size= 1) + xlab("�r") + ylab("Prosentandel av sidevisninger") + labs(color= "Yrke", title="Utvikling til de mest bes�kte yrkesbeskrivelsene i 2021") +
  ggthemes::theme_economist()

ggplotly(a, tooltip = c("label", "label2","text"))


#Ved � holde mark�ren over et yrke i grafen vises informasjon om antall ansatte med det yrket. H�yt antall ansatte er definert som de 20% yrkene med flest ansatte. Verdien rank_ansatt angir hvor vanlig yrket er fra 100 (yrket med flest ansatte) til 0 (yrket med f�rrest ansatte). 
   

df.3 <- df.1[df.1$page_title %in% top10.13,]

# df.3 %>%
#   select(page_title, year, rank_ansatte, rank_ansatte_gruppe) %>%
#   filter(year == 2013) %>%
#   rename(Yrke = page_title)

b <- ggplot(df.3, aes(x=as.character(year), y=page_views_pst*100, group= page_title, text= paste("Yrke:", page_title))) 
b <- b + geom_line(aes(color= page_title, label=rank_ansatte_gruppe, label2= rank_ansatte), size= 1) + xlab("�r") + ylab("Prosentandel av sidevisninger") + 
  labs(color= "Yrke", title="Utvikling til de mest bes�kte yrkesbeskrivelsene i 2013") +
  ggthemes::theme_economist()
ggplotly(b, tooltip = c("label", "label2","text"))


# De mest bes�kte yrkesbeskrivelsene fra 2013 har med unntak av sykepleier g�tt ned eller stagnert m�lt etter prosentandel sidevisninger. Det kan forklares av at mange nye yrker har kommet inn i denne perioden. Det kan likevel nevnes at det er en klar nedgang i bes�k for ingeni�r og til dels sivil�konom.  



# ```
# 
# ```{r stolpediagram, include=F}
# # stolpediagram i Ggplot2
# # "year" p� ordinalniv� for � vise alle �r  
# ggplot(df_sykepleier, aes(x=as.character(year), y=page_views_pst*100)) +
#   xlab("�r") + ylab("Prosentandel av sidevisninger") + 
#   geom_bar(stat="identity", fill="steelblue") +
#   geom_text(aes(label=page_views), vjust=1.6, color="white", size=3.5) +
#   labs(title = "Sidevisninger p� yrket sykepleier") + 
#   # ggthemes::theme_economist() + ggthemes::scale_colour_economist()
#   ggthemes::theme_fivethirtyeight()
# ```


### Hvilke yrketsbeskrivelser har st�rst endring i bes�k mellom 2013 og 2021

# ```{r, echo=F, include=F}

df.4 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2021 | year== 2013, page_type == "yrke") %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))


freq <- data.frame(table(df.4$page_title)) #number of occurences 
yrke.2years <- as.character(freq$Var1[freq$Freq == 2]) #finding ocupations with both years

df.5 <- df.4[df.4$page_title %in% yrke.2years,] #excluding ocupations with only one occurence
# df.5 <- df.5[order(df.5$page_title),]

df.5.13 <- df.5[df.5$year == 2013,] #object for 2013
#df.5.13 <- df.5.13[order(df.5.13$page_title),]
df.5.13 <- arrange(df.5.13, page_title)


df.5.21 <- df.5[df.5$year == 2021,] #object for 2021
df.5.21 <- arrange(df.5.21, page_title)

#test that both years are sorted correct
all.equal(df.5.13[,1], df.5.21[,1]) #should be true

#new df with difference 2021 and 2013
diff <- data.frame(df.5.13$page_title, df.5.13$page_views_pst, df.5.21$page_views_pst, df.5.21$page_views_pst-df.5.13$page_views_pst) 
names(diff) <- c("page_title", "2013", "2021", "increase_page_views_pst")
diff <- arrange(diff, desc(increase_page_views_pst))

diff.1 <- bind_rows(slice_head(diff,n=5), slice_tail(diff, n=5)) #looking only at a few
diff.2 <- bind_rows(slice_head(diff,n=20), slice_tail(diff, n=20)) #looking only at some more 
diff.2 <- left_join(diff.2, emp, by="page_title") # joining with employment data

diff.2 <-diff.2 %>%
  select(-antall_ansatte) %>%
  mutate_if(is.numeric, round,4) %>%
  mutate(rank_ansatte = round(rank_ansatte, 1)) %>%
  mutate(rank_ansatt_gruppe = word(rank_ansatte_gruppe, 1)) %>%
  rename(yrke=page_title, endring_pst=increase_page_views_pst, rank_gruppe=rank_ansatt_gruppe) %>%
  select(-rank_ansatte_gruppe)

# ```

#### Tabell med de 40 yrkene med st�rst endring i prosentvise sidevisninger fra 2013 til 2021.
# 
# De 20 f�rste har st�rst �kning (h�yest �kning f�rst), mens de 20 siste har st�rst nedgang. Tabellen viser at det prim�rt er yrker med mange ansatte som har de st�rste endringene. Kun 7 yrker er under medianen av antall ansatte (rank_ansatt<50). 
# 
# 
# ```{r, echo=F, warning=F, fig.width=10}
# knitr::kable(diff.2)  

# Plot occupations with largest effect
diff.long <- diff.1 %>% 
  gather("year", "page_views_pst", '2013':'2021') 

#Join with employment data
diff.long <- left_join(diff.long, emp, by="page_title")


c <- ggplot(diff.long, aes(x=as.character(year), y=page_views_pst*100, group= page_title, text= paste("Yrke:", page_title))) 
c <-   c + geom_line(aes(color= page_title, label= rank_ansatte_gruppe, label2= rank_ansatte), size= 1) + xlab("�r") + ylab("Prosentandel av sidevisninger") + labs(color= "Yrke", title = "Endring i prosentandel sidevisinger til de yrkene m st�rst endring fra 2013 til 2021") +
  ggthemes::theme_economist()
ggplotly(c, tooltip = c("label", "label2","text"))


# ```
# Oppsummert ser vi at �kningen er h�yest for yrker innenfor omsorg og helse med relativt mange ansatte. Det er dermed ikke de best betalte yrkene/prestisjeyrker som har st�rst �kningen i bes�k. Likevel ser vi en �kning for blant annet aksjemegler, pilot og advokat.  
# 
# Bes�ksandelen har g�tt ned for yrker ned for annerkjente yrker med h�yt antalle ansatte. Noen av disse har det v�rt oppmerksomhet rundt behov i tiden fremover feks: ingen�r og dataingen�r.  
# 
# # Ser p� utvikling for utdanningsbeskrivelser
# 
# ```{r, include=F}

dfu.21 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2021, page_type == "utdanningsbeskrivelse") %>%
  slice_max(page_views_pst, n=10) %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))

dfu.13 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2013, page_type == "utdanningsbeskrivelse", page_title!="") %>%
  slice_max(page_views_pst, n=10) %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))

(top10.13u <- dfu.13$page_title)
top10.13u <- na.omit(top10.13u)
(top10.21u <- dfu.21$page_title)

# ```
# 
# #### Utvikling i prosentandel av sidevisninger over tid for de mest bes�kte utdanningsbeskrivelsene i 2013 and 2021
# ```{r, echo=F, fig.width=10}
dfu.1 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, page_type == "utdanningsbeskrivelse") %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))

dfu.2 <- dfu.1[dfu.1$page_title %in% top10.21u,]

e <- ggplot(dfu.2, aes(x=as.character(year), y=page_views_pst*100, group= page_title, text= paste("Utdanning:", page_title))) 

e <- e + geom_line(aes(color= page_title), size= 1) + xlab("�r") + ylab("Prosentandel av sidevisninger") + labs(color= "Utdanningsbeskrivelse", title="Utvikling til de mest bes�kte Utdanningsbeskrivelsene i 2021") + ggthemes::theme_economist()
ggplotly(e, tooltip = "text")

# ```
# �kningen i bes�k for utdanningsbeskrivelser f�lger det vi s� for ykene. Sykepleie og psykologiutdanningen er mest bes�kt. Disse yrkene l� ogs� �verst i 2021. 
# Merk: Det er en datafeil for Sykpleier 2019 og Vidreutdanning for sykepleiere 2021. Fallet vi ser for disse to punktene er ikke reelt. 
# ```{r, echo=F, fig.width=10}

dfu.3 <- dfu.1[dfu.1$page_title %in% top10.13u,]
f <- ggplot(dfu.3, aes(x=as.character(year), y=page_views_pst*100, group= page_title, text= paste("Utdanning:", page_title))) 

f <- f + geom_line(aes(color= page_title), size= 1) + xlab("�r") + ylab("Prosentandel av sidevisninger") + labs(color= "Utdanningsbeskrivelse", title="Utvikling til de mest bes�kte Utdanningsbeskrivelsene i 2013") +
  ggthemes::theme_economist()
ggplotly(f, tooltip = "text")

# ```
# 
# 
# 
# ### Hvor endringen i interesse v�rt st�rst for utdanningsbeskrivelser
# 
# ```{r, include=F}

dfu.4 <- ga_pw_utdanningno_data %>%
  filter(page_views_pst < 1, year == 2021 | year== 2013, page_type == "utdanningsbeskrivelse") %>%
  select(page_title, year, page_views_pst, page_views) %>%
  arrange(desc(page_views_pst))


freq.u <- data.frame(table(dfu.4$page_title)) #number of occurences 
ut.2years <- as.character(freq.u$Var1[freq.u$Freq == 2]) #finding ocupations with both years NB: Some education programs have 3 or 4 occurences 

dfu.5 <- dfu.4[dfu.4$page_title %in% ut.2years,] #excluding ocupations with more or less occurences


dfu.5.13 <- dfu.5[dfu.5$year == 2013,] #object for 2013
dfu.5.13 <- arrange(dfu.5.13, page_title)


dfu.5.21 <- dfu.5[dfu.5$year == 2021,] #object for 2021
out <- data.frame(table(dfu.5.21$page_title)) #Helseadminstrasjon comes twice in 2021
out <- as.character(out$Var1[out$Freq != 1])
dfu.5.21 <- dfu.5.21[! dfu.5.21$page_title %in% out,]    

dfu.5.21 <- arrange(dfu.5.21, page_title)

#test that both years are sorted correct
all.equal(dfu.5.13[,1], dfu.5.21[,1]) #should be true

# ```
# Tilsvarende tabell som for yrkene. De 20 utdanningene med mest �kning �verst og de med st�rst nedgang er de 20 nederste radene. Nesten alle utdanningene har en prosentvising �kning. Det usikkert for meg hvordan dette har seg.  
# 
# Handel og markedsf�ring og �konomi og adminstrasjon har den klart st�rste nedgangen. Derimot har �konomisk-adminstrative fag en tydelig oppgang. De to sistnevnte virker kun som en navneendring og endringen mellom dem ser ikke reell ut. 
# 
# ```{r, echo=F}

#new df with difference 2021 and 2013
diff.u <- data.frame(dfu.5.13$page_title, dfu.5.13$page_views_pst, dfu.5.21$page_views_pst, dfu.5.21$page_views_pst-dfu.5.13$page_views_pst) 
names(diff.u) <- c("page_title", "page_views_pst_13", "page_views_pst_21", "increase_page_views_pst")
diff.u <- arrange(diff.u, desc(increase_page_views_pst))

diff.u1 <- bind_rows(slice_head(diff.u,n=5), slice_tail(diff.u, n=5)) #looking only at a few
diff.u2 <- bind_rows(slice_head(diff.u,n=20), slice_tail(diff.u, n=20)) #looking only at some more 

diff.u2 <- diff.u2 %>%
  rename(Utdanning=page_title, Endring_pst=increase_page_views_pst, '2013'=page_views_pst_13, '2021'=page_views_pst_21)


knitr::kable(diff.u2)


# ```
