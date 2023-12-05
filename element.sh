PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo 'Please provide an element as an argument.'
else

if [[  $1 =~ ^[0-9]+$ ]]
then
ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
else
if [[ ${#1} -lt 3 ]]
then
ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
else
ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")

fi
fi

if [[ -z $ELEMENT ]]
then
echo "I could not find that element in the database."
else

DETAILS=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT")

IFS=$'|'
echo "$DETAILS" | while read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELT_POINT BOIL_POINT;
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
done

fi

fi

