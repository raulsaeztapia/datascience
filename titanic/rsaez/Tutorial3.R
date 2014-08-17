# SEGUIMOS EL TUTORIAL DE ...
# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 1: Booting up in R
# Full guide available at http://trevorstephens.com/

# importamos la libreria Recursive Partition and Regression Trees
library(rpart)

# especificamos el directorio de trabajo
setwd("~/datascience/titanic/rsaez")

# importamos datasets
train <- read.csv("~/datascience/titanic/rsaez/train.csv")
test <- read.csv("~/datascience/titanic/rsaez/test.csv")

# generamos un arbol de decision a partir de los camos mas representativos para nuestras predicciones
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
# generamos el grafico que nos muestra el arbol de decision
plot(fit)
text(fit)
# no esta muy claro, verdad? ahora lo veremos mas claro

## ahora necesitamos incluir ciertas librerias y para ello hay que instalar paquetes
# install.packages('rattle')
# install.packages('rpart.plot')
# install.packages('RColorBrewer')
# ahora los importamos
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# ahora estara mas claro el arbol de decision
fancyRpartPlot(fit)

# generamos el CSV para el submition
Prediction <- predict(fit, test, type = "class")

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "miprimerarboldecision.csv", row.names = FALSE)

# vamos a modificar parametros que controlan aspectos en la creacion del arbol de decisiones 
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class", control = rpart.control(minsplit = 2, cp=0))

# generamos de nuevo el grafico
fancyRpartPlot(fit)

# generamos el CSV para el submition
Prediction <- predict(fit, test, type = "class")

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "misegundoarboldecision.csv", row.names = FALSE)
## aqui hemos provado overfitting:
# Overfitting is technically defined as a model that performs better on a training set than another simpler model, but does
# worse on unseen data, as we saw here. We went too far and grew our decision tree out to encompass massively complex rules
# that may not generalize to unknown passengers. Perhaps that 34 year old female in third class who paid $20.17 for a
# ticket from Southampton with a sister and mother aboard may have been a bit of a rare case after all.

# solo para que veamos la potencia de la creacion de los arboles de decision con R vamo a hacer una prueba con un
# arbol de deiciones interactivo
## fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class", control = rpart.control(minsplit = 2, cp=0))
## new.fit <- prp(fit, snip = TRUE)$obj
## fancyRpartPlot(new.fit)
