set -gx VCPKG_ROOT $HOME/vcpkg
if status is-interactive
    set -lx PATH_DIRECTORIES \
        $HOME/.local/bin \
        $HOME/.config/tmuxifier/bin \
        $HOME/.config/herd-lite/bin \
        $HOME/.nvm \
        $HOME/vcpkg \
        $HOME/.cargo/bin \
        $HOME/go/bin \
        /Applications/WezTerm.app/Contents/MacOS \
        /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin \
        $HOME/.bun/bin

    set -x PATH $PATH_DIRECTORIES $PATH

    set -gx PHP_INI_SCAN_DIR $HOME/.config/herd-lite/bin
    set -gx GPG_TTY (tty)

    set -gx EDITOR nvim

    # git
    alias gaa="git add -A"
    alias gaap="git add -A -p"
    alias gce="git checkout"
    alias gcm="git commit"
    alias gpp="git push"
    alias gpl="git pull"
    alias gss="git status"
    alias gll="git log"
    alias gllo="git log --oneline"
    alias gbb="git branch"
    alias lg="lazygit"
    alias ld="lazydocker"
    source ~/.config/fish/custom/git-things.fish

    # bin
    alias ls="exa"
    alias cat="bat"
    alias find="fd"
    alias copy="pbcopy <"
    alias v="nvim"
    alias vim="nvim"
    alias python="python3"

    # development
    alias b="bun"
    alias p="pnpm"

    # directories
    alias pro="cd ~/Projects"

    # config files
    alias nvimrc="vim ~/.config/nvim"
    alias fishrc="vim ~/.config/fish/config.fish"
    alias weztermrc="vim ~/.config/wezterm/wezterm.lua"

    # utils
    alias work="timer 25m && terminal-notifier -message 'Pomodoro'\
        -title 'Work Timer is up! Take a Break 😊'\
        -sound Crystal"

    alias rest="timer 5m && terminal-notifier -message 'Pomodoro'\
        -title 'Break is over! Get back to work 😬'\
        -sound Crystal"

    # Disable done.fish window detection at startup
    set -g __done_allow_nongraphical 1

    fish_vi_key_bindings
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# Lazy-load tmuxifier
function tmuxifier -d "Lazy-load tmuxifier"
    eval (command tmuxifier init - fish)
    functions -e tmuxifier
    tmuxifier $argv
end

# Lazy-load Google Cloud SDK
function gcloud -d "Lazy-load gcloud"
    if test -f "$HOME/google-cloud-sdk/path.fish.inc"
        source "$HOME/google-cloud-sdk/path.fish.inc"
    end
    functions -e gcloud
    gcloud $argv
end

if type -q tmux; and status is-interactive; and not string match -qr 'screen|tmux' -- "$TERM"; and test -z "$TMUX"
    tmux
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
~/.local/bin/mise activate fish | source

# TokyoNight Color Palette
set -l foreground c0caf5
set -l selection 2e3c64
set -l comment 565f89
set -l red f7768e
set -l orange ff9e64
set -l yellow e0af68
set -l green 9ece6a
set -l purple 9d7cd8
set -l cyan 7dcfff
set -l pink bb9af7

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_option $pink
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_selected_background --background=$selection
