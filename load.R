setwd("~/Repos/titanic-machine-learning-for-disaster/")

load_train <- function(){
    train <- read.csv("./data/train.csv")
    train
}

load_test <- function(){
    test <- read.csv("./data//test.csv")
    test
}

