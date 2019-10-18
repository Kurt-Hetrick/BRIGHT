# 9 March 2018

basic .bashrc, .bash_profile and .sge request files for jhgenomics users using the bright local user accounts

# MONITOR_BRIGHT_SERVERS.sh
- CHECKS SERVERS UNDER BRIGHT LICENSE AND REGISTERED TO SGE FOR DROPPED RAM AND ONLINE STATES EVERY HOUR

`nohup MONITOR_BRIGHT_SERVERS.sh 2>&1 </dev/null &`

SOMETIMES YOU HAVE TO HIT <CTRL+C> to get it to release, but once you do so it will run in the background.

# file_extension_size.sh
- Calculates the 15 file extensions in a directory (including within subdirectories) that take up the most space in Gb

`file_extension_size.sh /path/to/dir`

# submitter_bwa_samtools_qumulo_testing.sh

if you want to submit one job to each server across all servers on sge (in SINGLE TEST TYPE), below is an example

`for server in $(qstat -f -s r | egrep -v "^[0-9]|^-|^queue|^ " | cut -d . -f 1,2 | sort | egrep -v "programmers|cgc"); do submitter_bwa_samtools_qumulo_testing.sh /mnt/research/tools/LINUX/00_GIT_REPO_KURT/02_DEVELOPMENT_BRANCHES/RANDOM/QUMOLO_TESTS/bwa_mem.sh $server 4 SINGLE 1 ; done | bash`

