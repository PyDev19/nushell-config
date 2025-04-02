def --env load-vcvars [arch: string = "x64"] {
    if ($nu.os-info.family != "windows") {
        print "load-vcvars only works on windows"
        return
    }

    let env_vars = do { 
        cmd.exe /c $"call vcvarsall.bat ($arch) && set"
    } | lines | parse "{key}={value}"

    mut new_env = {}

    for row in $env_vars {
        let key = $row.key | str trim
        let value = $row.value | str trim

        if $key == "PWD" {
            continue
        }

        if $key == "Path" {
            let paths = $value | split row ";"
            let new_value = $env | get $key | prepend $paths
            $new_env = ($new_env | upsert $key $paths)
        } else {
            $new_env = ($new_env | upsert $key $value)
        }
    }

    load-env $new_env

    print $"MSVC environment variables loaded for ($arch)."
}

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

def right_prompt [] {
    mut prompt = []

    if $env.CMD_DURATION_MS != "0" {
        let duration_sec = ($env.CMD_DURATION_MS | into float | math round --precision 2) / 1000
        $prompt = $prompt | append $"(ansi yellow)[  ($duration_sec)s ](ansi cyan)-"
    }

    if $env.LAST_EXIT_CODE != 0 {
        $prompt = $prompt | append $"(ansi red)[ ✖ ($env.LAST_EXIT_CODE) ](ansi cyan)-"
    }

    let current_time = date now | format date "%I:%M:%S %p"
    $prompt = $prompt | append $"(ansi magenta)[  ($current_time) ]"

    $prompt | str join
}

$env.PROMPT_COMMAND = { || left_prompt }
$env.PROMPT_COMMAND_RIGHT = { || right_prompt }
$env.PROMPT_INDICATOR = ""