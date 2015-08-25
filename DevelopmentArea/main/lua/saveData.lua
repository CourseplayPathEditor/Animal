function gAm:saveData()
print("saving data");
local rootTag = gAm.scriptName;
local xmlFile = createXMLFile("animalMod", gAm.savegameFilename, rootTag);

	if (xmlFile ~= nil) then
		-- info --
        setXMLString(xmlFile, rootTag ..".Author", "jengske_BE");
		setXMLString(xmlFile, rootTag ..".Date", "18/08/2015");
		setXMLString(xmlFile, rootTag ..".Copyright", "jengske_BE");
        --
		-- user messages // need to be modified or deleted
        txt1 = "modify this section to suit your needs.";
        txt2 = "DO NOT MODIFY";
       -- txt3 = "2";
		-- configuration
		local a = gAm.animals;
		local tag = rootTag ..".Info1";
		setXMLString(xmlFile, tag, txt1);
		local tag = rootTag ..".Conf";
		local tag = rootTag ..".Conf.section1";
		setXMLBool(xmlFile, tag .."#scriptActive", gAm.IsActive);
		setXMLBool(xmlFile, tag .."#deBug", gAm.deBug);
		setXMLString(xmlFile, tag .."#defaultMode", gAm.defaultMode);
		--setXMLString(xmlFile, tag .."#isCowBreed", isCowBreed);
		--setXMLString(xmlFile, tag .."#defaultMode", gAm.defaultMode);
		--setXMLString(xmlFile, tag .."#defaultMode", gAm.defaultMode);
		
		--
		
		local tag = rootTag ..".Conf.section2";
		-- cow
		--setXMLInt(xmlFile, tag ..".pool#minCowPool", gAm.animals.minCowPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#medCowPool", a.medCowPool); -- max cows you could own
		setXMLInt(xmlFile, tag ..".pool#maxCowPool", a.maxCowPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#curCowPool", a.curCowPool); -- set by config.xml
		setXMLInt(xmlFile, tag ..".age#maxCowAge", a.maxCowAge); -- max age
		setXMLInt(xmlFile, tag ..".age#cowBreedAge", a.cowBreedAge); -- age before it could breed
		setXMLInt(xmlFile, tag ..".breed#maxCowBreedTime", a.maxCowBreedTime); -- time we need to grow before it get born
		setXMLInt(xmlFile, tag ..".breed#cbPeriod", a.cbPeriod ); -- multiplier for breeding (time)
		setXMLInt(xmlFile, tag ..".breed#cbPeriodTime", a.cbPeriodTime); -- time in day's that the breeding period lest  
		setXMLInt(xmlFile, tag ..".weight#maxCowWeight", a.maxCowWeight); -- max weight of healthy animal
		setXMLInt(xmlFile, tag ..".weight#minCowWeight", a.minCowWeight); -- min weight 
		--setXMLInt(xmlFile, tag ..".weight#curCowWeight", a.curCowWeight); -- current weight
		--setXMLInt(xmlFile, tag ..".price#curCowPrice", a.curCowPrice); -- current price alive
		--
		local tag = rootTag ..".Conf.section3";
		-- sheep
		--setXMLInt(xmlFile, tag ..".pool#minSheepPool", gAm.animals.minSheepPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#medSheepPool", a.medSheepPool); -- max cows you could own
		setXMLInt(xmlFile, tag ..".pool#maxSheepPool", a.maxSheepPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#curSheepPool", a.curSheepPool); -- set by config.xml
		setXMLInt(xmlFile, tag ..".age#maxSheepAge", a.maxSheepAge); -- max age
		setXMLInt(xmlFile, tag ..".age#sheepBreedAge", a.sheepBreedAge); -- age before it could breed
		setXMLInt(xmlFile, tag ..".breed#maxSheepBreedTime", a.maxSheepBreedTime); -- time we need to grow before it get born
		setXMLInt(xmlFile, tag ..".breed#sbPeriod", a.sbPeriod ); -- multiplier for breeding (time)
		setXMLInt(xmlFile, tag ..".breed#sbPeriodTime", a.sbPeriodTime); -- time in day's that the breeding period lest  
		setXMLInt(xmlFile, tag ..".weight#maxSheepWeight", a.maxSheepWeight); -- max weight of healthy animal
		setXMLInt(xmlFile, tag ..".weight#minSheepWeight", a.minSheepWeight); -- min weight 
		--setXMLInt(xmlFile, tag ..".weight#curSheepWeight", a.curSheepWeight); -- current weight
		--setXMLInt(xmlFile, tag ..".price#curSheepPrice", a.curSheepPrice); -- current price alive
		--
		local tag = rootTag ..".Conf.section4";
		-- chicken
		--setXMLInt(xmlFile, tag ..".pool#minChickenPool", gAm.animals.minChickenPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#medChickenPool", a.medChickenpPool); -- max cows you could own
		setXMLInt(xmlFile, tag ..".pool#maxChickenPool", a.maxChickenPool); -- max cows you could own
		--setXMLInt(xmlFile, tag ..".pool#curChickenPool", a.curChickenPool); -- set by config.xml
		setXMLInt(xmlFile, tag ..".age#maxChickenAge", a.maxChickenAge); -- max age
		setXMLInt(xmlFile, tag ..".age#chickenBreedAge", a.chickenBreedAge); -- age before it could breed
		setXMLInt(xmlFile, tag ..".breed#maxChickenBreedTime", a.maxChickenBreedTime); -- time we need to grow before it get born
		setXMLInt(xmlFile, tag ..".breed#chbPeriod", a.chbPeriod ); -- multiplier for breeding (time)
		setXMLInt(xmlFile, tag ..".breed#chbPeriodTime", a.chbPeriodTime); -- time in day's that the breeding period lest  
		setXMLInt(xmlFile, tag ..".weight#maxChickenWeight", a.maxChickenWeight); -- max weight of healthy animal
		setXMLInt(xmlFile, tag ..".weight#minChickenWeight", a.minChickenWeight); -- min weight 
		--setXMLInt(xmlFile, tag ..".weight#curChickenWeight", a.curChickenWeight); -- current weight
		--setXMLInt(xmlFile, tag ..".price#curChickenPrice", a.curChickenPrice); -- current price alive
		--
		local tag = rootTag ..".Info2";
		setXMLString(xmlFile, tag, txt2);
		
		-- player stats
       local tag = rootTag ..".PlayerStats";
		
        -- todo
		setXMLInt(xmlFile, tag .."#money", gAm.stats.money);
		-- breedingStats --
       local tag = rootTag ..".Breeding";
       -- todo
	   setXMLInt( xmlFile, tag .."#totalNumBreeds", gAm.stats.breedStats.totalNumBreeds);
	   setXMLInt( xmlFile, tag .."#cowInBreed", gAm.stats.breedStats.cowInBreed);
	   setXMLInt( xmlFile, tag .."#sheepInBreed", gAm.stats.breedStats.sheepInBreed);
	   setXMLInt( xmlFile, tag .."#chickenInBreed", gAm.stats.breedStats.chickenInBreed);
       local tag = rootTag ..".Breeding.cow";
	   -- todo: read the breedtable for cows
	   
	   
	   local tag = rootTag ..".Breeding.sheep";
	   -- todo: read the breedtable for sheep
	  
	   local tag = rootTag ..".Breeding.chicken";
        -- todo: read the breedtable for chicken
		
    end;
        saveXMLFile(xmlFile);
        print(gAm.scriptName ..".xml saved");
        delete(xmlFile);
end;

local CareerScreenSaveSelectedGame = CareerScreen.saveSelectedGame; -- add Save Callback

CareerScreen.saveSelectedGame = function(self)
	if (gAm.deBug == true) then
		print("gAm_a - DEBUG - Save Callback");
	end;
	CareerScreenSaveSelectedGame(self);
    
	
    gAm:saveData();  
   
end; 