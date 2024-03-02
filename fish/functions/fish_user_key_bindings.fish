function fish_user_key_bindings
	set -g fish_key_bindings fish_vi_key_bindings

	fish_default_key_bindings -M insert
	fish_vi_key_bindings --no-erase

	# https://github.com/fish-shell/fish-shell/issues/7152#issuecomment-663575001
	bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
	bind -M command \cz 'fg 2>/dev/null; commandline -f repaint'

	# https://stackoverflow.com/a/58382277
	bind -M insert \cy accept-autosuggestion execute
end
