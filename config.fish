if status is-interactive
    # Commands to run in interactive sessions can go here
end
set PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin ~/.npm-global/bin /opt/homebrew/opt/python@3.9/libexec/bin $PATH

alias cat=bat
alias ls='exa -l --group-directories-first --color=auto --icons --no-permissions --no-user'
alias ll='exa -lahF --group-directories-first --color=auto --icons'
alias find="fzf --ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
#alias nvim='~/Downloads/nvim-osx64/bin/nvim'

#set EDITOR ~/Downloads/nvim-osx64/bin/nvim
set FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'
starship init fish | source

fish_vi_key_bindings
#tmuxinator start coding

[ -f ~/.inshellisense/key-bindings.fish ] && source ~/.inshellisense/key-bindings.fish
