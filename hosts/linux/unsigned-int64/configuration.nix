{ config, pkgs, lib, agenix, ... }:

{
  imports = 
  [ ./hardware-configuration.nix ] ++
  (import ./networking);
  
  age.secrets = {
    wireguard-server.file = ./../../../secrets/wireguard-server.age;
    wireguard0.file = ./../../../secrets/wireguard0.age;
    wireguard-shared.file = ./../../../secrets/wireguard-shared.age;
    wireguard-server-shared_julio.file = ./../../../secrets/wireguard-server-shared_julio.age;
  };
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    generationsDir = { copyKernels = true; };
    systemd-boot = {
      enable = true;
      configurationLimit = 15;
    };
    timeout = 10;
  };
  boot.initrd.services.swraid.mdadmConf = config.environment.etc."mdadm.conf".text;
  #!!! maybe delete since we are running 32 gigs
  zramSwap = { enable = true; };
  networking = {
    hostName = "unsigned-int64";
    interfaces = {
      enp1s0 = {
        name = "eth0";
        useDHCP = true;
        ipv4.addresses = [
          {
            address = "91.107.210.152";
            prefixLength = 32;
          }
          {
            address = "88.99.124.6";
            prefixLength = 32;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:4f8:c010:a22c::1";
            prefixLength = 128;
          }
        ];
      };
    };
    nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = "enp1s0";
        internalInterfaces = [ "wireguard0" ];
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ 53 3128 51280 51820 ];
      allowedTCPPorts = [ 53 80 443 3128 25565 ];
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -i enp1s0 -p tcp --dport 25565 -j DNAT --to-destination 172.168.10.2:25565
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o wg-ports0 -p tcp --dport 25565 -d 172.168.10.2 -j SNAT --to-source 172.168.10.1

        ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wg-ports0 -p tcp --dport 25565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg-ports0 -o enp1s0 -p tcp --sport 25565 -m state --state ESTABLISHED,RELATED -j ACCEPT
      '';
      extraStopCommands = ''
        ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -i enp1s0 -p tcp --dport 25565 -j DNAT --to-destination 172.168.10.2:25565
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o wg-ports0 -p tcp --dport 25565 -d 172.168.10.2 -j SNAT --to-source 172.168.10.1

        ${pkgs.iptables}/bin/iptables -D FORWARD -i enp1s0 -o wg-ports0 -p tcp --dport 25565 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg-ports0 -o enp1s0 -p tcp --sport 25565 -m state --state ESTABLISHED,RELATED -j ACCEPT
      '';
    };
  };
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    keyMap = "us";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-u16b.psf.gz";
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "";
        openssh.authorizedKeys.keys =
          [
            # marie
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            # alex
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
          ];
      };
      ashuramaru = {
        isNormalUser = true;
        home = "/home/ashuramaru";
        description = "Marie";
        initialHashedPassword = "";
        extraGroups = [ "wheel" "users" ];
        openssh.authorizedKeys.keys =
          [
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKNF4qCh49NCn6DUnzOCJ3ixzLyhPCCcr6jtRfQdprQLAAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEF0v+eyeOEcrLwo3loXYt9JHeAEWt1oC2AHh+bZP9b0AAAACnNzaDpyZW1vdGU= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNR1p1OviZgAkv5xQ10NTLOusPT8pQUG2qCTpO3AhmxaZM2mWNePVNqPnjxNHjWN+a/FcZ5on74QZQJtwXI5m80AAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBFdzdMIdu/bKlIkGx1tCf1sL65NwrmpvBZQ+nSbKknbGHdrXv33mMzLVUsCGUaUxmeYcCULNNtSb0kvgDjRlcgIAAAAOc3NoOnJlbW90ZS1kc2E= email:ashuramaru@tenjin-dk.com id:ashuramaru@unsigned-int32"
          ];
      };
      meanrin = {
        isNormalUser = true;
        home = "/home/meanrin";
        description = "Alex";
        initialHashedPassword = "";
        extraGroups = [ "wheel" "users" ];
        openssh.authorizedKeys.keys =
          [
            "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
          ];
      };
      Jack = {
        isNormalUser = true;
        home = "/home/jackS";
        description = "JackS";
        initialHashedPassword = "";
        extraGroups = [ "users" ];
        openssh.authorizedKeys.keys =
          [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJDgmNWQRw6NXAdJuXVJcKKX9F6xzMpcb+h2qQ7KYn/e dimonsterhome@gmail.com"
          ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    git
    htop
    tmux
  ];
  environment.etc."mdadm.conf".text = ''
    ARRAY /dev/md0 name=unsigned-int64:root UUID=8e5e4207:07f4d007:9654119f:86f9b109
  '';
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "ashuramaru@riseup.net";
    };
    sudo = {
      wheelNeedsPassword = false;
    };
  };
  services = {
    pcscd.enable = true;
    openssh = {
      enable = true;
      allowSFTP = true;
      openFirewall = true;
      settings = {
        passwordAuthentication = false;
        kbdInteractiveAuthentication = true;
        permitRootLogin = "prohibit-password";
      };
    };
    dnsmasq = {
      enable = true;
      settings = {
        inteface = "wireguard0";
      };
      resolveLocalQueries = true; 
    };
  };
  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };
  system.stateVersion = "22.11";
}
