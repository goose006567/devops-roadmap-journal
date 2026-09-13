# Day 2 Notes

## Linux Essentials
File permissions, processes, and diagnostics - checked disk usage with `df`, memory with `free`/`vm_stat`, and processes with `ps`/`top` to understand what's actually running and using resources on a machine.

## server_healthcheck.sh
A Bash script that automates basic monitoring:
- Checks disk usage and flags any mount over 80% full
- Reports total/used/free memory with usage percentage
- Verifies a given process (default `sshd`) is running
- Logs a timestamped summary line to `healthcheck.log`

## cron Scheduling
Scheduled the script with cron so it runs automatically on a timer instead of needing me to remember to run it - the building block of alerting and cleanup jobs.

## Key Insight
Health checks + scheduling = the smallest version of what real monitoring tools (Prometheus, etc.) do, just without the metrics collection and dashboards.