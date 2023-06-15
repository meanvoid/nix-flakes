{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.etc."mdadm.conf".text = ''
    HOMEHOST <ignore>
    ARRAY /dev/md0 UUID=2d0be890:bc0f45fb:96a52424:865c564f
    ARRAY /dev/md5 UUID=c672589e:b68e1eae:6d443de9:956ba431
  '';
}
