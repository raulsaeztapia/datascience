# SEGUIMOS EL TUTORIAL DE ...
# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 1: Booting up in R
# Full guide available at http://trevorstephens.com/

# especificamos el directorio de trabajo
setwd("~/datascience/titanic/rsaez")

# importamos datasets
train <- read.csv("~/datascience/titanic/rsaez/train.csv")
test <- read.csv("~/datascience/titanic/rsaez/test.csv")

# resumen del genero del pasaje
summary(train$sex)

# proporcion de supervivientes de todo el pasaje
prop.table(table(train$sex, train$survived))

# proporcion de supervivientes por genero de todo el pasaje
prop.table(table(train$sex, train$survived), 1)

# proporcion de generos por supervivientes o no supervivientes de todo el pasaje
prop.table(table(train$sex, train$survived), 2)

# only men dead
test$survived <- 0
test$survived[test$Sex == 'female'] <- 1

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$survived)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "onlyMenDead.csv", row.names = FALSE)

# resumen de edades del fichero de entrenamiento
summary(train$Age)

# creamos una nueva columna para identificar a los menores de 18 anios, osea ninios
train$child <- 0
# y los ponemos un 1 a todos aquellos que cumplan la condicion
train$child[train$Age < 18] <- 1

# intentamos encontrar los supervivientes para un numero de subconjuntos
aggregate(Survived ~ child + Sex, data=train, FUN=sum)
# hemos sumado la columna survived para cada uno de las ocurrencias del producto cartesiano de child y sex

# ahora debemos saber cuantos hay de cada una de las ocurrencias del producto cartesiano
aggregate(Survived ~ child + Sex, data=train, FUN=length)
# necesitamos este dato para poder calcular la proporcion de cada uno de ellos

# ahora calculamos la proporcion utilizando una funcion custom en el aggregate
aggregate(Survived ~ child + Sex, data=train, FUN=function (x) {sum(x) / length(x)})
# bueno seguimos viendo que muchos de las mujeres o niñas sobrevivieron pero no es así para los hombres o niños

# vamos a probar con la clase y el coste del billete para ver si ajustamos la probabilidad
# creamos una nueva columna para clasificar el coste del billete en unos rangos
train$fare2 <- '30+'
train$fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
train$fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$fare2[train$Fare < 10] <- '<10'

# calculamos la agregada de supervivientes por los rangos de coste que hemos generado, su clase y sexo
aggregate(Survived ~ fare2 + Pclass + Sex, data=train, FUN=function (x) {sum(x) / length(x)})
# es curioso que hayan sobrevivido tan pocas mujeres que pagaron más de 20$ en clase 3 (puede que recibieran el impacto del iceberg)

# con esta nueva tesis vamos a generar otro submit
test$survived <- 0
test$survived[test$Sex == 'female'] <- 1
test$survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

# creamos una tabla a partir de los datos de supervivientes
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$survived)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "famaleP3F20.csv", row.names = FALSE)