#!/bin/sh

# check if node_modules exists, if not install dependencies
if [ -d "/app/node_modules" ]; then
    npm run serve -- --port 3000
else
    npm ci
fi