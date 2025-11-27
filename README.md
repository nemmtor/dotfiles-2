Instructions:

1. Make a backup of your .config dir and nvim cache:

```bash
cp -R ~/.config ~/.config.bak
```

```bash
cp -R ~/.local/share/nvim ~/.local/share/nvim.bak
cp -R ~/.local/state/nvim ~/.local/state/nvim.bak
cp -R ~/.cache/nvim ~/.cache/nvim.bak
```

2. Clone this repo and copy content of .config to your .config dir and clone content of .claude

3. Install [Tmuxifier](https://github.com/jimeh/tmuxifier) place it in ~/.config/tmuxifier

```bash
git clone git@github.com:jimeh/tmuxifier.git ~/.config/tmuxifier
```

4. Install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```
