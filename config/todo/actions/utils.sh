#!/usr/bin/env bash

error_handler() {
	local -r code="$?"
	case "$code" in
		0)
			return
			;;
		1)
			echo "Invalid task number"
			exit "$code"
			;;
		2)
			echo "Cancelled"
			exit "$code"
			;;
		3)
			echo "Invalid view name"
			exit "$code"
			;;
		*)
			echo "Unexpected error $code"
			exit "$code"
			;;
	esac
}

linenr() {
	num=$1
	fzf=$2

	len=$(wc -l "$TODO_FILE" | cut -d ' ' -f 1)
	[ -z "$num" ] && {
		[ -n "$fzf" ] && command -v fzf &> /dev/null && {
			num=$($TODO_SH -p command ls | fzf --preview= | cut -d ' ' -f 1)
			[ -z "$num" ] && return 2
			num=$((10#$num))
		} || num="$len"
	}
	[[ $num =~ ^[1-9][0-9]*$ ]] || return 1
	((num > len)) && return 1

	echo "$num"
}

print_header() {
	local -r name=$1
	local width=$2
	local symbol=$3
	[ -z "$width" ] && width=$(tput cols)
	[ -z "$symbol" ] && symbol="-"
	local -r padding=$((width - ${#name}))
	local -r template="$symbol%.0s"
	printf -- "$template" $(seq $((padding / 2)))
	printf -- "%s" "$name"
	printf -- "$template" $(seq $((padding / 2 + padding % 2)))
}

overview() {
	local -r name="$1"
	local symbol
	local subcmd

	case "$1" in
		"contexts")
			symbol="@"
			subcmd="lsc"
			;;
		"projects")
			symbol="+"
			subcmd="lsprj"
			;;
		*)
			return 3
			;;
	esac

	# Parameters
	local -r min_lines="10" # per tag -- tasks + heading
	local -r min_desc_chars="30"
	local -r prompt_n_lines=3

	local -r term_w=$(tput cols)
	local -r term_h=$(tput lines)
	local -r n_cols=$((term_w / min_desc_chars))

	print_header "$name"

	# # bash: read tag:tasks
	# declare -A tasks
	# while read -r task; do
	# 	while read -r tag; do
	# 		tasks[$tag]+="$task"$'\n'
	# 	done < <(echo "$task" | grep "$symbol\S\+" -o || echo "-$symbol")
	# done < <(TODOTXT_VERBOSE=0 $TODO_SH -p command ls)

	# python
	declare -A tasks
	mapfile -t -d '' parr < <(TODOTXT_VERBOSE=0 $TODO_SH -p command ls | $TODO_ACTIONS_DIR/tags.py "$symbol")
	# total_len - 1, tag1, tasks1, ...
	for i in $(seq 1 2 $parr); do
		tag=${parr[i]}
		task=${parr[$((i + 1))]}
		tasks[$tag]=$task
	done

	local -r n_tags=${#tasks[@]}
	local -r n_rows=$(((n_tags + n_cols - 1) / n_cols))       # ceil(tags/cols)
	local n_lines=$(((term_h - prompt_n_lines - 1) / n_rows)) # XXX -1 -- header

	# ensure a minimum number of tasks per tag
	local overflow= # bool: output didn't fit on a single screen
	((min_lines > n_lines)) && n_lines="$min_lines" && overflow="1"

	local cells=()
	for tag in "${!tasks[@]}"; do
		local count=$(printf -- "%s" "${task}" | wc -l)
		local heading="$tag: $count"
		local underline=$(print_header "" "${#heading}")
		cells+=("$(printf -- "\n$heading\n$underline\n%s" "${tasks[$tag]}" | head -n "$n_lines")")
	done

	# disable stretching on the last row by adding an empty cell
	for i in $(seq $((n_cols * n_rows - n_tags))); do
		cells+=("")
	done

	# use pr to columnate output
	for i in $(seq 0 $((n_rows - 1))); do
		# evil magic to pass an array of strings using process substitution
		subs=$(printf '<(printf %%s %q) ' "${cells[@]:$((i * n_cols)):n_cols}")
		eval pr --omit-pagination --merge --width="$term_w" $subs
	done

	# notify if output didn't fit on a single screen
	[ -n "$overflow" ] && printf '\n%s\n' 'Overflow, scroll up' || true
}
