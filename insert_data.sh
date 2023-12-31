#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE TABLE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != "year" ]]
  then
    WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $WTEAM_ID ]]
    then 
      INSERT_WTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi
    OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OTEAM_ID ]]
    then 
      INSERT_OTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WTEAM_ID', '$OTEAM_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi
done