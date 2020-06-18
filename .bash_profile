#   Set Prompt
#   ------------------------------------------------------------

export PS1="$SQUIGGLES\n⎬ ${C_DEFAULT}[\h] «\u» ${C_BLUE}\w \$(prompt_git \"\[${C_DEFAULT}\]on \[${C_RED}\]\" \"\[${C_GREEN}\]\") \n${C_DEFAULT}⎬ ♛ ⟼  "

#   Git Tracking for Prompt
#   ------------------------------------------------------------

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

github-create() {
repo_name=$1

dir_name=`basename $(pwd)`

if [ "$repo_name" = "" ]; then
echo "Repo name (hit enter to use '$dir_name')?"
read repo_name
fi

if [ "$repo_name" = "" ]; then
repo_name=$dir_name
fi

username=`git config github.user`
if [ "$username" = "" ]; then
echo "Could not find username, run 'git config --global github.user <username>'"
invalid_credentials=1
fi

token=`git config github.token`
if [ "$token" = "" ]; then
echo "Could not find token, run 'git config --global github.token <token>'"
invalid_credentials=1
fi

if [ "$invalid_credentials" == "1" ]; then
return 1
fi

echo -n "Creating Github repository '$repo_name' ..."
curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
echo " done."

echo -n "Pushing local code to remote ..."
git remote add origin git@github.com:$username/$repo_name.git > /dev/null 2>&1
git push -u origin master > /dev/null 2>&1
echo " done."
}


#   Case-insensitive globbing (used in pathname expansion)
#   -----------------------------------------------------------
shopt -s nocaseglob;

#   Autocorrect typos in path names when using `cd`
#   -----------------------------------------------------------
shopt -s cdspell;

#   Activate Colors
#   -----------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagaced

#   Set Architecture Flags
#   -----------------------------------------------------------
export ARCHFLAGS="-arch x86_64"

#   Set Paths
#   -----------------------------------------------------------
export PATH="$PATH:/usr/local/bin:/Applications/Google\ Chrome.app/Contents/MacOS"
export PATH="$HOME/.fastlane/bin:$PATH"

#   Load .bashrc
#   -----------------------------------------------------------
test -f ~/.bashrc && source ~/.bashrc

#   Homebrew bash_completion Requirement
#   -----------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

#   GIT branch_completion Requirement
#   -----------------------------------------------------------
if [ -f ~/.git-completion.bash ]; then
. ~/.git-completion.bash
fi

#   Command Aliases
#   -----------------------------------------------------------

alias xc='open -a Xcode'
alias sub='open -a Sublime\ Text'
alias vs='open -a Visual\ Studio\ Code'
alias rs='open -a Realm\ Studio'

alias post='open -a Postman'

alias gc='open -a Google\ Chrome'
alias saf='open -a Safari'

alias slack='open -a Slack'
alias spark='open -a Spark'

alias 1pass='open -a 1Password\ 6'
alias skc='open -a Sketch'

alias ev='open -a Evernote'
alias bear='open -a Bear'

alias catr='cat README.md'

alias cm='open -a Digital\ Color\ Meter'
alias sys='open -a System\ Preferences'

alias xcp='open -a Xcode *.xcodeproj/'
alias xcw='open -a Xcode *.xcworkspace/'

alias xcp='open -a Xcode Podfile'

alias opng='open *.png'
alias opdf='open *.pdf'
alias ojpg='open *.jpg'

alias mpdf='mv *.pdf'
alias mpng='mv *.png'
alias mzip='mv *.zip'

alias pbc='pbcopy'
alias pbp='pbpaste'
alias cwd='pwd | pbcopy'

alias mv='mv -iv'
alias mkdir='mkdir -pv'

alias rm='rm -v'
alias rmf='rm -rfv'

alias countf='ls | wc -l'

alias doc='brew doctor'
alias brewup='brew update'

alias c='clear'
alias ..='cd ../'                               # Go back 1 directory level
alias ...='cd ../../'                           # Go back 2 directory levels
alias .3='cd ../../../'                         # Go back 3 directory levels
alias .4='cd ../../../../'                      # Go back 4 directory levels
alias .5='cd ../../../../../'                   # Go back 5 directory levels
alias .6='cd ../../../../../../'                # Go back 6 directory levels

alias .p='source ~/.bash_profile'
alias xcb='open -a Xcode ~/.bash_profile'
alias xcg='open -a Xcode ~/.gitconfig'

alias devpy='dev_appserver.py'

alias sdn='sudo shutdown -h now'                # shutdown the computer
alias sdr='sudo shutdown -r now'                # restart the computer

#   Command Functions
#   -------------------------------------------------------------

mkcd() { mkdir -pv $1; cd $1; }                  # Make multi-level directory and cd to the newly made directory
mvcd() { mv -iv $1 $2; cd $2; }                  # Move the given file or directory into a new or existing directory and change the working directory to the given directory

mkcds() { mkdir -pv $1; cd $1; clear; ls; }
mvcds() { mv -iv $1 $2; cd $2; clear; ls; }

