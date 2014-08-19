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

# aqui podemos ver como hay 263 NA en las edades del pasaje
summary(combi$Age)

# vamos a crear un arbol de decision basado en aquellos que si tienen edad para predecir los que no la tienen
Agefit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Embarked + Title, data = combi[!is.na(combi$Age),], method = "anova")

# y rellenamos los que no tienen con la prediccion
combi$Age[is.na(combi$Age)] <- predict(Agefit, combi[is.na(combi$Age),])

# vamos a ver un resumen de todo el dataframe para ver si hay algo que mejorar
summary(combi)

# buscamos donde estan los vacios en el embarque
which(combi$Embarked == '')
# y los rellenamos con S asumiendo que seguramente embarcaron
combi$Embarked[c(62,830)] = "S"
# convertimos a factor
combi$Embarked <- factor(combi$Embarked)

# ahora buscamos los NA de la tarifa
which(is.na(combi$Fare))
# y rellenamos con la media de todas las tarifas
combi$Fare[1044] <- median(combi$Fare, na.rm = TRUE)

# como Random Forest en R solo puede consumir factores de hasta 32 niveles nuestro FamilyID debe ser reducido
combi$FamilyID2 <- combi$FamilyID
combi$FamilyID2 <- as.character(combi$FamilyID2)
combi$FamilyID2[combi$FamilySize <= 3] <- 'Small'
combi$FamilyID2 <- factor(combi$FamilyID2)

# ahora instalamos el paquete de Random Forest
# install.packages('randomForest')

# y lo importamos
library(randomForest)

# vamos a especificar la semilla de aleatoriedad
set.seed(415)

# reemplazamos los registros de los dataframe con los correspondientes que hemos tratado en combi
train <- combi[1:891,]
test <- combi[892:1309,]

# creamos el modelo Random Forest
fit <- randomForest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID2, data=train, importance = TRUE, ntree = 2000)

# si queremos ver como se aplican cada una de nuestras variables en el modelo
varImpPlot(fit)

# generamos el CSV para el submition
Prediction <- predict(fit, test)

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "firstforest.csv", row.names = FALSE)

# instalamos el paquete party
#install.packages('party')

# y la importamos
library(party)

# volvemos a especificar el mismo factor de aleatoriedad para conseguir datos consistentes
set.seed(415)

# ahora vamos a crear el modelo basado en Conditional Inference
fit <- cforest(as.factor(Survived) ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID, data = train, controls=cforest_unbiased(ntree=5000, mtry=3))
# este tipo de Forest soporta mas niveles de factores que Random Forest y por ello utilizamos el FamilyID original

# generamos el CSV para el submition ahora con parametros para OOB (Out-of-Bag)
Prediction <- predict(fit, test, OOB = TRUE, type = "response")

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "conditionalInferenceForest.csv", row.names = FALSE)
