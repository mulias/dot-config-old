dot_config
==========
My personal linux configuration files.

Thanks to the wonders of `$XDG_CONFIG_HOME`, I now keep all my config files in
the `~/.config` directory. While many programs find their config files
automatically, for some I had to set an environment variable in `.zsh` or add a
filepath argument in `.xinitrc`. A few programs can't be coerced into storing
their config files in `~/.config` at all. I keep these files in
`~/.config/*_stow` directories, and then use
[GNU Stow](https://www.gnu.org/software/stow/) to symlink the files to their
normal locations.

A number of programs use `~/.config` to store automatically generated or
otherwise boring config files. I add these to `.gitignore` as needed.
