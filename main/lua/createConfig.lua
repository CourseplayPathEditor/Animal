-- create the config file //this function need to be deleted once the script is beta version
	function gAm:createConfig() -- only for setting up the confFile
		print("saving configFile");
		local rootTag = gAm.scriptName;
		local xmlFile = createXMLFile("animalMod", gAm.setConfFilename, rootTag);

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
			local tag = rootTag ..".Conf.activation";
			setXMLBool(xmlFile, tag ..".script#scriptActive", gAm.IsActive);
			setXMLBool(xmlFile, tag ..".deBug#deBugOn/Off", gAm.deBug);
			setXMLString(xmlFile, tag ..".mode#defaultMode", gAm.defaultMode);
			setXMLBool(xmlFile, tag ..".breed#isCowBreed", isCowBreed);
			setXMLBool(xmlFile, tag ..".breed#isSheepBreed", isSheepBreed);
			setXMLBool(xmlFile, tag ..".breed#isChickenBreed", isChickenBreed);
			
			--
			
			local tag = rootTag ..".Conf.setCow";
			-- cow
			setXMLInt(xmlFile, tag ..".pool#minCowPool", a.minCowPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#medCowPool", a.medCowPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#maxCowPool", a.maxCowPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#curCowPool", a.curCowPool); -- set by config.xml
			setXMLInt(xmlFile, tag ..".age#maxCowAge", a.maxCowAge); -- max age
			setXMLInt(xmlFile, tag ..".age#cowBreedAge", a.cowBreedAge); -- age before it could breed
			setXMLInt(xmlFile, tag ..".breedTimes#maxCowBreedTime", a.maxCowBreedTime); -- time we need to grow before it get born
			setXMLInt(xmlFile, tag ..".breedTimes#cbPeriod", a.cbPeriod ); -- multiplier for breeding (time)
			setXMLInt(xmlFile, tag ..".breedTimes#cbPeriodTime", a.cbPeriodTime); -- time in day's that the breeding period lest  
			setXMLInt(xmlFile, tag ..".weight#maxCowWeight", a.maxCowWeight); -- max weight of healthy animal
			setXMLInt(xmlFile, tag ..".weight#minCowWeight", a.minCowWeight); -- min weight 
			setXMLInt(xmlFile, tag ..".weight#curCowWeight", a.curCowWeight); -- current weight
			setXMLInt(xmlFile, tag ..".price#curCowPrice", a.curCowPrice); -- current price alive
			--
			local tag = rootTag ..".Conf.setSheep";
			-- sheep
			setXMLInt(xmlFile, tag ..".pool#minSheepPool", a.minSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#medSheepPool", a.medSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#maxSheepPool", a.maxSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#curSheepPool", a.curSheepPool); -- set by config.xml
			setXMLInt(xmlFile, tag ..".age#maxSheepAge", a.maxSheepAge); -- max age
			setXMLInt(xmlFile, tag ..".age#sheepBreedAge", a.sheepBreedAge); -- age before it could breed
			setXMLInt(xmlFile, tag ..".breedTimes#maxSheepBreedTime", a.maxSheepBreedTime); -- time we need to grow before it get born
			setXMLInt(xmlFile, tag ..".breedTimes#sbPeriod", a.sbPeriod ); -- multiplier for breeding (time)
			setXMLInt(xmlFile, tag ..".breedTimes#sbPeriodTime", a.sbPeriodTime); -- time in day's that the breeding period lest  
			setXMLInt(xmlFile, tag ..".weight#maxSheepWeight", a.maxSheepWeight); -- max weight of healthy animal
			setXMLInt(xmlFile, tag ..".weight#minSheepWeight", a.minSheepWeight); -- min weight 
			setXMLInt(xmlFile, tag ..".weight#curSheepWeight", a.curSheepWeight); -- current weight
			setXMLInt(xmlFile, tag ..".price#curSheepPrice", a.curSheepPrice); -- current price alive
			--
			local tag = rootTag ..".Conf.setChicken";
			-- chicken
			setXMLInt(xmlFile, tag ..".pool#minChickenPool", a.minChickenPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#medChickenPool", a.medChickenpPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#maxChickenPool", a.maxChickenPool); -- max cows you could own
			setXMLInt(xmlFile, tag ..".pool#curChickenPool", a.curChickenPool); -- set by config.xml
			setXMLInt(xmlFile, tag ..".age#maxChickenAge", a.maxChickenAge); -- max age
			setXMLInt(xmlFile, tag ..".age#chickenBreedAge", a.chickenBreedAge); -- age before it could breed
			setXMLInt(xmlFile, tag ..".breedTimes#maxChickenBreedTime", a.maxChickenBreedTime); -- time we need to grow before it get born
			setXMLInt(xmlFile, tag ..".breedTimes#chbPeriod", a.chbPeriod ); -- multiplier for breeding (time)
			setXMLInt(xmlFile, tag ..".breedTimes#chbPeriodTime", a.chbPeriodTime); -- time in day's that the breeding period lest  
			setXMLInt(xmlFile, tag ..".weight#maxChickenWeight", a.maxChickenWeight); -- max weight of healthy animal
			setXMLInt(xmlFile, tag ..".weight#minChickenWeight", a.minChickenWeight); -- min weight 
			setXMLInt(xmlFile, tag ..".weight#curChickenWeight", a.curChickenWeight); -- current weight
			setXMLInt(xmlFile, tag ..".price#curChickenPrice", a.curChickenPrice); -- current price alive
			--
			
	    end;
	        saveXMLFile(xmlFile);
	        print(gAm.setConfFilename .." saved");
	        delete(xmlFile);
	end;
	
	local CareerScreenSaveSelectedGame = CareerScreen.saveSelectedGame; -- add Save Callback

CareerScreen.saveSelectedGame = function(self)
	if (gAm.deBug == true) then
		print("gAm_a - DEBUG - Save Callback");
	end;
	CareerScreenSaveSelectedGame(self);
    
	
    --gAm_a:saveData();  -- first creating my config file
    gAm:createConfig();
end; 

print ("AnimalMod.createConfig loaded");