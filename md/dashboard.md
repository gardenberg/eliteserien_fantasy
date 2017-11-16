Dashboard mellom rundene
================

(Sist oppdatert før runde 11)

``` r
#fordeling av poeng i forrige runde
summary(filter(df_lag,dato=="2017-05-31")$event_total)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.00   29.00   34.00   34.98   40.00   94.00

``` r
#fordeling av poeng over alle runder
summary(df_lag$event_total)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   -4.00   31.00   39.00   40.04   47.00  113.00

``` r
#mine poeng over alle runder
summary(filter(df_lag,player_name=="Eivind Hageberg")$event_total)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   28.00   34.50   39.00   41.55   44.00   70.00

``` r
#mine lagdata etter runde
kable(arrange(filter(df_lag,player_name=="Eivind Hageberg"),dato))
```

|      id| entry\_name |  event\_total| player\_name    | movement | own\_entry |   rank|  last\_rank|  rank\_sort|  total|  entry|  league|  start\_event|  stop\_event| dato       |
|-------:|:------------|-------------:|:----------------|:---------|:-----------|------:|-----------:|-----------:|------:|------:|-------:|-------------:|------------:|:-----------|
|  194007| Moneyball   |            34| Eivind Hageberg | new      | FALSE      |  48416|           0|       49429|     34|  36536|     319|             1|           30| 2017-04-04 |
|  194007| Moneyball   |            54| Eivind Hageberg | up       | FALSE      |  30723|       48416|       31253|     88|  36536|     319|             1|           30| 2017-04-07 |
|  194007| Moneyball   |            36| Eivind Hageberg | up       | FALSE      |  26879|       30723|       27107|    124|  36536|     319|             1|           30| 2017-04-11 |
|  194007| Moneyball   |            46| Eivind Hageberg | down     | FALSE      |  26886|       26879|       27013|    170|  36536|     319|             1|           30| 2017-04-19 |
|  194007| Moneyball   |            39| Eivind Hageberg | down     | FALSE      |  33366|       29605|       33475|    209|  36536|     319|             1|           30| 2017-04-25 |
|  194007| Moneyball   |            35| Eivind Hageberg | down     | FALSE      |  36216|       33366|       36301|    244|  36536|     319|             1|           30| 2017-05-02 |
|  194007| Moneyball   |            28| Eivind Hageberg | down     | FALSE      |  40085|       36216|       40139|    272|  36536|     319|             1|           30| 2017-05-09 |
|  194007| Moneyball   |            42| Eivind Hageberg | up       | FALSE      |  34687|       40085|       34728|    314|  36536|     319|             1|           30| 2017-05-14 |
|  194007| Moneyball   |            70| Eivind Hageberg | up       | FALSE      |  19292|       34687|       19336|    384|  36536|     319|             1|           30| 2017-05-18 |
|  194007| Moneyball   |            31| Eivind Hageberg | down     | FALSE      |  25109|       19292|       25145|    415|  36536|     319|             1|           30| 2017-05-24 |
|  194007| Moneyball   |            42| Eivind Hageberg | up       | FALSE      |  21806|       25109|       21842|    457|  36536|     319|             1|           30| 2017-05-31 |

Jeg har over de første ti rundene i gjennomsnitt fått 37.5 poeng per runde - i et spenn fra 70 til 28 poeng. Med 415 poeng ligger jeg over medianen og gjennomsnittet, men under grensa fra 3 kvartil - altså blant de 50 % beste, men ikke 25 % beste. I runde 10 gikk det enda litt oppover med 42 poeng.

![](dashboard_files/figure-markdown_github/unnamed-chunk-3-1.png)![](dashboard_files/figure-markdown_github/unnamed-chunk-3-2.png)![](dashboard_files/figure-markdown_github/unnamed-chunk-3-3.png)![](dashboard_files/figure-markdown_github/unnamed-chunk-3-4.png)

I starten gikk det oppover, men fjerde til sjuende runde har gitt fall i plasseringa. I fjerde runde lå jeg fortsatt over medianen for utdelte event-poeng i den runden, men i femte, sjette og sjuende runde har jeg ligget under. Årsaken ser ut til å være små marginer på feil side: Rosteds utvisning og Sarpsborgs påfølgende tap, en kjip femte runde, og en sjette runde hvor hverken Odd, Brann eller RBK klarte å holde 0 helt i mål - og hvor Bendtner plutselig skaffe seg masse poeng i runde seks (når han satt på min benk). Sjuende runden var også bare sorgen - kronet av Kaptein Hansens skade i 59.30 minutt, som ga ham 2 poeng i stedet for de 12 poengene han ville fått i det sekstiende minutt. Over hvor mange runder må marginene helle i feil retning for at det er et mønster?

Niende runde ga 70 poeng, og dermed et kraftig byks oppover. Tiende runde var derimot med 31 poeng mer normalt - og en indikasjon på at jeg bør utløse wildcardet nå for å få nytte av det, i et håp om å hoppe enda litt lenger opp på tabellen. Den påfølgende runden ga med 42 poeng et lite løft, men langtifra det rykket jeg hadde håpa på.

### Spillertroppen

``` r
kable(arrange(select(filter(df,team_now==1),id,navn,posisjon,team_navn,total_points,points_per_game,status,news,chance_of_playing_this_round,chance_of_playing_next_round,in_dreamteam),posisjon,desc(total_points)),caption="Nåværende 15 spillere")
```

|   id| navn              | posisjon | team\_navn |  total\_points| points\_per\_game | status | news                             |  chance\_of\_playing\_this\_round|  chance\_of\_playing\_next\_round| in\_dreamteam |
|----:|:------------------|:---------|:-----------|--------------:|:------------------|:-------|:---------------------------------|---------------------------------:|---------------------------------:|:--------------|
|    1| Andreas Lie       | Keeper   | AAFK       |             60| 5.5               | a      |                                  |                                NA|                                NA| TRUE          |
|  268| Sayouba Mande     | Keeper   | STB        |             38| 3.8               | a      |                                  |                                NA|                                NA| FALSE         |
|   33| Gilli Sørensen    | Forsvar  | BRA        |             64| 5.8               | a      |                                  |                                NA|                                NA| TRUE          |
|  150| Thomas Grøgaard   | Forsvar  | ODD        |             57| 5.2               | a      |                                  |                                NA|                                NA| TRUE          |
|  172| Tore Reginiussen  | Forsvar  | RBK        |             45| 4.1               | a      |                                  |                                NA|                                NA| FALSE         |
|  148| Steffen Hagen     | Forsvar  | ODD        |             42| 3.8               | i      | Ukjent - Sjanse for å spille: 0% |                                NA|                                NA| FALSE         |
|    9| Daníel Grétarsson | Forsvar  | AAFK       |             40| 4.0               | a      |                                  |                                NA|                                NA| FALSE         |
|  277| Tonny Brochmann   | Midtbane | STB        |             64| 5.8               | a      |                                  |                                NA|                                NA| TRUE          |
|  132| Sander Svendsen   | Midtbane | MOL        |             51| 5.1               | a      |                                  |                                NA|                                NA| FALSE         |
|  164| Riku Riski        | Midtbane | ODD        |             49| 4.5               | a      |                                  |                                NA|                                NA| FALSE         |
|  184| Fredrik Midtsjø   | Midtbane | RBK        |             45| 4.1               | a      |                                  |                                NA|                                NA| FALSE         |
|  279| Luc Kassi         | Midtbane | STB        |             45| 4.1               | a      |                                  |                                NA|                                NA| FALSE         |
|  137| Björn Sigurdarson | Angrep   | MOL        |             58| 5.3               | a      |                                  |                                NA|                                NA| TRUE          |
|   44| Jakob Orlov       | Angrep   | BRA        |             47| 5.2               | a      |                                  |                                NA|                                NA| FALSE         |
|   93| Benjamin Stokke   | Angrep   | KBK        |             43| 3.9               | a      |                                  |                                NA|                                NA| FALSE         |

Rosted fikk rødt kort i runde fire, og måtte stå over runde 5. Før runde 6 og 7 ser alt greit ut. Før runde 8 er Hansen skada og Ruud suspendert, og de må dermed byttes ut. Det samme så ut til å gjelde før runde 9, men det viste seg å ha mer med hvor ofte dataene oppdateres av VG. Ingenting er i veien før runde 10.

Før runde 11 er Kastrati suspendert. Like greit, siden han ikke leverer - se grafen under. Etter cuprunden mellom runde 10 og 11 fortalte også jungeltelegrafen/twitter at Espen Ruud var blitt suspendert (uten at datasettet var oppdatert av den grunn). Før runde 12 ser alt greit ut med det nye mannskapet, men i og med at det har vært ei cuprunde og VG (eller hvem det nå er som er ansvarlig) har vært treige med oppdateringer av skadestatus så er det ekstra viktig å ha riktig rekkefølge på benken.

![](dashboard_files/figure-markdown_github/unnamed-chunk-5-1.png)![](dashboard_files/figure-markdown_github/unnamed-chunk-5-2.png)

Mange av spillerne har, etter å ha prestert godt i starten av sesongen, hatt en negativ trend. Er det middelmådge spillere som nå spiller som normalt, eller gode spillere som har en dårlig periode? Men selv om poengene har sunket, har verdien på laget mitt heldigvis gått i riktig retning igjen - men Bendtner ser ut til å tapt seg med 0.1.

Før runde 7 håper jeg virkelig at jeg ser naturlig variasjon, og ikke en synkende trend - mange av spillerne har lineære trender på vei nedover gjennom de siste kampene. Trenden fortsatte imidlertid for flere av spillerne i runde 7 - noe som ga det dårlige resultatet. Tålmodigheten med Bendtner nærmer seg veldig slutt.

Etter runde 8 ser bildet ut til å fortsette: Enkelte spillere har hatt et par gode runder helt først, men ikke levert jevnt over de siste (ca.)5 kampene: Trondsen, Kastrati, Shuaibu, Matthew, Rosted.

Før runde 10 ser vi at både Kastrati, Shuaibu og Matthew har prestert under forventa, og at det kan ha dreid seg om en over gjennomsnittlig god start på året for disse. Nouri, Sigurdarson, Ruud, Kristiansen og Svendsen har derimot gjennomggående flere tilfeller hvor de har sanka flere poeng.

Runde 10 var ikke en slik runde, og jeg ønsker nå å bruke wildcardet. Kjekt nok for irritasjonen viste runde 11 at samtlige nye spillere (unntatt Kassi, som jeg benka) presterte under trendlinja.

#### Etterpågrafen

``` r
#poeng for de jeg har solgt
ggplot(aes(x=round,y=total_points),data=df_spillerdata[df_spillerdata$id_player %in% filter(df,(team_past==1))$id,])+
        facet_wrap(~navn)+
        geom_point()+
        geom_line(aes(colour=as.factor(myteam)))+
        geom_smooth(method="lm")+
        labs(colour="På laget mitt")+
        scale_x_continuous(breaks=min(df_spillerdata$round):max(df_spillerdata$round),labels=min(df_spillerdata$round):max(df_spillerdata$round))
