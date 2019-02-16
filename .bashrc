## changes in this block are done by me 
alias docs='cd /Users/atulsachdeva/Docs'
alias dwnl='cd /Users/atulsachdeva/Downloads'
alias desk='cd /Users/atulsachdeva/Desktop'

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

if [[ $- == *i* ]]; then

	orange=$(tput setaf 166);
	yellow=$(tput setaf 228);
	green=$(tput setaf 71);
	white=$(tput setaf 15);
	violet=$(tput setaf 61);
	blue=$(tput setaf 33);
	bold=$(tput bold);
	reset=$(tput sgr0);

	PS1="\[${bold}\]\n";
	PS1+="\[${orange}\]\u";
	PS1+="\[${white}\] at ";
	PS1+="\[${yellow}\]\h";
	PS1+="\[${white}\] in ";
	PS1+="\[${green}\]\w";
	PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
	PS1+="\n";
	PS1+="\[${white}\]\$ \[${reset}\]";

fi;

##
alias mysql=/usr/local/mysql/bin//mysql