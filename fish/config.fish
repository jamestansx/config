status is-interactive || exit

if status is-login
	set -gx EDITOR nvim
	set -gx VISUAL nvim
	set -gx TERMINAL foot
	set -gx BROWSER firefox-developer-edition

	set -gx XDG_CACHE_HOME $HOME/.cache
	set -gx XDG_CONFIG_HOME $HOME/.config
	set -gx XDG_DATA_HOME $HOME/.local/share
	set -gx XDG_STATE_HOME $HOME/.local/state
	fish_add_path $HOME/.local/bin

	# Ensure gpg-agent is started so that SSH will work
	# https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
	set -gx GNUPGHOME $XDG_CONFIG_HOME/gnupg
	gpgconf --launch gpg-agent

	if test -z "$WAYLAND_DISPLAY" -a "$XDG_VTNR" = 1
		set -gx XDG_SESSION_TYPE wayland
		set -gx XDG_CURRENT_DESKTOP river
		set -gx XDG_SESSION_DESKTOP river

		set -gx _JAVA_AWT_WM_NONREPARENTING 1
		set -gx MOZ_ENABLE_WAYLAND 1
		set -gx MOZ_DBUS_REMOTE 1
		set -gx GTK_USE_PORTAL 1

		set -l timestamp (date +%F-%R)
		exec river -log-level warning > /tmp/river-$timestamp.log 2>&1
	end
end

# https://wiki.archlinux.org/title/GnuPG#SSH_agent
set -gx GPG_TTY (tty)
set -e SSH_AGENT_PID
set -q gnupg_SSH_AUTH_SOCK_by || set -l gnupg_SSH_AUTH_SOCK_by 0
if test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
	set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
gpg-connect-agent updatestartuptty /bye &>/dev/null

# Emulates vim's cursor shape behaviour
set fish_cursor_default block
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

fish_config theme choose kanagawa_dragon
