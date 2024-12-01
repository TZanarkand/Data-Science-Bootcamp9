library(nycflights13)
library(tidyverse)
library(dplyr)

data("flights")
data("airlines")

# Q1 :ในปี 2013 มีเที่ยวบินจากไหนไปไหนเยอะที่สุด
f1 <- flights %>% 
  select(origin,dest,year) %>%
  filter(year == 2013) %>%
  count(origin,dest) %>%
  arrange(desc(n))

# Q2 :อยากทราบระยะทางของเที่ยวบินแต่ละเที่ยวในหน่วย km และ ความเร็วเฉลี่ยในอากาศของแต่ละเที่ยวบิน
f2 <- flights %>%
  inner_join(airlines) %>%
  filter(air_time != "") %>%
  select(name, month, day, origin, dest, distance, air_time, carrier) %>%
  mutate(distance_in_km = round(distance * 1.609344,2),
         speed_kph = floor(distance_in_km / (air_time/60)) ) %>%
  arrange(distance_in_km, desc(speed_kph)) %>% 
  head(5)

# Q3 : อยากทราบว่าในปี 2013 เครื่องบินทุกสายมีระยะทางบินรวมกันเท่าไหร่ และ ค่าสูงสุด ต่ำสุด และค่าเฉลี่ย ของระยะทาง และความเร็ว(ในหน่วยkmph)
f3 <- flights %>%
  select(distance, air_time) %>%
  mutate(distance_in_km = distance * 1.609344,
         speed_kph = distance_in_km / (air_time/60)) %>%
  summarise(avg_dist_km = mean(distance_in_km),
            min_dist_km = min(distance_in_km),
            max_dist_km = max(distance_in_km),
            total_dist_km = sum(distance_in_km),
            avg_spd_kph = mean(speed_kph, na.rm = TRUE),
            min_spd_kph = min(speed_kph, na.rm = TRUE),
            max_spd_kph = max(speed_kph, na.rm = TRUE),
            count = n())
# เป็น optional ลองๆ ดู: speed_kph_adjusted = ifelse(is.na(speed_kph), mean(speed_kph), speed_kph) ) %>%

# Q4 : อยากทราบว่าในปี 2013 มีเที่ยวบินที่มีระยะทางน้อยกว่า 100 ไมล์ และ มากกว่า 3000 ไมล์ จำนวนกี่เที่ยวและบินจากไหนไปไหนบ้าง โดยใช้สายการบินอะไร
f4 <- flights %>%
  filter(distance >= 3000 | distance <= 100) %>%
  group_by(carrier,origin, dest, distance) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  left_join(airlines)

# Q5 : อยากทราบว่าในปี 2013 เดือนธันวาคม (เทศกาลคริสต์มาส และ ปีใหม่) ผู้คนเดินทางไปยังที่ใดมากที่สุด
f5 <- flights %>%
  select(month, dest) %>%
  filter(month == 12) %>%
  count(dest) %>%
  arrange(desc(n)) %>%
  head(10) 