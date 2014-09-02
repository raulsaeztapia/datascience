# Set working directory and import datafiles
setwd(".")
seaflow <- read.csv("seaflow_21min.csv")

# load dataset
data(seaflow)

## 75% of the sample size
smp_size <- floor(0.75 * nrow(seaflow))

## set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(seaflow)), size = smp_size)
# we create both dataframes
train <- seaflow[train_ind, ]
test <-  seaflow[train_ind, ]

# summary of time field for get mean value
summary(train$time)
