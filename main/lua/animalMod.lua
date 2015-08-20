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
gAm.XMLdir = g_currentModDirectory .."xml/";
gAm.LUAdir = g_currentModDirectory .."lua/";
gAm.IMGdir = g_currentModDirectory .."img/";
--gAm.GUIdir = g_currentModDirectory .."gui/";

-- inspired by courseplay.lua
gAm.path = g_currentModDirectory;
if gAm.path:sub(-1) ~= '/' then
	gAm.path = gAm.path .. '/';
end;


-- place sub-classes here in order to get an overview of the contents, subclasses wil start like gAm."_class", "gAm._man"
-------------------
gAm._man = {};
gAm._breed = {};
gAm.Utils = {};
-- files -------
gAm.version = 0.5;
gAm.scriptName = "AnimalMod_Dev"; -- .xml to store and load info
gAm.vehicleName = "vehicles"; -- .xml to load animal info

-- savegame dir
gAm.savegamePath = getUserProfileAppPath() .. "savegame" .. g_careerScreen.selectedIndex;
gAm.savegameFilename = gAm.savegamePath .. "/" .. gAm.scriptName ..".xml";

-- configfile dir
gAm.saveConfPath = getUserProfileAppPath() .. "savegame" .. g_careerScreen.selectedIndex;
gAm.setConfFilename = gAm.savegamePath .. "/" ..gAm.scriptName .."_conf" ..".xml";
gAm.getConfigFileName = Utils.getFilename(gAm.scriptName .."_conf" ..".xml", gAm.XMLdir);
----------------
-- variables --
gAm.animalTypes = {[1] = "cow", [2] = "sheep", [3] = "chicken"};
gAm.animalFillTypes = {[1] = "cow", [2] = "sheep", [3] = "chicken"}; -- not in use now but setup for expansion to trailer and trigger classes.
gAm.animalStates = {[1] = "idle", [2] = "breeding", [3] = "sick", [4] = "dead"}; -- animal states
gAm.animals = {}; -- main animal table
gAm.totalNumCows = 0;
gAm.totalNumSheep = 0;
gAm.totalNumChicken = 0;
-- references for syncing 
gAm.farm = {}; -- reference to script data
gAm.game = {}; -- reference to player data

-- Stats to be saved & synced // only sync with gAm_mn.farm or gAm_mn.game
gAm.stats = {}; -- this table will hold all information, and will be used to save, draw, sync functions
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
gAm.count = 0;
---------------
-- script info ---
print ("------------------------------ AnimalMod ---------------------------------------------------------------------");
print(gAm.scriptName .."_V" ..string.format(gAm.version));	
print("author: Jengske_BE");
print("Fs version: FS2015");
print("This livecycle script gives a aging System, health Sytem and breeding System")
print ("---------------------------------------------------------------------------------------------------");
---------------------------------------------------------------------
function gAm:getFilesCallback(filename, configname)
	if (filename == gAm.scriptName ..".xml") then
		gAm.xmlFound = true;
	end;
	
	if (configname == gAm.scriptName .."_conf" ..".xml") then
		gAm.confFound = true;
	end;
end;
----------------------------
local filePath = gAm.path .. 'lua/manager.lua';
assert(fileExists(filePath), ('ANIMALMOD ERROR: "manager.lua" can\'t be found at %q'):format(filePath));
source(filePath);
-------------------
local function initialize()
--function gAm:initialize()
	local fileList = {
		'createConfig',
		'setup',
		'datasync',
		'loadData',
		'saveData',
		'debugging',
		'breed'
	};

	local numFiles, numFilesLoaded = #(fileList) + 2, 2; -- + 2 as 'animalMod.lua' and 'manager.lua' have already been loaded
	for _,file in ipairs(fileList) do
		local filePath = gAm.LUAdir .. file .. '.lua';
		assert(fileExists(filePath), '\tANIMALMOD ERROR: could not load file ' .. filePath);
		source(filePath);
		print('\t### AnimalMod: ' .. filePath .. ' has been loaded');
		numFilesLoaded = numFilesLoaded + 1;
	end;

	print(('### AnimalMod: initialized %d/%d files (v%s)'):format(numFilesLoaded, numFiles, gAm.version));
end;

initialize();
-----------------------------
-- functions needed by game
function gAm:loadMap(name)

	-- print ("-- manager.lua: gAm output --");
	-- print ("-----------------------------");
	-- gAm.count = gAm.count + 1;
	-- for k, v in pairs (gAm) do
		
		-- if (type(v) == "string") then
		-- print("output: " ..k .." = " ..string.format(v));
		-- elseif(type(v) == "table") then
		-- print("output: " ..k .." = " ..type(v));
		-- end;
		
		
	-- end;
	-- print ("-------------" ..gAm.count .."----------------");
	-- checking for config --
	-- if() then
	-- if the configfile is missing stop the script from starting up
	-- return gAm = nil;
	-- end;
	-------------------------
end;

function gAm:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm:updateTick(dt)
	
end;

function gAm:update(dt)
	-- if (gAm.count == 1) then
		-- print ("-- manager.lua: gAm output --");
		-- print ("-----------------------------");
		-- gAm.count = gAm.count + 1;
			-- for k, v in pairs (gAm) do
				
				-- if (type(v) == "string") then
				-- print("output: " ..k .." = " ..string.format(v));
				-- elseif(type(v) == "table") then
					-- for kk, vv in pairs(v)do
						-- if (type(vv) == "string") then
						-- print("output: " ..k ..": " ..kk .." = " ..vv);
						-- elseif(type(vv) == "table") then
							-- for kk2, vvv in pairs(vv)do
								-- if (type(vvv) == "string") then
								-- print("output: " ..k ..": " ..kk ..kk2 .." = " ..vvv);
								-- else
								-- print (type(vvv));
								-- end;
							-- end;
						-- end;
					-- end;
				-- end;
				
				
			-- end;
		-- print ("-------------" ..gAm.count .."----------------");
	
	-- end;
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