library(titanic)
library(tidyverse)

## convert Survived to factor
titanic_train$Survived <- factor(titanic_train$Survived,
                                 levels = c(0,1),
                                 labels = c("Dead", "Alive"))

## predict survival [0 - Dead, 1 - Alive]
head(titanic_train)

## drop Na (missing values)
titanic_train <-  na.omit(titanic_train)
nrow(titanic_train)

## split data
set.seed(42)
n <-nrow(titanic_train)
id <- sample(1:n, n*0.8) ## 80% train 20% test
train_data <- titanic_train[id, ]
test_data <- titanic_train[-id, ]

## train model 
logis_model <- glm(Survived ~  Sex + Pclass + Age, data = train_data, family = "binomial")
p_train <-  predict(logis_model, type = "response") ## probability
train_data$pred <- if_else(p_train >= 0.45, "Alive", "Dead")
acc_train <- mean(train_data$Survived == train_data$pred)

## test model
p_test <-  predict(logis_model, newdata = test_data, type = "response") ## probability
test_data$pred <- if_else(p_test >= 0.45, "Alive", "Dead")
acc_test <- mean(test_data$Survived == test_data$pred)

## Acc
cat("Acc train_data:", acc_train,
    "\nAcc test_data:", acc_test)
cat("Acc diff:", abs(acc_train-acc_test))


