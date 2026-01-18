{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # Required for Windows 11 (TPM support)
    };
  };
  programs.virt-manager.enable = true;
}
