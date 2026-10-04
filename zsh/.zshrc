#fastfetch
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins (zinit plugin manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias ga='git add'
alias gaa='git add .'
alias gl='git log --oneline --graph --parents --all --decorate'
alias gout='git checkout'
alias gcm='git commit'
alias gst='git status'
alias gres='git restore ./'
#alias za='var=$(fdfind --exclude EPFL/archive | fzf --query="EPFL ") && zathura $var --log-level=error &'
alias loadtex='zathura build/master.pdf& localleaf -m latex/master.tex ./ -- --outdir=build/ --auxdir=aux/'


# Shell integrations
#source <(fzf --zsh)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# ───────── fo : fzf open ─────────
# Catégories : à chaque <cat> correspondent <cat>_extensions et <cat>_software
img_extensions=(png jpg jpeg gif webp bmp svg tiff ico)
img_software=(eog)

document_extensions=(pdf)
document_software=(zathura)

office_extensions=(doc docx odt xls xlsx ods ppt pptx odp)
office_software=(libreoffice)

video_extensions=(mp4 mkv avi mov webm flv wmv)
video_software=(vlc)

audio_extensions=(mp3 flac ogg wav m4a opus)
audio_software=(vlc)

text_extensions=(txt md json yaml yml toml conf ini sh zsh py js ts html css c cpp h rs go lua)
text_software=(vim)

fo_categories=(img document office video audio text)
terminal_software=(vim)
fo_default_software=vim
fo_excluded_dirs=(~/EPFL/archive)

fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

fo() {
  local finder
  if (( $+commands[fd] )); then finder=fd
  elif (( $+commands[fdfind] )); then finder=fdfind
  fi

  # Filtre d'exclusion : retire les chemins situés dans fo_excluded_dirs
  local -a gargs
  local d
  for d in "${fo_excluded_dirs[@]}"; do gargs+=(-e "${d%/}/"); done

  local -a sels
  {
    if [[ -n $finder ]]; then
      $finder --type f --hidden --exclude '.*/' --absolute-path "$@"
    else
      find "${(@)${@:-.}:A}" -type f -not -path '*/.*/*'
    fi
  } | { (( $#gargs )) && grep -vF "${gargs[@]}" || cat } \
    | sed "s|^$PWD/||" \
    | fzf --query="" --multi --preview 'file -b {}' \
    | while IFS= read -r line; do sels+=("$line"); done

  local f ext cat_name exts_var sw_var c cmd
  local -a exts sws
  for f in "${sels[@]}"; do
    [[ -z $f ]] && continue
    ext=${f:e:l}
    cmd=""

    for cat_name in "${fo_categories[@]}"; do
      exts_var="${cat_name}_extensions"
      exts=( "${(@P)exts_var}" )
      if (( ${exts[(Ie)$ext]} )); then
        sw_var="${cat_name}_software"
        sws=( "${(@P)sw_var}" )
        for c in "${sws[@]}"; do
          if (( $+commands[$c] )); then cmd=$c; break; fi
        done
        break
      fi
    done

    [[ -z $cmd ]] && cmd=$fo_default_software

    if (( ${terminal_software[(Ie)$cmd]} )); then
      "$cmd" "$f"                                  # terminal : premier plan
    else
      setsid "$cmd" "$f" >/dev/null 2>&1 &!        # GUI : détaché
    fi
  done
}
feo() {
  local finder
  if (( $+commands[fd] )); then finder=fd
  elif (( $+commands[fdfind] )); then finder=fdfind
  fi

  # Filtre d'exclusion : retire les chemins situés dans fo_excluded_dirs
  local -a gargs
  local d
  for d in "${fo_excluded_dirs[@]}"; do gargs+=(-e "${d%/}/"); done

  local -a sels
  {
    if [[ -n $finder ]]; then
      $finder --type f --hidden --exclude '.*/' --absolute-path "$@"
    else
      find "${(@)${@:-.}:A}" -type f -not -path '*/.*/*'
    fi
  } | { (( $#gargs )) && grep -vF "${gargs[@]}" || cat } \
    | sed "s|^$PWD/||" \
    | fzf --query="EPFL " --multi --preview 'file -b {}' \
    | while IFS= read -r line; do sels+=("$line"); done

  local f ext cat_name exts_var sw_var c cmd
  local -a exts sws
  for f in "${sels[@]}"; do
    [[ -z $f ]] && continue
    ext=${f:e:l}
    cmd=""

    for cat_name in "${fo_categories[@]}"; do
      exts_var="${cat_name}_extensions"
      exts=( "${(@P)exts_var}" )
      if (( ${exts[(Ie)$ext]} )); then
        sw_var="${cat_name}_software"
        sws=( "${(@P)sw_var}" )
        for c in "${sws[@]}"; do
          if (( $+commands[$c] )); then cmd=$c; break; fi
        done
        break
      fi
    done

    [[ -z $cmd ]] && cmd=$fo_default_software

    if (( ${terminal_software[(Ie)$cmd]} )); then
      "$cmd" "$f"                                  # terminal : premier plan
    else
      setsid "$cmd" "$f" >/dev/null 2>&1 &!        # GUI : détaché
    fi
  done
}
