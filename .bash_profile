# OSX ~/.bash_profile harvested 2017-11-27
if [ -f ~/.bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

GPG_TTY=$(tty)
export GPG_TTY
export PINENTRY_USER_DATA="USE_CURSES=1"

#bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
 . $(brew --prefix)/etc/bash_completion
fi

if [ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share"
  export GIT_PROMPT_THEME=Custom
  export GIT_SHOW_UNTRACKED_FILES=no # Don't count untracked files (no, normal, all)
  export GIT_PROMPT_ONLY_IN_REPO=1 # Use the default prompt when not in a git repo.
  source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh"
fi
