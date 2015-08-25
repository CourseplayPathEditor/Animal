--
-- LoadAble
-- This is the specialization for fillable vehicles, such as trailers or sprayers
--
-- @author  Stefan Geiger orginal 'FillAble.lua' modified version Dirk Peeters
-- @date  22/07/10
--
-- Copyright (C) GIANTS Software GmbH, Confidential, All Rights Reserved.
source("dataS/scripts/vehicles/specializations/FillActivatable.lua");

LoadAble = {};

LoadAble.NUM_FILLTYPES = 0;
LoadAble.FILLTYPE_UNKNOWN = 0;
LoadAble.FILLTYPE_START_TOTAL_AMOUNT = 500000;

LoadAble.fillTypeNameToInt = {}
LoadAble.fillTypeIntToName = {}
LoadAble.fillTypeIndexToDesc = {}
LoadAble.fillTypeNameToDesc = {}
LoadAble.economyFillTypes = {};

LoadAble.defaultFillPlaneMaterial = nil;
LoadAble.defaultFillIconMaterial = nil;

LoadAble.MATERIAL_TYPE_FILLPLANE = 1;
LoadAble.MATERIAL_TYPE_ICON = 2;
LoadAble.MATERIAL_TYPE_UNLOADING = 3;
LoadAble.MATERIAL_TYPE_SMOKE = 4;
LoadAble.MATERIAL_TYPE_STRAW = 5;
LoadAble.MATERIAL_TYPE_CHOPPER = 6;

LoadAble.defaultMaterials = {};

LoadAble.fillTypeNameToInt["unknown"] = LoadAble.FILLTYPE_UNKNOWN;
LoadAble.fillTypeIntToName[LoadAble.FILLTYPE_UNKNOWN] = "unknown";
LoadAble.sendNumBits = 6;

function LoadAble.registerFillType(name, nameI18N, pricePerLiter, partOfEconomy, hudOverlayFilename, hudOverlayFilenameSmall, massPerLiter, maxPhysicalSurfaceAngle, i3dFilename, isAnimated)
    local key = "FILLTYPE_"..string.upper(name);
    if LoadAble[key] == nil then
        if LoadAble.NUM_FILLTYPES >= 64 then
            print("Error: LoadAble.registerFillType too many fill types. Only 64 fill types are supported");
            return;
        end;
        LoadAble.NUM_FILLTYPES = LoadAble.NUM_FILLTYPES+1;
        LoadAble[key] = LoadAble.NUM_FILLTYPES;
        LoadAble.fillTypeNameToInt[name] = LoadAble.NUM_FILLTYPES;
        LoadAble.fillTypeIntToName[LoadAble.NUM_FILLTYPES] = name;
        local desc = {};
        desc.name = name;
        desc.nameI18N = nameI18N;
        if desc.nameI18N == nil then
            desc.nameI18N = name;
            if g_i18n:hasText(desc.nameI18N) then
                desc.nameI18N = g_i18n:getText(name);
            end
        end
        desc.index = LoadAble.NUM_FILLTYPES;
        desc.massPerLiter = Utils.getNoNil(massPerLiter, 0.0001);
        desc.pricePerLiter = Utils.getNoNil(pricePerLiter, 0);
        desc.previousHourPrice = desc.pricePerLiter;
        desc.startPricePerLiter = desc.pricePerLiter;
        desc.totalAmount = LoadAble.FILLTYPE_START_TOTAL_AMOUNT;
        desc.partOfEconomy = Utils.getNoNil(partOfEconomy, false);
        desc.hudOverlayFilename = hudOverlayFilename;
        desc.hudOverlayFilenameSmall = Utils.getNoNil(hudOverlayFilenameSmall, hudOverlayFilename);
        desc.materials = {}
        desc.maxPhysicalSurfaceAngle = maxPhysicalSurfaceAngle;
        LoadAble.fillTypeIndexToDesc[LoadAble.NUM_FILLTYPES] = desc;
        LoadAble.fillTypeNameToDesc[name] = desc;
        if desc.partOfEconomy then
            table.insert(LoadAble.economyFillTypes, desc);
        end;
    end;
    return LoadAble[key];
end;
--
function LoadAble.onCreateFillMaterial(_, id)
    local fillType = getUserAttribute(id, "fillType");
    if fillType == nil then
        print("Warning: No fillType '"..tostring(fillType).."' given for LoadAble.onCreateMaterial");
        return
    end;
    local desc = LoadAble.fillTypeNameToDesc[fillType];
    if desc == nil then
        print("Warning: Unkown fillType '"..tostring(fillType).."' for LoadAble.onCreateFillMaterial");
        return;
    end;
    local matTypeName = getUserAttribute(id, "materialType");
    if matTypeName == nil then
        print("Warning: No materialtype given for filltype '"..tostring(fillType).."' for LoadAble.onCreateFillMaterial");
        return;
    end;
    local materialType = LoadAble.getMaterialType(matTypeName);
    if materialType == nil then
        print("Warning: Unkown materialtype '"..matTypeName.."' given for filltype '"..tostring(fillType).."' for LoadAble.onCreateFillMaterial");
        return;
    end;
    local matIdStr = Utils.getNoNil(getUserAttribute(id, "materialId"), 1);
    if tonumber(matIdStr) == nil then
        print("Warning: Invalid materialId '"..matIdStr.."' for "..desc.name.."-"..matTypeName.."!")
        return;
    end;
    local materialId = tonumber(matIdStr);
    if desc.materials[materialType] == nil then
        desc.materials[materialType] = {};
    end;
    local materials = desc.materials[materialType];
    if LoadAble.defaultMaterials[materialType] == nil then
        LoadAble.defaultMaterials[materialType] = {};
    end;
    local default = LoadAble.defaultMaterials[materialType];
    materials[materialId] = getMaterial(id, 0);
    if default[materialId] == nil then
        default[materialId] = materials[materialId];
    end;
end;
--
function LoadAble.getFillMaterial(fillType, materialType, materialTypeId)
    if materialType == nil or materialTypeId == nil then
        return nil;
    end;
    local desc = LoadAble.fillTypeIndexToDesc[fillType];
    if desc == nil then
        return;
    end;
    local types = desc.materials[materialType];
    local isDefault = false;
    if types == nil then
        types = LoadAble.defaultMaterials[materialType];
        isDefault = true;
    end;
    if types == nil then
        return nil;
    end;
    if types[materialTypeId] ~= nil then
        return types[materialTypeId], isDefault;
    end;
    return types[1], isDefault;
end;
--
function LoadAble.getMaterialType(materialTypeName)
    local key = "MATERIAL_TYPE_"..string.upper(materialTypeName);
    return LoadAble[key];
end;
--
function LoadAble.cleanup()
    for i=1, LoadAble.NUM_FILLTYPES do
        local desc = LoadAble.fillTypeIndexToDesc[i];
        if desc ~= nil then
            desc.materials = {};
        end;
    end;
    LoadAble.defaultMaterials = {};
