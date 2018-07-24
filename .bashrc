#######################################
##### .bash_history file settings #####
#######################################

# Make the .bash_history file very big
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# appends session history to .bash_history
shopt -s histappend

# immediately add commands to .bash_history instead of on logout.
# This is helpful since I multiple concurrent sessions running.
PROMPT_COMMAND='history -a'

# I've seen the extended version of above...but am not implementing it at this time.
# I think this will re-read .bash_history to all open terminals...
# After each command, append to the history file and reread it
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Avoid duplicates in .bash_history
export HISTCONTROL=ignoredups:erasedups

#####################################################
##### This is for general environment variables #####
#####################################################

# This should be the bash equivalent of unsetting autologout
export TMOUT=0

# just a safety option if accidentally using rm without any flags
alias rm="rm -i"

#safety to stop chmod function GL 3/27/2018
alias chmod="echo Please do not use chmod on Qumulo, we are managing permission through Windows ACLs. Do not chmod"

# important for qumulo
# qumulo appears to read $USER umask when redirecting stdout
# 770 for dirs & 660 for files
# Note that you cannot use umask to make new files executable.
# http://www.ixbrian.com/blog/?p=121
umask 0007

# This sets the prompt
# "$USER@HOSTNAME> "
export PS1="\u@\h> "

# protects against overwriting file with > redirect
# can still force overwrite with >| redirect
set -o noclobber

################################################################
##### module loading section for bright cluster management #####
################################################################

# I don't think I need to set /usr/bin, /bin, etc

# eventually going to replace anaconda with one that I've compiled
# module load anaconda-python/2.7.12
module load java/1.8.0_112
module load datamash/1.1.0
module load parallel/20161222
module load perl/5.25.9
module load R/3.0.1
module load tabix/0.2.6
module load samtools/0.1.18
module load vcftools/0.1.12b
module load bedtools/2.26.0
module load pigz/2.3.4
module load vt/0.5772

# don't really see ever changing this
module load sublime_text/3.3143

# these two are core modules for using bright, so I'm putting these last
module load sge/2011.11p1
# both the CC and CXX variables should really be exported within the gcc module, but I'm not doing that today
module load gcc/5.1.0


###########################################
###########################################

# temp fix to bad ananconda module that I initially had above
export PATH="/mnt/linuxtools/ANACONDA/anaconda2-5.0.0.1/bin:$PATH"

## This will always put the current working directory in front of any directory for PATH
export PATH=".:$PATH"
