{
  virtualisation.docker = {
    enable = true;
  };
  users.users.adam.extraGroups = [ "docker" ];
}