end;
--
function LoadAble.addFillTypeToEconomy(index)
    if not LoadAble.fillTypeIndexToDesc[index].partOfEconomy then
        LoadAble.fillTypeIndexToDesc[index].partOfEconomy = true;
        table.insert(LoadAble.economyFillTypes, desc);
    end
end;
--
function LoadAble.prerequisitesPresent(specializations)
    return true;
end;
--
function LoadAble:load(xmlFile)
    self.allowFillType = LoadAble.allowFillType;
    self.resetFillLevelIfNeeded = LoadAble.resetFillLevelIfNeeded;
    self.setFillLevel = LoadAble.setFillLevel;
    self.getFillLevel = LoadAble.getFillLevel;
    self.getCapacity = LoadAble.getCapacity;
    self.setCapacity = LoadAble.setCapacity;
    self.getAllowFillFromAir = LoadAble.getAllowFillFromAir;
    self.getFirstEnabledFillType = LoadAble.getFirstEnabledFillType;
    self.setLastValidFillType = SpecializationUtil.callSpecializationsFunction("setLastValidFillType");
    self.getOverlayFillType = LoadAble.getOverlayFillType;
    self.getDoRenderFillType = LoadAble.getDoRenderFillType;
    self.updateMeasurementNode = LoadAble.updateMeasurementNode;
    self.attachPipe = LoadAble.attachPipe;
    self.detachPipe = LoadAble.detachPipe;
    self.supportsFillTriggers = Utils.getNoNil(getXMLBool(xmlFile, "vehicle.supportsFillTriggers#value"), self.supportsFillTriggers);
    if self.supportsFillTriggers then
        assert(self.setIsFilling == nil, "LoadAble needs to be the first specialization which implements setIsFilling");
        self.setIsFilling = LoadAble.setIsFilling;
        self.addFillTrigger = LoadAble.addFillTrigger;
        self.removeFillTrigger = LoadAble.removeFillTrigger;
        self.fillLitersPerSecond = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.fillLitersPerSecond"), 500);
        local unitFillTime = getXMLFloat(xmlFile, "vehicle.unitFillTime");
        if unitFillTime ~= nil then
            self.unitFillTime = unitFillTime * 1000;
        end;
        self.currentFillTime = 0;
        self.fillTriggers = {};
        self.fillActivatable = FillActivatable:new(self);
        self.isFilling = false;
    end;
    self.fillLevel = 0;
    self.capacity = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.capacity"), 0.0);
    self.fillTypeChangeThreshold = 0.05; -- fill level percentage that still allows overriding with another fill type
    self.synchronizeFillLevel = true;
    self.synchronizeFullFillLevel = false;
    self.fillRootNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.fillRootNode#index"));
    if self.fillRootNode == nil then
        self.fillRootNode = self.components[1].node;
    end;
    self.fillMassNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.fillMassNode#index"));
    if self.fillMassNode == nil then
        self.fillMassNode = self.fillRootNode;
    end;
    self.exactFillRootNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.exactFillRootNode#index"));
    if self.exactFillRootNode == nil then
        self.exactFillRootNode = self.fillRootNode;
    end;
    self.fillAutoAimTargetNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.fillAutoAimTargetNode#index"));
    if self.fillAutoAimTargetNode == nil then
        self.fillAutoAimTargetNode = self.exactFillRootNode;
    end;
    self.attacherPipeRef = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.attacherPipe#refIndex"));
    self.attacherPipeRefVehicle = nil;
    self.attacherPipe = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.attacherPipe#index"));
    self.attacherPipeVehicle = nil;
    self.fillTypes = {};
    self.fillTypes[LoadAble.FILLTYPE_UNKNOWN] = true;
    local fillTypes = getXMLString(xmlFile, "vehicle.fillTypes#fillTypes");
    if fillTypes ~= nil then
        local types = Utils.splitString(" ", fillTypes);
        for k,v in pairs(types) do
            local fillType = LoadAble.fillTypeNameToInt[v];
            if fillType ~= nil then
                self.fillTypes[fillType] = true;
            else
                print("Warning: '"..self.configFileName.. "' has invalid fillType '"..v.."'.");
            end;
        end;
    end;
    local fruitTypes = getXMLString(xmlFile, "vehicle.fillTypes#fruitTypes");
    if fruitTypes ~= nil then
        local types = Utils.splitString(" ", fruitTypes);
        for k,v in pairs(types) do
            local fillType = LoadAble.fillTypeNameToInt[v];
            if fillType ~= nil then
                self.fillTypes[fillType] = true;
            else
                print("Warning: '"..self.configFileName.. "' has invalid fillType '"..v.."'.");
            end;
        end;
    end;
    self.currentFillType = LoadAble.FILLTYPE_UNKNOWN;
    self.lastValidFillType = LoadAble.FILLTYPE_UNKNOWN;
    if self.isServer then
        self.sentFillType = self.currentFillType;
        self.sentFillLevel = self.fillLevel;
    end;
    self.alsoUseFillVolumeLoadInfoForDischarge = Utils.getNoNil(getXMLBool(xmlFile, "vehicle.alsoUseFillVolumeLoadInfoForDischarge"), false);
    if self.isClient then
        self.fillVolumes = {};
        self.fillVolumeDeformers = {};
        local i = 0;
        while true do
            local key = string.format("vehicle.fillVolumes.fillVolume(%d)", i);
            if not hasXMLProperty(xmlFile, key) then
                break;
            end;
            local fillVolume = {};
            fillVolume.baseNode = Utils.indexToObject(self.components, getXMLString(xmlFile, key.."#index"));
            fillVolume.allSidePlanes = Utils.getNoNil(getXMLBool(xmlFile, key.."#allSidePlanes"), true);
            local defaultFillType = getXMLString(xmlFile, key.."#defaultFillType");
            if defaultFillType ~= nil then
                local fillType = LoadAble.fillTypeNameToInt[defaultFillType];
                if fillType ~= nil then
                    fillVolume.defaultFillType = fillType;
                else
                    print("Warning: Invalid defaultFillType '"..tostring(defaultFillType).."' in '"..self.configFileName.."'");
                end;
            end;
            fillVolume.maxDelta = Utils.getNoNil(getXMLFloat(xmlFile, key.."#maxDelta"), 1.0);
            fillVolume.maxSurfaceAngle = math.rad( Utils.getNoNil(getXMLFloat(xmlFile, key.."#maxAllowedHeapAngle"), 35) );
            local maxPhysicalSurfaceAngle = math.rad(35);
            fillVolume.maxSubDivEdgeLength = Utils.getNoNil(getXMLFloat(xmlFile, key.."#maxSubDivEdgeLength"), 0.9);
            fillVolume.volume = createFillPlaneShape(fillVolume.baseNode, "fillPlane", self.capacity, fillVolume.maxDelta, fillVolume.maxSurfaceAngle, maxPhysicalSurfaceAngle, fillVolume.maxSubDivEdgeLength, fillVolume.allSidePlanes);
            fillVolume.deformers = {};
            if fillVolume.volume ~= nil then
                local j = 0;
                while true do
                    local node = Utils.indexToObject(self.components, getXMLString(xmlFile, key..".deformNode("..j..")#index"));
                    if node == nil then
                        break;
                    end;
                    local initPos = { localToLocal(node, fillVolume.baseNode, 0,0,0) };
                    local polyline = findPolyline(fillVolume.volume, initPos[1],initPos[3]);
                    self.fillVolumeDeformers[node] = {node=node, initPos=initPos, posX=initPos[1], posZ=initPos[3], polyline=polyline, volume=fillVolume.volume, baseNode=fillVolume.baseNode};
                    j = j + 1;
                end;
            end;
            fillVolume.scrollSpeedDischarge = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, key.."#scrollSpeedDischarge"), "0 0 0")) };
            fillVolume.scrollSpeedLoad = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, key.."#scrollSpeedLoad"), "0 0 0")) };
            for i=1,3 do
                fillVolume.scrollSpeedDischarge[i] = fillVolume.scrollSpeedDischarge[i] / 1000;
                fillVolume.scrollSpeedLoad[i] = fillVolume.scrollSpeedLoad[i] / 1000;
            end;
            fillVolume.uvPosition = {0, 0, 0};
            if fillVolume.volume ~= nil and fillVolume.volume ~= 0 then
                link(fillVolume.baseNode, fillVolume.volume);
                table.insert(self.fillVolumes, fillVolume);
            end;
            i = i + 1;
        end;
        self.fillVolumeHeights = {};
        self.fillVolumeHeightRefNodeToFillVolumeHeight = {};
        local i=0;
        while true do
            local key = string.format("vehicle.fillVolumeHeights.fillVolumeHeight(%d)", i);
            if not hasXMLProperty(xmlFile, key) then
                break;
            end;
            local volumeHeight = {};
            volumeHeight.fillVolumeId = getXMLInt(xmlFile, key.."#fillVolumeId");
            volumeHeight.volumeHeightIsDirty = false;
            volumeHeight.refNodes = {};
            local j=0;
            while true do
                local refNode = Utils.indexToObject(self.components, getXMLString(xmlFile, string.format("%s.refNode(%d)#index", key, j)));
                if refNode == nil then
                    break;
                end;
                table.insert(volumeHeight.refNodes, {refNode=refNode});
                self.fillVolumeHeightRefNodeToFillVolumeHeight[refNode] = volumeHeight;
                j=j+1;
            end;
            volumeHeight.nodes = {};
            local j=0;
            while true do
                local node = Utils.indexToObject(self.components, getXMLString(xmlFile, string.format("%s.node(%d)#index", key, j)));
                if node == nil then
                    break;
                end;
                if node ~= nil then
                    local baseScale = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, string.format("%s.node(%d)#baseScale", key, j)), "1 1 1")) };
                    local scaleAxis = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, string.format("%s.node(%d)#scaleAxis", key, j)), "0 0 0")) };
                    local scaleMax = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, string.format("%s.node(%d)#scaleMax", key, j)), "0 0 0")) };
                    local basePosition = { getTranslation(node) };
                    local transAxis = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, string.format("%s.node(%d)#transAxis", key, j)), "0 0 0")) };
                    local transMax = { Utils.getVectorFromString(Utils.getNoNil(getXMLString(xmlFile, string.format("%s.node(%d)#transMax", key, j)), "0 0 0")) };
                    local orientateToWorldY = Utils.getNoNil(getXMLBool(xmlFile, string.format("%s.node(%d)#orientateToWorldY", key, j)), false);
                    table.insert(volumeHeight.nodes, {node=node, baseScale=baseScale, scaleAxis=scaleAxis, scaleMax=scaleMax, basePosition=basePosition, transAxis=transAxis, transMax=transMax, orientateToWorldY=orientateToWorldY});
                end;
                j=j+1;
            end;
            table.insert(self.fillVolumeHeights, volumeHeight);
            i=i+1;
        end;
        local fillPlanesRotDeg = Utils.getNoNil(getXMLBool(xmlFile, "vehicle.fillPlanes#rotationDegrees"), false);
        self.fillPlanes = {};
        local i = 0;
        while true do
            local key = string.format("vehicle.fillPlanes.fillPlane(%d)", i);
            if not hasXMLProperty(xmlFile, key) then
                break;
            end;
            local fillPlane = {};
            fillPlane.nodes = {};
            local fillType = getXMLString(xmlFile, key.."#type");
            if fillType ~= nil then
                local nodeI = 0;
                while true do
                    local nodeKey = key..string.format(".node(%d)", nodeI);
                    if not hasXMLProperty(xmlFile, nodeKey) then
                        break;
                    end;
                    local node = Utils.indexToObject(self.components, getXMLString(xmlFile, nodeKey.."#index"));
                    if node ~= nil then
                        local defaultX, defaultY, defaultZ = getTranslation(node);
                        local defaultRX, defaultRY, defaultRZ = getRotation(node);
                        setVisibility(node, false);
                        local animCurve = AnimCurve:new(linearInterpolatorTransRotScale);
                        local keyI = 0;
                        while true do
                            local animKey = nodeKey..string.format(".key(%d)", keyI);
                            local keyTime = getXMLFloat(xmlFile, animKey.."#time");
                            local x,y,z = Utils.getVectorFromString(getXMLString(xmlFile, animKey.."#translation"));
                            if y == nil then
                                y = getXMLFloat(xmlFile, animKey.."#y");
                            end;
                            local rx,ry,rz = Utils.getVectorFromString(getXMLString(xmlFile, animKey.."#rotation"));
                            local sx,sy,sz = Utils.getVectorFromString(getXMLString(xmlFile, animKey.."#scale"));
                            if keyTime == nil then
                                break;
                            end;
                            local x = Utils.getNoNil(x, defaultX);
                            local y = Utils.getNoNil(y, defaultY);
                            local z = Utils.getNoNil(z, defaultZ);
                            if fillPlanesRotDeg then
                                rx = Utils.getNoNilRad(rx, defaultRX);
                                ry = Utils.getNoNilRad(ry, defaultRY);
                                rz = Utils.getNoNilRad(rz, defaultRZ);
                            else
                                rx = Utils.getNoNil(rx, defaultRX);
                                ry = Utils.getNoNil(ry, defaultRY);
                                rz = Utils.getNoNil(rz, defaultRZ);
                            end
                            local sx = Utils.getNoNil(sx, 1);
                            local sy = Utils.getNoNil(sy, 1);
                            local sz = Utils.getNoNil(sz, 1);
                            animCurve:addKeyframe({x=x, y=y, z=z, rx=rx, ry=ry, rz=rz, sx=sx, sy=sy, sz=sz, time = keyTime});
                            keyI = keyI +1;
                        end;
                        if keyI == 0 then
                            local minY, maxY = Utils.getVectorFromString(getXMLString(xmlFile, nodeKey.."#minMaxY"));
                            local minY = Utils.getNoNil(minY, defaultY);
                            local maxY = Utils.getNoNil(maxY, defaultY);
                            animCurve:addKeyframe({x=defaultX, y=minY, z=defaultZ, rx=defaultRX, ry=defaultRY, rz=defaultRZ, sx=1, sy=1, sz=1, time = 0});
                            animCurve:addKeyframe({x=defaultX, y=maxY, z=defaultZ, rx=defaultRX, ry=defaultRY, rz=defaultRZ, sx=1, sy=1, sz=1, time = 1});
                        end;
                        local alwaysVisible = Utils.getNoNil(getXMLBool(xmlFile, nodeKey.."#alwaysVisible"), false);
                        table.insert(fillPlane.nodes, {node=node, animCurve = animCurve, alwaysVisible=alwaysVisible});
                    end;
                    nodeI = nodeI +1;
                end;
                if table.getn(fillPlane.nodes) > 0 then
                    if self.defaultFillPlane == nil then
                        self.defaultFillPlane = fillPlane;
                    end;
                    self.fillPlanes[fillType] = fillPlane;
                end;
            end;
            i = i +1;
        end;
        if self.defaultFillPlane==nil then
            self.fillPlanes = nil;
        end;
        if self.fillPlanes == nil then
            LoadAble.loadDeprecatedTrailerGrainPlane(self, xmlFile);
            --[[if hasXMLProperty(xmlFile, "vehicle.grainPlane") then
                print("Warning: '"..self.configFileName.. "' uses old grainPlane format, which is not supported anymore.");
            end;]]
        end;
        self.measurementNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.measurementNode#index"));
        self.measurementTime = 0;
    end;
    self.allowFillFromAir = Utils.getNoNil(getXMLBool(xmlFile, "vehicle.allowFillFromAir#value"), true);
    local unloadTriggerNode = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.unloadTrigger#index"));
    if unloadTriggerNode ~= nil then
        self.unloadTrigger = FillTrigger:new();
        self.unloadTrigger:load(unloadTriggerNode, self.currentFillType, self);
    end;
    if self.isServer then
        local shovelFillTriggerId = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.shovelFillTrigger#index"));
        if shovelFillTriggerId ~= nil then
            local shovelFillTrigger = FillableShovelFillTrigger:new();
            if shovelFillTrigger:load(shovelFillTriggerId, self) then
                self.shovelFillTrigger = shovelFillTrigger;
            else
                shovelFillTrigger:delete();
            end
        end
    end;
    self.fillVolumeLoadInfo = {};
    self.fillVolumeLoadInfo.name = "fillVolumeLoadInfo";
    self.fillVolumeUnloadInfo = {};
    self.fillVolumeUnloadInfo.name = "fillVolumeUnloadInfo";
    self.fillVolumeDischargeInfo = {};
    self.fillVolumeDischargeInfo.name = "fillVolumeDischargeInfo";
    for _,tbl in pairs( {self.fillVolumeLoadInfo, self.fillVolumeUnloadInfo, self.fillVolumeDischargeInfo} ) do
        local indexString = getXMLString(xmlFile, "vehicle."..tbl.name.."#index");
        if indexString == nil then
            tbl.node = createTransformGroup(tbl.name);
            link(self.components[1].node, tbl.node);
            setTranslation(tbl.node, 0,0,0);
        else
            tbl.node = Utils.indexToObject(self.components, indexString);
        end;
        tbl.width = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle."..tbl.name.."#width"), 1.0);
        tbl.length = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle."..tbl.name.."#length"), 1.0);
        if tbl.name == "fillVolumeDischargeInfo" then
            tbl.alsoUseLoadInfoForDischarge = Utils.getNoNil(getXMLBool(xmlFile, "vehicle."..tbl.name.."#alsoUseLoadInfoForDischarge"), false);
            tbl.loadInfoSizeScale = Utils.getVectorNFromString( Utils.getNoNil(getXMLString(xmlFile, "vehicle."..tbl.name.."#loadInfoSizeScale"), "1 1"), 2 );
            tbl.loadInfoFillFactor = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle."..tbl.name.."#loadInfoFillFactor"), 0.6);
        end;
    end;
    self:setFillLevel(0, LoadAble.FILLTYPE_UNKNOWN);
    setUserAttribute(self.fillRootNode, "vehicleType", "Integer", 2);
    self.fillableDirtyFlag = self:getNextDirtyFlag();
