{ flake, lib, ... }: {
  imports = [ flake.inputs.nixvim.homeModules.nixvim ];

  # Disable neovim in this case
  programs.neovim.enable = lib.mkForce false;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    imports = [
      ./base.nix
      ./keybindings.nix
      ./lsp.nix
      ./formatting.nix
      ./clipboard.nix
      ./cmp.nix
      ./ai.nix
      ./debugger.nix

      ./ui/default.nix
      ./ui/bufferline.nix
      ./ui/git.nix
      ./ui/lspsaga.nix
      ./ui/lualine.nix
      ./ui/neotest.nix
      ./ui/noice.nix
      ./ui/telescope.nix
      ./ui/treesitter.nix
      ./ui/tree.nix
      ./ui/debugger.nix
    ];
  };
}
