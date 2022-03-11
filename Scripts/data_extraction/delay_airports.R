library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

{
  razem<-NULL
for (year in seq(2006,2008)){
#for (i in c(2008)){
  file_path<-str_c("../../CSV/data/", year ,".csv")
  obecny<-fread(file_path,colClasses = c("NULL",rep(NA,3),"NULL",NA,rep("NULL",2),NA,rep("NULL",5),NA,NA,NA,rep("NULL",12)))
  tmp<- obecny %>% 
        filter(DepDelay>=-60) %>% 
        mutate(Del_Only=fifelse(ArrDelay<0,0,ArrDelay)) %>%
        select(Origin,Del_Only) %>% drop_na() %>%
        group_by(Origin)%>% summarise(Flights=n(), TotDelay=sum(Del_Only))
  razem<-rbindlist(list(razem,tmp))
  cat("year", i,"done\n")
  }
}


zwracane<-razem %>% 
          group_by(Origin) %>% 
          summarise(Average=(sum(TotDelay)/sum(Flights)),NoFlights=sum(Flights)) %>%
          arrange(Average)

str="last_3_yrs_most_delay_airports"
fwrite(zwracane,str_c("../../CSV/results/", str ,".csv"))
