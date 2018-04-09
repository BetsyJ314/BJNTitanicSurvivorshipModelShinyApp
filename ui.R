#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

# Shiny UI interface
shinyUI(fluidPage(

  # Application title
  titlePanel("Would You Have Survived the Sinking of the Titanic?"),
  titlePanel(h3(em("Select your age, gender, and passenger class to find out!"))),
  titlePanel(h5("Betsy Nash")),
  titlePanel(h5("April 8,2018")),

  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(
      # slider input for age "slider1"
       sliderInput("slider1",
                   label = h3("Select Age"),
                   min = 0,
                   max = 71,
                   #beginning value
                   value = 20),
       # radio input gender "radio"
       radioButtons("radio",
                   label = h3("Select Gender"),
                   choices = list("Female" = 1, "Male" = 2),
                   selected = 2),
       # select passenger class "select"
       selectInput("select", label = h3("Select Passenger Class"),
                   choices = list("1st Class" = 1, "2nd Class" = 2, "3rd Class" = 3),
                   selected = 3),
       #Button
       actionButton("goButton", "Check Status")
                ),

    # Main panel, reserving space
     mainPanel(h2("Survivorship Status"),textOutput("Status"))
                )
                )
  )
