library(dplyr)
library(stringr)
library(data.table)
library(ggplot2)

{
  year<-str_c("D:/Documents/DS/1 semestr/DPRPy/Projekty/Projekt 2/CSV/", 2001 ,".csv")
  obecny<-fread(year,colClasses = c("NULL", NA,NA,rep("NULL",18),NA,rep("NULL",7)))
  podsumowanie<- obecny %>% mutate(Date=as.Date(str_c(.$DayofMonth,.$Month,2001,sep=","),format="%d,%m,%Y")) %>%
    group_by(Date) %>% summarise(CancelledPerc=mean(Cancelled))
}
days<-as.Date(str_c(podsumowanie$DayofMonth,podsumowanie$Month,2001,sep=","),format="%d,%m,%Y")
Sys.setlocale(locale="English")

ggplot(podsumowanie,aes(Date,CancelledPerc))+geom_line(color="firebrick",size=1.5)+labs(x="Month",y="Cancelled flights")+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
  scale_x_date(date_labels="%b",date_breaks="2 months")+
  scale_y_continuous(labels = scales::percent)

Sys.setlocale(locale="Polish")
