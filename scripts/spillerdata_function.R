#function for å legge til spilleres status - skader mm - til estimeringsbakgrunnen

spillerdata_old = function(){
        library(dplyr)
        library(httr)
        library(jsonlite)
        source("scripts/datagrabbing_function.R")
        #kjører datagrabber for å sikre at det ligger oppdaterte spillerdata i /data/old
        datagrabber()
        #status ligger altså i filene som heter spillerdata.
        liste = list.files("./data/old/","spillerdata")
        historiske_spillerdata = data.frame()
        for(i in 1:length(liste)){
                temp = read.csv2(paste0("data/old/",liste[i]),stringsAsFactors = FALSE,colClasses = "character")
                temp$file_nr = i
                temp$dato_2 = gsub(".csv","",strsplit(liste[i],split="_",fixed=TRUE)[[1]][2],fixed=TRUE)
                historiske_spillerdata = bind_rows(historiske_spillerdata,temp)
        }
        #tester om datoene fra tittel er den samme som i kolonna
        #test = distinct(historiske_spillerdata,dato,dato_2,.keep_all=TRUE)
        #det stemmer,bruker dato_2 herifra
        #så er det å joine de sammen. først vil jeg bare joine inn runde
        temp_df = fromJSON(content(GET("https://fantasy.vg.no/drf/bootstrap-static"),"text",encoding="UTF-8"))
        runder = temp_df[[7]]
        #velger ut kolonnene jeg trenger
        runder = select(runder, round_id = id,name,deadline_time)
        #konverterer time til date
        runder$deadline_date = as.Date(runder$deadline_time)
        #først sette inn starttidspunkt
        runder$start_date = as.Date("2017-01-01")
        for(i in 1:nlevels(as.factor(runder$round_id))){
                if(i==1){
                        #setter første runde til 100 dager før deadline
                        runder$start_date[runder$round_id==i] = as.Date(runder$deadline_date[runder$round_id==i]-100)
                }
                if(i>1){
                        runder$start_date[runder$round_id==i] = as.Date(runder$deadline_date[runder$round_id==(i-1)])
                }
        }
        
        #så må det merges basert på en range - data.tables foverlaps ser ut til å kunne funke
        #basert på https://stackoverflow.com/questions/23371747/range-join-data-frames-specific-date-column-with-date-ranges-intervals-in-r 
        #som har speeches med ett tidspunkt og history med range, og joiner på date og id.
        historiske_spillerdata$dato_2 = as.Date(historiske_spillerdata$dato_2)
        historiske_spillerdata$dato_3 = historiske_spillerdata$dato_2
        
        require(data.table) ## 1.9.3+
        dt_historiske_spillerdata = setDT(historiske_spillerdata)
        dt_runder = setDT(runder)
        dt_historiske_spillerdata[,`:=`(dato_3 = dato_2)]
        setkey(dt_runder,start_date,deadline_date)
        historiske_spillerdata = foverlaps(dt_historiske_spillerdata, dt_runder, by.x=c("dato_2", "dato_3"))[, dato_3 := NULL]
        #dette ser ut som det funka, men jeg får omlag 2000 flere rader enn jeg starta med...15*430
        #hver mellom-runde har flere filer. jeg må teste om jeg har ulike statuser for samme mellomperiode
        #test = distinct(historiske_spillerdata,id,status,round_id)
        #count(test,round_id)
        #test = filter(left_join(test,data.frame(count(test,id,round_id))),n>1)
        #totalt 392 observasjoner fra div. runder har ulike statuser for samme runde. det holder altså ikke å joine på range
        #jeg må selektere vekk de filene som er lengst unna deadline.
        historiske_spillerdata$file_dato = historiske_spillerdata$dato_2
        historiske_spillerdata$diff_dato = historiske_spillerdata$file_dato - historiske_spillerdata$deadline_date
        historiske_spillerdata = left_join(historiske_spillerdata,count(distinct(historiske_spillerdata,round_id,file_dato,file_nr),round_id))
        historiske_spillerdata$file_count = historiske_spillerdata$n
        #innenfor hver runde må jeg beholde det datasettet med høyest diff_dato
        test = historiske_spillerdata %>%
                group_by(round_id,id)%>%
                arrange(desc(diff_dato))%>%
                top_n(1,diff_dato)
        #sjekker om det funka
        #test = ungroup(test) #husk ungroup!
        #count(test,round_id)
        #test2 = filter(left_join(test2,data.frame(count(test2,id,round_id))),n>1)
        #det gjorde det - nesten. siste utfordring: over har jeg plassert observasjonene innenfor hver runde,
        #og labla dem med neste runde (jeg henta info om spiller X mellom runde 1 og 2, da plasseres info som relevant for runde 2)
        #df_estimering fra dataprepper labler observasjoner til forrige runde (etter runde 1 har spiller Y følgende egenskaper)
        test$round_id = test$round_id-1
        historiske_spillerdata = test
        #fikser noen enhetlige omkodinger
        #lager et fullt navn
        historiske_spillerdata$navn = paste(historiske_spillerdata$first_name,historiske_spillerdata$second_name)
        #koder om posisjonskode til posisjonsnavn: 1 = keepere, 2 = forsvarsspillere, 3 = midtbanespillere, 4 = angrep
        historiske_spillerdata$posisjon = factor(historiske_spillerdata$element_type,labels=c("Keeper","Forsvar","Midtbane","Angrep"))
        #Koder om lagkode til lagnavn
        historiske_spillerdata$team = parse_number(historiske_spillerdata$team)
        historiske_spillerdata = arrange(historiske_spillerdata,team)
        historiske_spillerdata$team_navn = factor(historiske_spillerdata$team,labels=c("AAFK","BRA","FKH","KBK","LSK","MOL","ODD","RBK","SAN","SO8","SOG","STB","SIF","TIL","VIF","VIK"))
        distinct(historiske_spillerdata,team,team_navn)
        
        #tar ut variablene som skal eksporteres
        df = select(historiske_spillerdata,id,round_id,web_name,status,news,chance_of_playing_this_round,chance_of_playing_next_round,ep_next,element_type,team,posisjon,team_navn,selected_by_percent,navn)
        
        #sjekker for evt. parse-feil
        df$id = parse_number(df$id)
        #levels(as.factor(df$status))
        #levels(as.factor(df$ep_next))
        df$ep_next = parse_number(df$ep_next)
        #levels(as.factor(df$ep_next))
        #levels(as.factor(df$selected_by_percent))
        df$selected_by_percent = parse_number(gsub(",",".",df$selected_by_percent,fixed=TRUE))
        
        #sjekker for na
        #apply(df,2,function(x){sum(is.na(x))})
        
        #lagrer en lokal kopi av dataene
        write.csv2(df,paste0("data/spillerdata_runde-",min(df$round_id),"-",max(df$round_id),".csv"),row.names=F)
        return(df)
}







