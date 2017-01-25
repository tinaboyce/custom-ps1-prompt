# Colorized Input
# http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Custom Command Prompt
PS1="\[\033[33m\]\u\[\033[00m\] \w\[\$(gitcolor)\]\$(gitify)\[\033[00m\] \$ "



### Functions for custom git-aware command prompt ###
# http://randy3k.github.io/blog/git-aware-prompt/ (Copied 16/12/16)

function git-branch-name {
    echo `git symbolic-ref HEAD --short 2> /dev/null || (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/.*(\(.*\))/\1/')`
}

function git-dirty {
    st=$(git status 2>/dev/null | tail -n 1)
    if [[ ! $st =~ "working directory clean" ]]
    then
        echo "*"
    fi
}

function git-unpushed {
    brinfo=`git branch -v | grep "$(git-branch-name)"`
    if [[ $brinfo =~ ("ahead "([[:digit:]]*)) ]]
    then
        echo -n "+${BASH_REMATCH[2]}"
    fi
    if [[ $brinfo =~ ("behind "([[:digit:]]*)) ]]
    then
        echo -n "-${BASH_REMATCH[2]}"
    fi
}

function gitcolor {
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        if [[ $(git-dirty) == "*" ]];
        then
            echo -e "\033[31m"
        else
            echo -e "\033[32m"
        fi
    fi
}

function gitify {
    st=$(git status 2>/dev/null | head -n 1)
    if [[ ! $st == "" ]]
    then
        echo -e " ($(git-branch-name)$(git-dirty)$(git-unpushed))"
    fi
}
