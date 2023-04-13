{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
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
	    address = "2a01:4f8:c010:a22c";
	    prefixLength = 64;
	  } 
	];
      };
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ 53 3128  ];
      allowedTCPPorts = [ 53 80 443 3128 25565 ];
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -I INPUT -p tcp --dport 22 -i wireguard0 -j DROP
	${pkgs.iptables}/bin/iptables -I INPUT -p tcp -i wireguard0 -s 172.168.1.100 -j ACCEPT

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
	"sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTfrnNlYOUKKGzgAcD+5eblH8mQRRoA4jU6GYNqKa/VAAAACnNzaDpnaXRodWI= Marie Levjewa email: ashuramaru@tenjin-dk.com id:unsigned-int32"
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
	"sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBTfrnNlYOUKKGzgAcD+5eblH8mQRRoA4jU6GYNqKa/VAAAACnNzaDpnaXRodWI= Marie Levjewa email: ashuramaru@tenjin-dk.com id:unsigned-int32"
	"sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBCzoNOzhhF9uYDu7CbuzVRJ2K6dClXLrEoJrQvIYjnxHTBMqKuByi9M2HEmkpGO+a3H3WjeeXfqjH2CwZJ97jmIAAAAEc3NoOg== meanrin@outlook.com"
	];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    htop
    tmux
  ];
  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "ashuramaru@riseup.net";
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
