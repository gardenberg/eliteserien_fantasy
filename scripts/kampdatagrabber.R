kampdatagrabber = function(url_data="http://www.nifs.no/kamper.php?land=1&t=5&u=672248",tidspunkt = "2016-05-10",aar="2016",neste=FALSE){
        library(tidyr)
        library(rvest)
        library(dplyr)
        library(readr)
        library(ggplot2)
        library(stringr)
        library(knitr)
        
        file = read_html(url_data)        
        tabeller = html_nodes(file, "table")
        #antar at tabell_6 jevnt over er tabellen vi ønsker
        tabell_6 <- html_table(tabeller[[6]], fill = TRUE)        
        #antar at alle tabellene får den ubruke tittelen som første rad, og at det er 241 rader
        tabell_6 = slice(tabell_6,2:nrow(tabell_6))
        names(tabell_6)[1] = "data"
        #antar at tabellen er sortert (skulle heller brukt grep1), og kutter alle ikke-spilte kamper
        if(aar=="2017"&neste==FALSE){
                tabell_6 = slice(tabell_6,1:grep("Ikke spilt",tabell_6$data,fixed=TRUE)[1]-1)
        }
        if(aar=="2017"&neste==TRUE){
                tabell_6 = slice(tabell_6,grep("Ikke spilt",tabell_6$data,fixed=TRUE)[1]:grep("Ikke spilt",tabell_6$data,fixed=TRUE)[8])
        }
        #antar at alle tabellene har \t og \n som ubrukelige symboler
        tabell_6$data_2 = gsub("\t","",tabell_6$data,fixed=TRUE)
        tabell_6$data_2 = gsub("\n","",tabell_6$data_2,fixed=TRUE)
        #antar samme lengde på hver rad
        df = separate(tabell_6,data_2,into=c("dato","div"),sep=10,extra="merge")
        df = separate(df,div,into=c("klokkeslett","div"),sep=6,extra="merge")
        df$dato = as.POSIXct(df$dato)
        df_1 = separate(filter(df,dato<as.POSIXct(tidspunkt)),div,into=c("runde","div"),sep=7,extra="merge")
        df_2 = separate(filter(df,dato>as.POSIXct(tidspunkt)),div,into=c("runde","div"),sep=8,extra="merge")
        df = bind_rows(df_1,df_2)
        df = separate(df,div,into=c("hjemmelag","div"),sep="-",extra="merge")
        df = separate(df,div,into=c("fjernes_1","div"),sep="[:blank:]",extra="merge")
        df = separate(df,div,into=c("bortelag","div"),sep="[:blank:]",extra="merge")
        if(aar=="2017"&neste==TRUE){
                df$sluttresultat=NA
                df$pauseresultat=NA
                df = separate(df,div,into=c("fjernes_2","div"),sep=19,extra="merge")
                df = separate(df,div,into=c("hjemme_odds","div"),sep=4,extra="merge")
                df = separate(df,div,into=c("uavgjort_odds","div"),sep=4,extra="merge")
                df = separate(df,div,into=c("borte_odds","kommentar"),sep=4,extra="merge",fill="right")
        }
        if(neste==FALSE){
                df = separate(df,div,into=c("sluttresultat","div"),sep="\\(",extra="merge")
                df = separate(df,div,into=c("pauseresultat","div"),sep="\\)",extra="merge")
                df = separate(df,div,into=c("fjernes_2","hjemme_odds","uavgjort_odds","borte_odds"),sep=":",extra="merge")
                df$hjemme_odds = gsub("U","",df$hjemme_odds,fixed=TRUE)
                df$uavgjort_odds = gsub("B","",df$uavgjort_odds,fixed=TRUE)
                df = separate(df,borte_odds,into=c("borte_odds","kommentar"),sep="[:blank:]",extra="merge",fill="right")
        }
        #edgecase-opprydding
        df$sluttresultat[df$bortelag=="Sarpsborg"]=gsub("08","",df$sluttresultat[df$bortelag=="Sarpsborg"],fixed=TRUE)
        df$bortelag[df$bortelag=="Sarpsborg"]=gsub("Sarpsborg","Sarpsborg 08",df$bortelag[df$bortelag=="Sarpsborg"],fixed=TRUE)
        df$sluttresultat[df$bortelag=="Sandnes"]=gsub("Ulf","",df$sluttresultat[df$bortelag=="Sandnes"],fixed=TRUE)
        df$bortelag[df$bortelag=="Sandnes"]=gsub("Sandnes","Sandnes Ulf",df$bortelag[df$bortelag=="Sandnes"],fixed=TRUE)
        #siste opprydding
        df = select(df,-fjernes_1,-fjernes_2)
        df$aar = aar
        return(df)
}