# Set working directory and import datafiles
setwd("/home/user/datascience/assignment5")
seaflow <- read.csv("seaflow_21min.csv")

# ## 75% of the sample size
# smp_size <- floor(0.75 * nrow(seaflow))
# 
# ## set the seed to make your partition reproductible
# set.seed(123)
# train_ind <- sample(seq_len(nrow(seaflow)), size = smp_size)
# # we create both dataframes
# train <- seaflow[train_ind, ]
# test <-  seaflow[train_ind, ]

train <- sample(seaflow, replace = FALSE)
test <- sample(seaflow, replace = FALSE)


# Install and load required packages for fancy decision tree plotting
# install.packages('rattle')
# install.packages('rpart')
# install.packages('rpart.plot')
# install.packages('RColorBrewer')
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# generamos una formula y arbol
fit <- rpart(formula = pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, method="class", data=train)

# generamos el grafico que nos muestra el arbol de decision
plot(fit)
text(fit)
# generamos de nuevo el grafico mas legible
fancyRpartPlot(fit)
