{
  sops = {
    defaultSopsFile = ../../secrets.enc.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops/agekey.txt";
  };
}