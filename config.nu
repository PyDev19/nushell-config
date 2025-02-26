# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.
def left_prompt [] {
    let folder_name = $env.PWD | path basename
    let folder_name_display = $"[ ($folder_name) ]"

    let is_git_repo = [$env.PWD, "\\.git"] | str join | path exists
    let git_branch = if $is_git_repo {
        $"-[ (git branch --show-current | str trim) ]"
    } else {
        ""
    }

    let venv = try { $env.VIRTUAL_ENV_PROMPT } catch { "" }
    let venv_display = if $venv != "" {
        $"-[ ($venv) ]"
    } else {
        ""
    }
    
    [$folder_name_display, $git_branch, $venv_display] | str join
}

$env.PROMPT_COMMAND = { || left_prompt }
