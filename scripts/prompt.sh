#!/usr/bin/env bash

. pscript

TYPE_SPEED=50

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"

clear

PROMPT_TIMEOUT=1

p "Press enter to test cdc-streams workflow from ysql to ycql"

PROMPT_TIMEOUT=0

p "Checking ycql alerts keyspace for any flight watch events!"

ycqlsh $(hostname -i) -k alerts -e "desc tables"

pe "ycqlsh $(hostname -i) -k alerts -e \"select * from flight_watch\""

p "Inserting flight schedule data to ysql to test cdc flow event to ycql"

p "insert into flight_schedule values('YB524', current_date, 'SIN', 'IND', now()::timestamp, (now()+interval '20 minutes')::timestamp, (now()+interval '20 minutes')::timestamp, (now()-interval '120 minutes')::timestamp, (now()-interval '90 minutes')::timestamp, (now()-interval '120 minutes')::timestamp, 'T4', 'T4');"

PROMPT_TIMEOUT=0

ysqlsh -h $(hostname -i) -c "insert into flight_schedule values('YB524', current_date, 'SIN', 'IND', now()::timestamp, (now()+interval '20 minutes')::timestamp, (now()+interval '20 minutes')::timestamp, (now()-interval '120 minutes')::timestamp, (now()-interval '90 minutes')::timestamp, (now()-interval '120 minutes')::timestamp, 'T4', 'T4');"

PROMPT_TIMEOUT=1

p "Checking ycql alerts keyspace for any flight watch events!"

pe "ycqlsh $(hostname -i) -k alerts -e \"select * from flight_watch\""

PROMPT_TIMEOUT=0

p "Checking an update event flow!"

PROMPT_TIMEOUT=1

p "Update flight scheduled time departure delay: "

p "update flight_schedule set std=(now()-interval '120 minutes')::timestamp  where flight_no='YB524' and scheduled_date = current_date;"

PROMPT_TIMEOUT=0

ysqlsh -h $(hostname -i) -c "update flight_schedule set std=(now()-interval '120 minutes')::timestamp  where flight_no='YB524' and scheduled_date = current_date;"

PROMPT_TIMEOUT=1

p "Checking ycql alerts keyspace for any flight watch events!"

pe "ycqlsh $(hostname -i) -k alerts -e \"select * from flight_watch\""

p "That's it with the cdc stream event from from ysql to ycql!"

cmd

p ""