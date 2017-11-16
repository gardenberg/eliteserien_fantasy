Prediksjonsforsøk v2 - Support Vector Regression
================

(sist oppdatert: 26. mai før runde 11)

En maskinlæringsteknikk som skal ha fordeler ved små datasett er Support Vector Machine, som med en kontinuerlig avhengig variabel gjør Support Vector Regression [(for en kort tutorial, se f.eks. her)](https://www.svm-tutorial.com/2014/10/support-vector-regression-r/). SVM skal egne seg med få observasjoner, og høy korrelasjon mellom de uavhengige variablene. I følge Zumel og Mounts "Practical Data Science with R" er SVM særlig egna for å takle ikke-lineære kombinasjoner av variablene, uten at det nødvendigvis er noe jeg benytter meg av.

Fra [forrige prediksjonsforsøk](https://github.com/gardenberg/fantasy_fotball/blob/master/lagutvikling_5.md) har jeg notert meg følgende forbedringspunkter:

1.  Å evaluere prognosene med fitted values er feil, en må bruke predikerte values. Denne gangen holder jeg derfor runde 8 utenfor til testformål, og bruker runde 1-7 som treningsdata. Runde 9 holdes i bakkant til endelig testing av en utvalgt modell mot dagens modell. Dette ligner litt på det Wickham omtaler som en [60-20-20-split](http://r4ds.had.co.nz/model-intro.html). Her bør jeg legge til at jeg ikke er sikker på om all treninga, tuninga og estimeringa nedover bryter denne regelen.
2.  kryssvalidering som f.eks. utelat-en er en mer effektiv måte å utnytte informasjonen på enn mindre strukturerte måter.

Resultatet av alt arbeidet under er å bytte ut dagens lineære prediksjonsmodell med en SVM med RBF-kernel fra caret-pakka, med trainLength=9. Andre resultater er også:

1.  SVMer er ikke magiske, de er vanskelige å konfigurere på en riktig måte og leverer ikke nødvendigvis mye bedre resultater - datamaterialet og domenekunnskap er fortsatt viktig.
2.  Avveininga mellom nøyaktighet, hvor tungt noe er å beregne og overfitting er høyst reell for modeller som må tunes. SVM2-modellen tok ca. 1 døgn å tune inn på korrekte parametre, og selv om testresultatene var gode, floppet den helt på "poengtesten." SVM-modellen med polynomialkjerne var langt bedre, men tok også 24 timer å tune skikkelig og fikk PCen jevnlig til å krasje.
3.  Etter å ha kjørt igjennom dette noen ganger virker løsningene veldig ustabile. Er det SVM-modellen som finner ulike løsninger for hver gang, f.eks. p.g.a. tuningens ikke-parametriske natur eller flere optima? Eller er det min egen lagvelger-algoritme som gjør ting ustabile? Eller er det kodeblokken jeg har skrevet runde begge disse to for å gjøre dem enkle å bruke?

Noe ytterligere datautforsking
------------------------------

Ut ifra Kuhns Applied Predictive Modelling ser vi at skjevhet, korrelerte variabler og manglende verdier er blant de største problemene blant de uavhengige variablene. Dette ble delvis, men kanskje ufullstendig belyst i forrige prediksjonsforsøk.

### Skjevhet

En skjevhetsindikator kan beregnes med e1071-&gt;skewness, hvor verdier nærmere null indikerer en symmetrisk variabel, høyere verdier indikerer høyreskjeve fordelinger og negative verdier indikerer venstreskjeve fordelinger.

``` r
apply(select(df_estimering_na,total_points,rundepoeng,now_cost,selected,ep_next),2,skewness)
```

    ## total_points   rundepoeng     now_cost     selected      ep_next 
    ##    2.5832725    0.0368992    1.7826048    3.3308208    1.0409217

Selected og total\_points er de skjeveste variablene, fulgt av now\_cost og ep\_next. Ved hjelp av BoxCoxTrans i caret transformeres de. Box-Cox-tranformeringa tar kun positive verdier. For total\_points innebærer det at fordelinga må forskyves med minimumsverdien+1. Ep\_next må forsyves +1.

    ## Box-Cox Transformation
    ## 
    ## 3468 data points used to estimate Lambda
    ## 
    ## Input data summary:
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##       1     243     670    2300    2272   33150 
    ## 
    ## Largest/Smallest: 33200 
    ## Sample Skewness: 3.33 
    ## 
    ## Estimated Lambda: 0.1 
    ## With fudge factor, Lambda = 0 will be used for transformations

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-1.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-2.png)

    ##    Mode   FALSE    TRUE    NA's 
    ## logical    3453      15       0

    ## Box-Cox Transformation
    ## 
    ## 3468 data points used to estimate Lambda
    ## 
    ## Input data summary:
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   1.000   4.000   4.000   5.499   6.000  25.000 
    ## 
    ## Largest/Smallest: 25 
    ## Sample Skewness: 2.58 
    ## 
    ## Estimated Lambda: -0.9

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-3.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-4.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-5.png)

    ## Box-Cox Transformation
    ## 
    ## 3468 data points used to estimate Lambda
    ## 
    ## Input data summary:
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##   38.00   45.00   50.00   54.02   59.00  125.00 
    ## 
    ## Largest/Smallest: 3.29 
    ## Sample Skewness: 1.78 
    ## 
    ## Estimated Lambda: -2

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-6.png)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-7.png)

    ## Box-Cox Transformation
    ## 
    ## 3468 data points used to estimate Lambda
    ## 
    ## Input data summary:
    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    1.00    1.00    2.00    2.51    4.00    9.00 
    ## 
    ## Largest/Smallest: 9 
    ## Sample Skewness: 1.04 
    ## 
    ## Estimated Lambda: -0.3

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-3-8.png)

### Korrelasjoner

