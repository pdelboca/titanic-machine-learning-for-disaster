setwd("~/Repos/titanic-machine-learning-for-disaster/")
source("./clean.R")
library("ggplot2")

data <- get_clean_data()
str(data)

p <- ggplot(data) + theme_minimal()

# Number of passengers who survived
sum(data$survived) # 342

# Survived by Sex
p + geom_bar(aes(as.logical(survived),fill = sex),
             stat="bin", # the count of cases in each group (Survived/Not)
             position="dodge") +
    labs(title = "Survived by Gender")

# Social Class vs Sex
p + geom_bar(aes(pclass, fill=sex), stat = "bin") + 
    labs(title = "Social Class vs Sex")

# Age Histogram
p + geom_histogram(aes(age)) + geom_vline(aes(xintercept=mean(age, na.rm=T)),
                                          color="red")

# Age Histogram by Pclass
p + geom_histogram(aes(x = age, fill = pclass))

# Basic Plot of Sex vs Pclass vs Survived
# Conclusion: Almost all females from 1st Class survived
table <- table(data$sex,data$pclass,data$survived)
plot(table, main = "Sex, Pclass, Survived")

# Proportion of People who Survive by Sex
p + geom_bar(aes(survived, fill = sex), stat="bin", position="fill")


# Proportion of People who Live by Sex and Class
prop.table(ftable(data$sex,data$pclass,data$survived),1) * 100
survival.proportions <- as.data.frame(prop.table(ftable(data$sex,data$pclass,data$survived),1) * 100)
names(survival.proportions) <- c("sex","pclass","survived","freq")
survival.proportions$survived <- gsub(0,"Died",survival.proportions$survived)
survival.proportions$survived <- gsub(1,"Lived",survival.proportions$survived)

ggplot(survival.proportions) + geom_bar(aes(x=sex,y=freq,fill=survived),stat="identity") + 
    facet_grid(~pclass) + 
    labs(title = "Proportion of People who lived by Sex and Class")
