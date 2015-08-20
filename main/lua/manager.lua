--------------------------------------------------------
-- Author: Jengske_BE
-- Date: 18/08/2015
-- 
-- DO NOT MODIFY THIS FILE WITHOUT PERMISSION!!!
--------------------------------------------------------
-- Manager --
-------------
gAm._man = {};
gAm._man_mt = Class(gAm._man);
InitObjectClass(gAm._man, "gAm._man");

local modItem = ModsUtil.findModItemByModName(g_currentModName);


-- own functions----
function gAm._man:check1()
-- first step to check for changes on the amount of animals

end;

----------------------------
-- functions needed by game
function gAm._man:loadMap(name)
print("manager.lua:loadMap(name)");
	gAm:createConfig();
	gAm:setup();
	gAm:syncFarm();
	gAm:syncGame();
	--gAm:debugging();
end;

function gAm._man:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm._man:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm._man:updateTick(dt)

end;

function gAm._man:update(dt)

	if(gAm.totalNumCows < g_currentMission.husbandries.cow.totalNumAnimals) then
		print ("we have a change in cows");
		gAm.totalNumCows = g_currentMission.husbandries.cow.totalNumAnimals;
		gAm:syncFarm();
		gAm:syncGame();
		gAm:saveData();
	end;
end;

function gAm._man:draw()

end;

function gAm._man:deleteMap(name)

end;

--------------------------------------------------

print ("AnimalMod.Manager loaded");
addModEventListener(gAm._man);
