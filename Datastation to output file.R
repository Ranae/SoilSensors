library(ggplot2)
library(reshape2)
library(plyr)
library(dplyr)
library(lubridate)
library(stringr)

setwd("C:/Users/rdietzel/Dropbox/Togliatti/Data Processing/SoilSensors")

fileList<- list.files('.', pattern=glob2rx('*.csv'))

for (i in 1:length(fileList)){
  columnNames <- c("time", "7cmw", "7cmt", "15cmw", "15cmt", "25cmw", "25cmt" )
  d <- read.csv(fileList[i], skip=3, header=FALSE)
  colnames(d) <- columnNames
  d$logger <- fileList[i]
  ifelse(i==1,final <- d, final <- rbind(final,d))
}

fix.plots <- function(x){
  x %>% 
    str_replace(pattern="EM31369-19May2015-1453.csv", replacement="100") %>%
    str_replace(pattern="EM30506-19May2015-1452.csv", replacement="200") %>%
    str_replace(pattern="EM30508-19May2015-1453.csv", replacement="300") %>%
    str_replace(pattern="EM31370-19May2015-1453.csv", replacement="500") %>%
    str_replace(pattern="EM31289-19May2015-1453.csv", replacement="600") %>%
    str_replace(pattern="EM30505-19May2015-1452.csv", replacement="700") %>%
    str_replace(pattern="EM31288-19May2015-1453.csv", replacement="900") %>%
    str_replace(pattern="EM31374-19May2015-1453.csv", replacement="1200") 
    
}

final$logger<-as.factor(fix.plots(final$logger))

final$crop[final$logger %in% c("100", "200", "300", "400" "500", "600")]<-"soy"
final$crop[final$logger %in% c("700", "800", "900", "1000", "1100", "1200")]<-"corn"
final$planting[final$logger %in% c("200", "300", "600", "700", "900", "1200")]<-"early"
final$planting[final$logger %in% c("100", "400", "500", "800", "1000", "1100")]<-"late"

final$time<-as.POSIXct(strptime(df$time, "%m/%d/%Y %H:%M:%S"))


final$date<-parse_date_time(final$time, "%m/%d/%Y %H:%M:%S")#need timezone
final$date<-yday(final$date)

