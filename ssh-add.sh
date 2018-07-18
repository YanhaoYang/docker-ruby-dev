#!/bin/zsh

containers=( $(docker-compose ps | awk '{ print length($1) " " $1; }' | tail -n +3 | sort -n | cut -d ' ' -f2 -) )
echo $containers
for c in $containers
do
	echo $c
	if [[ $c == *"ssh-agent"* ]]; then
		echo "find $c"
		name=$c
		break
	fi
done
if [[ -n "$name" ]]; then
	echo "Adding ~/.ssh/$1 ..."
	docker run --rm --volumes-from=$name -v ~/.ssh:/.ssh -it yanhao/ssh-agent ssh-add /root/.ssh/$1
	echo "Done!"
else
	echo "No matching name to ssh-agent."
fi
