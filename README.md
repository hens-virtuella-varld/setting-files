# repo for setting files I using

## VIM

### File

vimrc

### Setup

```sh
$ cp vimrc ~/.vimrc
$ git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
$ vim "+call minpac#update()" +qall
```

## Git

gitconfig

### Setup

```sh
$ cp gitconfig ~/.gitconfig
```

## tmux

tmux.conf

### Setup

```sh
$ cp tmux.conf ~/.tmux.conf
```

## Bash

bashrc

### Setup

```sh
$ cp bashrc ~/.bashrc
```

## Zsh + Prezto

zshrc
zpreztorc

### Setup

```sh
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprez"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
cp zshrc ~/.zshrc
cp zpreztorc ~/.zpreztorc
chsh -s /bin/zsh
```
