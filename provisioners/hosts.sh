#!/bin/bash
for HOST in "$@"
do
  SUCCESS=0                      # All good programmers use Constants
  domain=${HOST}                 # Change this to meet your needs
  needle=www.$domain             # Fortunately padding & comments are ignored
  hostline="127.0.0.1 $domain www.$domain"
  filename=/etc/hosts

  # Determine if the line already exists in /etc/hosts
  echo "Calling Grep"
  grep -q "$needle" "$filename"  # -q is for quiet. Shhh...

  # Grep's return error code can then be checked. No error=success
  if [ $? -eq $SUCCESS ]
  then
    echo "$needle found in $filename"
  else
    echo "$needle not found in $filename"
    # If the line wasn't found, add it using an echo append >>
    echo "$hostline" >> "$filename"
    echo "$hostline added to $filename"
  fi
done
