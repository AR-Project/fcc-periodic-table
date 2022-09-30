#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c "

# check if argument exist or not
if [[ -z $1 ]]
then
  # no argument message
  echo "Please provide an element as an argument." 
else
  # check if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # search using number
    RESULT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1")
  else
    # search using string
    RESULT="$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING (type_id) WHERE symbol LIKE '$1' OR name ILIKE '$1'")"
  fi

  # verify if result return something or not
  if [[ -z $RESULT ]]
  then
    # no result message
    echo "I could not find that element in the database."
  else
    # read result into variable
    read ATOMNUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL <<< $RESULT

    # parse result into final sentence and echo it
    echo "The element with atomic number $ATOMNUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."  
  fi
fi
