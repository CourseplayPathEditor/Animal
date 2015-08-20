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

-- files -------
gAm.version = 0.5;
gAm.scriptName = "AnimalMod_Dev"; -- .xml to store and load info
gAm.vehicleName = "vehicles"; -- .xml to load animal info

-- savegame dir
gAm.savegamePath = getUserProfileAppPath() .. "savegame" .. g_careerScreen.selectedIndex;
gAm.savegameFilename = gAm.savegamePath .. "/" .. gAm.scriptName ..".xml";

-- configfile dir
gAm.saveConfPath = getUserProfileAppPath() .. "savegame" .. g_careerScreen.selectedIndex;
gAm.setConfFilename = gAm_a.savegamePath .. "/" ..gAm.scriptName .."_conf" ..".xml";
gAm.getConfigFileName = Utils.getFilename(gAm.scriptName .."_conf" ..".xml", gAm.XMLdir);
----------------
-- variables --
gAm.animalTypes = {};
gAm.animalFillTypes = {}; -- not in use now but setup for expansion to trailer and trigger classes.
gAm.animalStates = {};
gAm.animals = {}; -- main animal table
-- references for syncing 
gAm.farm = {}; -- reference to script data
gAm.game = {}; -- reference to player data

-- Stats to be saved & synced // only sync with gAm_mn.farm or gAm_mn.game
gAm_a.stats = {}; -- this table will hold all information, and will be used to save, draw, sync functions
gAm.confFound = false;
gAm.xmlFound = false;

-- Naming: used for random naming
gAm.maleNames = { -- Animal male naming
[1] = "WhiteTail",
[2] = "Spotty",
[3] = "Duster",
[4] = "Mika",
[5] = "Killer",
[6] = "Bill",
[7] = "Max",
[8] = "Jef",
[9] = "Blacky",
[10] = "Smoky"};

gAm.femaleNames = { -- Animal female naming
[1] = "WhiteSox",
[2] = "Bella",
[3] = "Didi",
[4] = "Mira",
[5] = "Kim",
[6] = "Ilona",
[7] = "Romy",
[8] = "Jesica",
[9] = "LadyD",
[10] = "Miranda"};
------
local count = 0;
---------------
function gAm:getFilesCallback(filename, configname)
	if (filename == gAm.scriptName ..".xml") then
		gAm.xmlFound = true;
	end;
	
	if (configname == gAm.scriptName .."_conf" ..".xml") then
		gAm.confFound = true;
	end;
end;
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
	
	-- checking for config --
	if() then
	-- if the configfile is missing stop the script from starting up
	return gAm = nil;
	end;
	-------------------------
end;

function gAm:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm:updateTick(dt)
	if (count == 1) then
		count = count + 1;
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
local animalTypes = am.gAm.mn.types;
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
