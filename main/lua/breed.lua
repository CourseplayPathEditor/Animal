-- todo
gAm._breed = {};
gAm._breed = Class(gAm._breed);
InitObjectClass(gAm._breed, "gAm._breed");



local modItem = ModsUtil.findModItemByModName(g_currentModName);
----------------------------
-- functions needed by game
function gAm._breed:loadMap(name)
	
end;

function gAm._breed:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm._breed:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm._breed:updateTick(dt)

end;

function gAm._breed:update(dt)

end;

function gAm._breed:draw()

end;

function gAm._breed:deleteMap(name)

end;

--------------------------------------------------

print ("AnimalMod.Breed loaded");
addModEventListener(gAm._breed);
