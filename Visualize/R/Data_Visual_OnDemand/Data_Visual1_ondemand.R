## get working directory
getwd()

## library tidyverse
library(tidyverse)

## basic plot (base R)

hist(mtcars$mpg)

## Analyzing horse power 
## Histogram - One Quantitative Variable
hist(mtcars$hp)
mean(mtcars$hp)
median(mtcars$hp)

## Change 0,1 from am to Auto, Manual by factor 
str(mtcars)
mtcars$am <- factor(mtcars$am,
                    levels = c(0, 1),
                    labels = c("Auto", "Manual"))

## นับจำนวน
table(mtcars$am)

## Bar Plot - One Qualitative Variable (1 ตัวแปรเชิงคุณภาพ)
barplot(table(mtcars$am))

## ใช้เยอะมากกกกก 
## Box Plot
boxplot(mtcars$hp)
fivenum(mtcars$hp) 
# ได้เลขมา 5 ตัว min Q1 Q2 Q3 max
# Q2 = med 
# รันแค่ fivenum + boxplot = combo set
min(mtcars$hp)
quantile(mtcars$hp, probs = c(.25, .5, .75))
max(mtcars$hp)

## whisker Calculation (เส้นขีดๆ ตรง box_plot)
## แบบว่ากำลังม้าเกิน 300 คือ outlier
Q3 <- quantile(mtcars$hp, probs = .75)
Q1 <- quantile(mtcars$hp, probs = .25)
IQR_hp <- Q3 - Q1

Q3 + 1.5*IQR_hp
Q1 - 1.5*IQR_hp

boxplot.stats(mtcars$hp, coef = 1.5)

## filter out outliers
## มี outlier 335 ต้องตัดออก 
mtcars_no_out <- mtcars %>% 
  filter(hp < 335)

# no outlier 
boxplot(mtcars_no_out$hp)

## Boxplot 2 variables
## Qualitative x Quantitative
data(mtcars)
mtcars$am <- factor(mtcars$am,
                    levels = c(0, 1),
                    labels = c("Auto", "Manual"))
boxplot(mpg ~ am, data = mtcars,
        col = c("gold", "salmon"))

## scatter plot
## 2 x Quantitve
## pch คือลักษณะจุดที่ plot
plot(mtcars$hp, mtcars$mpg, pch = 16, 
     col="blue",
     main = "Relationship between HP and MPG",
     xlab = "Horse Power",
     ylab = "Miles Per Gallon")
# แรงม้าสูง mpg ลดลง
cor(mtcars$hp, mtcars$mpg)
lm(mpg ~ hp, data = mtcars)

