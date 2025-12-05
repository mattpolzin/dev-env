# unlike framework-hardware-configuration.nix, this file is
# not auto-generated.
{ pkgs, ... }:
{
  # fingerprint reader:
  services.fprintd.enable = true;

  # better battery life for AMD procs
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = true;

  # BIOS updating
  services.fwupd.enable = true;

  # text size on hidpi display for some programs:
  environment.variables = {
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1.0";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
  };

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = true;
  programs.light.enable = true;

  # Note: with Bluetooth enabled, need to use rfkill to block or unblock
  # bluetooth before using bluetoothctl to power on, scan, pair, connect,
  # trust.
  hardware.bluetooth.enable = true;

  # support for reading more hardware state:
  boot.kernelModules = [
    "cros_ec"
    "cros_ec_lpcs"
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  # fix white screen & flicker when using integrated AMD graphics:
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  # swap partition decryption:
  boot.initrd.luks.devices."luks-d99ad198-c36b-4aa6-97e3-7f970030e770".device = "/dev/disk/by-uuid/d99ad198-c36b-4aa6-97e3-7f970030e770";
}