end;
--
function LoadAble:postLoad(xmlFile)
    local startFillLevel = Utils.getNoNil(getXMLFloat(xmlFile, "vehicle.startFillLevel"), 0);
    if startFillLevel > 0 then
        local firstFillType = self:getFirstEnabledFillType();
        if firstFillType ~= LoadAble.FILLTYPE_UNKNOWN then
            self:setFillLevel(startFillLevel, firstFillType, true);
        end;
    end;
end;
--
function LoadAble.loadDeprecatedTrailerGrainPlane(self, xmlFile)
    --self.grainPlane = Utils.indexToObject(self.components, getXMLString(xmlFile, "vehicle.grainPlane#index"));
    if self.isClient then
        if self.fillPlanes == nil then
            local defaultX, defaultY, defaultZ;
            local defaultRX, defaultRY, defaultRZ;
            local defaultSX, defaultSY, defaultSZ;
            self.fillPlanes = {};
            local i = 0;
            while true do
                local key = string.format("vehicle.grainPlane.node(%d)", i);
                local fruitType = getXMLString(xmlFile, key.."#type");
                local index = getXMLString(xmlFile, key.."#index");
                if fruitType==nil or index==nil then
                    break;
                end;
                local node = Utils.indexToObject(self.components, index);
                if node ~= nil then
                    defaultX, defaultY, defaultZ = getTranslation(node);
                    defaultRX, defaultRY, defaultRZ = getRotation(node);
                    defaultSX, defaultSY, defaultSZ = getScale(node);
                    setVisibility(node, false);
                    local fillPlane = {};
                    fillPlane.nodes = {};
                    table.insert(fillPlane.nodes, {node=node, alwaysVisible=false}); -- animCurve is filled below
                    -- Node: fruitType names are equal to the fillType names
                    self.fillPlanes[fruitType] = fillPlane;
                    if self.defaultFillPlane == nil then
                        self.defaultFillPlane = fillPlane;
                    end;
                end;
                i = i +1;
            end;
            if self.defaultFillPlane==nil then
                self.fillPlanes = nil;
            else
                local animCurve = AnimCurve:new(linearInterpolatorTransRotScale);
                local keyI = 0;
                while true do
                    local animKey = string.format("vehicle.grainPlane.key(%d)", keyI);
                    local keyTime = getXMLFloat(xmlFile, animKey.."#time");
                    local y = getXMLFloat(xmlFile, animKey.."#y");
                    local sx,sy,sz = Utils.getVectorFromString(getXMLString(xmlFile, animKey.."#scale"));
                    if keyTime == nil then
                        break;
                    end;
                    local x = Utils.getNoNil(x, defaultX);
                    local y = Utils.getNoNil(y, defaultY);
                    local z = Utils.getNoNil(z, defaultZ);
                    local rx = Utils.getNoNil(rx, defaultRX);
                    local ry = Utils.getNoNil(ry, defaultRY);
                    local rz = Utils.getNoNil(rz, defaultRZ);
                    local sx = Utils.getNoNil(sx, defaultSX);
                    local sy = Utils.getNoNil(sy, defaultSY);
                    local sz = Utils.getNoNil(sz, defaultSZ);
                    animCurve:addKeyframe({x=x, y=y, z=z, rx=rx, ry=ry, rz=rz, sx=sx, sy=sy, sz=sz, time = keyTime});
                    keyI = keyI +1;
                end;
                if keyI == 0 then
                    local minY, maxY = Utils.getVectorFromString(getXMLString(xmlFile, "vehicle.grainPlane#minMaxY"));
                    local minY = Utils.getNoNil(minY, defaultY);
                    local maxY = Utils.getNoNil(maxY, defaultY);
                    animCurve:addKeyframe({x=defaultX, y=minY, z=defaultZ, rx=defaultRX, ry=defaultRY, rz=defaultRZ, sx=defaultSX, sy=defaultSY, sz=defaultSZ, time = 0});
                    animCurve:addKeyframe({x=defaultX, y=maxY, z=defaultZ, rx=defaultRX, ry=defaultRY, rz=defaultRZ, sx=defaultSX, sy=defaultSY, sz=defaultSZ, time = 1});
                end;
                for _, fillPlane in pairs(self.fillPlanes) do
                    fillPlane.nodes[1].animCurve = animCurve;
                end;
            end;
        end;
    end;
