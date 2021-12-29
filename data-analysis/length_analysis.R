setwd("C:/Users/zhuzi/Downloads/ProsExp")
data = read.csv("NA_length_analysis.csv", header = TRUE)
View(data)

library(dplyr)

data %>%
  group_by(q_type) %>%
  summarize(mean(overall_length), mean(length_no_wh))

data %>%
  group_by(q_type) %>%
  summarize(sd(overall_length), sd(length_no_wh))

t.test(overall_length ~ q_type, data = data, var.equal = TRUE)
t.test(length_no_wh ~ q_type, data = data, var.equal = TRUE)
