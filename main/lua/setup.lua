-- script info
print ("---------------------------------------------------------------------------------------------------");
print(gAm.scriptName ..string.format(gAm.version));	
print("author: Jengske_BE");
print("Fs version: FS2015");
print("This livecycle script gives a aging System, health Sytem and breeding System")
print ("---------------------------------------------------------------------------------------------------");
---------------------------------------------------------------------
-- Script data
-- this data could not be modified
gAm.IsActive = true; -- enable/disable the script, default is enabled
gAm.deBug = true; -- enable/disable debugging, default is enabled
gAm.defaultMode = "production"; -- script modes: production, hobby, breeding
gAm.curMode = nil; -- monitor mode
gAm.modes = {[1] = "production", [2] = "hobby", [3] = "breeding"};
gAm.defaultState = "idle"; -- animal states: idle, breeding, sick, dead
gAm.curState = nil; -- monitor state
gAm.states = {[1] = "idle", [2] = "breeding", [3] = "sick", [4] = "dead"};
gAm.defaultGender = "female"; -- animal genders: male, female
gAm.genders = {[1] = "male", [2] = "female"};
gAm.fileFound = false;