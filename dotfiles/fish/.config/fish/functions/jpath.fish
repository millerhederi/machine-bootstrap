function jpath --description 'Get a list of all json paths from the stdin json'
    jq -r 'path(..) | join(".")' | sed -r 's/\.[0-9]+/\[\]/g' | sort -u
end