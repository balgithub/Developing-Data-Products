#---
#title: "NFL Play Predictor Web App"
#file: Server.R
#author: "Bruce Leistikow"
#date: "May 4, 2016"
#---


## Loading libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(ggvis)
library(caret)
library(rpart)
library(car)

## Loading the datafiles
nfl2013 <- read.csv("./2013 NFL Play-by-Play Data.csv", stringsAsFactors = FALSE)
nfl2014 <- read.csv("./2014 NFL Play-by-Play Data.csv", stringsAsFactors = FALSE)
nfl2015 <- read.csv("./2015 NFL Play-by-Play Data.csv", stringsAsFactors = FALSE)

#Refine, clean & merge into a dataset
nfl2013$Year <- "2013"
nfl2014$Year <- "2014"
nfl2015$Year <- "2015"
nfl1 <- merge(nfl2013, nfl2014, all = TRUE)
nfl <- merge(nfl1, nfl2015, all = TRUE)
nfl$Date <- as.Date(nfl$Date, "%m/%d/%y")
nfl$Play.Type <- recode(nfl$Play.Type, "'Pass'=1; 'Run'=2; 'Sack'=1")
nfl$Time <- as.difftime(nfl$Time)

nfl$Tm <- recode(nfl$Tm, "'Cardinals' = 'Arizona Cardinals';
                          'Falcons' = 'Atlanta Falcons';
                          'Ravens' = 'Baltimore Ravens';
                          'Bills' = 'Buffalo Bills';
                          'Panthers' = 'Carolina Panthers';
                          'Bears' = 'Chicago Bears';
                          'Bengals' = 'Cincinnati Bengals';
                          'Browns' = 'Cleveland Browns';
                          'Cowboys' = 'Dallas Cowboys';
                          'Broncos' = 'Denver Broncos';
                          'Lions' = 'Detroit Lions';
                          'Packers' = 'Green Bay Packers';
                          'Texans' = 'Houston Texans';
                          'Colts' = 'Indianapolis Colts';
                          'Jaguars' = 'Jacksonville Jaguars';
                          'Chiefs' = 'Kansas City Chiefs';
                          'Dolphins' = 'Miami Dolphins';
                          'Vikings' = 'Minnesota Vikings';
                          'Patriots' = 'New England Patriots';
                          'Saints' = 'New Orleans Saints';
                          'Giants' = 'New York Giants';
                          'Jets' = 'New York Jets';
                          'Raiders' = 'Oakland Raiders';
                          'Eagles' = 'Philadelphia Eagles';
                          'Steelers' = 'Pittsburgh Steelers';
                          'Chargers' = 'San Diego Chargers';
                          '49ers' = 'San Francisco 49ers';
                          'Seahawks' = 'Settle Seahawks';
                          'Rams' = 'St. Louis Rams';
                          'Buccaneers' = 'Tampa Bay Buccaneers';
                          'Titans' = 'Tennessee Titans';
                          'Redskins' = 'Washington Redskins'")
                 
incs <- c("Play.Type", "Tm", "Quarter", "Time", "Down", "ToGo", "Yard.Line", "Year")
nfl0 <- nfl[, (names(nfl) %in% incs)]
colnames(nfl0) = c("Team", "Quarter","Time","Down","ToGo","Play.Type", "Yard.Line", "Year")


## Generate Prediction Model
lm_model = lm(Play.Type ~ Team+Down+ToGo+Quarter+Time+Yard.Line, data=nfl0, na.action=na.exclude)


predfun = function(Down, ToGo, Quarter, Time, Yard.Line, Team)
{
  pred_data <- data.frame(Team, Down, ToGo, Quarter, Time, Yard.Line)
  colnames(pred_data) = c("Team", "Down", "ToGo", "Quarter", "Time", "Yard.Line")
  pred_data$Time <- as.difftime(pred_data$Time*60, units = "secs")
  play_prob = predict(lm_model, pred_data, type="response")
  return(play_prob)
}


shinyServer(function(input,output){
  output$variablesbyyear<-renderPlot({
    data <-switch(input$teams,
                  "Arizona Cardinals" = filter(nfl0,Team == "Arizona Cardinals"),
                  "Atlanta Falcons" = filter(nfl0,Team == "Atlanta Falcons"),
                  "Baltimore Ravens" = filter(nfl0,Team == "Baltimore Ravens"),
                  "Buffalo Bills" = filter(nfl0,Team == "Buffalo Bills"),
                  "Carolina Panthers" = filter(nfl0,Team == "Carolina Panthers"),
                  "Chicago Bears" = filter(nfl0,Team == "Chicago Bears"),
                  "Cincinnati Bengals" = filter(nfl0,Team == "Cincinnati Bengals"),
                  "Cleveland Browns" = filter(nfl0,Team == "Cleveland Browns"),
                  "Dallas Cowboys" = filter(nfl0,Team == "Dallas Cowboys"),
                  "Denver Broncos" = filter(nfl0,Team == "Denver Broncos"),
                  "Detroit Lions" = filter(nfl0,Team == "Detroit Lions"),
                  "Green Bay Packers" = filter(nfl0,Team == "Green Bay Packers"),
                  "Houston Texans" = filter(nfl0,Team == "Houston Texans"),
                  "Indianapolis Colts" = filter(nfl0,Team == "Indianapolis Colts"),
                  "Jacksonville Jaguars" = filter(nfl0,Team == "Jacksonville Jaguars"),
                  "Kansas City Chiefs" = filter(nfl0,Team == "Kansas City Chiefs"),
                  "Miami Dolphins" = filter(nfl0,Team == "Miami Dolphins"),
                  "Minnesota Vikings" = filter(nfl0,Team == "Minnesota Vikings"),
                  "New England Patriots" = filter(nfl0,Team == "New England Patriots"),
                  "New Orleans Saints" = filter(nfl0,Team == "New Orleans Saints"),
                  "New York Giants" = filter(nfl0,Team == "New York Giants"),
                  "New York Jets" = filter(nfl0,Team == "New York Jets"),
                  "Oakland Raiders" = filter(nfl0,Team == "Oakland Raiders"),
                  "Philadelphia Eagles" = filter(nfl0,Team == "Philadelphia Eagles"),
                  "Pittsburgh Steelers" = filter(nfl0,Team == "Pittsburgh Steelers"),
                  "San Diego Chargers" = filter(nfl0,Team == "San Diego Chargers"),
                  "San Francisco 49ers" = filter(nfl0,Team == "San Francisco 49ers"),
                  "Settle Seahawks" = filter(nfl0,Team == "Settle Seahawks"),
                  "St. Louis Rams" = filter(nfl0,Team == "St. Louis Rams"),
                  "Tampa Bay Buccaneers" = filter(nfl0,Team == "Tampa Bay Buccaneers"),
                  "Tennessee Titans" = filter(nfl0,Team == "Tennessee Titans"),
                  "Washington Redskins" = filter(nfl0,Team == "Washington Redskins")
    )

    ##### BARPLOT ###    
    counts <- table(data$Play.Type, data$Year)
    rownames(counts) <- c("Pass", "Run")
    g <- barplot(counts, 
                 #main="Distribution of Passes vs. Runs by Year",
                 col=c("darkblue","red"), 
                 legend = rownames(counts), beside=TRUE)
     g
  })

  ### PREDICTION ##
  output$probability = renderText({
    p <- predfun(input$down, input$togo, input$quarter, input$time, input$yardline, input$teams)
    if (p < 1.5){
      pout <- paste("Pass - predicted value of:", format(p, digits=4))
    }
    else {
      pout <- paste("Run - predicted value of:", format(p, digits=4))
    }
    pout
  })
  
  
  ##### TABLE ###
  output$table <- renderDataTable({
    nfl0
  }, options = list(bFilter = FALSE, iDisplayLength = 50))
  

  
  
  
})