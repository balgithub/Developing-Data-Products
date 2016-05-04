#---
#title: "NFL Play Predictor Web App"
#file: Ui.R
#author: "Bruce Leistikow"
#date: "May 4, 2016"
#---


##Loading required libraries
library(shiny)
require(markdown)
library(dplyr)
library(ggplot2)
library(ggvis)
library(caret)
library(rpart)

#Setup main and side panels 
shinyUI(
  navbarPage(
    "NFL FOOTBALL PLAY PREDICTOR",
    tabPanel(p(icon("star"), "Documentation"),
             h3("WELCOME TO NFL FOOTBALL PLAY PREDICTOR"),
             includeMarkdown('doc.md')
             
    ),
    tabPanel(p(icon("bar-chart"),"Explore"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("teams",label="Choose the Team to display",
                             choices = list("Arizona Cardinals", 
                                            "Atlanta Falcons",
                                            "Baltimore Ravens",
                                            "Buffalo Bills",
                                            "Carolina Panthers",
                                            "Chicago Bears",
                                            "Cincinnati Bengals",
                                            "Cleveland Browns",
                                            "Dallas Cowboys",
                                            "Denver Broncos",
                                            "Detroit Lions",
                                            "Green Bay Packers",
                                            "Houston Texans",
                                            "Indianapolis Colts",
                                            "Jacksonville Jaguars", 
                                            "Kansas City Chiefs", 
                                            "Miami Dolphins",
                                            "Minnesota Vikings", 
                                            "New England Patriots", 
                                            "New Orleans Saints",
                                            "New York Giants", 
                                            "New York Jets", 
                                            "Oakland Raiders", 
                                            "Philadelphia Eagles",
                                            "Pittsburgh Steelers", 
                                            "San Diego Chargers", 
                                            "San Francisco 49ers", 
                                            "Settle Seahawks",
                                            "St. Louis Rams", 
                                            "Tampa Bay Buccaneers", 
                                            "Tennessee Titans",
                                            "Washington Redskins"
                             )
                 ),
                 h4("Enter values for prediction"),
                 numericInput('down','Down Number (1-4)', 1, min=1,max=4,step=1),
                 numericInput('togo',"ToGo yardage (1-48 max)",10,min=1,max=48,step=1),
                 numericInput('quarter',"Quarter (1-5)",1,min=1,max=5,step=1),
                 numericInput('time',"Time left in Quarter (15-1 mins)",15,min=1,max=15,step=1),
                 numericInput('yardline',"Location on Field (0-99)",50,min=0,max=99,step=1)
                 
               ),
               mainPanel(
                 h4("BarPlot of Selected Team's Passes and Runs by Year"),
                 plotOutput("variablesbyyear"),
                 br(),
                 br(),
                 h3("Prediction of Pass or Run given Situtation Inputs"),
                 h4(textOutput("probability")),
                 p("The estimate probability is based on a simple linear regression model")
#                 br(),
#                 br()
                 )
             )),
    

     verbatimTextOutput("probability"),

     tabPanel(p(icon("table"),"Data"),
         dataTableOutput(outputId = "table"))
    
  ))