end;
--
function LoadAble:delete()
    if self.unloadTrigger ~= nil then
        self.unloadTrigger:delete();
        self.unloadTrigger = nil;
    end;
    for _, fillVolume in pairs(self.fillVolumes) do
        if fillVolume.volume ~= nil then
            delete(fillVolume.volume);
        end;
        fillVolume.volume = nil;
    end;
    if self.fillActivatable ~= nil then
        g_currentMission:removeActivatableObject(self.fillActivatable);
    end;
    if self.shovelFillTrigger ~= nil then
        self.shovelFillTrigger:delete();
    end
end;
--
function LoadAble:loadFromAttributesAndNodes(xmlFile, key, resetVehicles)
    if self.synchronizeFillLevel then
        local fillLevel = getXMLFloat(xmlFile, key.."#fillLevel");
        local fillType = getXMLString(xmlFile, key.."#fillType");
        if fillLevel ~= nil and fillType ~= nil then
            local fillTypeInt = LoadAble.fillTypeNameToInt[fillType];
            if fillTypeInt ~= nil then
                local fillSourceStruct = {x=0,y=0,z=0, d1x=0,d1y=0,d1z=0, d2x=0,d2y=0,d2z=0};
                self:setFillLevel(fillLevel, fillTypeInt, false, fillSourceStruct);
            end;
        end;
    end
    return BaseMission.VEHICLE_LOAD_OK;
