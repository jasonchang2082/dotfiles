export PATH=/opt/local/bin:$PATH

# prepend $HOME/bin to the path if it exists
if [ -e $HOME/bin ] ; then
  export PATH=$HOME/bin:$PATH
fi


# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# Completions
source ~/bin/git-completion.bash


# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

shopt -s histappend


# auto-completion is not case sensitive anymore
set completion-ignore-case On

export EDITOR='mate -w'


alias cls='clear'
alias gush='git push origin master'
alias mkdir="mkdir -vp"
alias go-bundles="cd ~/Library/Application\ Support/TextMate/Bundles/"

alias firefox-dev="~/Applications/Minefield.app/Contents/MacOS/firefox-bin -no-remote -P dev &"

###################################
# ls
###################################
export CLICOLOR=1
export LSCOLORS=hxfxcxdxbxegedabagHxHx

alias ll="ls -l -h"
alias la="ls -a"
alias l="ls"
alias lla="ls -a -l"
alias lm='ls -la | more'

# Reveal current dir in Path Finder
pf()
{
  osascript<<END
tell app "Path Finder"
  reveal POSIX file("$PWD")
  activate
end tell
END
}

# Open a manpage in Preview, which can be saved to PDF
pman()
{
   man -t "${1}" | open -f -a /Applications/Preview.app
}


###################################
# PROMPT
###################################
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
      WHITE="\[\033[1;37m\]"
 COLOR_NONE="\[\e[0m\]"

function parse_git_branch {
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  git_log_oneline="$(git log --pretty=oneline origin/master..master 2> /dev/null | wc -l)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
      state="${RED}⚡"
  fi
  
  if [[ ! ${git_log_oneline}} =~ " 0" ]]; then
      needs_push="${GREEN}·"
  fi
  
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi

  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo "(${branch})${remote}${state}${needs_push}"
  fi
}
 
function prompt_func() {
    previous_return_value=$?;
    prompt="[\w]  ${GREEN}$(parse_git_branch)${COLOR_NONE}"
    PS1="${prompt}\n${COLOR_NONE}$ "
}
 
PROMPT_COMMAND=prompt_func
