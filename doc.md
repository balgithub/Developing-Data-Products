### INTRODUCTION
The NFL Football Play Predictor is a part of the Developing Data Products Course.
The dataset used in this app was taken from: https://www.spreadsheet-sports.com/free-tools/2013-nfl-play-play-data-excel/.
### This app has 2 main features 
* It displays a bar plot of the Passes vs Runs for the past 3 years for the Team you select from the selection box.
* Based on the input values of number of wins, field goals and turnovers, the tool predicts whether the selected team will run a pass or run play using a simple linear regression model.

### HOW TO USE ?

**STEP 1**
Go to the Explore Tab.
Start by selecting an NFL team from the dropdown list. The Pass vs Runs by Year barplot will be displayed on the main panel.
NOTE - When the application first loads, it takes several seconds to create the prediction model and render the initial graph.  Please be patient!!

**STEP 2**
Enter your prediction values 
- For the Down, enter any value between 1 and 4 in the entry field of "Down" box
- For ToGo Yardage, enter any value between 1 and 48 (the largest value in the database range)
- For Quarter, enter any value between 1 and 5 (Overtime is the 5th Quarter)
- For Time, enter a value between 0.1 and 15 (minutes remaining in the quarter)
- For Yard Line, enter a value between 1 and 99 (99 being about to score, and 1 your about to get a safety!)
After you have entered these values, the Play Type will be predicted along with the prediction value which ranges between 1.0 and 2.0 (Pass or Run respectively).

**STEP 3**
To explore the dataset, select the Data tab from the top right of the web application. 

### SOURCE CODE
The code for the **ui.R** and **server.R** can be found on this github repository - [NFL_PLAY_PREDICTOR](https://github.com/balgithub/Developing-Data-Products)
