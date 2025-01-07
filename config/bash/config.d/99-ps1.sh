#!/usr/bin/env bash

_git() {
	local bare
	bare=$(git rev-parse --is-bare-repository 2> /dev/null) || return # we're not in a repo
	tput setaf 2
	printf ' '
	if [ "$bare" = 'true' ]; then
		printf 'bare'
	else
		local -r raw=$(git -C "$1" status --porcelain=v2 --show-stash --branch)

		# repo name
		local -r url="$(git remote get-url origin 2> /dev/null)"
		printf %s "$(basename -s .git "$url")/"

		# branch/commit
		local -r branch=$(echo "$raw" | grep -oP '(?<=^# branch.head ).*') && {
			if ! [ "$branch" = '(detached)' ]; then
				printf %s "$branch"
			else
				printf %.6s "$(echo "$raw" | grep -oP '(?<=^# branch.oid ).*')"
			fi
		}

		# status
		local status
		{
			# get XY status codes
			codes() {
				# TODO awk stuff is gpt, check
				echo "$raw" | grep '^[12]' | awk -v pos="$1" -v num="$2" '{printf substr($0, pos, num)} END {print ""}' \
					| sed 's/[. #]//g' | fold -w1 | LC_ALL=C sort -u | tr -d '\n'
			}

			# staging area (index)
			status+=$(codes 3 1)

			# work tree
			if [ -n "$(codes 4 1)" ] || echo "$raw" | grep -q '^\?'; then
				status+="?"
			fi

			# unpushed commits
			[ -n "$url" ] && [ -n "$(git cherry)" ] && status+='^'

			# stash
			echo "$raw" | grep -qP '(?<=^# stash )\d+' && status+='$'
		}
		[ -n "$status" ] && printf %s ":$status"
	fi
	tput sgr0
}

_code() {
	local err=$__last_return_code
	[ "$err" -ne 0 ] && {
		tput bold setaf 1
		printf '%s\n' " ERR:$err"
		tput sgr0
	}
}

_jobs() {
	# TODO figure out how to hide zoxide (?) job
	n_jobs=$(jobs | wc -l)
	((n_jobs > 0)) && {
		tput bold setaf 3
		printf %s " J:$n_jobs"
		tput sgr0
	}
}

_time() {
	printf %s " $(date +%H:%M)"
}

_ssh() {
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		printf '%s\n' " $(whoami)@$(hostname)"
	fi
}

_path() {
	cwd=$(pwd)
	len=${#HOME}
	[[ $cwd == "$HOME"* ]] \
		&& cwd="~${cwd:len}"
	tput bold
	printf %s "$cwd"
	tput sgr0
}

_shlvl() {
	[ -n "$SHLVL" ] && ((SHLVL > 1)) && printf %s " L:$SHLVL"
}

_nix() {
	[ -n "$IN_NIX_SHELL" ] && printf %s " $IN_NIX_SHELL"
}

PROMPT_COMMAND='__last_return_code=$?'"${PROMPT_COMMAND:+;${PROMPT_COMMAND}}"

PS1=
PS1+=' $(_code)'
PS1+='\n'
PS1+=' $(_ssh)'
PS1+='$(_path)$(_git)$(_jobs)$(_shlvl)$(_nix)$(_time)\n'
PS1+=' \$ '

PS2='│'