```

![](dashboard_files/figure-markdown_github/unnamed-chunk-6-1.png)

``` r
#verdi for de jeg har solgt
ggplot(aes(x=round,y=value),data=df_spillerdata[df_spillerdata$id_player %in% filter(df,(team_past==1))$id,])+
        facet_wrap(~navn)+
        geom_point()+
        geom_line(aes(colour=as.factor(myteam)))+
        labs(colour="På laget mitt")+
        scale_x_continuous(breaks=min(df_spillerdata$round):max(df_spillerdata$round),labels=min(df_spillerdata$round):max(df_spillerdata$round))
```

![](dashboard_files/figure-markdown_github/unnamed-chunk-6-2.png)

Fram til wildcardet ble brukt før runde 11 var det en fattig trøst at de solgte spillerne ikke har bidratt stort så langt, og har falt i pris. Rosted såg hakket hvassere ut i den runda - men ikke så mange andre.

``` r
qplot(as.factor(team_now),total_points,geom="boxplot",data=filter(df_spillerdata,is.na(team_now)==FALSE),facets=~posisjon)
```

![](dashboard_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
qplot(as.factor(round),total_points,geom="boxplot",data=filter(df_spillerdata,is.na(team_now)==FALSE),colour=as.factor(team_now),facets=~posisjon)
```

