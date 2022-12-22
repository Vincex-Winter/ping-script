# ping-script
Script to log downtime to local gateway

You can parameter substitution for a few parameters.
GATEWAY to change where it queries (default to local gateway)
INTERATE to change how often it queries (default to every 10 seconds)
LOG_FILE to change where it stores the query results (default to ~/ping-log.csv)

The output is in CSV format.

The script runs till process is ended.

Requires fping to be in installed.
