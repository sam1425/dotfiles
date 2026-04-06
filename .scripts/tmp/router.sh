#!/usr/bin/env bash
ROUTER_IP="192.168.1.1:8000"
PASSWORD="ibUqz6B9"
COOKIE_FILE="/tmp/router_cookie.txt"

# Login and save cookie
curl -s -X POST "http://$ROUTER_IP/login.asp" \
     -d "password=$PASSWORD" \
     -c "$COOKIE_FILE" \
     -o something.o

# Verify session by grabbing the sessionKey from the page you mentioned
curl -s -b "$COOKIE_FILE" "http://$ROUTER_IP/login.asp" | grep -o "var sessionKey = '[^']*'"
