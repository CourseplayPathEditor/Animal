-- author: Dirk Peeters - jengske_BE
-- date: 25/08/2005
-- copyright: Dirk Peeters - jengske_BE
-- 
--
-- fruitFix.lua replaces the Fillable.registerFillType function with a modified version of the orginal function.

-- we add to Fillable MAX_NUM_FILLTYPES
Fillable.MAX_NUM_FILLTYPES = 130; -- change this number to suit your needs, default is 64

local oldFillableRegisterFillType = Fillable.registerFillType;
Fillable.registerFillType = function(name, nameI18N, pricePerLiter, partOfEconomy, hudOverlayFilename, hudOverlayFilenameSmall, massPerLiter, maxPhysicalSurfaceAngle)
	print("new registerFilltype");
	local key = "FILLTYPE_"..string.upper(name);
	
    if Fillable[key] == nil then
        if Fillable.NUM_FILLTYPES >= Fillable.MAX_NUM_FILLTYPES then -- this line is modified
            print("Error: Fillable.registerFillType too many fill types. Only " ..tostring(Fillable.MAX_NUM_FILLTYPES) .." fill types are supported");
            return;
        end;
        Fillable.NUM_FILLTYPES = Fillable.NUM_FILLTYPES+1;
        Fillable[key] = Fillable.NUM_FILLTYPES;
        Fillable.fillTypeNameToInt[name] = Fillable.NUM_FILLTYPES;
        Fillable.fillTypeIntToName[Fillable.NUM_FILLTYPES] = name;
        local desc = {};
        desc.name = name;
        desc.nameI18N = nameI18N;
        if desc.nameI18N == nil then
            desc.nameI18N = name;
            if g_i18n:hasText(desc.nameI18N) then
                desc.nameI18N = g_i18n:getText(name);
            end
        end
        desc.index = Fillable.NUM_FILLTYPES;
        desc.massPerLiter = Utils.getNoNil(massPerLiter, 0.0001);
        desc.pricePerLiter = Utils.getNoNil(pricePerLiter, 0);
        desc.previousHourPrice = desc.pricePerLiter;
        desc.startPricePerLiter = desc.pricePerLiter;
        desc.totalAmount = Fillable.FILLTYPE_START_TOTAL_AMOUNT;
        desc.partOfEconomy = Utils.getNoNil(partOfEconomy, false);
        desc.hudOverlayFilename = hudOverlayFilename;
        desc.hudOverlayFilenameSmall = Utils.getNoNil(hudOverlayFilenameSmall, hudOverlayFilename);
        desc.materials = {}
        desc.maxPhysicalSurfaceAngle = maxPhysicalSurfaceAngle;
        Fillable.fillTypeIndexToDesc[Fillable.NUM_FILLTYPES] = desc;
        Fillable.fillTypeNameToDesc[name] = desc;
        if desc.partOfEconomy then
            table.insert(Fillable.economyFillTypes, desc);
        end;
    end;
	oldFillableRegisterFillType(name, nameI18N, pricePerLiter, partOfEconomy, hudOverlayFilename, hudOverlayFilenameSmall, massPerLiter, maxPhysicalSurfaceAngle);
	print("info: " ..Fillable.NUM_FILLTYPES .." add: " ..name);
    return Fillable[key];
	
end;