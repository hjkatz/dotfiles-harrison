# Zsh settings (see: http://zsh.sourceforge.net/Doc/Release/Options.html)

# TODO: pull these out of oh-my-zsh

# in order on the options page

# Changing directories
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHDMINUS

# Completion
unsetopt MENU_COMPLETE   # do not autoselect the first completion entry
unsetopt FLOWCONTROL
setopt AUTO_MENU         # show completion menu on succesive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END

# Correction
setopt CORRECT_ALL

# History
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS # ignore duplication command history list
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY # share command history data

# Jobs
setopt LONG_LIST_JOBS

# Comments
setopt INTERACTIVE_COMMENTS

# Something?
setopt MULTIOS
setopt PROMPT_SUBST

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt RM_STAR_WAIT
setopt EXTENDED_GLOB
setopt DVORAK
