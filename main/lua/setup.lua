
-- Script data
-- this data could not be modified
gAm.IsActive = true; -- enable/disable the script, default is enabled
gAm.deBug = true; -- enable/disable debugging, default is enabled
gAm.defaultMode = "production"; -- script modes: production, hobby, breeding
gAm.curMode = nil; -- monitor mode
gAm.modes = {[1] = "production", [2] = "hobby", [3] = "breeding"};
gAm.defaultState = "idle"; -- animal states: idle, breeding, sick, dead
gAm.curState = nil; -- monitor state
gAm.defaultGender = "female"; -- animal genders: male, female
gAm.genders = {[1] = "male", [2] = "female"};
gAm.fileFound = false;
gAm.ancestry = {[1] = "store", [2] = "farm"};

local a = gAm.animals; -- using 'a' for shorten code
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
a.minSheepPool = 50; -- max cows you could own
a.medSheepPool = 250; -- max cows you could own
a.maxSheepPool = 500; -- max cows you could own
a.curSheepPool = 250; -- set by config.xml
a.maxSheepAge = 5; -- max age
a.sheepBreedAge = 3; -- age before it could breed
a.maxSheepBreedTime = 1; -- time we need to grow before it get born
a.sbPeriod = 60000; -- multiplier for breeding (time)
a.sbPeriodTime = 5; -- time in day's that the breeding period lest  
a.maxSheepWeight = 100; -- max weight of healthy animal
a.minSheepWeight = 15; -- min weight 
a.curSheepWeight = 0; -- current weight
a.curSheepPrice = 0; -- current price alive

-- chicken
a.minChickenPool = 10; -- max cows you could own
a.medChickenPool = 750; -- max cows you could own
a.maxChickenPool = 1500; -- max cows you could own
a.curChickenPool = 10; -- set by config.xml
a.maxChickenAge = 5; -- max age
a.chickenBreedAge = 3; -- age before it could breed
a.maxChickenBreedTime = 1; -- time we need to grow before it get born
a.chbPeriod = 60000; -- multiplier for breeding (time)
a.chbPeriodTime = 5; -- time in day's that the breeding period lest  
a.maxChickenWeight = 4; -- max weight of healthy animal
a.minChickenWeight = 1; -- min weight 
a.curChickenWeight = 0; -- current weight
a.curChickenPrice = 0; -- current price alive


-- table structures ------------------------------------------
-- pools
a.cowPool = {}; -- cowPool
a.sheepPool = {}; -- sheepPool
a.chickenPool = {}; -- ChickenPool
a.breedPool = {}; -- holding animals that are breeding
a.eggPool = {}; -- holding the eggs
a.sickPool = {}; -- holding the sick animals

-- references for syncing 
gAm.farm = {}; -- reference to script data
gAm.game = {}; -- reference to player data

-- Stats to be saved & synced // only sync with gAm_mn.farm or gAm_mn.game
gAm.stats = {}; -- this table will hold all information, and will be used to save, draw, sync functions
-- player & sesion info
gAm.stats.money = 0; -- player money
gAm.stats.currentDay = 0; -- the current day
gAm.stats.currentTime = 0; -- the current time
-- animals --
gAm.stats.cowOwned = 0; -- anount of cows owned
gAm.stats.sheepOwned = 0; -- anount of sheeps owned
gAm.stats.chickenOwned = 0; -- anount of chickens owned
-- breeding --
gAm.stats.breedStats = {}; -- table to hold breeding information
gAm.stats.breedStats.totalNumBreeds = 0; -- counter to count total number of animals you have breed
gAm.stats.breedStats.cowInBreed = 0; -- amount of cows currently breeding
gAm.stats.breedStats.sheepInBreed = 0; -- amount of sheep currently breeding
gAm.stats.breedStats.chickenInBreed = 0; -- amount of chicken currently breeding
-- feeding --
gAm.stats.feeding = {}; -- table to hold feeding status
gAm.stats.feeding.types = {}; -- hold the feeding info
gAm.stats.feeding.types.grass = {};
gAm.stats.feeding.types.grass.fillLevelCow = 0;
gAm.stats.feeding.types.grass.fillLevelSheep = 0;
gAm.stats.feeding.types.grass.fillLevelChicken = 0;
gAm.stats.feeding.types.wheat = {};
gAm.stats.feeding.types.wheat.fillLevelCow = 0;
gAm.stats.feeding.types.wheat.fillLevelSheep = 0;
gAm.stats.feeding.types.wheat.fillLevelChicken = 0;
-- add more types ---

-----------------------------------------------------------------

-- local variables --------
-- enable or disable breeding --
local isCowBreed = true; -- enable or disable cow breeding, default is off
local isSheepBreed = true; -- enable or disable cow breeding, default is off
local isChickenBreed = true; -- enable or disable cow breeding, default is off
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

function gAm:getPrice(animalType, weight) -- useage: gAm:getPrice("cow", gAm_mn.curCowWeight), gAm:getPrice("sheep", gAm_mn.curSheepWeight), gAm:getPrice("chicken", gAm_mn.curChickenWeight)
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
function gAm:debugging()
	if (gAm.deBug == true) then
		a = gAm;
		if (a == nil) then
		print ("gAm does not exist");
		else
		print ("gAm is ready");
			for k, v in pairs (gAm) do
			print("gAm: ",k, " = ", v);
			end;
			
			for k, v in pairs (gAm.animals) do
			print("gAm.animals: ",k, " = ", v);
			end;
			
			for k, v in pairs (gAm.animals.cowPool) do
				for kk, vv in pairs (v) do
					print("cowPool: ", kk, " = ", vv);
				end;
			
			end;
			print ("--------------pools-------------------");
			print ("cow: ", string.format(#gAm.animals.cowPool));
			print ("sheep: ", string.format(#gAm.animals.sheepPool));
			print ("chicken: ", string.format(#gAm.animals.chickenPool));
			print ("---------------------------------");
		end;
	end;
	
end;
--------------------------------------------
-- these functions run only once at startup ---
function gAm:SetCowPool()
local a = gAm.animals.cowPool;
local pool = gAm.animals.curCowPool;
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
	print ("setCowPool");
end;

function gAm:SetSheepPool()
local a = gAm.animals.sheepPool;
local pool = gAm.animals.curSheepPool;
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
	print ("setSheepPool");
end;

function gAm:SetChickenPool()
local a = gAm.animals.chickenPool;
local pool = gAm.animals.curChickenPool;
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
	print ("setChickenPool");
end;

function gAm:SetFarm()
local pool = gAm.farm;

pool.cowOwned = 0;
pool.sheepOwned = 0;
pool.chickenOwned = 0;
pool.eggOwned = 0;
pool.totalNumSick = 0;
pool.totalNumBreed = 0;


end;

function gAm:SetGame()
local pool = gAm.game;
pool.cowOwned = 0;
pool.sheepOwned = 0;
pool.chickenOwned = 0;
pool.eggOwned = 0;
end;

function gAm:setName(gender)
	local g = gender;
	if(g == "male")then
	return gAm.maleNames[math.random(1, #gAm.maleNames)];
	end;
	if(g =="female") then
	return gAm.femaleNames[math.random(1, #gAm.femaleNames)];
	end;
end;

function gAm:setup()
	gAm:SetCowPool();
	gAm:SetSheepPool();
	gAm:SetChickenPool();
	gAm:SetFarm();
	gAm:SetGame();
	
end;