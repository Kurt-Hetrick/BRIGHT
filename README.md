# 9 March 2018

basic .bashrc, .bash_profile and .sge request files for jhgenomics users using the bright local user accounts

# MONITOR_BRIGHT_SERVERS.sh.
## CHECKS SERVERS UNDER BRIGHT LICENSE AND REGISTERED TO SGE FOR DROPPED RAM AND ONLINE STATES

TO RUN

nohup MONITOR_BRIGHT_SERVERS.sh 2>&1 </dev/null &

SOMETIMES YOU HAVE TO HIT <CTRL+C> to get it to release
