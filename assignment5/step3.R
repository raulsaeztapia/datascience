# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 1: Booting up in R
# Full guide available at http://trevorstephens.com/

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

install.packages('ggplot2')
library('ggplot2')
# Plot pe against chl_small  and color by pop
qplot(pe, chl_small, data = train, color = pop)