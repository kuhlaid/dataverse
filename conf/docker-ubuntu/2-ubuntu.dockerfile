# syntax=docker/dockerfile:1

# *** IMPORTANT - this script should be run from Docker Desktop and not tried to run using WSL terminal***

FROM ubuntu:latest

# run some scripts to create directies and set us up for 

# apache port, http
EXPOSE 80

# here we simply use Docker Desktop to setup a basic container