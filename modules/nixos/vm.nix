{
  config,
  pkgs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 floride libvirtd -"
  ];
  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="floride", GROUP="kvm", MODE="0660"
  '';

  boot.extraModulePackages = [config.boot.kernelPackages.kvmfr];
  boot.kernelModules = ["kvmfr"];
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=64
  '';
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm",
        "/dev/kvmfr0"
    ]
  '';
}
