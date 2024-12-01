## find the best hyperparameter that improve model performance

library(tidyverse)
library(caret)
library(mlbench)

data("BostonHousing")
data("PimaIndiansDiabetes")

## review train
clean_df <- mtcars %>% 
  select(mpg, hp, wt, am) %>%
  ## median imputation
  mutate(hp = replace_na(hp, 146.68),
         wt = replace_na(wt, 3.21)) %>%
  drop_na() 

## linear regression
(lm_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "lm"
))

## knn: k-nearest neighbors
## Experimentation
set.seed(42)

## grid search (dataframe)
k_grid <- data.frame(k = c(3,9) )

ctrl <- trainControl(
  method = "cv",
  number = 3,
  verboseIter = TRUE # progress bar
)

knn_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "knn",
  metric = "RMSE",
  trControl = ctrl,
  tuneGrid = k_grid
)

## random k, 4 values
knn_model <- train(
  mpg ~ ., 
  data = clean_df,
  method = "knn",
  metric = "RMSE",
  trControl = ctrl,
  tuneLength = 3
)

## save model
## .RDS extension
saveRDS(knn_model, "knnModel.RDS")


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












