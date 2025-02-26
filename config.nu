def left_prompt [] {
    let folder_name = $env.PWD | path basename
    let folder_name_display = $"[  ($folder_name) ]"

    let is_git_repo = [$env.PWD, "\\.git"] | str join | path exists
    let git_branch = if $is_git_repo {
        $"-[ 󰘬 (git branch --show-current | str trim) ]"
    } else {
        ""
    }

    let venv = try { $env.VIRTUAL_ENV_PROMPT } catch { "" }
    let venv_display = if $venv != "" {
        let python_version = python --version | str trim | split row " " | get 1
        $"-[  ($venv) v($python_version) ]"
    } else {
        ""
    }
    
    [$folder_name_display, $git_branch, $venv_display, "\n "] | str join
}

$env.PROMPT_COMMAND = { || left_prompt }
$env.PROMPT_INDICATOR = ""