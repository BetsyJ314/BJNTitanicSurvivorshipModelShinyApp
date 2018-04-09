#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

library(rsconnect)
library(dplyr)
library(tidyr)
library(caret)
library(gbm)
library(e1071)
#library(rattle)
#library(ggplot2)
#library(plotROC)
Titanicdf<-read.csv('http://math.ucdenver.edu/RTutorial/titanic.txt',sep='\t')
Titanicdf$Survived<-as.factor(Titanicdf$Survived)
TitanicdfClean<-Titanicdf[complete.cases(Titanicdf[ , 3:4]),]
TitanicdfTrim<-subset(TitanicdfClean,select=-c(Name))
set.seed(12345)
InBuild <- createDataPartition(TitanicdfTrim$Survived, p=0.80, list=FALSE)
BuildSet <- TitanicdfTrim[InBuild,]
Cntl<-trainControl(method="cv",number = 10)
FitGBM<-train(Survived~., data=BuildSet, method="gbm", trControl=Cntl, verbose=FALSE, na.action = na.pass)

# Define server logic required to get age, gender, passenger class

shinyServer(function(input, output) {

        #reactive inputs
        Criteria<-reactive({
        Age<-input$slider1

        SexCode<-input$radio
        Sex<-if(SexCode==1)"female" else "male"

        ClassCode<-input$select
        PClass<-if(ClassCode==1)"1st" else if (ClassCode==2) "2nd" else "3rd"

        DataInputs <- data.frame(Age=Age,Sex=Sex,PClass=PClass)
        Survival<-predict(FitGBM, newdata = DataInputs)
        if(Survival==1)"It is highly likely you would have survived!" else "Deepest sympathies, for it is highly likely you would not have survived."
})


        #Survivor Indicator, dependent on action button
        ModelPred<-eventReactive(input$goButton, {
                        Criteria()
                        })

        #output based on event reactive call above
        output$Status<-renderText({ModelPred()})


#close shiny server
})

