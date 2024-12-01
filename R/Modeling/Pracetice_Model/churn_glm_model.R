library(tidyverse)
library(caret)

df <- read_csv("churn.csv")

## 1.split data
train_test_split <- function(){
    set.seed(42)
    n <- nrow(df) # จำนวน row ของ df
    train_id <- sample(1:n, 0.8*n) # ดึงมา 80% ส่วนของ test data
    train_df <- df[train_id, ] 
    test_df <- df[-train_id, ] # data ใน train_id ที่ใช้ไปแล้วจะถูกลบไป 
    return(list(train_df, test_df)) # เก็บได้มากกว่า 1 ค่า 
}

prep_df <- train_test_split()

## 2. train model
model <- train(churn ~ totaldaycalls + totalevecalls + totalnightcalls,
               data = prep_df[[1]], # train_df
               method = "glm") # Logistic regression

## 3. score model
pred_churn <- predict(model, newdata = prep_df[[2]]) # นำ model ไป score/predict กับ test_data

## 4. evaluate model 
actual_churn <- prep_df[[2]]$churn

## error = actual - prediction
test_mae <- (mean(abs(pred_churn - actual_churn)))

MAE(pred_churn, actual_churn)







