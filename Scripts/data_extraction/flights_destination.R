library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

zapisz_wynik<-function(plik,nazwa_pliku)
{
  if(!file.exists(nazwa_pliku)){
    write_csv(x=plik,file=nazwa_pliku)
    cat("ok")
  } else {
    cat("Coś zepsułeś")
  }
  
}

airports=fread("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/airports.csv",fill=TRUE)

{razem<-NULL
#for (i in 2008){
for (i  in seq(2006,2008)){
#for (i in seq(2004,2008)){
#for (i in seq(1987,2008)){
  t<-str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/", i ,".csv")
  obecny<-fread(t,columns=c("Dest"))
  #to sie zmienia w zaleznosci od tego co chcemy policzyc
  pods_roku<-obecny %>% select("Dest") %>% count(Dest)
  #tutaj dostajemy dluga ramke ktora zawiera interesujace nas statystki (z kazdego roku oddzielnie)
  razem<-bind_rows(pods_roku,razem)
  cat("year", i,"done\n")
}}


top<-aggregate(razem$n, by=list(DestAP=razem$Dest), FUN=sum) %>% arrange(-x)%>% rename(Flights=x)

airports_tmp<-airports %>% select(iata,state)
zwracane<-inner_join(top,airports_tmp,by=c("DestAP"="iata"))
zwracane<-aggregate(zwracane$Flights, by=list(DestSt=zwracane$state), FUN=sum) %>% arrange(-x) %>% rename(Flights=x)


