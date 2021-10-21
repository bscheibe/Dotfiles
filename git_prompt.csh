set branch = `git branch |& grep \* | sed 's/\* //g' | cut -c 1-12`

if ("" == "$branch") then
  set prompt = "%n@%m [%c02] > "
else
  set prompt = "%n@%m [$branch\:%c02] > "
endif
