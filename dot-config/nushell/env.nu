

use std "path add"
path add /opt/homebrew/bin

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship/starship.toml"

zoxide init nushell | save -f ~/.zoxide.nu
