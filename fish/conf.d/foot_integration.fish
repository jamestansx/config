# Jumping between prompts
# https://codeberg.org/dnkl/foot/wiki#fish-1
function mark_prompt_start --on-event fish_prompt
	echo -en '\e]133;A\e\\'
end

# Piping last command's output
# https://codeberg.org/dnkl/foot/wiki#fish-2
function foot_cmd_start --on-event fish_preexec
	echo -en '\e]133;C\e\\'
end
function foot_cmd_end --on-event fish_postexec
	echo -en '\e]133;D\e\\'
end
