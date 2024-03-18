{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      clang-tools
      gdb
      valgrind
    ];
  };
}
