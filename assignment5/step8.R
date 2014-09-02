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


# generamos una formula y arbol
fit <- rpart(formula = pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, method="class", data=train)

# generamos el grafico que nos muestra el arbol de decision
plot(fit)
text(fit)
# generamos de nuevo el grafico mas legible
fancyRpartPlot(fit)

# generamos la prediccion
Prediction <- predict(fit, seaflow, type = "class")

# pintamos la tabla de la particion contra el campo pop
table(pred = Prediction, true = seaflow$pop)

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

# pintamos la tabla de la particion contra el campo pop
table(pred = Prediction, true = seaflow$pop)

# ahora instalamos el paquete de e1071
install.packages('e1071')

# y lo importamos
library(e1071)

# generamos una formula y random forest
fit <- svm(formula = pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_big + chl_small, data=train)

# generamos la prediccion
Prediction <- predict(fit, seaflow, type = "class")

# pintamos la tabla de la particion contra el campo pop
table(pred = Prediction, true = seaflow$pop)

# sanity check
# -- The measurements in this dataset are all supposed to be continuous
# (fsc_small, fsc_perp, fsc_big, pe, chl_small, chl_big), but one is not. Using plots or R code,
# figure out which field is corrupted.
summary.data.frame(train)
# fsc_big parece que tiene datos demasiado centrados
