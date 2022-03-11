library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)

airports=read.csv("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/airports.csv")

{
  razem<-NULL
  for (i in seq(2006,2008)){
  #for (i in c(2008)){
    year<-str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/", i ,".csv")
    obecny<-fread(year,colClasses = c("NULL",rep(NA,3),"NULL",NA,rep("NULL",2),NA,rep("NULL",5),NA,NA,NA,rep("NULL",12)))
    #obecny2<-fread(year,colClasses = c("NULL",rep(NA,3),"NULL",NA,rep("NULL",2),NA,rep("NULL",5),NA,"NULL","NULL",NA,rep("NULL",11)))
    tmp<- obecny %>% filter(DepDelay>=-60) %>%  mutate(Del_Only=fifelse(ArrDelay<0,0,ArrDelay)) %>%   select(Origin,Del_Only) %>% drop_na() %>%group_by(Origin)%>% summarise(Flights=n(), TotDelay=sum(Del_Only))
    razem<-bind_rows(razem,tmp)
    cat("year", i,"done\n")
  }
}

{
  str="last_1_yr_delay_states"
  #str="last_3_yrs_delay_states"
}

airports_tmp<-airports %>% select(iata,state)
zwracane<-inner_join(razem,airports_tmp,by=c("Origin"="iata")) %>% rename(State=state)

{
  top<-zwracane %>% group_by(State) %>% summarise(Average=(sum(TotDelay)/sum(Flights)),NoFlights=sum(Flights)) %>% arrange(Average)
  fwrite(top,str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/results/delay/states/", str ,".csv"))
}

