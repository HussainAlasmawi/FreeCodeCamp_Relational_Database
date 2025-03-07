#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE games, teams"
cat games.csv | while IFS=, read year round winner opp win_goals opp_goals
do
  if [[ $year != 'year' ]]
  then
  WIN_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")"
    if [[ -z $WIN_ID ]]
    then
    $PSQL "INSERT INTO teams(name) VALUES('$winner')"
    WIN_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")"
    fi
  OPP_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$opp'")"
    if [[ -z $OPP_ID ]]
    then
    $PSQL "INSERT INTO teams(name) VALUES('$opp')"
    OPP_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$opp'")"
    fi
  $PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($year,'$round',$WIN_ID,$OPP_ID,$win_goals,$opp_goals)"
  fi
done