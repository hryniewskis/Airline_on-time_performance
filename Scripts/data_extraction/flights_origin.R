library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

{razem<-NULL
for (i in 2008){
#for (i  in seq(2006,2008)){
#for (i in seq(2004,2008)){
#for (i in seq(1987,2008)){
  t<-str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/", i ,".csv")
  obecny<-fread(t,colClasses=c(rep("NULL",16),NA,rep("NULL",12)))
  #to sie zmienia w zaleznosci od tego co chcemy policzyc
  pods_roku<-obecny %>% select("Origin") %>% count(Origin)
  #tutaj dostajemy dluga ramke ktora zawiera interesujace nas statystki (z kazdego roku oddzielnie)
  razem<-bind_rows(pods_roku,razem)
  cat("year", i,"done\n")
}}

zwracane<-aggregate(razem$n, by=list(OriginAP=razem$Origin), FUN=sum) %>% arrange(-x)%>% rename(Flights=x)

