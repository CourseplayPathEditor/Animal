--------------------------------------------------------
-- Author: Jengske_BE
-- Date: 18/08/2015
-- 
-- DO NOT MODIFY THIS FILE WITHOUT PERMISSION!!!
--------------------------------------------------------

gAm_man = {};
gAm_man_mt = Class(gAm_man);
InitObjectClass(gAm_man, "gAm_man");

addModEventListener(gAm_man);
main = gAm_mn;
local modItem = ModsUtil.findModItemByModName(g_currentModName);

gAm_man.MissionDir = g_currentMission;
gAm_man.LoadDir = g_currentModDirectory;
gAm_man.XMLdir = g_currentModDirectory .."/xml/";
gAm_man.LUAdir = g_currentModDirectory .."/lua/";
gAm_man.IMGdir = g_currentModDirectory .."/img/";

local am = require("lua.main");
local animalTypes = am.gAm_mn.types;
local defaultType = animalTypes[8];


-- own functions----
function gAm_man:check1()
-- first step to check for changes on the amount of animals

end;

----------------------------
-- functions needed by game
function gAm_man:loadMap(name)
	
end;

function gAm_man:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm_man:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm_man:updateTick(dt)

end;

function gAm_man:update(dt)

end;

function gAm_man:draw()

end;

function gAm_man:deleteMap(name)

end;

--------------------------------------------------

print ("AnimalMod.Manager loaded");
