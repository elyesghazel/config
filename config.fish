# ═══════════════════════════════════════════════════════════════════════════
# ELYES GHAZEL - FISH SHELL CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

set -g fish_greeting ""

# ─────────────────────────────────────────────────────────────────────────
# ENVIRONMENT & CORE PATHS
# ─────────────────────────────────────────────────────────────────────────
set -gx EDITOR "code --wait"
set -gx BIZ_PATH $HOME/projects/03_business
set -gx EDU_PATH $HOME/projects/02_education
set -gx PLAY_PATH $HOME/projects/04_playground
set -gx PORTFOLIO_PATH $HOME/projects/01_swisscom/portfolio

# ─────────────────────────────────────────────────────────────────────────
# ABBREVIATIONS
# ─────────────────────────────────────────────────────────────────────────

# Navigation
abbr -a cdbiz "cd $BIZ_PATH"
abbr -a cdedu "cd $EDU_PATH"
abbr -a cdplay "cd $PLAY_PATH"
abbr -a cdport "cd $PORTFOLIO_PATH"

# Development & Git
abbr -a g "git"
abbr -a gs "git status"
abbr -a gc "git commit -m"
abbr -a gp "git push"
abbr -a nrd "npm run dev"
abbr -a ni "npm install"

# System Config
abbr -a fconf "nano ~/.config/fish/config.fish"
abbr -a vconf "nano ~/.config/vicinae/config.json"

# ─────────────────────────────────────────────────────────────────────────
# FUNCTION: Create New Project (npr)
# ─────────────────────────────────────────────────────────────────────────
function npr
    echo "Select project category:"
    echo "1) Swisscom"
    echo "2) Business / Private"
    echo "3) Education / School"
    read -l choice

    set -l base_path ""
    switch $choice
        case 1
            set base_path $HOME/projects/01_swisscom
        case 2
            set base_path $BIZ_PATH
        case 3
            set base_path $EDU_PATH
        case '*'
            echo "Error: Invalid selection."
            return 1
    end

    echo "Enter project name:"
    read -l project_name

    if test -z "$project_name"
        echo "Error: Project name cannot be empty."
        return 1
    end

    set -l final_path "$base_path/$project_name"

    mkdir -p $final_path
    cd $final_path
    git init -b main
    echo "# $project_name" > README.md
    
    echo "Status: Project initialized at $final_path"
    code .
end

# ─────────────────────────────────────────────────────────────────────────
# FUNCTION: GitHub Public Repo Creator (npu)
# ─────────────────────────────────────────────────────────────────────────
function npu
    set -l repo_name $argv[1]
    
    # Case: Name provided -> Initialize in Playground
    if test -n "$repo_name"
        set -l final_path "$PLAY_PATH/$repo_name"
        mkdir -p $final_path
        cd $final_path
    # Case: No name provided -> Use current directory
    else
        set repo_name (basename (pwd))
        if test (pwd) = "$HOME"
            echo "Error: Cannot initialize repository in HOME directory."
            return 1
        end
    end

    if not test -d .git
        git init -b main
    end

    git add .
    git commit -m "Initial commit" 2>/dev/null

    if command -sq gh
        echo "Syncing: $repo_name to GitHub..."
        gh repo create $repo_name --public --source=. --remote=origin --push 2>/dev/null; or git push -u origin (git branch --show-current)
    else
        echo "Error: GitHub CLI (gh) not found. Please run 'gh auth login'."
        return 1
    end

    code .
end

# ─────────────────────────────────────────────────────────────────────────
# FUNCTION: Background Timer (t)
# ─────────────────────────────────────────────────────────────────────────
function t
    nohup bash -c "sleep $argv[1] && notify-send 'Timer Expired' 'Duration: $argv[1]' && canberra-gtk-play -i complete-graduation" >/dev/null 2>&1 &
    echo "Timer started for $argv[1]."
end
