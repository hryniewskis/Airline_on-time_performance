library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)


names<-c("last_1_yr_most_flights_od","last_3_yrs_most_flights_od")
for (i in names){
  str<-str_c('D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/routes/full_data/', i ,".csv")
  raw<-fread(str)
  tmp3<-raw %>%rowwise() %>%  mutate(Between=str_c(min(Origin,Dest)," ",max(Origin,Dest)))
  zwracane<-aggregate(tmp3$Flights,by=list(Between=tmp3$Between),FUN=sum) %>% arrange(-x) %>% rename(Flights=x)
  i=str_replace(i,"_od","_between")
  zapisz_wynik(zwracane,str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/routes/full_data/",i,".csv"))
  
}