end;
--
function LoadAble:getSaveAttributesAndNodes(nodeIdent)
    if self.synchronizeFillLevel then
        local fillType = LoadAble.fillTypeIntToName[self.currentFillType];
        if fillType == nil then
            fillType = "unknown";
        end;
        local attributes = 'fillLevel="'..self.fillLevel..'" fillType="'..fillType..'"';
        return attributes, nil;
    end
    return nil;
end;
--
function LoadAble:getXMLStatsAttributes()
    local fillType = LoadAble.fillTypeIntToName[self.currentFillType];
    if fillType == nil then
        fillType = "unknown";
    end
    return string.format('fillLevel="%.3f" fillType="%s"', self:getFillLevel(self.currentFillType), Utils.encodeToHTML(tostring(fillType)));
end
--
function LoadAble:addNodeVehicleMapping(list)
    list[self.fillRootNode] = self;
    list[self.exactFillRootNode] = self;
end;
--
function LoadAble:removeNodeVehicleMapping(list)
    list[self.fillRootNode] = nil;
    list[self.exactFillRootNode] = nil;
end;
--
function LoadAble:mouseEvent(posX, posY, isDown, isUp, button)
end;
--
function LoadAble:keyEvent(unicode, sym, modifier, isDown)
end;
--
function LoadAble:readStream(streamId, connection)
    if connection:getIsServer() then
        if self.synchronizeFillLevel then
            local fillLevel = streamReadFloat32(streamId);
            local fillType = streamReadUIntN(streamId, LoadAble.sendNumBits);
            local fillSourceStruct = {x=0,y=0,z=0, d1x=0,d1y=0,d1z=0, d2x=0,d2y=0,d2z=0};
            self:setFillLevel(fillLevel, fillType, false, fillSourceStruct);
            local lastValidFillType = streamReadUIntN(streamId, LoadAble.sendNumBits);
            self:setLastValidFillType(lastValidFillType, true);
        end
    end
    if self.supportsFillTriggers then
        local isFilling = streamReadBool(streamId);
        self:setIsFilling(isFilling, true);
    end;
end;
--
function LoadAble:writeStream(streamId, connection)
    if not connection:getIsServer() then
        if self.synchronizeFillLevel then
            streamWriteFloat32(streamId, self.fillLevel);
            streamWriteUIntN(streamId, self.currentFillType, LoadAble.sendNumBits);
            streamWriteUIntN(streamId, self.lastValidFillType, LoadAble.sendNumBits);
        end
    end;
    if self.supportsFillTriggers then
        streamWriteBool(streamId, self.isFilling);
    end;
end;
--
function LoadAble:readUpdateStream(streamId, timestamp, connection)
    if connection:getIsServer() then
        if self.synchronizeFillLevel then
            if streamReadBool(streamId) then
                local fillLevel;
                if self.synchronizeFullFillLevel then
                    fillLevel = streamReadFloat32(streamId);
                else
                    fillLevel = streamReadUInt16(streamId)/65535*self:getCapacity();
                end
                local fillType = streamReadUIntN(streamId, LoadAble.sendNumBits);
                self:setFillLevel(fillLevel, fillType, true);
                local lastValidFillType = streamReadUIntN(streamId, LoadAble.sendNumBits);
                self:setLastValidFillType(lastValidFillType, lastValidFillType ~= self.lastValidFillType); -- or self.currentFillType == LoadAble.FILLTYPE_UNKNOWN
            end;
        end
    end;
