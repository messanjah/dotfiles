# MacOS changed the default shell from bash to zsh in 10.15 (Catalina).
# https://support.apple.com/en-us/HT208050
# This envar silences the deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f ~/.bashrc ]; then
        source ~/.bashrc
fi
export PATH=/usr/local/bin:$PATH
# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

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

# source homebrew env
eval "$(/opt/homebrew/bin/brew shellenv)"

#bash-completion
# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# bash-git-prompt
# https://formulae.brew.sh/formula/bash-git-prompt
if [ -f "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR="$HOMEBREW_PREFIX/opt/bash-git-prompt/share"
  export GIT_PROMPT_THEME=Custom
  export GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files
  export GIT_PROMPT_ONLY_IN_REPO=1 # Use the default prompt when not in a git repo.
  source "$HOMEBREW_PREFIX/opt/bash-git-prompt/share/gitprompt.sh"
fi

# asdf version manager
# https://asdf-vm.com/
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
. <(asdf completion bash)

# Makefile completions
# https://stackoverflow.com/questions/4188324/bash-completion-of-makefile-target
# https://bambowu.github.io/linux/MakefileCompletion/
complete -W "\`if [ -f Makefile ]; then grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_-]*$//'; elif [ -f makefile ]; then grep -oE '^[a-zA-Z0-9_-]+:([^=]|$)' makefile | sed 's/[^a-zA-Z0-9_-]*$//'; fi \`" make

export HOMEBREW_GITHUB_API_TOKEN=$(cat ~/.homebrew-github-api-token)

# ruby-build apparently doesn't use Homebrew's upgraded openssl.
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# openssl@3 borked install of procore_danger? Tried to install openssl 2.2.2
# RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# https://artifacts.procoretech.com/ui/admin/artifactory/user_profile

export ARTIFACTORY_USERNAME=
export ARTIFACTORY_PASSWORD=
export GOPROXY=https://$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD@artifacts.procoretech.com/artifactory/api/go/golang
export GONOSUMDB=github.com/procore

export AWS_DEFAULT_PROFILE=aws-sso-procoretech
