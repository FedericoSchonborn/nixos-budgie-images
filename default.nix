{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
  ];

  isoImage.edition = "budgie";

  services.xserver = {
    desktopManager.budgie = {
      enable = true;
      # Yoinked from installation-cd-graphical-calamares-gnome.nix
      extraGSettingsOverrides = ''
        [com.solus-project.icon-tasklist:Budgie]
        pinned-launchers=["firefox.desktop", "nixos-manual.desktop", "mate-terminal.desktop", "nemo.desktop", "gparted.desktop", "io.calamares.calamares.desktop"]
      '';
    };

    displayManager = {
      lightdm.enable = true;

      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };

  # Yoinked from installation-cd-graphical-calamares-plasma5.nix
  system.activationScripts.installerDesktop = let
    # Comes from documentation.nix when xserver and nixos.enable are true.
    manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

    homeDir = "/home/nixos/";
    desktopDir = homeDir + "Desktop/";
  in ''
    mkdir -p ${desktopDir}
    chown nixos ${homeDir} ${desktopDir}

    ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
    ln -sfT ${pkgs.mate.mate-terminal}/share/applications/mate-terminal.desktop ${desktopDir + "mate-terminal.desktop"}
    ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${desktopDir + "io.calamares.calamares.desktop"}
  '';

  system.nixos-generate-config.desktopConfiguration = [
    ''
      # Enable the Budgie desktop environment.
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.desktopManager.budgie.enable = true;
    ''
  ];

  system.stateVersion = "23.05";
}