end;
--
function LoadAble:writeUpdateStream(streamId, connection, dirtyMask)
    if not connection:getIsServer() then
        if self.synchronizeFillLevel then
            if streamWriteBool(streamId, bitAND(dirtyMask, self.fillableDirtyFlag) ~= 0) then
                if self.synchronizeFullFillLevel then
                    streamWriteFloat32(streamId, self.fillLevel);
                else
                    local percent = 0;
                    if self:getCapacity() ~= 0 then
                        percent = Utils.clamp(self.fillLevel / self:getCapacity(), 0, 1);
                    end;
                    streamWriteUInt16(streamId, math.floor(percent*65535));
                end
                streamWriteUIntN(streamId, self.currentFillType, LoadAble.sendNumBits);
                streamWriteUIntN(streamId, self.lastValidFillType, LoadAble.sendNumBits);
            end;
        end
    end;
end;
--
function LoadAble:update(dt)
    if self.firstTimeRun then
        if self.isServer then
            if self.emptyMass == nil then
                self.emptyMass = getMass(self.fillMassNode);
                self.currentMass = self.emptyMass;
            end;
            local massScale = 0;
            if self.currentFillType ~= nil and self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN then
                massScale = LoadAble.fillTypeIndexToDesc[self.currentFillType].massPerLiter;
            end;
            local newMass = self.emptyMass + self.fillLevel*massScale;
            if newMass ~= self.currentMass then
                setMass(self.fillMassNode, newMass);
                self.currentMass = newMass;
            end;
        end;
    end;
    if self.isClient and (self:getIsActive() or self.tipState == Trailer.TIPSTATE_OPENING or self.tipState == Trailer.TIPSTATE_OPEN) then
        for _,deformer in pairs(self.fillVolumeDeformers) do
            if deformer.deformerIsDirty and deformer.polyline ~= nil and deformer.polyline ~= -1 then
                deformer.deformerIsDirty = false;
                local posX, _, posZ = localToLocal(deformer.node, deformer.baseNode, 0,0,0);
                local dirty = false;
                if math.abs(posX - deformer.posX) > 0.0001 or math.abs(posZ - deformer.posZ) > 0.0001 then
                    deformer.lastPosX = posX;
                    deformer.lastPosZ = posZ;
                    local dx = posX - deformer.initPos[1];
                    local dz = posZ - deformer.initPos[3];
                    setPolylineTranslation(deformer.volume, deformer.polyline, dx,dz);
                end;
            end;
        end;
        for _,fillVolumeHeight in pairs(self.fillVolumeHeights) do
            if fillVolumeHeight.volumeHeightIsDirty == true and self.fillVolumes[fillVolumeHeight.fillVolumeId] ~= nil then
                fillVolumeHeight.volumeHeightIsDirty = false;
                local baseNode = self.fillVolumes[fillVolumeHeight.fillVolumeId].baseNode;
                local volumeNode = self.fillVolumes[fillVolumeHeight.fillVolumeId].volume;
                if baseNode ~= nil and volumeNode ~= nil then
                    local minHeight = math.huge;
                    for _,refNode in pairs(fillVolumeHeight.refNodes) do
                        local x,_,z = localToLocal(refNode.refNode, baseNode, 0,0,0);
                        minHeight = math.min(minHeight, getFillPlaneHeightAtLocalPos(volumeNode, x,z));
                    end;
                    for _,node in pairs(fillVolumeHeight.nodes) do
                        local sx = node.scaleAxis[1]*minHeight;
                        local sy = node.scaleAxis[2]*minHeight;
                        local sz = node.scaleAxis[3]*minHeight;
                        if node.scaleMax[1] > 0 then
                            sx = math.min(node.scaleMax[1], sx);
                        end
                        if node.scaleMax[2] > 0 then
                            sy = math.min(node.scaleMax[2], sy);
                        end
                        if node.scaleMax[3] > 0 then
                            sz = math.min(node.scaleMax[3], sz);
                        end
                        local tx = node.transAxis[1]*minHeight;
                        local ty = node.transAxis[2]*minHeight;
                        local tz = node.transAxis[3]*minHeight;
                        if node.transMax[1] > 0 then
                            tx = math.min(node.transMax[1], tx);
                        end
                        if node.transMax[2] > 0 then
                            ty = math.min(node.transMax[2], ty);
                        end
                        if node.transMax[3] > 0 then
                            tz = math.min(node.transMax[3], tz);
                        end
                        setScale(node.node, node.baseScale[1]+sx, node.baseScale[2]+sy, node.baseScale[3]+sz);
                        setTranslation(node.node, node.basePosition[1]+tx, node.basePosition[2]+ty, node.basePosition[3]+tz);
                        if node.orientateToWorldY then
                            local dx,dy,dz = localDirectionToWorld(getParent(node.node), 0,1,0);
                            local alpha = math.acos(dy);
                            setRotation(node.node, alpha,0,0);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
--
function LoadAble:setMovingToolDirty(node)
    if self.fillVolumeDeformers[node] ~= nil then
        self.fillVolumeDeformers[node].deformerIsDirty = true;
    end;
    if self.fillVolumeHeightRefNodeToFillVolumeHeight[node] ~= nil then
        self.fillVolumeHeightRefNodeToFillVolumeHeight[node].volumeHeightIsDirty = true;
    end;
end
--
function LoadAble:updateTick(dt)
    if self.isServer then
        if self.synchronizeFillLevel then
            if self.fillLevel ~= self.sentFillLevel or self.currentFillType ~= self.sentFillType or self.lastValidFillType ~= self.sentLastValidFillType then
                self:raiseDirtyFlags(self.fillableDirtyFlag);
                self.sentLastValidFillType = self.lastValidFillType;
                self.sentFillLevel = self.fillLevel;
                self.sentFillType = self.currentFillType;
            end;
        end
        if self.shovelFillTrigger ~= nil then
            self.shovelFillTrigger:update(dt);
        end
        if self.isFilling then
            local delta = 0;
            local doFill = false;
            if self.fillTrigger ~= nil then
                if self.unitFillTime ~= nil then
                    self.currentFillTime = self.currentFillTime - dt;
                    if self.currentFillTime <= 0 then
                        doFill = true;
                        delta = self.fillTrigger:fill(self, 1);
                        self.currentFillTime = self.unitFillTime;
                    end;
                else
                    delta = self.fillLitersPerSecond*dt*0.001;
                    delta = self.fillTrigger:fill(self, delta);
                    doFill = true;
                end;
            end
            if delta <= 0 and doFill then
                self:setIsFilling(false);
            end;
        end
    end;
    if self.isClient then
        if self.measurementTime > 0 then
            self.measurementTime = self.measurementTime - dt;
            if self.measurementTime <= 0 then
                self:updateMeasurementNode();
            end;
        end;
    end;
