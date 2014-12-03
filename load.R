setwd("~/Repos/titanic-machine-learning-for-disaster/")

LoadTrain <- function(){
    train <- read.csv("./data/train.csv")
    train
}

LoadTest <- function(){
    test <- read.csv("./data//test.csv")
    test
}

