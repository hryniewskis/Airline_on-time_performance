library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

{
  #str="last_1_yr_most_pop_states"
  #str="last_3_yrs_most_pop_states"

przyloty<-fread(str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/activity/origin/",str,".csv"),header = TRUE)
odloty<-fread(str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/activity/destination/",str,".csv"),,header = TRUE)
}

razem<-full_join(przyloty,odloty,by=c("OriginSt"="DestSt")) %>% mutate_all(~replace(., is.na(.), 0)) %>% mutate(Flights=Flights.x+Flights.y) %>% select("OriginSt","Flights") %>% rename("State"="OriginSt") %>% arrange(-Flights)





