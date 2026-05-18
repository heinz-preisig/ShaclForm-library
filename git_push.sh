#!/bin/bash


nano message.txt

git add .
git commit . -F message.txt
git push origin  --all -u

echo "hit return to finish"

read answer
