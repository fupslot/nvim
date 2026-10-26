# Neovim config

## What this repo is about

This is my personal setup for Neovim, the text editor I use for writing code every day. Neovim is plain and bare when you first install it. This repo holds the settings and add-ons that turn it into a comfortable place to work.

Here is what the setup gives you:

- **A dark, easy-on-the-eyes color theme.** It uses the Gruvbox colors.
- **Fast file search.** You can find a file by typing part of its name, or search for a word across the whole project.
- **A file tree on the side**, so you can browse folders the way you would in a regular file manager.
- **Help while you type code.** The editor suggests words as you type, shows mistakes as you make them, and lets you jump to where something is defined. This works for Python, TypeScript and JavaScript, Lua, HTML, JSON, Tailwind CSS and Terraform.
- **Automatic tidying when you save.** Files are neatly formatted every time you save them. You can switch this off with `,tf` if it gets in the way.
- **Git markers in the margin**, which show the lines you have added, changed or removed since your last commit.
- **GitHub Copilot**, which suggests whole lines of code as you type.
- **Smooth movement between Neovim and tmux panes** (tmux is a tool that splits one terminal window into several).

The main key for shortcuts is the comma. For example, `,ve` opens these settings and `,vs` reloads them after you make a change.

## How to set it up

You need Neovim version 0.11 or newer. The steps below assume a Mac with [Homebrew](https://brew.sh) installed.

**1. Install the tools this setup depends on.**

```sh
xcode-select --install
brew install neovim git ripgrep node
```

The first command installs Apple's developer tools, which some add-ons need in order to build themselves. Ripgrep makes searching across a project fast. Node.js is needed by Copilot and by several of the coding helpers.

**2. Install a Nerd Font and choose it in your terminal settings.**

A Nerd Font is a regular programming font with small icons added to it. Without one, you will see empty boxes where the file and folder icons should be. JetBrains Mono Nerd Font is a good choice:

```sh
brew install --cask font-jetbrains-mono-nerd-font
```

**3. Move any old Neovim settings out of the way.**

If you have used Neovim before, keep a copy of your old settings so nothing is lost:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

**4. Download this repo into the place Neovim looks for its settings.**

```sh
git clone git@github.com:fupslot/nvim.git ~/.config/nvim
```

**5. Open Neovim and let it install everything.**

```sh
nvim
```

The first start takes a minute or two. Neovim downloads all the add-ons and the coding helpers on its own. When the progress window says it is done, quit with `:q` and open Neovim again.

**6. Install the formatters.**

These are the small programs that tidy your files when you save. Run this inside Neovim:

```
:MasonInstall stylua yamlfmt prettierd
```

**7. Sign in to GitHub Copilot.**

Run `:Copilot setup` inside Neovim and follow the steps it shows you. You can skip this if you don't use Copilot.

You're done. To check that everything is healthy, run `:checkhealth` inside Neovim. It lists anything that is still missing.
