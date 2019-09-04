# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
current_user=$(whoami)

# Alias
alias ll="ls -la"
alias psown="ps -ef --sort=start_time | grep -v grep | grep ${current_user}"
alias zombies="ps -ef --sort=start_time | grep -v grep | grep \"defunct\""
alias countzs="ps aux | awk '{print \$8}' | grep -c Z"

# Functions
function clear_file()
{
    sed -i '/^#/d ; /^$/d' $1
}

