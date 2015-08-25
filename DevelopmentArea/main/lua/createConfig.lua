-- create the config file //this function need to be deleted once the script is beta version

-- todo: make this the settings.xml that holds all script parameters
-- activations
-- pools
-- age
-- breed
function gAm:createSettings()
-- tags --
-- main
local rootTag = gAm.scriptName;
-- activations
local activateTag = rootTag ..".activations";
local activateTagScript = rootTag ..".activations.script";
local activateTagDebug = rootTag ..".activations.debug";
local activateTagMode = rootTag ..".activations.mode";
-- pools
local poolTag = rootTag ..".pools";
local poolTagCow = rootTag ..".pools.cow";
local poolTagSheep = rootTag ..".pools.sheep";
local poolTagChicken = rootTag ..".pools.chicken";
-- aging
local ageTag = rootTag ..".aging";
local ageTagCow = rootTag ..".aging.cow";
local ageTagSheep = rootTag ..".aging.sheep";
local ageTagChicken = rootTag ..".aging.chicken";
-- breeding
local breedTag = rootTag ..".breeding";
local breedTagCow = rootTag ..".breeding.cow";
local breedTagSheep = rootTag ..".breeding.sheep";
local breedTagChicken = rootTag ..".breeding.chicken";
-- health
local healthTag = rootTag ..".health";
-- timerTags --
local timersTag = rootTag ..".timer";
-- timers g_currentMission.environment.currentDay
local dayTag = rootTag ..".timer.day";
-- timers g_currentMission.time
local timeTag = rootTag ..".timer.time";
local globalTag = rootTag ..".general";

-- add more later

----
local xmlFile = createXMLFile("Settings", gAm.setConfFilename, rootTag);

