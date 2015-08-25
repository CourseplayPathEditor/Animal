function gAm:syncFarm()
print ("syncFarm");
	local pool = gAm.farm;
	pool.cowOwned = gAm.totalNumCows;
	pool.sheepOwned = gAm.totalNumSheep;
	pool.chickenOwned = gAm.totalNumChicken;
	pool.eggOwned = #gAm.animals.eggPool;
	pool.totalNumSick = #gAm.animals.sickPool;
	pool.totalNumBreed = #gAm.animals.breedPool;
end;

function gAm:syncGame()
print("syncGame");
	local pool = gAm.game;
	pool.cowOwned = g_currentMission.husbandries.cow.totalNumAnimals;
	pool.sheepOwned = g_currentMission.husbandries.sheep.totalNumAnimals;
	pool.chickenOwned = g_currentMission.husbandries.chicken.totalNumAnimals;
	pool.eggOwned = g_currentMission.husbandries.chicken.numActivePickupObjects;
end;

