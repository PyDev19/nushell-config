def left_prompt [] {
    let folder_name = $env.PWD | path basename
    let folder_name_display = $"(ansi purple)[  ($folder_name) ](ansi cyan)"

    let is_git_repo = [$env.PWD, "\\.git"] | str join | path exists
    let git_branch = if $is_git_repo {
        $"-(ansi red)[ 󰘬 (git branch --show-current | str trim) ](ansi cyan)"
    } else {
        ""
    }

    let venv = try { $env.VIRTUAL_ENV_PROMPT } catch { "" }
    let venv_display = if $venv != "" {
        let python_version = python --version | str trim | split row " " | get 1
        $"-(ansi blue)[  ($venv) v($python_version) ]"
    } else {
        ""
    }
    
    [(ansi cyan), "╭─", $folder_name_display, $git_branch, $venv_display, (ansi cyan), "\n╰─ "] | str join
}

$env.PROMPT_COMMAND = { || left_prompt }
$env.PROMPT_INDICATOR = ""