local am = gAm;
local animals = gAm.animals;
	if (xmlFile ~= nil) then
	-- author info ---
	setXMLString(xmlFile, rootTag ..".Author", "jengske_BE");
	setXMLString(xmlFile, rootTag ..".Date", "18/08/2015");
	setXMLString(xmlFile, rootTag ..".Copyright", "jengske_BE");
	-- activations --
	setXMLBool(xmlFile, activateTagScript .."#scriptActive", am.IsActive);
	setXMLBool(xmlFile, activateTagScript .."#isCowBreed", isCowBreed);
	setXMLBool(xmlFile, activateTagScript .."#isSheepBreed", isSheepBreed);
	setXMLBool(xmlFile, activateTagScript .."#isChickenBreed", isChickenBreed);
	setXMLBool(xmlFile, activateTagDebug .."#deBugOn/Off", am.deBug);
	setXMLString(xmlFile, activateTagMode .."#defaultMode", am.defaultMode);
	
	-- pools 
	-- poolTagCow
	setXMLInt(xmlFile, poolTagCow .."#minCowPool", animals.minCowPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagCow .."#medCowPool", animals.medCowPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagCow .."#maxCowPool", animals.maxCowPool); -- max cows you could own
	--setXMLInt(xmlFile, poolTagCow .."#curCowPool", a.curCowPool); -- set by config.xml
	-- poolTagSheep
	setXMLInt(xmlFile, poolTagSheep .."#minSheepPool", animals.minSheepPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagSheep .."#medSheepPool", animals.medSheepPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagSheep .."#maxSheepPool", animals.maxSheepPool); -- max cows you could own
	--setXMLInt(xmlFile, tag .."#curSheepPool", a.curSheepPool); -- set by config.xml
	-- poolTagChicken
	setXMLInt(xmlFile, poolTagChicken .."#minChickenPool", animals.minChickenPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagChicken .."#medChickenPool", animals.medChickenpPool); -- max cows you could own
	setXMLInt(xmlFile, poolTagChicken .."#maxChickenPool", animals.maxChickenPool); -- max cows you could own
	--setXMLInt(xmlFile, tag .."#curChickenPool", a.curChickenPool); -- set by config.xml
	-- price
	setXMLInt(xmlFile, poolTagCow ..".price#curCowPrice", animals.curCowPrice); -- current price alive
	setXMLInt(xmlFile, poolTagSheep ..".price#curSheepPrice", animals.curSheepPrice); -- current price alive
	setXMLInt(xmlFile, poolTagChicken ..".price#curChickenPrice", animals.curChickenPrice); -- current price alive
	-- breeding		
	setXMLInt(xmlFile, breedTagCow .."#maxCowBreedTime", animals.maxCowBreedTime); -- time we need to grow before it get born
	setXMLInt(xmlFile, breedTagSheep .."#maxSheepBreedTime", animals.maxSheepBreedTime); -- time we need to grow before it get born
	setXMLInt(xmlFile, breedTagChicken .."#maxChickenBreedTime", animals.maxChickenBreedTime); -- time we need to grow before it get born
			
	-- breed timers
	setXMLInt(xmlFile, breedTagCow .."#cbPeriod", animals.cbPeriod ); -- multiplier for breeding (time)
	setXMLInt(xmlFile, breedTagCow .."#cbPeriodTime", animals.cbPeriodTime); -- time in day's that the breeding period lest  
	setXMLInt(xmlFile, breedTagSheep .."#sbPeriod", animals.sbPeriod ); -- multiplier for breeding (time)
	setXMLInt(xmlFile, breedTagSheep .."#sbPeriodTime", animals.sbPeriodTime); -- time in day's that the breeding period lest  
	setXMLInt(xmlFile, breedTagChicken .."#sbPeriod", animals.sbPeriod ); -- multiplier for breeding (time)
	setXMLInt(xmlFile, breedTagChicken .."#sbPeriodTime", animals.sbPeriodTime); -- time in day's that the breeding period lest  
			
	-- weights		
	setXMLInt(xmlFile, breedTagCow .."#maxCowWeight", animals.maxCowWeight); -- max weight of healthy animal
	setXMLInt(xmlFile, breedTagCow .."#minCowWeight", animals.minCowWeight); -- min weight 
	setXMLInt(xmlFile, breedTagCow .."#curCowWeight", animals.curCowWeight); -- current weight
	setXMLInt(xmlFile, breedTagSheep .."#maxSheepWeight", animals.maxSheepWeight); -- max weight of healthy animal
	setXMLInt(xmlFile, breedTagSheep .."#minSheepWeight", animals.minSheepWeight); -- min weight 
	setXMLInt(xmlFile, breedTagSheep .."#curSheepWeight", animals.curSheepWeight); -- current weight
	setXMLInt(xmlFile, breedTagChicken .."#maxChickenWeight", animals.maxChickenWeight); -- max weight of healthy animal
	setXMLInt(xmlFile, breedTagChicken .."#minChickenWeight", animals.minChickenWeight); -- min weight 
	setXMLInt(xmlFile, breedTagChicken .."#curChickenWeight", animals.curChickenWeight); -- current weight
	
	-- aging --
	setXMLInt(xmlFile, ageTagCow .."#maxCowAge", animals.maxCowAge); -- max age
	setXMLInt(xmlFile, ageTagCow .."#cowBreedAge", animals.cowBreedAge); -- age before it could breed
	setXMLInt(xmlFile, ageTagSheep .."#maxSheepAge", animals.maxSheepAge); -- max age
	setXMLInt(xmlFile, ageTagSheep .."#sheepBreedAge", animals.sheepBreedAge); -- age before it could breed
	setXMLInt(xmlFile, ageTagChicken .."#maxChickenAge", animals.maxChickenAge); -- max age
	setXMLInt(xmlFile, ageTagChicken .."#chickenBreedAge", animals.chickenBreedAge); -- age before it could breed
	
	-- W i P --
	-- these variables need to be added in setup.lua then uncomment them here.
	-- health --
	setXMLInt(xmlFile, healthTag .."#maxHealth", animals.maxHealth); -- max health
	setXMLInt(xmlFile, healthTag .."#maxHealth", animals.medHealth); -- med health
	setXMLInt(xmlFile, healthTag .."#maxHealth", animals.minHealth); -- min health
	
	-- timers
	--day--
	setXMLInt(xmlFile, dayTag .."#startDay", am.startDay); -- start day = 0 = g_currentMission.environment.currentDay
	--time--
	setXMLInt(xmlFile, timeTag .."#startTime", am.startTime); -- startTime = 0 = g_currentMission.time
	
	-- global settings
	setXMLBool(xmlFile, globalTag ..".runTime#firstTimeRun", am.firstTimeRun); -- false
	setXMLBool(xmlFile, globalTag ..".checkers#isCowCheck", am.isCowCheck); -- false
	setXMLBool(xmlFile, globalTag ..".checkers#isSheepCheck", am.isSheepCheck);
	setXMLBool(xmlFile, globalTag ..".checkers#isChickenCheck", am.isChickenCheck);
	end;
	
	saveXMLFile(xmlFile);
	print("development fase: " ..gAm.setConfFilename .." saved");
	delete(xmlFile);
end;

local CareerScreenSaveSelectedGame = CareerScreen.saveSelectedGame; -- add Save Callback

CareerScreen.saveSelectedGame = function(self)
	if (gAm.deBug == true) then
		print("gAm_a - DEBUG - Save Callback");
	end;
	CareerScreenSaveSelectedGame(self);
    
	
    gAm:createSettings();
end; 

print ("AnimalMod.createConfig loaded");
