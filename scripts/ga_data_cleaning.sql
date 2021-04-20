# Datavask av Google Analytics statistikk for besøk til utdanning.no


# formål kategorisere sidene i feltet "page_type"

UPDATE ga_pw_utdanningno_data SET page_type = "SUM", page_title = "SUM" WHERE page_url LIKE "ALLE%" ;

UPDATE ga_pw_utdanningno_data SET page_type = "yrke" WHERE page_url LIKE "/yrker/beskrivelse/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "utdanningsbeskrivelse" WHERE page_url LIKE "/studiebeskrivelse/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "bedrifter" WHERE page_url LIKE "/arbeidsliv/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "bedrifter" WHERE page_url LIKE "/bedrift/%" ;

# verktøy
UPDATE ga_pw_utdanningno_data SET page_type = "v-jobbkompasset" WHERE page_url LIKE "/jobbkompasset/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "v-karakterkalkulator" WHERE page_url LIKE "/karakterkalkulator%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "v-karriereplanleggeren" WHERE page_url LIKE "/karriereplanleggeren%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "v-utdanningssystemet" WHERE page_url LIKE "/utdanningssystemet%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "v-likestilling" WHERE page_url LIKE "/likestilling" ;
UPDATE ga_pw_utdanningno_data SET page_type = "v-arbeidsmarkedet" WHERE page_url LIKE "/arbeidsmarkedet%" ;


# internsøk
UPDATE ga_pw_utdanningno_data SET page_type = "internsøk" WHERE page_url LIKE "/sok%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "internsøk" WHERE page_url LIKE "/finn%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "internsøk" WHERE page_url LIKE "/nn/sok%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "internsøk" WHERE page_url LIKE "/search%" ;



UPDATE ga_pw_utdanningno_data SET page_type = "hjemmeside", page_title = "forside"  WHERE page_url = "/" ;
UPDATE ga_pw_utdanningno_data SET page_type = "hjemmeside" WHERE page_url = "/verktoy" ;
UPDATE ga_pw_utdanningno_data SET page_type = "hjemmeside" WHERE page_url = "/yrkesbeskrivelser" ;
UPDATE ga_pw_utdanningno_data SET page_type = "hjemmeside" WHERE page_url = "/utdanningsbeskrivelser" ;

UPDATE ga_pw_utdanningno_data SET page_type = "hjemmeside",
	page_title = "Interesseoversikt"
WHERE page_url LIKE "/interesseoversikt%" ;

UPDATE ga_pw_utdanningno_data SET page_type = "geografi" WHERE page_url LIKE "/landsdeler/%" ;

# org
UPDATE ga_pw_utdanningno_data SET page_type = "organisasjon" WHERE page_url LIKE "/org/%" ;

# utdanninger enkeltutdananingsprogrammer
UPDATE ga_pw_utdanningno_data SET page_type = "utdanning-vgs" WHERE page_url LIKE "/utdanning/vgs/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "utdanning-f" WHERE page_url LIKE "/utdanning/fagskole/%" ;
UPDATE ga_pw_utdanningno_data SET page_type = "opptakskrav" WHERE page_url LIKE "/utdanning/opptakskrav%" ;

UPDATE ga_pw_utdanningno_data SET page_type = "utdanning-uh" WHERE page_url LIKE "/utdanning/%" AND page_url LIKE "%.no/%" ;

# slette helt interne sider
DELETE FROM ga_pw_utdanningno_data WHERE page_url = "/sitemap" ;
DELETE FROM ga_pw_utdanningno_data WHERE page_url = "/user" ;
DELETE FROM ga_pw_utdanningno_data WHERE page_url LIKE "/node/%" ;

# se på alle som ikke har blitt tagget med
SELECT * FROM ga_pw_utdanningno_data WHERE page_type IS NULL ORDER BY pageviews DESC LIMIT 1000 ;