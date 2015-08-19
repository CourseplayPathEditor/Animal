--------------------------------------------------------
-- Author: Jengske_BE
-- Date: 18/08/2015
-- 
-- DO NOT MODIFY THIS FILE WITHOUT PERMISSION!!!
--------------------------------------------------------
gAm_a = {};
gAm_a_mt = Class(gAm_a);
InitObjectClass(gAm_a, "gAm_a");

addModEventListener(gAm_a);

local modItem = ModsUtil.findModItemByModName(g_currentModName);

gAm_a.MissionDir = g_currentMission;
gAm_a.LoadDir = g_currentModDirectory;

-- Load and save data information
-- LifeCycle xml naming
gAm_a.version = 0.5;
gAm_a.scriptName = "AnimalMod_Dev"; -- .xml to store and load info
gAm_a.vehicleName = "vehicles"; -- .xml to load animal info

-- savegame dir
gAm_a.savegamePath = getUserProfileAppPath() .. "savegame" .. g_careerScreen.selectedIndex;
gAm_a.savegameFilename = gAm_a.savegamePath .. "/" .. gAm_a.scriptName ..".xml";

-- configfile dir
gAm_a.configName = Utils.getFilename("/xml/" ..gAm_a.scriptName .."_conf" ..".xml", gAm_a.LoadDir);


-- script info
print ("---------------------------------------------------------------------------------------------------");
print(gAm_a.scriptName ..string.format(gAm_a.version));	
print("author: Jengske_BE");
print("Fs version: FS2015");
print("This livecycle script gives a aging System, health Sytem and breeding System")
print ("---------------------------------------------------------------------------------------------------");
---------------------------------------------------------------------
-- Script data
-- this data could not be modified
gAm_a.IsActive = true; -- enable/disable the script, default is enabled
gAm_a.deBug = true; -- enable/disable debugging, default is enabled
gAm_a.defaultMode = "production"; -- script modes: production, hobby, breeding
gAm_a.curMode = nil; -- monitor mode
gAm_a.modes = {[1] = "production", [2] = "hobby", [3] = "breeding"};
gAm_a.defaultState = "idle"; -- animal states: idle, breeding, sick, dead
gAm_a.curState = nil; -- monitor state
gAm_a.states = {[1] = "idle", [2] = "breeding", [3] = "sick", [4] = "dead"};
gAm_a.defaultGender = "female"; -- animal genders: male, female
gAm_a.genders = {[1] = "male", [2] = "female"};
gAm_a.fileFound = false;


