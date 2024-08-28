#!/bin/sh

# Write the password to a temporary file
echo $ACCOUNT_PASSWORD > /tmp/account_password

# Start rupx with the password file
exec /app/rupx --password /tmp/account_password "$@"