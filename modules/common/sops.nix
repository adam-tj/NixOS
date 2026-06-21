{
  sops = {
    defaultSopsFile = ../../secrets.enc.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/adam/.secrets/agekey.txt";
  };
}