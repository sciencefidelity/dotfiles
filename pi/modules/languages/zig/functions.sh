# zie = zig init-exe <app-name>
zie() { mkdir "$@" && cd "$@" && zig init-exe; }

# zil = zig init-lib <lib-name>
zil() { mkdir "$@" && cd "$@" && zig init-lib; }
