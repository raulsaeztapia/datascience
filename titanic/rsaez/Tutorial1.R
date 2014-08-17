# SEGUIMOS EL TUTORIAL DE ...
# Trevor Stephens - 9 Jan 2014
# Titanic: Getting Started With R - Part 1: Booting up in R
# Full guide available at http://trevorstephens.com/

# especificamos el directorio de trabajo
setwd("~/datascience/titanic/rsaez")

# importamos datasets
train <- read.csv("~/datascience/titanic/rsaez/train.csv")
test <- read.csv("~/datascience/titanic/rsaez/test.csv")

# hechamos un ojo a los datasets
str(train)

# vamos a ver cuantos sobrevivieron
table(train$survived)
# y en proporcion
prop.table(table(train$survived))

# creamos una nueva columna en el dataset test que se llama survived con todos los valores inicializados a 0
test$survived <- rep(0, 418)

# creamos una tabla a partir de los datos de supervivientes (de momento todos perecidos)
submit <- data.frame(PassengerId = test$PassengerId, Survived = test$survived)

# escribimos la tabla a un CSV para poder hacer un submit en Kaggle
write.csv(submit, file = "theyallperish.csv", row.names = FALSE)