end;
--
function LoadAble:draw()
    if self.isClient then
        if self:getDoRenderFillType() then
            local fillType = self:getOverlayFillType()
            if fillType ~= LoadAble.FILLTYPE_UNKNOWN then
                g_currentMission:setFillTypeOverlayFillType(fillType);
            end;
        end;
    end;
end;
--
function LoadAble:getAdditiveClientMass()
    local massScale = 0;
    if self.currentFillType ~= nil and self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN then
        massScale = LoadAble.fillTypeIndexToDesc[self.currentFillType].massPerLiter;
    end;
    return self.fillLevel*massScale;
end;
--
function LoadAble:resetFillLevelIfNeeded(fillType)
    if self.currentFillType ~= fillType then
        self.fillLevel = 0;
    end;
end;
--
function LoadAble:allowFillType(fillType, allowEmptying)
    local allowed = false;
    if self.fillTypes[fillType] then
        if self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN then
            if self.currentFillType ~= fillType then
                if self.fillLevel <= self:getCapacity()*self.fillTypeChangeThreshold then
                    allowed = true; -- fill level is low enough to be overridden
                    if allowEmptying then
                        self.fillLevel = 0; -- empty the trailer
                    end;
                end;
            else
                allowed = true; -- fill type is the same as the trailer's current fill type
            end;
        else
            allowed = true; -- fillable is empty --> LoadAble.FILLTYPE_UNKNOWN
        end;
    end;
    return allowed;
end;
--
function LoadAble:getFillLevel(fillType)
    if fillType == self.currentFillType then
        return self.fillLevel;
    end
    return 0;
end
--
function LoadAble:setFillLevel(fillLevel, fillType, force, fillSourceStruct)
    if (force == nil or force == false) and not self:allowFillType(fillType, false) then
        return
    end;
    if fillType ~= self.currentFillType then
        local maxPhysicalSurfaceAngle;
        if FruitUtil.fruitIndexToDesc[fillType] ~= nil then
            maxPhysicalSurfaceAngle = FruitUtil.fruitIndexToDesc[fillType].maxPhysicalSurfaceAngle;
        elseif LoadAble.fillTypeIntToName[fillType] ~= nil then
            maxPhysicalSurfaceAngle = LoadAble.fillTypeIntToName[fillType].maxPhysicalSurfaceAngle;
        end;
        if maxPhysicalSurfaceAngle ~= nil then
            for _,fillVolume in pairs(self.fillVolumes) do
                if fillVolume.volume ~= nil then
                    setFillPlaneMaxPhysicalSurfaceAngle(fillVolume.volume, maxPhysicalSurfaceAngle);
                end;
            end;
        end;
    end;
    if fillLevel < self.fillLevel and fillLevel < 0.0000001 then
        fillLevel = 0;
    end;
    local delta = math.min(fillLevel-self.fillLevel, self.capacity);
    local lastFillType = self.currentFillType;
    self.currentFillType = fillType;
    self.fillLevel = fillLevel;
    if self:getCapacity() == 0 then
        self.fillLevel = math.max(fillLevel, 0);
    else
        self.fillLevel = Utils.clamp(fillLevel, 0, self:getCapacity());
    end;
    if self.fillLevel <= 0 then
        self.fillLevel = 0;
        self.currentFillType = LoadAble.FILLTYPE_UNKNOWN;
    end;
    if self.unloadTrigger ~= nil then
        self.unloadTrigger.fillType = self.currentFillType;
    end;
    if self.isClient then
        if self.currentFillPlane ~= nil then
            for _, node in ipairs(self.currentFillPlane.nodes) do
                setVisibility(node.node, false);
            end;
            self.currentFillPlane = nil;
        end;
        if self.fillPlanes ~= nil and self.defaultFillPlane ~= nil then
            local fillPlane;
            local t = 0;
            if fillType ~= LoadAble.FILLTYPE_UNKNOWN then
                local fillTypeName = LoadAble.fillTypeIntToName[fillType];
                fillPlane = self.fillPlanes[fillTypeName];
                t = self.fillLevel/self:getCapacity();
            end
            if fillPlane == nil then
                fillPlane = self.defaultFillPlane
            end
            for _, node in ipairs(fillPlane.nodes) do
                local x,y,z, rx,ry,rz, sx,sy,sz = node.animCurve:get(t);
                setTranslation(node.node, x, y, z);
                setRotation(node.node, rx, ry, rz);
                setScale(node.node, sx, sy, sz);
                setVisibility(node.node, self.fillLevel > 0 or node.alwaysVisible);
            end;
            self.currentFillPlane = fillPlane;
        end;
        local materialId = nil;
        local isDefault = false;
        if self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN and self.currentFillType ~= lastFillType then
            local usedFillType = self.currentFillType;
            if self.forcedFillPlaneType ~= nil then
                usedFillType = self.forcedFillPlaneType;
            end;
            materialId, isDefault = LoadAble.getFillMaterial(usedFillType, LoadAble.MATERIAL_TYPE_FILLPLANE, 1);
        end;
        for _, fillVolume in pairs(self.fillVolumes) do
            setVisibility(fillVolume.volume, self.fillLevel > 0);
            if self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN and self.currentFillType ~= lastFillType then
                if isDefault and fillVolume.defaultFillType ~= nil then
                    materialId = LoadAble.getFillMaterial(fillVolume.defaultFillType, LoadAble.MATERIAL_TYPE_FILLPLANE, 1);
                end;
                if materialId ~= nil then
                    setMaterial(fillVolume.volume, materialId, 0);
                end;
            end;
            if fillSourceStruct ~= nil then
                local fss = fillSourceStruct;
                if Vehicle.debugRendering then
                    drawDebugLine( fss.x, fss.y, fss.z, 1,0,0, fss.x+fss.d1x, fss.y+fss.d1y, fss.z+fss.d1z, 1,0,0 );
                    drawDebugLine( fss.x, fss.y, fss.z, 0,0,1, fss.x+fss.d2x, fss.y+fss.d2y, fss.z+fss.d2z, 0,0,1 );
                    drawDebugPoint( fss.x, fss.y, fss.z, 1,1,1,1 );
                    drawDebugPoint( fss.x+fss.d1x, fss.y+fss.d1y, fss.z+fss.d1z, 1,0,0,1 );
                    drawDebugPoint( fss.x+fss.d2x, fss.y+fss.d2y, fss.z+fss.d2z, 0,0,1,1 );
                end;
                fss.x = fss.x - (fss.d1x + fss.d2x) / 2;
                fss.y = fss.y - (fss.d1y + fss.d2y) / 2;
                fss.z = fss.z - (fss.d1z + fss.d2z) / 2;
                fillPlaneAdd(fillVolume.volume, delta, fss.x,fss.y,fss.z, fss.d1x,fss.d1y,fss.d1z, fss.d2x,fss.d2y,fss.d2z);
            else
                local x,y,z = localToWorld(fillVolume.volume, 0,100,0);
                local d1x,d1y,d1z = localDirectionToWorld(fillVolume.volume, 5,0,0);
                local d2x,d2y,d2z = localDirectionToWorld(fillVolume.volume, 0,0,5);
                x = x - (d1x+d2x)/2;
                y = y - (d1y+d2y)/2;
                z = z - (d1z+d2z)/2;
                fillPlaneAdd(fillVolume.volume, delta, x,y,z, d1x,d1y,d1z, d2x,d2y,d2z);
            end;
        end;
    end;
    if self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN then
        self:setLastValidFillType(fillType, self.lastValidFillType ~= self.currentFillType);
    end
    self.measurementTime = 5000;
    self:updateMeasurementNode();
