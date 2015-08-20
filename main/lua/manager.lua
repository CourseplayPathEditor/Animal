--------------------------------------------------------
-- Author: Jengske_BE
-- Date: 18/08/2015
-- 
-- DO NOT MODIFY THIS FILE WITHOUT PERMISSION!!!
--------------------------------------------------------
-- main script tableStructure subclasses wil start like gAm."_class", "gAm._man"
gAm = {};
gAm_mt = Class(gAm);
InitObjectClass(gAm, "gAm");

local modItem = ModsUtil.findModItemByModName(g_currentModName);
-- directories --
gAm.MissionDir = g_currentMission;
gAm.LoadDir = g_currentModDirectory;
gAm.XMLdir = g_currentModDirectory .."/xml/";
gAm.LUAdir = g_currentModDirectory .."/lua/";
gAm.IMGdir = g_currentModDirectory .."/img/";
--gAm.GUIdir = g_currentModDirectory .."/gui/";
----------------
-- variables --
gAm.animalTypes = {};
gAm.animalStates = {};
local count = 0;
---------------
----------------------------
-- functions needed by game
function gAm:loadMap(name)
	for k, v in pairs (gAm) do
		print ("-- manager.lua: gAm output --");
		print ("-----------------------------");
		print("output: " ..k .." = " ..v);
		print ("-----------------------------");
		count = count + 1;
	end;
end;

function gAm:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm:updateTick(dt)
	if (count == 1) then
		for k, v in pairs (gAm) do
			print ("-- manager.lua: gAm output --");
			print ("-----------------------------");
			print("output2: " ..k .." = " ..v);
			print ("-----------------------------");
		end;	
	
	end;
end;

function gAm:update(dt)

end;

function gAm:draw()

end;

function gAm:deleteMap(name)

end;

--------------------------------------------------
print ("AnimalMod main structure set");
addModEventListener(gAm);
----------------------------------------------------------------------------------------------------------------------
--******************************************************************************************************--------------
----------------------------------------------------------------------------------------------------------------------
-- Manager --
-------------
gAm._man = {};
gAm._man_mt = Class(gAm._man);
InitObjectClass(gAm._man, "gAm._man");

local modItem = ModsUtil.findModItemByModName(g_currentModName);


local am = require("lua.main");
local animalTypes = am.gAm_mn.types;
local defaultType = animalTypes[8];


-- own functions----
function gAm._man:check1()
-- first step to check for changes on the amount of animals

end;

----------------------------
-- functions needed by game
function gAm._man:loadMap(name)
	
end;

function gAm._man:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm._man:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm._man:updateTick(dt)

end;

function gAm._man:update(dt)

end;

function gAm._man:draw()

end;

function gAm._man:deleteMap(name)

end;

--------------------------------------------------

print ("AnimalMod.Manager loaded");
addModEventListener(gAm._man);
