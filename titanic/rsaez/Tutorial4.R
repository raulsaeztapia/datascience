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

## ahora necesitamos incluir ciertas librerias y para ello hay que instalar paquetes
# install.packages('rattle')
# install.packages('rpart.plot')
# install.packages('RColorBrewer')
# ahora los importamos
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# creamos una columna en test llamada Survived con valores inicializados a NA. Esto lo hacemo para
# poder igualar las columnas de las dos tablas y asi poder combinarlas
test$Survived <- NA

# ahora creamos un dataframe con la combinacion de las dos tablas, por el mismo orden de sus filas
combi <- rbind(train, test)

# ahora necesitamos que los nombres de los pasajeros sean String y no Factor (como diccionarios de python)
combi$Name <- as.character(combi$Name)

# ahora que tenemos el nombre como texto podemos aplicar una funcion split para obtener el titulo de la persona
combi$Title <- sapply(combi$Name, FUN = function(x) {strsplit(x, split = '[,.]')[[1]][2]})
# quitamos todos los espacios en blanco
combi$Title <- sub(' ', '', combi$Title)
# y pintamos la tabla
table(combi$Title)

# parace que hay titulos muy parecidos que podemos agrupar
combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'

# y ahora de nuevo dejamos la columna como un factor
combi$Title <- factor(combi$Title)
# y pintamos la tabla
table(combi$Title)

# creamos una columna con el numero de integrantes de una misma familia en el pasaje por el parentesco
combi$FamilySize <- combi$SibSp + combi$Parch + 1
table(combi$FamilySize)

# creamos una nueva columna con el apellido de la familia
combi$Surname <- sapply(combi$Name, FUN = function (x) {strsplit(x, split = '[,.]')[[1]][1]})

# creamos una nueva columna con la combinacion del numero de integrantes y el apellido de la familia
combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep = "")

# todo lo que sea menos de tres integrantes nos parecera una familia pequenia
combi$FamilyID[combi$FamilyID <= 2] <- 'Small'

# convertimos a factor la columna de FamilyID para que pueda ser utilizada en el modelo
combi$FamilyID <- factor(combi$FamilyID)

# reemplazamos los registros de los dataframe con los correspondientes que hemos tratado en combi
train <- combi[1:891,]
test <- combi[892:1309,]

# generamos el CSV para el submition
Prediction <- predict(fit, test, type = "class")

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "familyarboldecision.csv", row.names = FALSE)