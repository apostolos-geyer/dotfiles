
import '.util.just'

all: all-langs all-vscode

all-langs: python nushell zig go deno sh

all-vscode: \
    python-vscode \
    nushell-vscode \
    zig-vscode \
    go-vscode \
    deno-vscode \
    sh-vscode


[doc('Install uv, install Python and tooling via uv')]
[group('tooling')]
python: (need "brew") && (uv-tools "ruff" "pyright" "basedpyright" "jupyterlab")
    brew install uv
    uv python install 3.9 3.10 3.11 3.12

[group('vscode-exts')]
[doc('Install VSCode extensions for Python (standards + ruff)')]
python-vscode: (need "code") && (code-exts \
    "charliermarsh.ruff" \
    "ms-python.python" \
    'ms-python.vscode-pylance' \
    "ms-pyright.pyright" \
    'ms-toolsai.jupyter' \
    'ms-toolsai.jupyter-keymap' \
    'ms-toolsai.jupyter-renderers' \
    'ms-toolsai.vscode-jupyter-cell-tags' \
    'ms-toolsai.vscode-jupyter-slideshow' \
    )


[doc("Install nushell")]
[group("tooling")]
nushell: (need "brew")
    brew install nushell

[doc("Install vscode extension for nushell")]
[group("vscode-exts")]
nushell-vscode: (code-exts "TheNuProjectContributors.vscode-nushell-lang")


[group('tooling')]
[doc('Install Zig and ZLS.')]
zig: (need "brew")
    brew install zig zls

[group('vscode-exts')]
[doc('Install VSCode extension for zig')]
zig-vscode: (code-exts "ziglang.vscode-zig")


[group('tooling')]
[doc('Install go, formatter, linter, LSP, and debugger.')]
go: (need "brew")
    brew install go
    go install mvdan.cc/gofumpt@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest

[group('vscode-exts')]
[doc('Install VSCode extensions for go (standard + golangci-lint)')]
go-vscode: (code-exts "golang.go" "golangci.golangci-lint")


[group('tooling')]
[doc('Install deno (for js dev)')]
deno: (need "brew")
    brew install deno

[group('vscode-exts')]
[doc('Install VSCode extension for deno (vscode-deno)')]
deno-vscode: (code-exts "denoland.vscode-deno")


[group('tooling')]
[doc('Install shell utilities')]
sh: (need "brew") (need "go")
    brew install \
        zsh \
        bash \
        shellcheck \
        bash-language-server
    go install mvdan.cc/sh/v3/cmd/gosh@latest


[group('vscode-exts')]
[doc('Install vscode extensions for shell scripts')]
sh-vscode: (code-exts \
    "timonwong.shellcheck" \
    "foxundermoon.shell-format"
    )


[group('tooling')]
[doc('lua, luajit, stylua, and lua language server')]
lua: (need "brew")
    brew install \
        lua \
        luajit \
        lua-language-server \
        stylua \
        luacheck \
        luarocks

[group('vscode-exts')]
[doc('Install lua vscode plugin')]
lua-vscode: (code-exts "sumneko.lua")


[group('tooling')]
[doc('apple pkl configuration language')]
pkl: (need "brew")
    brew install pkl

[group('vscode-exts')]
[doc('Install apple pkl vscode plugin [uses a nushell script to download & install, as its only available as a VSIX]')]
pkl-vscode: (need "nu") (need "code")
    #!/usr/bin/env nu
    (http get "https://api.github.com/repos/apple/pkl-vscode/releases/latest").assets
    | where (
        $it.name
        | str contains "vsix"
    )
    | first
    | do { |record|
        let dest = $"($env.HOME)/.vscode/extensions/($record.name)"
        http get $record.browser_download_url
        | save $dest
        code --install-extension $dest
        rm $dest
        } $in




[doc("Install passed vscode extensions")]
[positional-arguments]
[private]
code-exts +exts: (need "code")
    #!/usr/bin/env bash
    if [ "$(command -v parallel)" ]; then
        printf '%s\n' "$@" | parallel code --install-extension "{}"
    else
        for arg in "$@"
        do
            code --install-extension "$arg" &
        done
        wait
    fi

[doc("Install passed python tools")]
[positional-arguments]
[private]
uv-tools +exts: (need "uv")
    #!/usr/bin/env bash
    if [ "$(command -v parallel)" ]; then
        printf '%s\n' "$@" | parallel uv tool install "{}"
    else
        for arg in "$@"
        do
            uv tool install "$arg" &
        done
        wait
    fi
