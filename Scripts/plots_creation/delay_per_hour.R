library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)
library(ggplot2)

{
  razem<-NULL
  for (year in seq(2006,2008)){
    #for (i in c(2008)){
    file_path<-str_c("../../CSV/data/", year ,".csv")
    obecny<-fread(file_path,colClasses = c("NULL",rep(NA,3),"NULL",NA,rep("NULL",2),NA,rep("NULL",5),NA,NA,NA,rep("NULL",12)))
    #obecny2<-fread(year,colClasses = c("NULL",rep(NA,3),"NULL",NA,rep("NULL",2),NA,rep("NULL",5),NA,"NULL","NULL",NA,rep("NULL",11)))
    tmp<- obecny %>%
          filter(DepDelay>=-60) %>%
          mutate(Del_Only=fifelse(ArrDelay<0,0,ArrDelay)) %>%  
          select(CRSDepTime,Del_Only) %>%
          drop_na() %>% 
          mutate(Hour=cut(.$CRSDepTime, seq(from=0,to=2400,by=100),dig.lab=4,labels = FALSE)) %>%
          group_by(Hour)%>% 
          summarise(Flights=n(), TotDelay=sum(Del_Only))
    razem<-rbindlist(list(razem,tmp))
    cat("year", i,"done\n")
  }
}

final<-razem %>% na.omit() %>%  group_by(Hour) %>% summarise(Flights_all=sum(Flights), TotDelay_all=sum(TotDelay)) %>% mutate(AverageDel=TotDelay_all/Flights_all,.keep="unused")
final$Hour<-final$Hour-0.5

ggplot(final,aes(Hour,AverageDel))+
  geom_line(color="firebrick",size=2)+
  labs(x="Hour",y=expression(bold("Average Delay")))+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
  scale_y_continuous(n.breaks=8,labels=scales::label_number(suffix=" min",accuracy = 1))+
  scale_x_continuous(n.breaks=9,labels=scales::label_number(suffix=":00",accuracy = 1))

