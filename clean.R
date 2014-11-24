setwd("~/Repos/titanic-machine-learning-for-disaster/")
source("./load.R")

get_clean_data <- function(){
    data <- load_train()
    
    names(data) <- tolower(names(data))
    
    # Pclass should be Factors
    data$pclass <- as.factor(data$pclass)
    
    data    
}