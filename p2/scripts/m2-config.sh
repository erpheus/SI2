#!/bin/bash

asadmin --user admin --passwordfile ./passwordfile  <<< "delete-jvm-options -client"
asadmin --user admin --passwordfile ./passwordfile  <<< "create-jvm-options -server"
asadmin --user admin --passwordfile ./passwordfile  <<< "create-jvm-options -Xms512m"
asadmin --user admin --passwordfile ./passwordfile  <<< "set server.monitoring-service.module-monitoring-levels.web-container=HIGH"
asadmin --user admin --passwordfile ./passwordfile  <<< "set server.monitoring-service.module-monitoring-levels.thread-pool=HIGH"
asadmin --user admin --passwordfile ./passwordfile  <<< "set server.monitoring-service.module-monitoring-levels.jvm=HIGH"
asadmin --user admin --passwordfile ./passwordfile  <<< "set server.monitoring-service.module-monitoring-levels.jdbc-connection-pool=HIGH"
asadmin --user admin --passwordfile ./passwordfile  <<< "set server.monitoring-service.module-monitoring-levels.http-service=HIGH"