![](dashboard_files/figure-markdown_github/unnamed-chunk-7-2.png)

Etter runde 7: Selv om laget ikke gjør det så bra, ligger de utvalgte spillerne fortsatt i hovedsak over 75-persentilen - altså er de utvalgte spillerne bedre enn 75 prosent av alle spillere. Unntaket er forsvarsspillerne - og i runde 7 presterte både midtbane og angrep veldig gjennomsnittlig. I runde 8 lå de derimot over snittet.

### Lagforbedring

Jeg har både gjort bytter rett etter ferdigspilt runde (for å være sikker på at spillerne mine beholder verdien), og rett før neste runde (for å være sikker på å få med informasjonen i prisendringer og popularitet, som gir nyttig info til algoritmen). Ved nærmere ettertanke er det rett før neste runde som er mest fornuftig, ettersom jeg (antar at jeg) er avhengig av informasjonen i priser og popularitet for å få gode prediksjoner.

Etter runde fem og en analyse av bedre [prediksjonsmuligheter](https://github.com/gardenberg/fantasy_fotball/blob/master/lagutvikling_5.md), bytta jeg ut variabelen som spillere plukkes etter fra kumulerte totale poeng til predikerte poeng i neste runde basert på en rekke uavhengige variabler, deriblant summerte poeng i de tre siste kampene.

Etter runde 8: [Modellevalueringa](https://github.com/gardenberg/fantasy_fotball/blob/master/modellevaluering_2.md) tyder på at den enkle lineære modellen er den som har prestert best så langt, men kun såvidt, så jeg beholder modellen med summerte poeng en runde til. Etter runde 9 ligger enkel lineær modell og lineær og logtransformert modell med tre siste runder nesten helt likt.

Etter runde ti med 31 poeng gjorde jeg en ny analyse, denne gangen med en [Support Vector Machine](https://github.com/gardenberg/fantasy_fotball/blob/master/prediksjon_v2.md), som forhåpentligvis vil prestere bedre med omlag de samme variablene. SVM er imidlertid mer var for ujevne datasett og NA. Et uromoment før førstegangs bruk til runde 11 er at C ble estimert til 4, RMSE var 2.3 og R^2 18 %, mens i testkjøringa var C=2, RMSE=2.0 og R^2 ca 37 %. Eneste forskjellen er at jeg denne gangen trener på bakgrunn av runde 10-data, mens i testinga var dette siste testcase. Runde 10 kan altså ha skilt seg en del fra tidligere runder.

Skal jeg beholde en modell med C=4 som også tar inn over seg en såpass avvikende runde, eller skal jeg justere C=2 og dermed legge mindre vekt på den avvikende runden? En større C betyr at modellen legger større vekt på større avvik/residualer fra hovedtrenden i dataene. Det bør vel også bety at modellen blir dårligere på å forklare all variasjon, i bytte mot at den blir bedre på avvik - forhåpentligvis avvik med høye poeng. Det er neppe runde 10 alene som utløser dette. Dermed beholder jeg C=4 (og tuneLength=9)

#### Fullt lagbytte

Først en rask kikk på drømmelaget (som funnet ved lineær optimalisering).

``` r
temp_df = df_estimering
temp_df$team_now = temp_df$team_10
temp_df$points_nextround[temp_df$round==11] = 0 #kan ikke settes til NA, for da får svm.predict hikke - men funker 0?
#temp_df$prediksjon = predict(temp_modell,newdata=temp_df) #i prediksjon_v2 brukte bare data fra siste runde. når jeg gjorde det her fikk jeg et tullete resultat jeg ikke trodde på
temp_df$prediksjon = predict(modell_svm,newdata=temp_df)
optimized_team = teamchooser(filter(temp_df,round==11,is.na(prediksjon)==FALSE),incremental=FALSE,max_team_cost=1010,prediksjon=TRUE)

optimized_team[[1]]
```

    ## Success: the objective function is 58.55518

``` r
temp_df = optimized_team[[2]]
kable(select(optimized_team[[3]],id_player,navn,posisjon,team_navn,now_cost,selected_by_percent,total_points_kumulativ,prediksjon))
```

|  id\_player| navn                  | posisjon | team\_navn |  now\_cost|  selected\_by\_percent|  total\_points\_kumulativ|  prediksjon|
|-----------:|:----------------------|:---------|:-----------|----------:|----------------------:|-------------------------:|-----------:|
|           1| Andreas Lie           | Keeper   | AAFK       |         50|                   21.4|                        60|    5.083128|
|          48| Per Kristian Bråtveit | Keeper   | FKH        |         51|                    3.8|                        42|    3.156963|
|         151| Vegard Bergan         | Forsvar  | ODD        |         48|                    0.7|                        31|    3.755430|
|         172| Tore Reginiussen      | Forsvar  | RBK        |         64|                   33.6|                        45|    3.682513|
|         148| Steffen Hagen         | Forsvar  | ODD        |         60|                    6.3|                        42|    3.532610|
|           9| Daníel Grétarsson     | Forsvar  | AAFK       |         49|                    1.7|                        40|    3.403689|
|         193| Vegar Hedenstad       | Forsvar  | RBK        |         67|                   18.6|                        40|    3.298928|
|          37| Fredrik Haugen        | Midtbane | BRA        |         96|                   22.1|                        64|    4.940741|
|         277| Tonny Brochmann       | Midtbane | STB        |         68|                   27.3|                        64|    4.823613|
|          38| Kristoffer Barmen     | Midtbane | BRA        |         66|                    7.5|                        46|    3.951112|
|         164| Riku Riski            | Midtbane | ODD        |         73|                   12.0|                        49|    3.649904|
|         398| Chigozie Udoji        | Midtbane | LSK        |         57|                    0.7|                        31|    3.392427|
|          22| Mostafa Abdellaoue    | Angrep   | AAFK       |         88|                   21.7|                        56|    5.459748|
|          44| Jakob Orlov           | Angrep   | BRA        |         75|                    7.7|                        47|    3.363114|
|          93| Benjamin Stokke       | Angrep   | KBK        |         50|                    1.8|                        43|    3.061261|

``` r
#kommenter ut dette når du ikke bytter hele laget
#df = left_join(df,select(temp_df,id_player,solution_full,prediksjon),by=c("id"="id_player"))
#beste lag og laget nå
#kable(arrange(select(filter(df,((team_now==1&solution_full==1)|(team_now==1&solution_full==0)|(team_now==0&solution_full==1))),id,navn,posisjon,team_navn,now_cost,selected_by_percent,total_points,solution_full,team_now),posisjon))
```

Etter runde 7 ser vi at svært få laget mitt er igjen på drømmelaget: Rossbach, Grøgaard og Svendsen. Det samme var tilfellet før runde 11, hvor jeg brukte Wildcardet. Begge keeperne ble bytta ut, Grøgaard i forsvarsrekka ble beholdt, Svendsen på midtbana og Sigurdarson i angrep, men ellers var det fullt bytte.

#### Enkeltspillerbytte

Deretter ser vi på hvilket enkelt spillerbytte som vil gi størst (*predikert*) utbytte til neste runde:

``` r
optimized_team[[1]]
```

    ## Success: the objective function is 53.53595

``` r
temp_df = optimized_team[[2]]
df = left_join(df,select(temp_df,id_player,solution_incremental,prediksjon),by=c("id"="id_player"))
#beste lag og laget nå
kable(arrange(select(filter(df,((team_now==1&solution_incremental==1)|(team_now==1&solution_incremental==0)|(team_now==0&solution_incremental==1))),id,navn,posisjon,team_navn,now_cost,selected_by_percent,total_points,prediksjon,solution_incremental,team_now),posisjon))
```

|   id| navn               | posisjon | team\_navn |  now\_cost|  selected\_by\_percent|  total\_points|  prediksjon|  solution\_incremental|  team\_now|
|----:|:-------------------|:---------|:-----------|----------:|----------------------:|--------------:|-----------:|----------------------:|----------:|
|    1| Andreas Lie        | Keeper   | AAFK       |         51|                   21.4|             60|    5.083128|                      1|          1|
|  268| Sayouba Mande      | Keeper   | STB        |         46|                    6.8|             38|    1.820342|                      1|          1|
|    9| Daníel Grétarsson  | Forsvar  | AAFK       |         50|                    1.7|             40|    3.403689|                      1|          1|
|   33| Gilli Sørensen     | Forsvar  | BRA        |         70|                   37.6|             64|    3.516344|                      1|          1|
|  148| Steffen Hagen      | Forsvar  | ODD        |         60|                    6.3|             42|    3.532610|                      1|          1|
|  150| Thomas Grøgaard    | Forsvar  | ODD        |         62|                   22.1|             57|    3.377111|                      1|          1|
|  172| Tore Reginiussen   | Forsvar  | RBK        |         64|                   33.6|             45|    3.682513|                      1|          1|
|  132| Sander Svendsen    | Midtbane | MOL        |         88|                   29.1|             51|    2.584789|                      1|          1|
|  164| Riku Riski         | Midtbane | ODD        |         73|                   12.0|             49|    3.649904|                      1|          1|
|  184| Fredrik Midtsjø    | Midtbane | RBK        |         87|                   28.1|             45|    3.076990|                      1|          1|
|  277| Tonny Brochmann    | Midtbane | STB        |         69|                   27.3|             64|    4.823613|                      1|          1|
|  279| Luc Kassi          | Midtbane | STB        |         60|                    3.8|             45|    3.100799|                      1|          1|
|   22| Mostafa Abdellaoue | Angrep   | AAFK       |         90|                   21.7|             56|    5.459748|                      1|          0|
|   44| Jakob Orlov        | Angrep   | BRA        |         75|                    7.7|             47|    3.363114|                      1|          1|
|   93| Benjamin Stokke    | Angrep   | KBK        |         51|                    1.8|             43|    3.061261|                      1|          1|
|  137| Björn Sigurdarson  | Angrep   | MOL        |         96|                   32.8|             58|    1.499638|                      0|          1|

Før runde fire ble Gashi bytta mot Trondsen, noe som så bra ut da. Før runde fem ble Flo bytta mot Kastrati. Før runde seks foreslår algoritmen å bytte ut SIFs Parr mot Odds Grøgaard. I utgangspunktet er jeg litt skeptisk - men man skal stole på maskinene! Jeg fikk i hvert fall ikke færre poeng ut av det byttet. Før runde sju er det Moldes Hussain, som har slitt både min og Moldes benk, som foreslås bytta mot LSK sin Ifeanyi Matthew.

Før runde 8 er det Nicklas Bendtner som foreslås bytta ut mot Moldes Bjørn Sigurdarson. Men jeg må også egentlig vurdere om jeg skal bruke Wildcard og bytte hele mannskapet - ettersom det optimale laget nå ligger ganske langt unna laget jeg har foran meg. Før jeg gjør det vil jeg helst få lagt inn noen betraktninger om odds og kommende kamper. Bendtner har falt i verdi, og vil antakeligvis falle ytterligere når flere bruker Wildcards (han har vel slått til i en kamp så langt...). Så dermed går jeg for dette byttet - selv om jeg på ingen måte er trygg på Molde-spissene, og Molde har både Brann og Odd i de neste tre kampene.

Før runde 9 foreslår algoritmen at jeg dropper Rosted og dytter inn Morten Skjønsberg fra Stabæk. Dette er i tråd med nivået i de siste kampene. Det er alltid et spørsmål om et fall i poengene skyldes at spilleren har falt ned på sitt normale nivå eller har falt ned fra sitt normale nivå. Stabæk er ikke noe topplag, og har dårlige odds mot Strømsgodset i runde 9. Det at jeg nå kommer til å sitte med en del penger i banken gjør meg også litt skeptisk. Men som vanlig - algoritmen bestemmer.

Før runde 10 foreslås det å bytte Heltne Nilsen mot Brochmann - en Stabækspiller. Heltne Nilsen har ikke levert, men jeg håper at neste runde vil gi en ny Brannspiller.

Før runde 12 foreslår SVM (RBF-kernel RBF) å bytte Sigurdarson (predikert 1.7 i runde 12) mot Mos (predikert 5.9 i runde 12). Jeg synes det virker litt pussig, ettersom Sigurdarson er den spilleren med høyest poengsum så langt. Mos er rett nok veldig populær, og antas å ha gode utsikter i neste kamp mot FKH bl.a. på [målscoreroddsen](https://eliteseriefantasy.com/2017/06/02/oddsassistenten-runde-12/). Men siden jeg er såpass usikker på modellen akkurat nå, avventer jeg bytte denne runden og tar heller to før runde 13.

### Odds for kommende kamper
