#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# $($PSQL "TRUNCATE TABLE customers, appointments")
echo -e "\n~~~~~ Herman's Salon ~~~~~\n"
echo Welcome to my Salon, how can I help you?

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n1) Cut\n2) Color\n3) Perm\n4) Style\n5) Trim"
  read SERVICE_ID_SELECTED

  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_FORMATTED=$(echo $SERVICE | sed 's/ //')

  case $SERVICE_ID_SELECTED in
    1) HAIRCUT_MENU ;;
    2) HAIRCUT_MENU ;;
    3) HAIRCUT_MENU ;;
    4) HAIRCUT_MENU ;;
    5) HAIRCUT_MENU ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

HAIRCUT_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  #get available phone numbers
  CUSTOMER_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #if no phone number exists
  if [[ -z $CUSTOMER_PHONE_NUMBER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
  
    echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $CUSTOMER_NAME?"
    read SERVICE_TIME

    echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
    
    CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
    APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  else
    CUSTOMER_NAME_RESULT=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_FORMATTED, $CUSTOMER_NAME_RESULT?"
    read SERVICE_TIME
    echo -e "\nI have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_RESULT."

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  fi
}

MAIN_MENU