mvcdd() { mv -iv $1 ~/Desktop; cd ~/Desktop; clear; ls; }
mvcdra() { mv -iv $1 /Applications; cd ~/../../Applications; clear; ls; }

cds() { cd $1; clear; ls; }                    # Change working directory, clear the terminal window, and then list the contents of the new working directory
cdr() { cd /; clear; ls; }                     # Change working directory to root, clear the terminal window, and then list the contents of the root directory
cdra() { cd /Applications/; clear; ls; }        # Change working directory to root applications, clear the terminal window, and then list the contents of the root applications directory
cdd() { cd ~/Desktop/; clear; ls; }            # Change working directory to desktop, clear the terminal window, and then list the contents of the desktop
cdds() { cd ~/Desktop/Swift/; clear; ls; }      # Change working directory to swift, clear the terminal window, and then list the contents of the swift directory
cddf() { cd ~/Desktop/Flipmass/; clear; ls; }   # Change working directory to flipmass, clear the terminal window, and then list the contents of the flipmass directory
cdsd() { cd ~/Downloads/; clear; ls; }         # Change the working directory to downloads, clear the terminal window, and then list the contents of downloads
cdsx() { cd ~/Library/Developer/Xcode/; clear; ls; }
cdsc() { cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/Desktop/; clear; ls; }
cddpi() { cd ~/Desktop/DPI/; clear; ls; }       # Change working directory to `DPI`, clear the terminal window, and then list the contents of the `DPI` directory

cl() { clear; ls; }                              # Clear the terminal window and then list the contents of the working directory
lsa() { clear; ls -a; }
lsl() { clear; ls -al; }
cla() { clear; ls -a; }                          # Clear the terminal window and then list the contents of the working directory as well as any hidden files
..l() { cd ../; clear; ls; }                     # Go back 1 directory level, clear the terminal window, and then list the contents of the working directory
...l() { cd ../..; clear; ls; }                  # Go back 2 directory levels, clear the terminal window, and then list the contents of the working directory

gfind() { git log --oneline --decorate --graph --all -E -i --grep $1; }
#    q() { osascript -e 'quit app "$1"'; }            # Quit the given app TODO: FIXME

# Launch an insecure instance of Google Chrome on localhost:8080
unsafeChrome() { cd; cd ../../Applications/Google\ Chrome.app/Contents/MacOS; ./Google\ Chrome --user-data-dir=test --unsafely-treat-insecure-origin-as-secure=http://localhost:8080; }

# unsafeChrome() { ./Google\ Chrome --user-data-dir=test --unsafely-treat-insecure-origin-as-secure=http://localhost:8080; }

# rmam() { ls | grep $1 | xargs rm -rfv; }         # remove all files and directories that match the given argument
# rmxm() { ls | grep -v $1 | xargs rm -rfv; }      # remove all files and directories except the given argument

#   Command History Settings
#   -------------------------------------------------------------
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE='pwd:ls:cd:cds:cl:sprof:mv:c:..l:...l:cdd:cdr:..:...:.3:.4:.4:.6:doc:brewup:xcb:.p:cla:gc:saf:ev:slack:cm'

#   Color Aliases
#   -------------------------------------------------------------

C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

#   Prompt Separators
#   -------------------------------------------------------------

# ≑⚪️ ⤖ ⪼ ∷∷∷ ⨳ ♛ ⟼

FLAT='______________________________________________________________________'
SQUIGGLES='~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
CORN='≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎≎'
OTHER_CORN='⋖⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⪥⋗'
DNA='⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺⋲⋺'
FLAT_CHAINED='⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞⟝⟞'
BIG_SQUIGGLES='⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧⦦⦧'
LITTLE_ARROWS='⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴⧴'
CHAINED_ARROWS='⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽⧼⋯⧽'
FLAT_ARROWS='⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶   ⟵⟶'
RANCH='⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋⋌⋋'
CIGS='🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬 🚬'
BLUE_BEDS='🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏 🛏'
BLACK_ANTS='〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️ 〰️'
FLAGS='🇦🇫 🇦🇽 🇦🇱 🇩🇿 🇦🇸 🇦🇩 🇦🇴 🇦🇮 🇦🇶 🇦🇬 🇦🇷 🇦🇲 🇦🇼 🇦🇺 🇦🇹 🇦🇿 🇧🇸 🇧🇭 🇧🇩 🇧🇧 🇧🇾 🇧🇪 🇧🇿 🇧🇯 🇧🇲 🇧🇹 🇧🇴 🇧🇶 🇧🇦 🇧🇼 🇧🇷 🇮🇴 🇻🇬 🇧🇳 🇧🇬 🇧🇫 🇧🇮 🇨🇻 🇰🇭 🇨🇲 🇨🇦 🇮🇨 🇰🇾 🇨🇫 🇹🇩 🇨🇱 🇨🇳 🇨🇽'
PURPLE_MONSTERS='👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾 👾'


export PATH="$HOME/.cargo/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
