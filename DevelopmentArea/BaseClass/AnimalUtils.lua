AnimalUtils = {};
AnimalUtil.AnimalTypes = {};
AnimalUtils.NUM_ANIMALTYPES = 0;
function AnimalUtils.registerAnimalType(name, AnimalType, pricePerLiter, woodChipsPerLiter, allowsWoodHarvester)
    if AnimalUtil.AnimalTypes[AnimalType] == nil then
        local desc = {};
        desc.name = name;
        desc.AnimalType = AnimalType;
        desc.pricePerLiter = pricePerLiter;
        desc.woodChipsPerLiter = woodChipsPerLiter;
        desc.allowsWoodHarvester = allowsWoodHarvester;
        AnimalUtil.AnimalTypes[AnimalType] = desc;
    end
end;

function AnimalUtils:getHusbandries(animal)
	for k, v in pairs (g_currentMission.husbandries[animal]) do
	print("husbandries: " ..k , v);
	end;
end;

function AnimalUtils:getFruits(animal)
	for k, v in pairs (FruitUtil.fruitTypes) do
	print("fruitTypes: " ..k , " = ", v );
	end;
end;

function AnimalUtils:husbandriesToAnimal(animal)
	for k, v in pairs (g_currentMission.husbandries[animal]) do
	table.insert(AnimalUtil.AnimalTypes[animal][k],v);
	end;
end;