-- Naming: used for random naming
gAm_a.maleNames = { -- Animal male naming
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

gAm_a.femaleNames = { -- Animal female naming
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

gAm_mn = {}; -- main script table

a = gAm_mn; -- using 'a' for shorten code
a.types = {[1] = "cow", [2] = "sheep", [3] = "chicken", [4] = "egg", [5] = "wool", [6] = "milk", [7] = "meat", [8] = "unknown"}; -- animals and products
-- these data need to be in a config file to be used at start
-- cow
a.minCowPool = 100; -- max cows you could own
a.medCowPool = 250; -- max cows you could own
a.maxCowPool = 500; -- max cows you could own
a.curCowPool = 250; -- set by config.xml
a.maxCowAge = 5; -- max age
a.cowBreedAge = 3; -- age before it could breed
a.maxCowBreedTime = 1; -- time we need to grow before it get born
a.cbPeriod = 60000; -- multiplier for breeding (time)
a.cbPeriodTime = 5; -- time in day's that the breeding period lest  
a.maxCowWeight = 500; -- max weight of healthy animal
a.minCowWeight = 15; -- min weight 
a.curCowWeight = 0; -- current weight
a.curCowPrice = 0; -- current price alive

-- sheep
a.minSheepPool = 100; -- max cows you could own
a.medSheepPool = 250; -- max cows you could own
a.maxSheepPool = 500; -- max cows you could own
a.curSheepPool = 250; -- set by config.xml
a.maxSheepAge = 5; -- max age
a.sheepBreedAge = 3; -- age before it could breed
a.maxSheepBreedTime = 1; -- time we need to grow before it get born
a.sbPeriod = 60000; -- multiplier for breeding (time)
a.sbPeriodTime = 5; -- time in day's that the breeding period lest  
a.maxSheepWeight = 500; -- max weight of healthy animal
a.minSheepWeight = 15; -- min weight 
a.curSheepWeight = 0; -- current weight
a.curSheepPrice = 0; -- current price alive

-- chicken
a.minChickenPool = 100; -- max cows you could own
a.medChickenPool = 250; -- max cows you could own
a.maxChickenPool = 500; -- max cows you could own
a.curChickenPool = 250; -- set by config.xml
a.maxChickenAge = 5; -- max age
a.chickenBreedAge = 3; -- age before it could breed
a.maxChickenBreedTime = 1; -- time we need to grow before it get born
a.chbPeriod = 60000; -- multiplier for breeding (time)
a.chbPeriodTime = 5; -- time in day's that the breeding period lest  
a.maxChickenWeight = 500; -- max weight of healthy animal
a.minChickenWeight = 15; -- min weight 
a.curChickenWeight = 0; -- current weight
a.curChickenPrice = 0; -- current price alive


-- table structures ------------------------------------------
-- pools
a.cowPool = {}; -- cowPool
a.sheepPool = {}; -- sheepPool
a.chickenPool = {}; -- ChickenPool
a.breedPool = {}; -- holding animals that are breeding

-- references for syncing 
a.farm = {}; -- reference to script data
a.game = {}; -- reference to player data

-- Stats to be saved & synced // only sync with gAm_mn.farm or gAm_mn.game
gAm_a.stats = {}; -- this table will hold all information, and will be used to save, draw, sync functions
-- player & sesion info
gAm_a.stats.money = 0; -- player money
gAm_a.stats.currentDay = 0; -- the current day
gAm_a.stats.currentTime = 0; -- the current time
-- animals --
gAm_a.stats.cowOwned = 0; -- anount of cows owned
gAm_a.stats.sheepOwned = 0; -- anount of sheeps owned
gAm_a.stats.chickenOwned = 0; -- anount of chickens owned
-- breeding --
gAm_a.stats.breedStats = {}; -- table to hold breeding information
gAm_a.stats.breedStats.totalNumBreeds = 0; -- counter to count total number of animals you have breed
gAm_a.stats.breedStats.cowInBreed = 0; -- amount of cows currently breeding
gAm_a.stats.breedStats.sheepInBreed = 0; -- amount of sheep currently breeding
gAm_a.stats.breedStats.chickenInBreed = 0; -- amount of chicken currently breeding
-- feeding --
gAm_a.stats.feeding = {}; -- table to hold feeding status
gAm_a.stats.feeding.types = {}; -- hold the feeding info
gAm_a.stats.feeding.types.grass = {};
gAm_a.stats.feeding.types.grass.fillLevelCow = 0;
gAm_a.stats.feeding.types.grass.fillLevelSheep = 0;
gAm_a.stats.feeding.types.grass.fillLevelChicken = 0;
gAm_a.stats.feeding.types.wheat = {};
gAm_a.stats.feeding.types.wheat.fillLevelCow = 0;
gAm_a.stats.feeding.types.wheat.fillLevelSheep = 0;
gAm_a.stats.feeding.types.wheat.fillLevelChicken = 0;
-- add more types ---

-----------------------------------------------------------------
-- local variables --------
-- enable or disable breeding --
local isCowBreed = false; -- enable or disable cow breeding, default is off
local isSheepBreed = false; -- enable or disable cow breeding, default is off
local isChickenBreed = false; -- enable or disable cow breeding, default is off
local cowCheck = 0;
local sheepCheck = 0;
local chickenCheck = 0;
-- timers to do our checking
local day = 0;
local curDay = 0;
local dTime = 0;
local curTime = 0;
local cowTime = 0;
local sheepTime = 0;
local chickenTime = 0;
local eggTime = 0;
local syncTime = 0;
-- multipliers
-- todo
-- price per kilo
local cowKg = 5; 
local sheepKg = 3.5;
local chickenKg = 0.5;

function gAm_a:getPrice(animalType, weight) -- useage: gAm_a:getPrice("cow", gAm_mn.curCowWeight), gAm_a:getPrice("sheep", gAm_mn.curSheepWeight), gAm_a:getPrice("chicken", gAm_mn.curChickenWeight)
local animal = animalType;
local kg = weight;
local price = 0;
	if(animalType == "cow") then
		price = kg * cowKg;
	elseif(animalType == "sheep") then
		price = kg * sheepKg;
	elseif(animalType == "chicken") then
		price = kg * chickenKg;
	else
	return;
	end;
	print("price is ", price);
	return price;
end;
---------------------------
-- debugging our script -------------------
function gAm_a:debugging()
	a = gAm_mn;
	if (a == nil) then
	print ("gAm_mn does not exist");
	else
	print ("gAm_mn is ready");
		for k, v in pairs (gAm_a) do
		print("gAm_a: ",k, " = ", v);
		end;
		
		for k, v in pairs (gAm_mn) do
		print("gAm_mn: ",k, " = ", v);
		end;
		
		for k, v in pairs (gAm_mn.cowPool) do
			for kk, vv in pairs (v) do
				print("cowPool: ", kk, " = ", vv);
			end;
		
		end;
		print ("--------------pools-------------------");
		print ("cow: ", string.format(#gAm_mn.cowPool));
		print ("sheep: ", string.format(#gAm_mn.sheepPool));
		print ("chicken: ", string.format(#gAm_mn.chickenPool));
		print ("---------------------------------");
	end;
	
	
end;
--------------------------------------------
-- these functions run only once at startup ---
function gAm_a:SetCowPool()
local a = gAm_mn.cowPool;
local pool = gAm_mn.curCowPool;
	for i = 1, pool do
	-- insert the amount of cows
	table.insert( a, i, {
	id = "COW" ..i,
	name = "",
	aType = "cow",
	age = 0,
	breedAge = 0,
	maxAge = 0,
	weight = 0,
	health = 100,
	isSick = false,
	isAlive = false,
	gender = "",
	isBreedReady = false,
	isBreeding = false,
	startBreeding = nil,
	endBreeding = nil,
	certificate = 0,
	isActive = false,
	forMeat = false,
	forWool = false,
	forMilk = false,
	forEggs = false,
	ancestry = ""
	});
	
	end;
end;

function gAm_a:SetSheepPool()
local a = gAm_mn.sheepPool;
local pool = gAm_mn.curSheepPool;
	for i = 1, pool do
	-- insert the amount of sheeps
	table.insert( a, i, {
	id = "SHEEP" ..i,
	name = "",
	aType = "sheep",
	age = 0,
	breedAge = 0,
	maxAge = 0,
	weight = 0,
	health = 100,
	isSick = false,
	isAlive = false,
	gender = "",
	isBreedReady = false,
	isBreeding = false,
	startBreeding = nil,
	endBreeding = nil,
	certificate = 0,
	isActive = false,
	forMeat = false,
	forWool = false,
	forMilk = false,
	forEggs = false,
	ancestry = ""
	});
	end;
end;

function gAm_a:SetChickenPool()
local a = gAm_mn.chickenPool;
local pool = gAm_mn.curChickenPool;
	for i = 1, pool do
	-- insert the amount of chicken
	table.insert( a, i, {
	id = "CHICKEN" ..i,
	name = "",
	aType = "chicken",
	age = 0,
	breedAge = 0,
	maxAge = 0,
	weight = 0,
	health = 100,
	isSick = false,
	isAlive = false,
	gender = "",
	isBreedReady = false,
	isBreeding = false,
	startBreeding = nil,
	endBreeding = nil,
	certificate = 0,
	isActive = false,
	forMeat = false,
	forWool = false,
	forMilk = false,
	forEggs = false,
	ancestry = ""
	});
	end;
end;

function gAm_a:SetFarm()
local pool = gAm_mn.farm;

pool.cowOwned = 0;
pool.sheepOwned = 0;
pool.chickenOwned = 0;
pool.eggOwned = 0;
pool.totalNumSick = 0;
pool.totalNumBreed = 0;


end;

function gAm_a:SetGame()
local pool = gAm_mn.game;
end;

-- save and load data -----
function gAm_a:getFilesCallback(filename)
	if filename == gAm_a.scriptName ..".xml" then
		gAm_a.fileFound = true;
	end;
    
end;

function gAm_a:saveData()
print("saving data");
local rootTag = "test";
local xmlFile = createXMLFile(rootTag, gAm_a.savegameFilename, rootTag);

	if (xmlFile ~= nil) then
	
        setXMLString( xmlFile, rootTag, gAm_a.scriptName);
		setXMLString( xmlFile, rootTag, gAm_a.scriptName .."#author", "Jengske_BE");
        --
		--local am = gAm_mn;
        txt1 = "--AnimalMod SaveGameFile, created when saving your session--";
        txt2 = "--Use the AnimalMod.xml from inside the mod.zip to change settings.--";
        txt3 = "--In this section you change the value used during your gamplay--";
        local tag = "Info";
        setXMLString(xmlFile, tag, txt1);
        local tag = "modInfo";
        setXMLString(xmlFile, tag.."#test2", txt2);
       
        --
    end;
        saveXMLFile(xmlFile);
        print(gAm_a.scriptName ..".xml saved");
        delete(xmlFile);
end;

function gAm_a:loadData()

end;

local CareerScreenSaveSelectedGame = CareerScreen.saveSelectedGame; -- add Save Callback

CareerScreen.saveSelectedGame = function(self)
	if (gAm_a.deBug == true) then
		print("gAm_a - DEBUG - Save Callback");
	end;
	CareerScreenSaveSelectedGame(self);
    
	
    gAm_a:saveData();
    
end; 

---------------------------

function gAm_a:setName(gender)
	local g = gender;
	if(g == "male")then
	return gAm_a.maleNames[math.random(1, #gAm_a.maleNames)];
	end;
	if(g =="female") then
	return gAm_a.femaleNames[math.random(1, #gAm_a.femaleNames)];
	end;
end;

-- functions needed by game
function gAm_a:loadMap(name)
	gAm_a:SetCowPool();
	gAm_a:SetSheepPool();
	gAm_a:SetChickenPool();
	gAm_a:debugging();
	gAm_a:saveData();
end;

function gAm_a:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm_a:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm_a:updateTick(dt)

end;

function gAm_a:update(dt)

end;

function gAm_a:draw()

end;

function gAm_a:deleteMap(name)

end;

--------------------------------------------------
print ("AnimalMod.Main loaded");
