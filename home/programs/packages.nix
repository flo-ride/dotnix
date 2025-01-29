{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Tools
    pavucontrol
    networkmanagerapplet
    thunderbird
    blueberry
    yubikey-personalization
    wdisplays

    # Dev
    git-review
    maven
    opentofu
    typst
    typst-live
    onlyoffice-bin
    libreoffice

    # Productivity
    flameshot
    xfce.thunar
    (pkgs.discord.override {
      #withOpenASAR = true;
      withVencord = true;
    })
    termius

    # Programs
    kicad-unstable

    # Fun
    spotify
  ];
}
