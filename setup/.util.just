

[doc("Prevent a recipe from being run if executable is missing.")]
[no-exit-message]
[private]
need executable:
    #!/usr/bin/env bash
    [ "$(command -v {{executable}})" ] || \
        (echo "{{executable}} required. relaunch '>> just <cmd>' after installing {{executable}}" \
            && exit 1)


[doc("Install a brew bundle from a file")]
[private]
bundle pth: (need "brew")
    echo "{{pth}}"
    brew bundle install --file="{{pth}}"


[doc("Ensure just was launched with sudo")]
[extension('.bash')]
[no-exit-message]
[private]
need-sudo:
    #!/usr/bin/env bash
    [ "$EUID" -eq 0 ] || \
        (echo "sudo required. relaunch with '>> sudo just <cmd>'" && exit 1)


[doc("Kill a process via pkill.")]
[private]
pkill-quit process: need-sudo
    pkill "{{process}}"


[doc("Kill a process via killall.")]
[private]
killall-quit process: need-sudo
    killall "{{process}}"