``` r
#velger å ta ut team, round
ggpairs(data=select(df_estimering_na,total_points,now_cost,selected,ep_next,rundepoeng,element_type,points_nextround),title="Fantasifotball-korrelasjoner",diag=list(continous='density'),axisLabels = 'none')
```

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning in (function (data, mapping, alignPercent = 0.6, method =
    ## "pearson", : Removed 3 rows containing missing values

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing missing values (geom_point).

    ## Warning: Removed 3 rows containing non-finite values (stat_density).

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-4-1.png)

Korrelasjonsmatrisen viser korrelasjoner mellom variablene. Den høyeste korrelasjonen er mellom rundepoeng og ep\_next total\_points og rundepoeng - noe som gir mening, ettersom rundepoeng viser om en har fått poeng eller ikke. Deretter er det ep\_next og total\_points.

Det er flere variabler som korrelerer mer med hverandre enn med den avhengige variabelen. Dette kan gi problematisk (multi)kolinearitet. Finnes det en måte å få ut/skille informasjonen som kommer fra poengene i forrige runde, og det andre deltakere veit om form og framtidig kampprogram? Kanskje. Men jeg har ikke tid til å håndtere dette nå.

### Manglende observasjoner og splitting til test-set

Eksplisitt manglende observasjoner har vi i variabelen som summerer poeng i de tre siste rundene, ettersom denne vanskelig lar seg beregne i runde 1 og 2. Som erstatning velger jeg å sette inn totale poeng fra forrige runde. Variabelen som måler poeng i neste runde mangler også observasjoner i siste spilte runde - siden neste runde ikke er spilt enda.

Et bidrag til implisitt manglende observasjoner (og dermed ulikt antall spillere i hver runde, og dermed vanskeligere formulering av treningssett) er spillere som er kjøpt inn etter seriestart, og dermed mangler (implisitt) data om tidligere runder. Jeg fjerner disse, enn så lenge, særlig ettersom et raskt kikk på poengsummene deres (spillere med id 431 og over) tyder på at ingen av dem hører hjemme på topplistene.

``` r
#df_estimering_na = na.omit(df_estimering_na) i utgangspunktet gjorde jeg slik, men det kan vi unngå

#for de første rundene brukes total_points og rundepoeng for *_threelast
df_estimering_na$points_threelast[is.na(df_estimering_na$points_threelast)==TRUE] = df_estimering_na$total_points[is.na(df_estimering_na$points_threelast)==TRUE]

df_estimering_na$rundepoeng_threelast[is.na(df_estimering_na$rundepoeng_threelast)==TRUE] = df_estimering_na$rundepoeng[is.na(df_estimering_na$rundepoeng_threelast)==TRUE]

#de implisitt manglende rundene legges til og fjernes øyeblikkelig
df_estimering_na = complete(df_estimering_na, expand(df_estimering_na, nesting(navn,team_navn,posisjon,team,element_type, id_player), round))
df_estimering_na = filter(df_estimering_na,id_player<431)
count(select(df_estimering_na,id_player,round),round)
```

    ## # A tibble: 8 x 2
    ##   round     n
    ##   <int> <int>
    ## 1     1   430
    ## 2     2   430
    ## 3     3   430
    ## 4     4   430
    ## 5     5   430
    ## 6     6   430
    ## 7     7   430
    ## 8     8   430

``` r
#det ser også ut til at na i team_1 skaper trøbbel. er det NA der, er verdien 0
df_estimering_na$team_1[is.na(df_estimering_na$team_1)==TRUE] = 0
```

Til slutt splittes datasettet opp i et treningssett og et testsett. Treningssettet har data fra de sju første rundene (inkl. poengfangsten i åttende runde), mens testsettet har uavhengige variabler for runde 8 og resultatet for runde 9. Runde 9 og 10 lastes inn i den endelige testen, for å unngå at jeg fristes til å bruke dataene på forhånd.

``` r
#splitter opp i train og endelig_test
df_estimering_na_train = filter(df_estimering_na,round<8)
df_estimering_na_test = filter(df_estimering_na,round==8)
```

Modellering
-----------

Som en benchmark bruker jeg en lineær modell med points\_nextround som avhengig variabel (ikke logtransformert).

``` r
#MODELL 0: LINEÆR MODELL SOM BENCHMARK
#først enkel lineær modell som benchmark
#trener
model_benchmark = lm(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train)
#tester
df_estimering_na_test$prediksjon_lm = predict(model_benchmark,newdata=df_estimering_na_test)
```

Første alternative modell er en enkel SVM uten tuning. SVM er egentlig laget for klassifisering, men når den avhengige variabelen er kontinuerlig gjør den regressjon i stedet. I dette tilfellet: eps-regresjon ([kort om forskjellige SVM-regresjoner](https://stats.stackexchange.com/questions/94118/difference-between-ep-svr-and-nu-svr-and-least-squares-svr). Kernelen er radial (mer om det lenger ned), kostnadsfaktoren 1, og modellen trenger 1682 "support vectors" for å skille dataene fra hverandre.

``` r
#MODELL 1: ENKEL SVM UTEN TUNING
#trener
model_svm1 <- svm(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train)
model_svm1
```

    ## 
    ## Call:
    ## svm(formula = points_nextround ~ total_points + I(total_points^2) + 
    ##     rundepoeng + now_cost + selected + as.factor(element_type) + 
    ##     as.factor(team) + ep_next, data = df_estimering_na_train)
    ## 
    ## 
    ## Parameters:
    ##    SVM-Type:  eps-regression 
    ##  SVM-Kernel:  radial 
    ##        cost:  1 
    ##       gamma:  0.04 
    ##     epsilon:  0.1 
    ## 
    ## 
    ## Number of Support Vectors:  1726

``` r
#tester
df_estimering_na_test$prediksjon_svm1 <- predict(model_svm1, newdata=df_estimering_na_test)
```

Andre alternativ er en modell tunet med et gridsearch. Tuning her vil si at x antall modeller med ulike kostnads- og epsilon-parametre estimeres (mens gamma holdes konstant). Her endte jeg opp med å prøve ut ca. 3500 modeller, noe som tok ca. en og en halv dag, så dette bør absolutt kunne gjøres på mer effektive måter.

``` r
#MODELL 2: TUNING med e1071-tune
#tuneResult <- tune(svm, points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train,
#              ranges = list(epsilon = seq(0,1,0.1), cost = 0.1:100)
#)
#tuneResult_2 <- tune(svm, points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train,
#              ranges = list(epsilon = seq(0,0.7,0.01), cost = seq(0.1,20,0.5))
#)

#for illustrasjonens skyld
tuneResult_ill <- tune(svm, points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train,
              ranges = list(epsilon = seq(0.4,0.5,0.01), cost = seq(0.1,1,0.1))
)

#dette er fortsatt 10*10 modeller, som tar ca. 30 min.

print(tuneResult_ill)
```

    ## 
    ## Parameter tuning of 'svm':
    ## 
    ## - sampling method: 10-fold cross validation 
    ## 
    ## - best parameters:
    ##  epsilon cost
    ##     0.48  0.1
    ## 
    ## - best performance: 4.765405

``` r
plot(tuneResult_ill)
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-9-1.png)

``` r
tuneResult_ill$best.model
```

    ## 
    ## Call:
    ## best.tune(method = svm, train.x = points_nextround ~ total_points + 
    ##     I(total_points^2) + rundepoeng + now_cost + selected + as.factor(element_type) + 
    ##     as.factor(team) + ep_next, data = df_estimering_na_train, 
    ##     ranges = list(epsilon = seq(0.4, 0.5, 0.01), cost = seq(0.1, 
    ##         1, 0.1)))
    ## 
    ## 
    ## Parameters:
    ##    SVM-Type:  eps-regression 
    ##  SVM-Kernel:  radial 
    ##        cost:  0.1 
    ##       gamma:  0.04 
    ##     epsilon:  0.48 
    ## 
    ## 
    ## Number of Support Vectors:  856

``` r
model_svm2 = svm(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=df_estimering_na_train,type="eps-regression",kernel="radial",cost=0.1,epsilon=0.47,gamma=0.04)

#tester
df_estimering_na_test$prediksjon_svm2 <- predict(model_svm2, newdata=df_estimering_na_test)
```

Diagrammet over viser rMSE etter ulike verdier av C og epsilon, der mørkere områder gir lavere RMSE. Modellen som velges har C på 0.2.

SVM-tuning i E1071-pakka bruker10-fold crossvalidation, dvs. deler opp datasettet i ti tilfeldige grupper og beregner RMSE på bakgrunn av disse ti. Siden datasettet er en tidsserie er ikke det beste måten å gjøre det på - i virkeligheten vil dataene ligge etter hverandre. Det vil kunne påvirke nøyaktighetsestimatet fra tuningen, som igjen påvirker parametrene som tuningen velger. De kan derfor bli mindre optimale enn en skulle håpe på.

I stedet kan jeg bruke [createTimeSlices](http://topepo.github.io/caret/data-splitting.html#time) i caret-pakka. Dette er en implementasjon av "rolling forecasting origin" fra [Hyndman](https://www.otexts.org/fpp/2/5), hvor et gitt sett med observasjoner brukes som treningssett og testes på et testsett fra et senere tidspunkt, gjentatte ganger. Ikke verdens beste forklaring, og jeg er ikke 100 % sikker på om implementasjon av dette er riktig ettersom jeg har paneldata - både tverrsnitt og tidsserie - og ikke utelukkende en tidsserie.

Jeg kunne sikkert brukt createTimeSlices med e1071-SVM (eller e1071 med caret), men siden createTimeSlices alene gir meg et listeobjekt jeg ikke helt forstår hvordan brukes, dokumentasjonen er så som så (også i følge [forfatteren](http://stackoverflow.com/questions/22334561/createtimeslices-function-in-caret-package-in-r)) og e1071-svm må legges inn som custom funksjon i caret - så går jeg heller rett til caret. Caret har en haug med ulike [SVMer](http://topepo.github.io/caret/train-models-by-tag.html#Support_Vector_Machines).

``` r
#MODEL 3: SVM med Caret
count(select(df_estimering_na_train,id_player,round),round)
```

    ## # A tibble: 7 x 2
    ##   round     n
    ##   <int> <int>
    ## 1     1   430
    ## 2     2   430
    ## 3     3   430
    ## 4     4   430
    ## 5     5   430
    ## 6     6   430
    ## 7     7   430

``` r
train_nr = floor(nrow(filter(df_estimering_na_train,round==1))*.8)
test_nr = ceiling(nrow(filter(df_estimering_na_train,round==1))*.2)
kontroll = trainControl(method="timeslice",initialWindow=train_nr,horizon=test_nr,fixedWindow=TRUE)
modell_svm_caret = train(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+ep_next,
                        data = arrange(df_estimering_na_train,round),
                        method = "svmRadial",
                        trControl = kontroll
                        )
modell_svm_caret
```

    ## Support Vector Machines with Radial Basis Function Kernel 
    ## 
    ## 3010 samples
    ##    6 predictor
    ## 
    ## No pre-processing
    ## Resampling: Rolling Forecasting Origin Resampling (86 held-out with a fixed window) 
    ## Summary of sample sizes: 344, 344, 344, 344, 344, 344, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   C     RMSE      Rsquared 
    ##   0.25  2.180017  0.3313975
    ##   0.50  2.155097  0.3277746
    ##   1.00  2.138282  0.3183709
    ## 
    ## Tuning parameter 'sigma' was held constant at a value of 0.1302996
    ## RMSE was used to select the optimal model using  the smallest value.
    ## The final values used for the model were sigma = 0.1302996 and C = 1.

``` r
#har tatt ut as.factor(team) pga feilmelding om null varians

#tester
df_estimering_na_test$prediksjon_svm3 <- predict(modell_svm_caret, newdata=df_estimering_na_test)

#MODEL 4: SVM med Caret og transformerte variabler
count(select(df_estimering_na_train,id_player,round),round)
```

    ## # A tibble: 7 x 2
    ##   round     n
    ##   <int> <int>
    ## 1     1   430
    ## 2     2   430
    ## 3     3   430
    ## 4     4   430
    ## 5     5   430
    ## 6     6   430
    ## 7     7   430

``` r
train_nr = floor(nrow(filter(df_estimering_na_train,round==1))*.8)
test_nr = ceiling(nrow(filter(df_estimering_na_train,round==1))*.2)
kontroll = trainControl(method="timeslice",initialWindow=train_nr,horizon=test_nr,fixedWindow=TRUE)
modell_svm_caret2 = train(points_nextround~total_points_transformed+I(total_points_transformed^2)+rundepoeng+now_cost_transformed+selected_transformed+as.factor(element_type)+ep_next_transformed,
                        data = arrange(df_estimering_na_train,round),
                        method = "svmRadial",
                        trControl = kontroll
                        )
modell_svm_caret2
```

    ## Support Vector Machines with Radial Basis Function Kernel 
    ## 
    ## 3010 samples
    ##    6 predictor
    ## 
    ## No pre-processing
    ## Resampling: Rolling Forecasting Origin Resampling (86 held-out with a fixed window) 
    ## Summary of sample sizes: 344, 344, 344, 344, 344, 344, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   C     RMSE      Rsquared 
    ##   0.25  2.197265  0.3214667
    ##   0.50  2.174021  0.3246566
    ##   1.00  2.154146  0.3241978
    ## 
    ## Tuning parameter 'sigma' was held constant at a value of 0.1218062
    ## RMSE was used to select the optimal model using  the smallest value.
    ## The final values used for the model were sigma = 0.1218062 and C = 1.

``` r
#har tatt ut as.factor(team) pga feilmelding om null varians

#tester
df_estimering_na_test$prediksjon_svm4 <- predict(modell_svm_caret2, newdata=df_estimering_na_test)

#MODEL 5: SVM med Caret og team
count(select(df_estimering_na_train,id_player,round),round)
```

    ## # A tibble: 7 x 2
    ##   round     n
    ##   <int> <int>
    ## 1     1   430
    ## 2     2   430
    ## 3     3   430
    ## 4     4   430
    ## 5     5   430
    ## 6     6   430
    ## 7     7   430

``` r
train_nr = floor(nrow(filter(df_estimering_na_train,round==1))*.8)
test_nr = ceiling(nrow(filter(df_estimering_na_train,round==1))*.2)
kontroll = trainControl(method="timeslice",initialWindow=train_nr,horizon=test_nr,fixedWindow=TRUE)
modell_svm_caret3 = train(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,
                        data = arrange(df_estimering_na_train,round),
                        method = "svmRadial",
                        trControl = kontroll
                        )
modell_svm_caret3
```

    ## Support Vector Machines with Radial Basis Function Kernel 
    ## 
    ## 3010 samples
    ##    7 predictor
    ## 
    ## No pre-processing
    ## Resampling: Rolling Forecasting Origin Resampling (86 held-out with a fixed window) 
    ## Summary of sample sizes: 344, 344, 344, 344, 344, 344, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   C     RMSE      Rsquared 
    ##   0.25  2.171579  0.3679799
    ##   0.50  2.109241  0.3761882
    ##   1.00  2.062153  0.3765250
    ## 
    ## Tuning parameter 'sigma' was held constant at a value of 0.02531586
    ## RMSE was used to select the optimal model using  the smallest value.
    ## The final values used for the model were sigma = 0.02531586 and C = 1.

``` r
#tester
df_estimering_na_test$prediksjon_svm5 <- predict(modell_svm_caret3, newdata=df_estimering_na_test)
```

Når disse er estimert, må jeg først evaluere dem på treningsdataene. Caret-&gt;resamples gir meg muligheten til å se på noen av modellene, men det virker litt for snaut å kun se å tre odeller. I stedet nøyer jeg meg med å konstatere at alle modellene har RMSE fra 2.2 til 2.4 (Modell 3 med riktig sortering gir RMSE på 2.4, feil sortering i modell 1 og 2 RSME på 2.2, med transformerte uavhengige variabler (modell 4) 2.3 og med team-variabelen inkludert RMSE på 2.1)

### Testdata

Når det er gjort, kan vi se på ulike nøyaktighetsmål (ved hjelp av forecast::accuracy), samt plots av faktiske observerte verdier mot predikerte verdier for test-settet, og faktiske verdier mot residualer.

| modell |  RMSE|  MAE|
|:-------|-----:|----:|
| lm     |   2.0|  1.1|
| svm1   |   2.2|  1.1|
| svm2   |   2.2|  1.3|
| svm3   |   2.1|  1.1|
| svm4   |   2.2|  1.1|
| svm5   |   2.3|  1.1|

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-11-1.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-11-2.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-11-3.png)

Som vi ser over har alle modellene MAE på 1.1 - 1.4 (samme som de første lineære modellene jeg vurderte), og RMSE på 2.1-2.3. Dvs. at gjennomsnittlig feilmargin for modellene ligger på 1.1-1.4 poeng, men det finnes større feil i modellen som gjør RMSE større enn MAE [(i følge denne tolkninga)](https://medium.com/human-in-a-machine-world/mae-and-rmse-which-metric-is-better-e60ac3bde13d). Interessant nok er gjennomsnittsfeilen MAE minst for den ukalibrerte SVM-modellen SVM1, mens RMSE er minst for benchmarkmodellen med lineær regresjon.

Som vi ser av grafen av predikerte verdier mot faktiske verdier, predikerer også alle disse modellene konsekvent for lave verdier. Dette gjelder særlig SVM1, SVM2 og SVM4, men siden maks y-akse legger seg på 6, mens maks i virkeligheten er 20, så ligger alle for lavt. Dette hadde ikke nødvendigvis gjort så mye hvis det var slik at høye predikerte verdier = høye faktiske verdier, men det er ikke nødvendigvis slik. Alle modellene predikerer høye verdier for spillere som fikk lave verdier - og særlig den lineære modellen, mens f.eks. SVM5 i mindre grad gjør dette. Noen predikerer også lavere verdier for spillere som fikk høye verdier - som f.eks. SVM5.

Det samme mønsteret ser vi igjen i residualene, hvor høyere faktiske verdier henger sammen med større restledd - residualene blir gjennomgående mindre og mer negative med høyere verdier av prediksjonen (dvs. at prediksjon av høyere poengsum var feil, spilleren fikk en lavere poengsum - derfor negativt restledd). Dette kan bety at modellen mangler en variabel som gjør den i stand til å peke ut spillere som får høye poengsummer.

Endelig evaluering: hvor mange poeng?
-------------------------------------

Når det er gjort må jeg plugge modellen inn i modellevalueringsalgoritmen som finner hvor mange poeng jeg hadde fått. Dette er den faktiske evalueringa. Skulle en mindre presis algoritme fra over gi konsistent høyere poengsummer her, vil jeg velge den.

I motsetning til den nåværende [evalueringsalgorimen](https://github.com/gardenberg/fantasy_fotball/blob/master/modellevaluering_2.md) prøver jeg denne gangen å lage en df med prediksjoner for hver enkelt runde, og så beregne poengene med bakgrunn i den. Dermed unngår jeg å nøste prediksjonene inn i hele formelen, noe som fører til mange if-setninger for ulike typer formler.

For runde 1 setter jeg laget lik det laget jeg faktisk hadde for alle. Jeg beregner en løsning med ett bytte per runde, og en løsning med bytte av hele mannskapet hver runde. Verdien antas å være 1000 hver runde.

Loopene over gir meg en haug data.frames med beregnede poengsummer, som jeg kan sammenlikne.

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-1.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-2.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-3.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-4.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-5.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-14-6.png)

Som vi ser gjør den lineære benchmark-modellen - dagens modell - det relativt skarpt, og samler med 429 poeng over 8 runder mer enn alle unntatt to algoritmer. Med tetthetsplottet ser vi også at benchmarkmodellen leverer stabilt rundt 50 poeng, men av og til faller ned på 30 poeng.

Den dårligste er den enkle tunede SVM (SVM2, 310 poeng). Den ser ut til å falle sammen for data fra 6, 7 og 8 runde. Blant de øvrige som ender under bencharken finner vi den enkle SVMen (SVM1, 413 poeng) og SVM4 med transformerte prediktorer (416 poeng).

SVM 3 fra caret gjør det bedre, med 440 poeng og SVM5 med team-variabelen gjør det best med totalt 443 poeng. SVM5 ser også ut til å kunne få en topp på et høyere sted enn benchmarkmodellen, og at den ikke faller ned på 30-tallet som benchmarken. Det ville vært et stort pluss om modellen konsekvent leverte høyere poengsummer.

Hvordan ville algoritmene gjort det hvis de hver eneste runde fikk sette opp et nytt lag? Den tunede SVM2 ville gjort det håpløst. Den enkle modellen ville også lagt seg under benchmarkmodellen. Alle tre caret-modeller ville levert høyere poengsummer enn benchmark-modellen. Den desidert beste modellen er den som hensyntar team.

Her bør det legges til at resultatene ikke er helt stabile. Ved første gangs gjennomkjøring var SVM fra caret med team den suverent beste, med nærmere 470 poeng over 8 runder. Det er heller ikke slik at disse resultatene betyr at algoritmen vet noe - algoritmer kan også ha flaks.

Ut ifra dette ser det ut til at SVM fra caret, med team som en del av modellen, er den algoritmen som kan skaffe meg flest poeng - også flere poeng enn den lineære benchmark-modellen, som er den jeg bruker i dag.

### Valg av kernel

SVM bruker en kernel-funksjon. Jeg skal ikke påstå at jeg forstår matematikken i det, men det ser ut til å være et triks for å løse ikke-lineære sammenhenger. Kernelen må imidlertid velges manuelt av brukeren - og [testes deretter](https://stats.stackexchange.com/questions/10551/how-do-i-choose-what-svm-kernels-to-use).

``` r
rvalues = resamples(list(svm_rbf=modell_svm_caret5a,svm_lin=modell_svm_caret5b,svm_poly=modell_svm_caret5c))
summary(rvalues)
```

    ## 
    ## Call:
    ## summary.resamples(object = rvalues)
    ## 
    ## Models: svm_rbf, svm_lin, svm_poly 
    ## Number of resamples: 2581 
    ## 
    ## RMSE 
    ##            Min. 1st Qu. Median  Mean 3rd Qu.  Max. NA's
    ## svm_rbf  1.0630   1.705  2.084 2.062   2.393 3.122    0
    ## svm_lin  0.9848   1.710  2.115 2.064   2.377 3.126    0
    ## svm_poly 1.0770   1.665  2.027 2.034   2.402 3.139    0
    ## 
    ## Rsquared 
    ##             Min. 1st Qu. Median   Mean 3rd Qu.   Max. NA's
    ## svm_rbf  0.04043  0.2839 0.3857 0.3774  0.4817 0.6666    0
    ## svm_lin  0.04675  0.2908 0.3795 0.3871  0.4751 0.7040    0
    ## svm_poly 0.04692  0.2524 0.4000 0.3869  0.5143 0.8042    0

Som vi ser her er modellene ganske like, og ganske varierende - ned RNSE som spenner seg fra ca. 1.1 til ca. 3.2, og forklart variason fra 2-3 % til 68-79%. Forskjellen i R^2 er større enn i RMSE.

| modell |  RMSE|  MAE|
|:-------|-----:|----:|
| svm5a  |   2.2|  1.1|
| svm5b  |   2.2|  1.1|
| svm5c  |   2.3|  1.1|

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-17-1.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-17-2.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-17-3.png) RMSE på test-settet er veldig likt for de tre modellene. Prediksjonene som skiller seg mest ut er polynomial-kernelen, som predikerer langt høyere poengsummer enn de andre modellene. Prediksjonen ser imidlertid ut til å også være mer feil - illustrert med residual-plottet, hvor det er flere uteliggere i svm5c enn i de andre - men kanskje også en svakere stigning på trenden?

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-1.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-2.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-3.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-4.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-5.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-19-6.png)

I poengfangst-testen ser vi at den lineære modellen og polynomial-modellen gjør det såvidt bedre enn RBF-modellen i den inkrementelle testen. Dette avviker fra første gjennomkjøring, hvor RBF gjorde det best. I den fulle testen gjør polynomial-kernelen det best, noe som stemmer overens med erfaringene fra første runde.

### Tuning

Vi sitter da igjen med en RBF-kjerne og en poly-kjerne. RBF-kernelen har to parametre som må tunes: sigma og C(kostnadsfaktor). Sigma kan beregnes automatisk av algoritmen, mens kostnadsparameteret må innstilles. Det angir hvor stor en residual må være før det tas hensyn til den i modellen - jo større C, jo større må avviket være før det tas hensyn til, og desto mer vekt ilegges disse avvikene. Det vil si at større C gir en modell som kan passe godt til treningsdataene, men større fare for overfitting.

Polynomial-kernelen har i tillegg et gradsparameter som må tunes - og er en god del mer beregningskrevende enn RBF (eller andre modeller). Så beregningskrevende at det viste seg at en modell med tuneLength satt til 9 tok minst 24 timer å trene, og/eller får PCen min til å knele. Siden det er helt urealistisk å skulle bruke noe slikt i praksis, avbrøt jeg beregninga etter ett døgn.

I denne omgangen begrenser vi oss til å sette tuneLength til 9, i stedet for default 3. Dette øker beregningstida med minst tre, så det får være godt nok. Det er også mulig å gjøre gridsearch i carets train-funksjon (som f.eks. [her](http://blog.revolutionanalytics.com/2015/10/the-5th-tribe-support-vector-machines-and-caret.html)), men ettersom algoritmen allerede ser ut til å kunne gi forbedringer og det tar lang tid å beregne (samt at overfitting er et reellt problem - se SVM2 over, som kollapset helt) nøyer vi oss med det.

``` r
rvalues2 = resamples(list(svm_rbf_tl3=modell_svm_caret5a,svm_rbf_tl9=modell_svm_caret5a2))
summary(rvalues2)
```

    ## 
    ## Call:
    ## summary.resamples(object = rvalues2)
    ## 
    ## Models: svm_rbf_tl3, svm_rbf_tl9 
    ## Number of resamples: 2581 
    ## 
    ## RMSE 
    ##              Min. 1st Qu. Median  Mean 3rd Qu.  Max. NA's
    ## svm_rbf_tl3 1.063   1.705  2.084 2.062   2.393 3.122    0
    ## svm_rbf_tl9 1.082   1.654  2.054 2.040   2.393 3.123    0
    ## 
    ## Rsquared 
    ##                Min. 1st Qu. Median   Mean 3rd Qu.   Max. NA's
    ## svm_rbf_tl3 0.04043  0.2839 0.3857 0.3774  0.4817 0.6666    0
    ## svm_rbf_tl9 0.03026  0.2720 0.3824 0.3745  0.4997 0.6875    0

De to modellene gjør det svært likt på treningsdataene, og har samme C-parameter (2).

    ## Joining, by = c("id_player", "round")
    ## Joining, by = c("id_player", "round")
    ## Joining, by = c("id_player", "round")
    ## Joining, by = c("id_player", "round")

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-1.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-2.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-3.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-4.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-5.png)![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-22-6.png)

SVM med RBF-kernel tunet på tunelength=9 gjør det i første beregning bedre på poengfangsten de første 8 rundene, både inkrementelt (selv om her er forskjellen innafor forskjellene som er observert med RBF tuneLength=3) og med fullt lagbytte. Det fulle lagbytte hver runde slår også det fulle lagbyttet med Polynomial-kjerne. I andre runde gjør de to det like godt inkrementelt, tuneLength=3 gjør det kanskje også bedre - mens tuneLength=9 gjør det bedre på den fulle testen.

### Siste test

I siste test tester jeg dagens lineære modell mot SVM med RBF og tuneLength=9.

``` r
#lese inn nye data
df_estimering = read.csv2("data/data_prediksjon-v2_test.csv",stringsAsFactors = FALSE)
df_original = df_estimering

#evt. na-håndtering og symmetrifisering
count(select(df_estimering,id_player,round),round)
```

    ## # A tibble: 10 x 2
    ##    round     n
    ##    <int> <int>
    ##  1     1   430
    ##  2     2   432
    ##  3     3   432
    ##  4     4   433
    ##  5     5   433
    ##  6     6   434
    ##  7     7   436
    ##  8     8   438
    ##  9     9   438
    ## 10    10   439

``` r
df_estimering = complete(df_estimering, expand(df_estimering, nesting(navn,team_navn,posisjon,team,element_type, id_player), round))
count(select(df_estimering,id_player,round),round)
```

    ## # A tibble: 10 x 2
    ##    round     n
    ##    <int> <int>
    ##  1     1   439
    ##  2     2   439
    ##  3     3   439
    ##  4     4   439
    ##  5     5   439
    ##  6     6   439
    ##  7     7   439
    ##  8     8   439
    ##  9     9   439
    ## 10    10   439

``` r
#løser problemet ved å droppe alle som ikke  har spilt i alle runder - ikke en blivende løsning.
df_estimering = filter(df_estimering,id_player<431)
count(select(df_estimering,id_player,round),round)
```

    ## # A tibble: 10 x 2
    ##    round     n
    ##    <int> <int>
    ##  1     1   430
    ##  2     2   430
    ##  3     3   430
    ##  4     4   430
    ##  5     5   430
    ##  6     6   430
    ##  7     7   430
    ##  8     8   430
    ##  9     9   430
    ## 10    10   430

``` r
#fortsatt na for svm og ujevne serier for lm - ujevnhet var en function-feil
#så for svm er det points_nextround i runde 9 som er problemet - løser dette det ved å fjerne runde 10
df_estimering = filter(df_estimering,round<10)

#trene modell, predikere runde 10 - benchmark
modell_benchmark = lm(points_nextround~points_threelast+I(points_threelast^2)+rundepoeng_threelast+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=filter(df_estimering,round<9))
summary(modell_benchmark)
```

    ## 
    ## Call:
    ## lm(formula = points_nextround ~ points_threelast + I(points_threelast^2) + 
    ##     rundepoeng_threelast + now_cost + selected + as.factor(element_type) + 
    ##     as.factor(team) + ep_next, data = filter(df_estimering, round < 
    ##     9))
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -6.7107 -0.9128 -0.1567  0.1622 15.4586 
    ## 
    ## Coefficients:
    ##                            Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)              -7.216e-02  2.421e-01  -0.298 0.765657    
    ## points_threelast          1.474e-01  2.285e-02   6.451 1.27e-10 ***
    ## I(points_threelast^2)    -6.217e-03  1.017e-03  -6.111 1.10e-09 ***
    ## rundepoeng_threelast      3.938e-01  1.152e-01   3.418 0.000638 ***
    ## now_cost                  2.001e-03  4.457e-03   0.449 0.653503    
    ## selected                  2.716e-05  1.133e-05   2.396 0.016618 *  
    ## as.factor(element_type)2 -1.285e-01  1.280e-01  -1.004 0.315537    
    ## as.factor(element_type)3 -1.282e-01  1.375e-01  -0.932 0.351541    
    ## as.factor(element_type)4 -1.314e-01  1.587e-01  -0.828 0.407644    
    ## as.factor(team)2          3.557e-01  2.147e-01   1.657 0.097684 .  
    ## as.factor(team)3          3.160e-01  2.083e-01   1.517 0.129313    
    ## as.factor(team)4         -1.154e-01  2.023e-01  -0.571 0.568211    
    ## as.factor(team)5         -2.141e-01  2.063e-01  -1.038 0.299492    
    ## as.factor(team)6          7.691e-02  2.086e-01   0.369 0.712397    
    ## as.factor(team)7          2.389e-02  2.087e-01   0.115 0.908841    
    ## as.factor(team)8          2.504e-01  2.221e-01   1.128 0.259461    
    ## as.factor(team)9          2.202e-01  2.130e-01   1.033 0.301485    
    ## as.factor(team)10         1.940e-01  2.062e-01   0.941 0.346692    
    ## as.factor(team)11         4.191e-02  2.001e-01   0.209 0.834171    
    ## as.factor(team)12         4.435e-01  1.985e-01   2.235 0.025514 *  
    ## as.factor(team)13         3.610e-02  2.051e-01   0.176 0.860263    
    ## as.factor(team)14         4.158e-02  2.021e-01   0.206 0.836993    
    ## as.factor(team)15         7.731e-02  1.964e-01   0.394 0.693896    
    ## as.factor(team)16         1.252e-01  2.145e-01   0.584 0.559423    
    ## ep_next                   6.161e-01  2.933e-02  21.006  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 2.089 on 3415 degrees of freedom
    ## Multiple R-squared:  0.3325, Adjusted R-squared:  0.3278 
    ## F-statistic: 70.89 on 24 and 3415 DF,  p-value: < 2.2e-16

``` r
#predikerer runde 10
df_estimering$prediksjon_lm[df_estimering$round==9] = predict(modell_benchmark,newdata=filter(df_estimering,round==9))
```

    ## Warning: Unknown or uninitialised column: 'prediksjon_lm'.

``` r
#trene modell, predikere runde 10 - svm
##kontroll
train_nr = floor(nrow(filter(df_estimering,round==1))*.8)
test_nr = ceiling(nrow(filter(df_estimering,round==1))*.2)
kontroll = trainControl(method="timeslice",initialWindow=train_nr,horizon=test_nr,fixedWindow=TRUE)
modell_svm = train(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,
                        data = arrange(filter(df_estimering,round<9),round),
                        method = "svmRadial",
                        tuneLength = 9,
                        trControl = kontroll
                        )
modell_svm
```

    ## Support Vector Machines with Radial Basis Function Kernel 
    ## 
    ## 3440 samples
    ##    7 predictor
    ## 
    ## No pre-processing
    ## Resampling: Rolling Forecasting Origin Resampling (86 held-out with a fixed window) 
    ## Summary of sample sizes: 344, 344, 344, 344, 344, 344, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   C      RMSE      Rsquared 
    ##    0.25  2.169742  0.3655876
    ##    0.50  2.110335  0.3734621
    ##    1.00  2.063491  0.3744404
    ##    2.00  2.046184  0.3693924
    ##    4.00  2.061025  0.3591746
    ##    8.00  2.107982  0.3422825
    ##   16.00  2.177268  0.3213186
    ##   32.00  2.290288  0.2935638
    ##   64.00  2.430941  0.2677059
    ## 
    ## Tuning parameter 'sigma' was held constant at a value of 0.02484585
    ## RMSE was used to select the optimal model using  the smallest value.
    ## The final values used for the model were sigma = 0.02484585 and C = 2.

``` r
df_estimering$prediksjon_svm[df_estimering$round==9] = predict(modell_svm,newdata=filter(df_estimering,round==9))
```

    ## Warning: Unknown or uninitialised column: 'prediksjon_svm'.

``` r
#sjekke resultatene
#SJEKK 1: RMSE, prediksjon og residualer
df_diagnose = select(df_estimering,id_player,points_nextround,prediksjon_svm,prediksjon_lm)%>%
        gather(modell,prediksjon,starts_with("prediksjon"))%>%
        separate(modell,into=c("slett","modell"),sep="\\_")%>%
        select(-slett)%>%
        mutate("residual"=points_nextround-prediksjon)

df_accuracy = group_by(df_diagnose,modell)%>%
        summarise("RMSE" = round(forecast::accuracy(prediksjon,points_nextround)["Test set","RMSE"],1),
                  "MAE" = round(forecast::accuracy(prediksjon,points_nextround)["Test set","MAE"],1))
kable(df_accuracy)
```

| modell |  RMSE|  MAE|
|:-------|-----:|----:|
| lm     |   1.7|  1.1|
| svm    |   2.0|  1.0|

``` r
#evaluering
ggplot(aes(x=points_nextround,y=prediksjon),data=df_diagnose)+
        geom_point(alpha=0.5)+
        geom_density2d()+
        facet_wrap(~modell)
```

    ## Warning: Removed 6880 rows containing non-finite values (stat_density2d).

    ## Warning: Removed 6880 rows containing missing values (geom_point).

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-1.png)

``` r
ggplot(aes(x=points_nextround,y=residual),data=df_diagnose)+
        geom_point(alpha=0.5)+
        facet_wrap(~modell)
```

    ## Warning: Removed 6880 rows containing missing values (geom_point).

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-2.png)

``` r
ggplot(aes(x=prediksjon,y=residual),data=df_diagnose)+
        geom_point(alpha=0.5)+
        facet_wrap(~modell)
```

    ## Warning: Removed 6880 rows containing missing values (geom_point).

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-3.png)

``` r
#TEST 2: kjøre poengsankingstesten.
df_estimering$prediksjon = 0
for(i in min(df_estimering$round):max(df_estimering$round)){
        if(i==1){
                model_benchmark = lm(points_nextround~points_threelast+I(points_threelast^2)+rundepoeng_threelast+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=filter(df_estimering,round==i))
                df_estimering$prediksjon[df_estimering$round==i] = predict(model_benchmark,newdata=filter(df_estimering,round==i))
        }
        if(i>1){
                model_benchmark = lm(points_nextround~points_threelast+I(points_threelast^2)+rundepoeng_threelast+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,data=filter(df_estimering,round<i))
                df_estimering$prediksjon[df_estimering$round==i] = predict(model_benchmark,newdata=filter(df_estimering,round==i))
        }
}

df_estimering = lagvelgemaskin(df_estimering)
resultater_benchmark_inc = poengberegningsmaskin(df_original,df_estimering,modell="benchmark")
```

    ## Joining, by = c("id_player", "round")

``` r
df_estimering = lagvelgemaskin_full(df_estimering)
resultater_benchmark_full = poengberegningsmaskin(df_original,df_estimering,modell="benchmark")
```

    ## Joining, by = c("id_player", "round")

``` r
#MODEL 5A2: SVM radial - tuneLength=9
df_estimering$prediksjon = 0
#df_estimering$points_nextround[df_estimering$round==10] = 0 #NA og 0 i denne er ikke mulig
for(i in min(df_estimering$round):max(df_estimering$round)){
        if(i==1){
                modell_svm = train(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,
                        data = arrange(filter(df_estimering,round==1),round),
                        method = "svmRadial",
                        tuneLength = 9,
                        trControl = kontroll
                        )
                df_estimering$prediksjon[df_estimering$round==1] = predict(modell_svm,newdata=filter(df_estimering,round==1))
        }
        if(i>1){
                modell_svm = train(points_nextround~total_points+I(total_points^2)+rundepoeng+now_cost+selected+as.factor(element_type)+as.factor(team)+ep_next,
                        data = arrange(filter(df_estimering,round<i),round),
                        method = "svmRadial",
                        tuneLength = 9,
                        trControl = kontroll
                        )
                df_estimering$prediksjon[df_estimering$round==i] = predict(modell_svm,newdata=filter(df_estimering,round==i))
        }
}

df_estimering = lagvelgemaskin(df_estimering)
resultater_svm_inc = poengberegningsmaskin(df_original,df_estimering,modell="svm_radial")
```

    ## Joining, by = c("id_player", "round")

``` r
df_estimering = lagvelgemaskin_full(df_estimering)
resultater_svm_full = poengberegningsmaskin(df_original,df_estimering,modell="svm_radial")
```

    ## Joining, by = c("id_player", "round")

``` r
resultater_inc = bind_rows(resultater_benchmark_inc,resultater_svm_inc)
resultater_full = bind_rows(resultater_benchmark_full,resultater_svm_full)

#PLOT RESULTATET
qplot(parse_number(round),Poeng,data=resultater_inc,geom="line",colour=fct_reorder2(as.factor(modell),parse_number(round),Poeng))+
        labs(colour="modell",title="Poeng etter runde og modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-4.png)

``` r
qplot(parse_number(round),`Kumulerte poeng`,data=resultater_inc,geom="line",colour=fct_reorder2(as.factor(modell),parse_number(round),`Kumulerte poeng`))+
        labs(colour="modell",title="Totale poeng etter runde og modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-5.png)

``` r
qplot(Poeng,data=resultater_inc,colour=modell,geom="density")+
        labs(title="Poengfordeling etter modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-6.png)

``` r
qplot(parse_number(round),Poeng,data=resultater_full,geom="line",colour=fct_reorder2(as.factor(modell),parse_number(round),Poeng))+
        labs(colour="modell",title="Poeng etter runde og modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-7.png)

``` r
qplot(parse_number(round),`Kumulerte poeng`,data=resultater_full,geom="line",colour=fct_reorder2(as.factor(modell),parse_number(round),`Kumulerte poeng`))+
        labs(colour="modell",title="Totale poeng etter runde og modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-8.png)

``` r
qplot(Poeng,data=resultater_full,colour=modell,geom="density")+
        labs(title="Poengfordeling etter modell")
```

![](prediksjon_v2_files/figure-markdown_github/unnamed-chunk-23-9.png) Den lineære modellen har lavere rmse og litt høyere mae. Prediksjonen for runde 10 ser ut til å inneholde flere høye verdier for spillere som fikk lave verider (LM), noe som gir SVM større residualer og lavere prediksjoner.

Poengtesten viser igjen at benchmark-testen gjør det skarpt, og tidvis bedre enn SVM-modellen - inkl. i prediksjoner for runde 7-9. Kumulativt gjør SVM det bedre, og fordelinga tyder på at den ligger på et litt høyere nivå.

I testen for å velge et fullt lag gjør imidlertid SVM det drastisk mye bedre, og scorer konsekvent over 100 poeng per runde.
