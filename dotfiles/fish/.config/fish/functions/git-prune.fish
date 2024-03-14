function git-prune --description 'Delete all local git branches except for main'
    git branch | grep -v "main" | xargs git branch -D
end
