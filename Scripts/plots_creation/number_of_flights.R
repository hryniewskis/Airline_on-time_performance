library(dplyr)
library(stringr)
library(data.table)
library(tidyr)
library(ggplot2)
library(scales)
library(lubridate)
{
  razem<-NULL
for (i in seq(1987,2008)){
  year<-str_c("../../CSV/", i ,".csv")
  #faster version of read_csv from data.table package
  obecny<-fread(year,colClasses = c(NA,rep("NULL",28)))
  podsumowanie<- obecny %>% group_by(Year) %>% summarise(Flights=n())
  #faster version of bind_rows from data.table package
  razem<-rbindlist(list(razem,podsumowanie))
  #to see the progress of the data loading
  cat("year", i,"done\n")
}}

ggplot(razem,aes(ymd(Year,truncated = 2),Flights))+
  geom_line(color="royalblue",size=1.5,stat = "smooth",method="loess",alpha=0.4)+
  geom_point(color="firebrick",size=3)+
  labs(x="Year",y=expression(bold("Flights (in milions)")))+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+
  scale_y_continuous(n.breaks=8,labels = scales::label_number(suffix = "M",scale = 1e-6))+
  scale_x_date(labels = date_format("%Y"),date_breaks="4 years")

