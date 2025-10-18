# modules/laptop.nix
{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    laptop.enable = lib.mkEnableOption "Enable laptop-specific settings";
  };
  config = lib.mkIf config.laptop.enable {
    virtualisation = {
      waydroid.enable = true;
      libvirtd.enable = true;
      virtualbox.host.enable = true;
      vmware.host.enable = true;
    };

    virtualisation.libvirtd = {
      # Enable TPM emulation (for Windows 11)
      qemu = {
        swtpm.enable = true;{
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };

    # Enable USB redirection
    virtualisation.spiceUSBRedirection.enable = true;

    # Touchpad (libinput)
    services.xserver.libinput.enable = true;

    # User groups for virtualization
    users.users.razushi = {
      extraGroups = [
        "libvirtd"
        "kvm"
      ];
    };

    environment.systemPackages = with pkgs; [
      # Laptop
      thinkfan
      gnome-boxes
      qemu
      qemu_kvm
      wireshark
      gns3-gui
      gns3-server
      # kdePackages.krdc
      # libsForQt5.krdc
      dnsmasq
      vmware-workstation
      iwd
      kdePackages.krdp
    ];
  };
}
