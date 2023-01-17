#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
        echo -e "\n$1\n"
  fi
  
  echo "Welcome to My Salon, how can I help you?"
  echo -e "\n1) Hair-Cutting\n2) Tanning\n3) Nail Treatments\n4) Perm\n"
  read SERVICE_ID_SELECTED
  
  # service does't exist 
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-4] ]]
  then
        MAIN_MENU "Sorry, but you picked a service doesn't exist!"
  else
        echo -e "\nWhat's your phone number?"
        read CUSTOMER_PHONE

        CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

        if [[ -z $CUSTOMER_NAME ]]
        then
              echo -e "\nI don't have a record for that phone number, what's your name?"
              read CUSTOMER_NAME

              echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
              read SERVICE_TIME

              $PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')"

              CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

              INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES ('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")

              if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
              then
                    SERVICE=$($PSQL "SELECT name FROM SERVICES WHERE service_id = $SERVICE_ID_SELECTED")              
                    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
              fi
        else
              echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
              read SERVICE_TIME

              CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

              INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES ('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")

              if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
              then
                    SERVICE=$($PSQL "SELECT name FROM SERVICES WHERE service_id = $SERVICE_ID_SELECTED")              
                    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
              fi


        fi


  fi





}

MAIN_MENU

