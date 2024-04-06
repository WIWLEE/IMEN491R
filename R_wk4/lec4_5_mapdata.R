# lec4_5_mapdata.R
# map data
# spatial analysis

# set working directory
setwd("D:/rcode")

#공간지도 패키지 불러오기
library(raster)
library(rgdal)
library(rgeos)
library(ggplot2)
library(maptools)

## 1. 데이터 불러오기
#지도 데이터 불러오기
korea=shapefile('./data/TL_SCCO_CTPRVN.shp')
korea <- spTransform(korea, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
head(korea)

kmap <- fortify(korea,region='CTP_KOR_NM')
head(kmap)

#분석 데이터 불러오기
loss<- read.csv("./data/disaster_loss.csv")
loss=data.frame(loss)
loss

## 2. 행정구역지도와 데이터 결합하기
map_loss=merge(kmap,loss,by.x='id',by.y='CTP_KOR_NM')
head(map_loss)


## 3. 공간지도 그리기
ggplot() +
  geom_polygon(data=map_loss, aes(x=long, y=lat, group=group, fill=LOSS), color='black')+
  scale_fill_gradient(low='white', high='red')+
  labs(title="Typhoon annual average loss")

## 3-1. 라벨을 이용해 그리기
#sido:라벨을 찍을 위치와 데이터 결합 파일
id=c('강원도','경기도','경상남도','경상북도','광주광역시','대구광역시','대전광역시','부산광역시',
     '서울특별시','세종특별자치시','울산광역시','인천광역시','전라남도','전라북도','제주특별자치도',
     '충청남도','충청북도')
lat=c(37.73533029652902,37.37461571682183,35.34289466534233, 36.36421656520106, 35.15304344259423, 35.832921148206935, 36.34515471294123, 35.17054383562119, 
      37.653727266473544, 36.54678809312607, 35.55526578760384,37.47597369268592, 34.865797681620236,35.758055644819734, 33.397462234218615,
      36.53241594721893, 37.00226015826154 )
lon=c(128.4397367563543, 127.26963023732642,128.19793564596964,128.9105911242575,126.83143573256017,128.57562177593638, 127.39223207828397, 129.06218231400558,
      126.98917443004862,127.25928222608304,129.3267761313981,126.67537883135644,126.95171618419725,127.15494457083665,126.55618969258185,
      126.85961846125828, 127.73357551475945)
sido=data.frame(id,lat,lon)
sido=merge(sido,loss,by.x='id',by.y='CTP_KOR_NM')

#라벨 그리기
ggplot() +
  geom_polygon(data=map_loss, aes(x=long, y=lat, group=group), color='black' ,fill='white')+
  geom_label(data=sido, aes(x=lon, y=lat, label=LOSS))+
  labs(title="Typhoon annual average loss")

############ extra code #################
# mapdata : more world map 
# install.packages("mapdata")

library(mapdata)

# 1. Korea using mapdata package
map(database = 'worldHires', region = c('South Korea','North Korea'), col='green', fill = TRUE)
title("Korea")

# 2.Italy 
par(mfrow = c(1, 1),mar=c(2,2,2,2))
map(database = 'world', region = c('Italy'), col='coral', fill = TRUE)
title("Italy")

