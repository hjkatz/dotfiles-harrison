# see: http://unix.stackexchange.com/questions/108699/documentation-on-less-termcap-variables
# mb = start blink
# md = start bold
# me = turn off bold, blink, and underline
# so = start stdout (reverse video?)
# se = stop stdout
# us = start underline
# ue = stop underline

man() {
	env \
		LESS_TERMCAP_mb=$(printf "${fg_bold[magenta]}") \
		LESS_TERMCAP_md=$(printf "${fg_bold[green]}") \
		LESS_TERMCAP_me=$(printf "${reset_color}") \
        LESS_TERMCAP_so=$(printf "${bg[black]}${fg_bold[red]}") \
		LESS_TERMCAP_se=$(printf "${reset_color}") \
		LESS_TERMCAP_us=$(printf "${fg_bold[yellow]}") \
		LESS_TERMCAP_ue=$(printf "${reset_color}") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}
