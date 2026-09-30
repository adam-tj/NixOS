{
  services.logind.settings = {
  Login = {
    # Ignore lid closure when on AC power or battery
    HandleLidSwitch = "ignore";
    
    # Optional: specifically handle external power vs. battery
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
};
}