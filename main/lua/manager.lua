--------------------------------------------------------
-- Author: Jengske_BE
-- Date: 18/08/2015
-- 
-- DO NOT MODIFY THIS FILE WITHOUT PERMISSION!!!
--------------------------------------------------------
-- Manager --
-------------
gAm = {};
gAm._man = {};
gAm._man_mt = Class(gAm._man);
InitObjectClass(gAm._man, "gAm._man");

local modItem = ModsUtil.findModItemByModName(g_currentModName);


local filePath = gAm.path .. 'lua/animalMod.lua';
assert(fileExists(filePath), ('ANIMALMOD ERROR: "animalMod.lua" can\'t be found at %q'):format(filePath));
source(filePath);
-------------------
local function initialize()
	local fileList = {
		'createConfig',
		'setup',
		'breed'
	};

	local numFiles, numFilesLoaded = #(fileList) + 3, 3; -- + 3 as 'register.lua', 'courseplay.lua' and 'CpManager.lua' have already been loaded
	for _,file in ipairs(fileList) do
		local filePath = gAm.LUAdir .. file .. '.lua';
		assert(fileExists(filePath), '\tANIMALMOD ERROR: could not load file ' .. filePath);
		source(filePath);
		print('\t### AnimalMod: ' .. filePath .. ' has been loaded');
		numFilesLoaded = numFilesLoaded + 1;
	end;

	print(('### AnimalMod: initialized %d/%d files (v%s)'):format(numFilesLoaded, numFiles, gAm.version));
end;

-- own functions----
function gAm._man:check1()
-- first step to check for changes on the amount of animals

end;
initialize();
----------------------------
-- functions needed by game
function gAm._man:loadMap(name)
	
end;

function gAm._man:mouseEvent(posX, posY, isDown, isUp, button)
end;

function gAm._man:keyEvent(unicode, sym, modifier, isDown)
end;

function gAm._man:updateTick(dt)

end;

function gAm._man:update(dt)

end;

function gAm._man:draw()

end;

function gAm._man:deleteMap(name)

end;

--------------------------------------------------

print ("AnimalMod.Manager loaded");
addModEventListener(gAm._man);
