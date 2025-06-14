# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/02c3b24f-0535-4d24-b1c4-7b497243605c";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/1181-321F";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/bin" =
    {
      device = "/usr/bin";
      fsType = "none";
      options = [ "bind" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/52fb8889-7e1b-403e-8543-c8b168f0bdab"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-0f5edef33c50.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-15ad41c8f2e4.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-6e0e491b9cc6.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-93ab3bf87048.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth15b9b94.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth4960377.useDHCP = lib.mkDefault true;
  # networking.interfaces.veth94056eb.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethbb5422a.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethd48b918.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethfc755e2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
