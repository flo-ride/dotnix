{
  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nixos-unified-template-shell";
      meta.description = "Shell environment for modifying this Nix configuration";
      packages = with pkgs; [
        just
        nixd
        sops
        ssh-to-age
      ];
      shellHook = ''
        if [ -z "$SSH_AUTH_SOCK" ]; then
          eval "$(ssh-agent -c)"
        fi

        ssh-add /home/floride/.ssh/id_flo

        export SOPS_AGE_KEY=$(ssh-to-age -i /home/floride/.ssh/id_flo -private-key)
      '';
    };
  };
}
