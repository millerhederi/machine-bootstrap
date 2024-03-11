if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval "$(/opt/homebrew/bin/brew shellenv)"

set -gx PATH $PATH ~/go/bin

function git-prune -d "Delete all local git branches except for main"
    git branch | grep -v "main" | xargs git branch -D
end

funcsave git-prune