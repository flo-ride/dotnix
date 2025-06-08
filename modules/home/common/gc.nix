{
  # Garbage collect the Nix store
  nix.gc = {
    automatic = true;
    # dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