end;
--
function LoadAble:setCapacity(capacity)
    self.capacity = capacity;
end;
--
function LoadAble:getCapacity()
    return self.capacity;
end;
--
function LoadAble:getAllowFillFromAir()
    return self.allowFillFromAir;
end;
--
function LoadAble:getFirstEnabledFillType()
    for fillType, enabled in pairs(self.fillTypes) do
        if fillType ~= LoadAble.FILLTYPE_UNKNOWN and enabled then
            return fillType;
        end
    end
    return LoadAble.FILLTYPE_UNKNOWN;
end
--
function LoadAble:setLastValidFillType(lastValidFillType, hasChanged)
    if self.lastValidFillType ~= lastValidFillType then
        self.lastValidFillType = lastValidFillType;
    end;
end;
--
function LoadAble:getOverlayFillType()
    if self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN then
        return self.currentFillType;
    end;
    return LoadAble.FILLTYPE_UNKNOWN;
end;
--
function LoadAble:getDoRenderFillType()
    return self.currentFillType ~= LoadAble.FILLTYPE_UNKNOWN;
end;
--
function LoadAble:setIsFilling(isFilling, noEventSend)
    SetIsFillingEvent.sendEvent(self, isFilling, noEventSend)
     if self.isFilling ~= isFilling then
        self.isFilling = isFilling;
        self.fillTrigger = nil;
        if isFilling then
            -- find the first trigger which is activable
            for i, trigger in ipairs(self.fillTriggers) do
                if trigger:getIsActivatable(self) then
                    self.fillTrigger = trigger;
                    break;
                end;
            end;
        end
    end;
end;
--
function LoadAble:addFillTrigger(trigger)
    if table.getn(self.fillTriggers) == 0 then
        g_currentMission:addActivatableObject(self.fillActivatable);
    end;
    table.insert(self.fillTriggers, trigger);
end;
--
function LoadAble:removeFillTrigger(trigger)
    for i=1, table.getn(self.fillTriggers) do
        if self.fillTriggers[i] == trigger then
            table.remove(self.fillTriggers, i);
            break;
        end;
    end;
    if table.getn(self.fillTriggers) == 0 then
        if self.isServer then
            self:setIsFilling(false);
        end;
        g_currentMission:removeActivatableObject(self.fillActivatable);
    end;
end;
--
function LoadAble:updateMeasurementNode()
    if self.measurementNode ~= nil then
        local isWorking = 1;
        if self.measurementTime <= 0 then
            isWorking = 0;
        end;
        setShaderParameter(self.measurementNode, "fillLevel", self.fillLevel/self:getCapacity(), isWorking, 0, 0, false);
    end;
end;
--
function LoadAble:onAttach(attacherVehicle)
    if self.attacherPipe ~= nil then
        local vehicle = LoadAble.findAttacherPipeVehicle(self:getRootAttacherVehicle(), true);
        if vehicle ~= nil then
            self:attachPipe(self, vehicle);
        end;
    elseif self.attacherPipeRef ~= nil then
        local vehicle = LoadAble.findAttacherPipeVehicle(self:getRootAttacherVehicle(), false);
        if vehicle ~= nil then
            self:attachPipe(vehicle, self);
        end;
    end;
end;
--
function LoadAble:onDetach()
    self:detachPipe();
end;
--
function LoadAble:attachPipe(pipeVehicle, refVehicle)
    pipeVehicle.attacherPipeRefVehicle = refVehicle;
    refVehicle.attacherPipeVehicle = pipeVehicle;
    for _, movingPart in pairs(pipeVehicle.activeDirtyMovingParts) do
        if movingPart.node == pipeVehicle.attacherPipe then
            movingPart.referenceFrame = refVehicle.attacherPipeRef;
            movingPart.referenceFrameOffset = {0,0,0};
            Cylindered.updateMovingPart(self, movingPart, false);
            break;
        end;
    end;
end;
--
function LoadAble:detachPipe()
    if self.attacherPipeRefVehicle ~= nil then
        for _, movingPart in pairs(self.activeDirtyMovingParts) do
            if movingPart.node == self.attacherPipe then
                movingPart.referenceFrame = self.rootNode;
                break;
            end;
        end;
        self.attacherPipeRefVehicle.attacherPipeVehicle = nil;
        self.attacherPipeRefVehicle = nil;
    end;
    if self.attacherPipeVehicle ~= nil then
        for _, movingPart in pairs(self.attacherPipeVehicle.activeDirtyMovingParts) do
            if movingPart.node == self.attacherPipeVehicle.attacherPipe then
                movingPart.referenceFrame = self.attacherPipeVehicle.rootNode;
                break;
            end;
        end;
        self.attacherPipeVehicle.attacherPipeRefVehicle = nil;
        local attacherPipeVehicle = self.attacherPipeVehicle;
        self.attacherPipeVehicle = nil;
        -- try to reattach
        local vehicle = LoadAble.findAttacherPipeVehicle(attacherPipeVehicle:getRootAttacherVehicle(), true);
        if vehicle ~= nil then
            attacherPipeVehicle:attachPipe(attacherPipeVehicle, vehicle);
        end;
    end;
end;
--
function LoadAble.findAttacherPipeVehicle(currentVehicle, lookForPipeRef)
    if lookForPipeRef then
        if currentVehicle.attacherPipeRef ~= nil and currentVehicle.attacherPipeRefVehicle == nil then
            return currentVehicle;
        end;
    else
        if currentVehicle.attacherPipe ~= nil and currentVehicle.attacherPipeVehicle == nil then
            return currentVehicle;
        end;
    end;
    for _,implement in pairs(currentVehicle.attachedImplements) do
        if implement.object ~= nil then
            local ret = LoadAble.findAttacherPipeVehicle(implement.object, lookForPipeRef);
            if ret ~= nil then
                return ret;
            end
        end
    end
    return nil;
end



