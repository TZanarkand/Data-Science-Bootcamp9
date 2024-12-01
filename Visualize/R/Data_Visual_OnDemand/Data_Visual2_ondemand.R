## ggplot2
## library tidyverse
library(tidyverse)

## Discrete = factor
## Continuous = numeric

## First Plot
ggplot(data = mtcars, mapping = aes(x = hp, y = mpg)) +
       geom_point() + 
       geom_smooth() + 
       geom_rug()
## แบบย่อ
ggplot(mtcars, aes(hp, mpg)) +
  geom_point(size = 3, col = "blue", alpha = 0.2) 
## alpha ความเข้มจาง

ggplot(mtcars, aes(hp)) +
  geom_histogram(bins = 10, fill = "red", alpha = 0.5)
## bins อย่าใช้ค่า default
## ต้องเห็น pattern 

ggplot(mtcars, aes(hp)) +
  geom_boxplot()

## เทคนิค reuse code
## density เป็น hist ที่ norm มา
p <- ggplot(mtcars, aes(hp))
p + geom_histogram(bins = 10)
p + geom_density()

## Box plot by groups
# table(diamonds$cut) แต่ count ง่ายกว่า 
diamonds %>% 
  count(cut)
  
## ordinal factor -> Bar_Chart
ggplot(diamonds, aes(cut)) +
  geom_bar(fill = "lightblue")
## mapping ไม่ใส่ก็ได้ 
## อิงสีตาม cut
ggplot(diamonds, mapping = aes(cut, fill=cut)) +
  geom_bar()
## geom_bar(position = "stack") default
## dodge คือไม่ให้ซ้อนกัน
ggplot(diamonds, mapping = aes(cut, fill=color)) +
  geom_bar(position = "dodge")
## เป็น % 0 - 1
ggplot(diamonds, mapping = aes(cut, fill=color)) +
  geom_bar(position = "fill")

## SCATTER PLOT 
## aes = ความสวยงาม 
## เรียก tidyverse ก็ไม่ต้องเรียก dplyr ก็ได้
set.seed(42)
small_diamonds <- sample_n(diamonds, 5000)

ggplot(small_diamonds, aes(carat, price)) +
  geom_point()

## FACET : small multiples
## แบ่งตาม color
ggplot(small_diamonds, aes(carat, price)) +
  geom_point() + 
  geom_smooth(method = "lm", col = "red") +
  facet_wrap(~color, ncol = 3) + # 4 column 
  theme_minimal() +
  labs(title = "Relationship between carat and price by color",
       x = "carat",
       y = "Price USD",
       caption = "Source: Diamonds from ggplot2 package")
# set vs map
ggplot(small_diamonds, aes(carat, price, col=cut)) +
  geom_point(size = 3, alpha = 0.2) + 
  facet_wrap(~color, ncol = 2) +
  theme_minimal()
