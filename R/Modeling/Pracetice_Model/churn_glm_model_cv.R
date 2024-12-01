library(tidyverse)
library(caret)
library(mlbench)

df <-  read_csv("churn.csv")

## preview data
head(df)

## change type of y to factor
df$churn <- factor(df$churn, 
                    levels=c("No","Yes"), 
                    labels=c("No", "Yes"))
## check churn
table(df$churn)

## 1. split data
train_test_split <- function(data, size=0.8) {
  set.seed(42)
  n <- nrow(data)
  train_id <- sample(1:n, size*n)
  train_df <- data[train_id, ] 
  test_df <- data[-train_id, ]
  return( list(train_df, test_df) )
}

prep_df <- train_test_split(df, size=0.8)

## 2. train model
## cv stands for K-Fold CV
ctrl <- trainControl(method = "cv",
                     number = 5)

model <- train(churn ~ totaldayminutes + totaleveminutes + totalnightminutes + numbervmailmessages,
               data = prep_df[[1]],
               method = "glm",
               trControl = ctrl)

## 3. score model
pred_churn <- predict(model, newdata= prep_df[[2]])

## 4. evaluate model with acc
actual_churn <- prep_df[[2]]$churn

acc <- mean(actual_churn == pred_churn)

