## Correlation
cor(mtcars$mpg, mtcars$hp)
cor(mtcars$mpg, mtcars$wt)

plot(mtcars$hp, mtcars$mpg, pch=16)

# correlation matrix
cor(mtcars[ , c("mpg", "wt", "hp")])

## dplyr (tidyverse)
library(dplyr)

corMat <- mtcars %>% 
  select(mpg, wt, hp) %>%
  cor() 

# compute correlation (r) and sig test
cor(mtcars$mpg, mtcars$hp)
# จะทราบ p-value ด้วย และรู้ค่า CI
cor.test(mtcars$mpg, mtcars$hp)



## Linear Regression 
## mpg = f(hp) ; mpg เป็นฟังก์ชันของ hp
lmFit <- lm(mpg ~ hp, data = mtcars)

# สรุปผลเห็น T, F, Regress, Box_plot ทุกสรรพสิ่ง
summary(lmFit)

## prediction
# สมมติแรงม้า = 200
# manual
lmFit$coefficients[[1]] + lmFit$coefficients[[2]] * 200

# ถ้ารถหลายคันละ ?
new_cars <- data.frame(
  hp = c(250,320,400,410,450)
)
## predict()
# ทำนายแบบ multiple โดยทำเป็น vector
new_cars$mpg_pred <- predict(lmFit, newdata = new_cars)
new_cars$hp_pred <- NULL # ลบ
new_cars

# ข้อเสีย Linear อย่าใช้ data ที่ beyond เกินไป 
# เก็บข้อมูลให้มากขึ้น เพื่อเพิม scope range
summary(mtcars$hp)



## Root Mean Squared Error (rmse)
## Multiple Linear Regression 
## mpg = f(hp, wt, am)
## mpg = intercept + bo*hp + b1*wt + b2*am

lmFit_V2 <- lm(mpg ~ hp + wt + am, data = mtcars)

coefs <- coef(lmFit_V2)
# manual
coefs[[1]] + coefs[[2]]*200 + coefs[[3]]*3.5 + coefs[[4]]*1
## Build Full Model with ( . )
lmFit_Full <- lm(mpg ~ ., data = mtcars)
## ลบ gear
lmFit_Full <- lm(mpg ~ . - gear, data = mtcars)
# จะได้ค่า predicted [mpg]
mtcars$predicted <- predict(lmFit_Full)

## Train RMSE 
# RMSE [ actual - predicted ]
# ค่า error ของ dataset ที่ใช้ train model ตัวนี้ขึ้นมา
squared_error <- (mtcars$mpg - mtcars$predicted) ** 2
rmse <- sqrt(mean(squared_error))
rmse

## -----------------------


summary(lmFit_Full)


library(titanic)
head(titanic_train)
