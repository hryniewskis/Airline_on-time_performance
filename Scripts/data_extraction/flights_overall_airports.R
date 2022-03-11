library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

{
str="last_1_yr_most_pop_airports"
#str="last_3_yrs_most_pop_airports"
#str="last_5_yrs_most_pop_airports"
#str="last_3_yrs_most_pop_airports"

przyloty<-fread(str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/activity/origin/full_info/",str,".csv"),header = TRUE)
odloty<-fread(str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/activity/destination/full_info/",str,".csv"),header = TRUE)
}


zwracane<-full_join(przyloty,odloty,by=c("OriginAP"="DestAP")) %>%
          mutate_all(~replace(., is.na(.), 0)) %>% 
          mutate(Flights=Flights.x+Flights.y) %>% 
          select("OriginAP","Flights") %>% 
          rename("Airport"="OriginAP") %>% 
          arrange(-Flights)

fwrite(zwracane,str_c("../../CSV/results/origin_dest/", str ,"_od.csv"))
