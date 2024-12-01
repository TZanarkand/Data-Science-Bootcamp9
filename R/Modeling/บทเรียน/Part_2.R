library(mlbench) # เป็น dataset
library(tidyverse)
library(caret)

data("BostonHousing")
data("PimaIndiansDiabetes")
data("mtcars")

## review train
clean_df <- mtcars %>% 
  ## select(mpg, hp, wt, am) %>% 
  mutate(hp = replace_na(hp, 146.68),
         wt = replace_na(wt, 3.21)) %>%
  ## rule of thumb: NA < 3-5% it's ok to drop Na
  drop_na() 

View(clean_df)

## AIS
churn ~ data + call + sms + roaming(0) 
# roaming อาจมีการใช้งาน 120MB แต่ อาจจะไม่มีเลยก็ได้เพราะเขาไม่ได้ไป ตปท
# การ imputation พิจารณาข้อมูลด้วย

## linear regression 
## ถ้าเราลองใส่ตัวแปรต้นทั้งหมดไป ผลลัพธ์มันจะแย่ลงเพราะตัวแปรมันไม่ได้เกี่ยวข้องอะไร
lm_model <- train(
  mpg ~ ., # ใส่ตัวแปรต้นทั้งหมด
  data = clean_df,
  method = "lm"
)

## decision tree
set.seed(42)

(tree_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "rpart", 
  metric = "RMSE"
))

## KNN: k-nearest neightbors
## ระบุด้วยว่าจะใช้อะไรจูน
## ถ้าเราใส่วงเล็บครอบ เวลา run มันจะแสดงผลลัพธ์ให้เลย
## resampling ทำให้ข้อมูลไม่เหมือนเดิมต้อง set.seed
set.seed(42)
(knn_model <- train(
  mpg ~ ., # ใส่ตัวแปรต้นทั้งหมด
  data = clean_df,
  method = "knn", 
  metric = "Rsquared"
))

## grid search (dataframe) รับได้แค่แบบนี้
k_grid <- data.frame(k=c(3,5,7)) 

crtl <-  trainControl(
  method = "cv",
  number = 5, # ทำจนถึง 5 fold
  verboseIter = TRUE # progress bar 
) 

## ตัวเด็ด
crtl <-  trainControl(
  method = "repeatedcv", # ใช้ตัวนี้
  number = 3, 
  repeats = 5, # ทำ Fold ละ rep = 5 ครั้ง
  verboseIter = TRUE 
) 

(knn_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "knn", 
  metric = "Rsquared",
  trControl = crtl,
  #tuneGrid = k_grid
))

## 2 แนวคิด 1. ลองเรื่อยๆ 2. เลือก model ที่เทรนง่าย
## เลือก hyperpara 5 7 9 ดีๆ  ขึ้นอยู่กับ metric ที่ใช้ในการจูน 
## concept: Experimentation ลองเรื่อยๆๆๆๆๆๆๆๆ

## ลองใช้ tuneLength เป็นการ random ค่า k ขึ้นมาตาม n ที่เรากำหนด
(knn_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "knn", 
  metric = "RMSE",
  trControl = crtl,
  tuneLength = 5
))

## save model
## .RDS extension
saveRDS(knn_model, "knnModel.RDS")

## read RDS 
friend_laptop <- readRDS("knnModel.RDS")

## Batch Procession

## Jan 2024 => train model .RDS
## Feb 2024 => train model2 .RDS

## Streaming/ Near Real-Time Processing
# 10.50Am => new customers => predict เป็นการ train แบบ real-time




## จุดตัดสำคัญที่บอกว่าเข้าใจ ML หรือไม่
## normalization
## 1. min-max (feature scaling 0-1)
## 2. standardization -3,+3

x <- c(5, 10, 12, 15, 20)

minmaxNorm <- function(x) {
  (x-min(x)) / ( max(x)-min(x) )
}

# center and scale
# standardization
zNorm <- function(x) {
  (x-mean(x)) / sd(x)
}

## preProcess()
train_df <- mtcars[1:20, ]
test_df <- mtcars[21:32, ]

## compute x_bar, x_sd
transformer <- preProcess(train_df,
                          method=c("center","scale"))

## min max scaling [0,1]
transformer <- preProcess(train_df,
                          method=c("range"))

train_df_z <- predict(transformer, train_df)
test_df_z <- predict(transformer, test_df)

# ลองดูว่าแบบไหนได้ performance ที่ดี ต้องลองๆๆๆๆ