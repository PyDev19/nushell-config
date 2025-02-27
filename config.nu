def left_prompt [] {
    mut prompt = [];
    $prompt = $prompt | append $"(ansi cyan)╭─"

    let folder_name = $env.PWD | path basename
    $prompt = $prompt | append $"(ansi purple)[  ($folder_name) ](ansi cyan)"

    if ([$env.PWD, "\\.git"] | str join | path exists) {
        $prompt = $prompt | append $"-(ansi red)[ 󰘬 (git branch --show-current | str trim) ](ansi cyan)"
    }

    try {
        let venv = $env.VIRTUAL_ENV_PROMPT
        let python_version = python --version | str trim | split row " " | get 1
        $prompt = $prompt | append $"-(ansi blue)[  ($venv) v($python_version) ]"
    } catch { "" }

    $prompt = $prompt | append $"(ansi cyan)\n╰─ "
    
    $prompt | str join
}

$env.PROMPT_COMMAND = { || left_prompt }
$env.PROMPT_INDICATOR = ""