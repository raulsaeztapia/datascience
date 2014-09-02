# Set working directory and import datafiles
setwd("/home/user/datascience/assignment5")
seaflow <- read.csv("seaflow_21min.csv")

## 75% of the sample size
smp_size <- floor(0.25 * nrow(seaflow))

## set the seed to make your partition reproductible
set.seed(123)
train_ind <- sample(seq_len(nrow(seaflow)), size = smp_size)
# we create both dataframes
train <- seaflow[train_ind, ]

# train <- sample(seaflow, replace = FALSE)



# Install and load required packages for fancy decision tree plotting
# install.packages('rattle')
# install.packages('rpart')
# install.packages('rpart.plot')
# install.packages('RColorBrewer')
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# ahora instalamos el paquete de Random Forest
# install.packages('randomForest')

# y lo importamos
library(randomForest)

# generamos una formula y random forest
fit <- randomForest(formula = pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, method="class", data=train)
varImpPlot(fit)
importance(fit)

# generamos la prediccion
Prediction <- predict(fit, seaflow, type = "class")

# comprobamos si la prediccion es es igual al campo clase (pop) y la respuesta la almacenamos en una columna nueva
# el resultado sera 1 o 0
seaflow$pop_result <- Prediction == seaflow$pop
# comprobamos cuan precisa a sido nuestra respuesta -- el resultado sera entre 0 y 1
sum(seaflow$pop_result) / length(seaflow$pop_result)
