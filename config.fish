# ═══════════════════════════════════════════════════════════════════════════
# ELYES' FISH CONFIGURATION (WSL & WINDOWS)
# ═══════════════════════════════════════════════════════════════════════════

set -g fish_greeting ""

# ─────────────────────────────────────────────────────────────────────────
# ENVIRONMENT & PATHS
# ─────────────────────────────────────────────────────────────────────────
set -gx EDITOR "code --wait"
set -gx BIZ_PATH ~/projects/03_business
set -gx EDU_PATH ~/projects/02_education
# ─────────────────────────────────────────────────────────────────────────
# ABBREVIATIONS 
# ─────────────────────────────────────────────────────────────────────────

# Navigieren
abbr -a cdbiz "cd $BIZ_PATH"
abbr -a cdedu "cd $EDU_PATH"

# Coding & Git
abbr -a g "git"
abbr -a gs "git status"
abbr -a gc "git commit -m"
abbr -a gp "git push"
abbr -a nrd "npm run dev"
abbr -a ni "npm install"

# System & Configs
abbr -a fconf "nano ~/.config/fish/config.fish"
abbr -a sc "sudo systemctl"

# ─────────────────────────────────────────────────────────────────────────
# FUNCTIONS: GitHub Workflow (npu)
# ─────────────────────────────────────────────────────────────────────────
function npu
    set repo_name (basename (pwd))
    echo "🚀 Creating GitHub Repo: $repo_name"
    git init
    git add .
    git commit -m "Initial commit"
    gh repo create $repo_name --public --source=. --remote=origin --push
    code .
end

function npr
    echo "What will the project be used for?"
    echo "1) Swisscom"
    echo "2) Private / Business"
    echo "3) School / Course"
    read -l choice

    set -l base_path ""
    switch $choice
        case 1
            set base_path "$HOME/projects/01_swisscom"
        case 2
            set base_path "$HOME/projects/03_business"
        case 3
            set base_path "$HOME/projects/02_education"
        case '*'
            echo "Invalid option."
            return 1
    end

    echo "Describe a project name."
    read -l project_name

    if test -z "$project_name"
        echo "Name can't be empty"
        return 1
    end

    set -l final_path "$base_path/$project_name"

    mkdir -p $final_path
    cd $final_path
    git init
    echo "# $project_name" > README.md
    
    echo "Project $project_name created at $base_path"
    code .
end

# ─────────────────────────────────────────────────────────────────────────
# FUNCTION: Timer)
# ─────────────────────────────────────────────────────────────────────────
function t
    nohup bash -c "sleep $argv[1] && notify-send 'Timer done!' 'Zeit: $argv[1]' && canberra-gtk-play -i complete-graduation" >/dev/null 2>&1 &
    echo "Timer for $argv[1] started."
end

