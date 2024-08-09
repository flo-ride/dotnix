{ pkgs, ... }: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # utils
    file
    du-dust
    duf
    fd
    ranger
    grc

    # CLI-Tools
    bat
    lsd
    htop
    neofetch
    netcat
    pulsemixer
    gnupg
    ansible
    docker-compose
    nodejs
    python3
    rustup

    tldr # Better than man
    thefuck
  ];

  programs = {
    bat.enable = true;
    ssh.enable = true;
  };
}
