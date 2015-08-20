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
			--local a = gAm_mn;
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
			setXMLInt(xmlFile, tag ..".pool#minCowPool", gAm_mn.minCowPool); -- max cows you could own
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
			setXMLInt(xmlFile, tag .."#minSheepPool", gAm.minSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#medSheepPool", a.medSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#maxSheepPool", a.maxSheepPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#curSheepPool", a.curSheepPool); -- set by config.xml
			setXMLInt(xmlFile, tag .."#maxSheepAge", a.maxSheepAge); -- max age
			setXMLInt(xmlFile, tag .."#sheepBreedAge", a.sheepBreedAge); -- age before it could breed
			setXMLInt(xmlFile, tag .."#maxSheepBreedTime", a.maxSheepBreedTime); -- time we need to grow before it get born
			setXMLInt(xmlFile, tag .."#sbPeriod", a.sbPeriod ); -- multiplier for breeding (time)
			setXMLInt(xmlFile, tag .."#sbPeriodTime", a.sbPeriodTime); -- time in day's that the breeding period lest  
			setXMLInt(xmlFile, tag .."#maxSheepWeight", a.maxSheepWeight); -- max weight of healthy animal
			setXMLInt(xmlFile, tag .."#minSheepWeight", a.minSheepWeight); -- min weight 
			setXMLInt(xmlFile, tag .."#curSheepWeight", a.curSheepWeight); -- current weight
			setXMLInt(xmlFile, tag .."#curSheepPrice", a.curSheepPrice); -- current price alive
			--
			local tag = rootTag ..".Conf.setChicken";
			-- chicken
			setXMLInt(xmlFile, tag .."#minChickenPool", gAm_mn.minChickenPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#medChickenPool", a.medChickenpPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#maxChickenPool", a.maxChickenPool); -- max cows you could own
			setXMLInt(xmlFile, tag .."#curChickenPool", a.curChickenPool); -- set by config.xml
			setXMLInt(xmlFile, tag .."#maxChickenAge", a.maxChickenAge); -- max age
			setXMLInt(xmlFile, tag .."#chickenBreedAge", a.chickenBreedAge); -- age before it could breed
			setXMLInt(xmlFile, tag .."#maxChickenBreedTime", a.maxChickenBreedTime); -- time we need to grow before it get born
			setXMLInt(xmlFile, tag .."#chbPeriod", a.chbPeriod ); -- multiplier for breeding (time)
			setXMLInt(xmlFile, tag .."#chbPeriodTime", a.chbPeriodTime); -- time in day's that the breeding period lest  
			setXMLInt(xmlFile, tag .."#maxChickenWeight", a.maxChickenWeight); -- max weight of healthy animal
			setXMLInt(xmlFile, tag .."#minChickenWeight", a.minChickenWeight); -- min weight 
			setXMLInt(xmlFile, tag .."#curChickenWeight", a.curChickenWeight); -- current weight
			setXMLInt(xmlFile, tag .."#curChickenPrice", a.curChickenPrice); -- current price alive
			--
			
	    end;
	        saveXMLFile(xmlFile);
	        print(gAm_a.setConfFilename .." saved");
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