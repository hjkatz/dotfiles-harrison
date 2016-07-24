# Zsh settings (see: http://zsh.sourceforge.net/Doc/Release/Options.html)

# in order on the options page

# Changing directories
setopt AUTO_CD           # auto cd to directories without needing to type cd
setopt AUTO_PUSHD        # auto push directories onto the directory stack
setopt CDABLE_VARS       # if the cd command doesn't exist, try ~/command
setopt PUSHD_IGNORE_DUPS # don't push duplicates onto the directory stack
setopt PUSHDMINUS        # cd -3 works as expected

# Completion
setopt   ALWAYS_TO_END    # move cursor to the end of the completion if a match is found
setopt   AUTO_MENU        # show completion menu on succesive tab press
setopt   COMPLETE_IN_WORD # keep cursor inside the word while completion is happening
setopt   GLOB_COMPLETE    # complete globs to a pattern match instead of an insertion
unsetopt MENU_COMPLETE    # do not autoselect the first completion entry

# Expansion and Globbing
setopt EXTENDED_GLOB # turn on extended globbing :)

# History
setopt APPEND_HISTORY         # every zsh session appends to the histfile instead of overwriting
setopt EXTENDED_HISTORY       # save extra information in the histfile ‘: <beginning time>:<elapsed seconds>;<command>’
setopt HIST_EXPIRE_DUPS_FIRST # if we must delete from the history, delete duplicates first
setopt HIST_IGNORE_DUPS       # ignore duplication command history list
setopt HIST_IGNORE_SPACE      # commands that start with a space do not get recorded to the history
setopt HIST_VERIFY            # don’t execute lines with history expansion, instead put them on the current line expanded
setopt INC_APPEND_HISTORY     # write to the histfile immediately on command execution
setopt SHARE_HISTORY          # share command history data between zsh processes

# Input/Output
setopt   CORRECT      # correct the spelling of commands
setopt   DVORAK       # correct for spelling mistakes with Dvorak layout
unsetopt FLOWCONTROL  # output flow control via start/stop characters is disabled
setopt   RM_STAR_WAIT # safety first for rm * or rm path/*

# Job Control
setopt AUTO_CONTINUE  # when `disown`-ing a job a SIGCONT is automatically sent to the process to start it up
setopt LONG_LIST_JOBS # list jobs in the long format by default

# Prompting
setopt PROMPT_SUBST # make expansion and substitution work inside prompts

# Scripts and Functions
setopt MULTIOS # perform implicit `tee`s or `cat`s when multiple redirections are attempted
