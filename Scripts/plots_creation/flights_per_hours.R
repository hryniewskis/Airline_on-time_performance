library(dplyr)
library(stringr)
library(readr)
library(data.table)
library(tidyr)
library(ggplot2)
library(scales)


{razem<-NULL
    for (i  in seq(2006,2008)){
    t<-str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/", i ,".csv")
    obecny<-fread(t,colClasses=c(rep("NULL",4),rep(NA,1),rep("NULL",24)))
    pods_roku<-obecny %>% select("DepTime") %>% count(DepTime)
    razem<-bind_rows(pods_roku,razem)
    cat("year", i,"done\n")
  }
}

final<-razem %>%mutate(Hour=cut(.$DepTime, seq(from=0,to=2400,by=100,),dig.lab=4,labels = FALSE)) %>% group_by(Hour) %>% summarise(Total=sum(n)) %>% na.omit()
final$Hour<-final$Hour-0.5


ggplot(final,aes(Hour,Total))+
  geom_line(color="firebrick",size=2)+
  labs(x="Hour",y=expression(bold("Flights")))+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
  scale_y_continuous(n.breaks=8,labels = scales::label_number(suffix = "M",scale = 1e-6))+
  scale_x_continuous(n.breaks=9,labels=scales::label_number(suffix=":00",accuracy = 1))
