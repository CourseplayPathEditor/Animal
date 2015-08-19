----
-- upsidedown project start: 7.11.2014
-- V1.0: released 11.11.2014
-- modules includes: shuttle, manMotorStart, gasGearLimiter





driveControl = {};
driveControl.Version = 3.51;

local driveControl_directory = g_currentModDirectory;

function driveControl:prerequisitesPresent(specializations)
    return true;
	--return SpecializationUtil.hasSpecialization(Steerable, specializations);
end;

function driveControl:load(xmlFile)
	if g_currentMission.driveControl == nil then
		g_currentMission.driveControl = {};
		g_currentMission.driveControl.useModules = {};
		g_currentMission.driveControl.useModules.shuttle = true;		
		g_currentMission.driveControl.useModules.manMotorStart = true;
		g_currentMission.driveControl.useModules.gasAndGearLimiter = false;
		g_currentMission.driveControl.useModules.hourCounter = true;
		g_currentMission.driveControl.useModules.sensibleSteering = true;
		g_currentMission.driveControl.useModules.manMotorKeepTurnedOn = true;
		g_currentMission.driveControl.useModules.handBrake = false;
		g_currentMission.driveControl.useModules.fourWDandDifferentials = true;
		g_currentMission.driveControl.useModules.inDoorSound = true;
		g_currentMission.driveControl.useModules.fruitDestruction = false; --not ready
		g_currentMission.driveControl.useModules.dirtModule = true;
		g_currentMission.driveControl.useModules.toggleActive = true;
		
		driveControl:loadConfigFile();
		
	end;
	
	self.driveControl = {};
	self.driveControl.noEnterCnt = 0;	
	
	self.driveControl.shuttle = {};
	self.driveControl.shuttle.direction = 1.0;
	self.driveControl.shuttle.onOffCnt = 0;
	self.driveControl.shuttle.isActive = true;
		
	self.driveControl.manMotorStart = {};
	self.driveControl.manMotorStart.isActive = true;
	self.driveControl.manMotorStart.isMotorStarted = false;
	self.driveControl.manMotorStart.startCnt = 0;
	self.driveControl.manMotorStart.wasHired = false;
	
	
	self.driveControl.gasGearLimiter = {};
	self.driveControl.gasGearLimiter.gasLimiter = 1.0;
	self.driveControl.gasGearLimiter.gearLimiter = 1.0;
	self.driveControl.gasGearLimiter.isSurpressed = false; --redo code later!
	
	self.driveControl.hourCounter = {};
	self.driveControl.hourCounter.hours = 0;
	
	self.driveControl.handBrake = {};
	self.driveControl.handBrake.isActive = g_currentMission.driveControl.useModules.handBrake;
	
	self.driveControl.fourWDandDifferentials = {};
	self.driveControl.fourWDandDifferentials.isSurpressed = false;
	self.driveControl.fourWDandDifferentials.fourWheel = false;
	self.driveControl.fourWDandDifferentials.diffLockFront = false;
	self.driveControl.fourWDandDifferentials.diffLockBack = false;
	self.driveControl.fourWDandDifferentials.fourWheelSet = true; --init differentials at startup
	self.driveControl.fourWDandDifferentials.diffLockFrontSet = true;--init differentials at startup
	self.driveControl.fourWDandDifferentials.diffLockBackSet = true;--init differentials at startup
	self.driveControl.fourWDandDifferentials.orgFuelUsage = 0;
	
	self.driveControl.inDoorSound = {};
	self.driveControl.inDoorSound.run2OutsideVolume = 0;
	driveControl.inDoorSoundFactor = Utils.getNoNil(driveControl.inDoorSoundFactor,0.45);
		
	
	self.driveControl.toggleActive = {};
	
	local iconWidth = math.floor(0.0095*1920)/1920;
		
	-- self.overlayArrowUp = Overlay:new("overlayArrowUp", Utils.getFilename("arrowUp.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.003,g_currentMission.speedHud.overlayValue1.y+0.076, iconWidth, iconWidth*16/9);
	-- self.overlayArrowDown = Overlay:new("overlayArrowDown", Utils.getFilename("arrowDown.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.003,g_currentMission.speedHud.overlayValue1.y+0.076, iconWidth, iconWidth*16/9);
	
	-- self.overlayBattery = Overlay:new("overlayBattery", Utils.getFilename("battery.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.037,g_currentMission.speedHud.overlayValue1.y+0.076, iconWidth, iconWidth*16/9);
	-- self.overlayPreHeat = Overlay:new("overlayPreHeat", Utils.getFilename("preHeat.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.037,g_currentMission.speedHud.overlayValue1.y+0.076, iconWidth, iconWidth*16/9);
	
	
	-- self.overlayGears = Overlay:new("overlayGears", Utils.getFilename("gears.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.037,g_currentMission.speedHud.overlayValue1.y+0.006, iconWidth, iconWidth*16/9);
	-- self.overlayPedals = Overlay:new("overlayPedals", Utils.getFilename("pedal.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.003,g_currentMission.speedHud.overlayValue1.y+0.006, iconWidth, iconWidth*16/9);
	
	
	-- self.overlayHourGlass = Overlay:new("overlayHourGlass", Utils.getFilename("hourGlass.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.049,g_currentMission.speedHud.overlayValue1.y-.002, 0.5*iconWidth, 0.5*iconWidth*16/9);
	
	-- self.overlayHandBrake = Overlay:new("overlayHandBrake", Utils.getFilename("handBrake.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.049,g_currentMission.speedHud.overlayValue1.y+0.076, 1.0*iconWidth, 1.0*iconWidth*16/9);
	
	
	-- self.overlay4WD = Overlay:new("overlay4WD", Utils.getFilename("4wd.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.049+1.0*0.010,g_currentMission.speedHud.overlayValue1.y+0.076, 1.0*iconWidth, 1.0*iconWidth*16/9);
	-- self.overlayDiffLockFront = Overlay:new("overlayDiffLockFront", Utils.getFilename("diffLockFront.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.049+2.0*0.010,g_currentMission.speedHud.overlayValue1.y+0.076, 1.0*iconWidth, 1.0*iconWidth*16/9);
	-- self.overlayDiffLockBack = Overlay:new("overlayDiffLockBack", Utils.getFilename("diffLockBack.dds", driveControl_directory), g_currentMission.speedHud.overlayValue1.x+.049+3.0*0.010,g_currentMission.speedHud.overlayValue1.y+0.076, 1.0*iconWidth, 1.0*iconWidth*16/9);
	
	if not driveControl.overlayArrowUp then -- aspect ratio independent code by Decker MMIV. Thx :)
        local iconWidth = math.floor(0.0095 * g_screenWidth) / g_screenWidth;
        local iconHeight = iconWidth * g_screenAspectRatio;
        local xAdjust = iconWidth * 0.25
        local yAdjust = iconHeight * 0.25
    
        local x,y = g_currentMission.speedHud.x,g_currentMission.speedHud.y;
        local w,h = g_currentMission.speedHud.width,g_currentMission.speedHud.height;
        local xIndent,yIndent = 0,0
    
        local halfTextW = getTextWidth(g_currentMission.speedUnitTextSize, "100%") / 2
    
        driveControl.overlayArrowUp   = Overlay:new("overlayArrowUp",   Utils.getFilename("arrowUp.dds",   driveControl_directory), x+xIndent-xAdjust,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
        driveControl.overlayArrowDown = Overlay:new("overlayArrowDown", Utils.getFilename("arrowDown.dds", driveControl_directory), x+xIndent-xAdjust,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
    
        driveControl.overlayBattery = Overlay:new("overlayBattery", Utils.getFilename("battery.dds", driveControl_directory), x+w-xIndent-iconWidth-xAdjust,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
        driveControl.overlayPreHeat = Overlay:new("overlayPreHeat", Utils.getFilename("preHeat.dds", driveControl_directory), x+w-xIndent-iconWidth-xAdjust,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
    
        driveControl.overlayHandBrake = Overlay:new("overlayHandBrake", Utils.getFilename("handBrake.dds", driveControl_directory), x+w,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
    
        driveControl.overlayPedals = Overlay:new("overlayPedals", Utils.getFilename("pedal.dds", driveControl_directory), x+xIndent-xAdjust,y+yIndent, iconWidth,iconHeight);
        driveControl.pedalsHudX,driveControl.pedalsHudY = driveControl.overlayPedals.x+driveControl.overlayPedals.width+halfTextW,driveControl.overlayPedals.y
    
        driveControl.overlayGears  = Overlay:new("overlayGears",  Utils.getFilename("gears.dds", driveControl_directory), x+w-xIndent-iconWidth,y+yIndent, iconWidth,iconHeight);
        driveControl.gearsHudX,driveControl.gearsHudY = driveControl.overlayGears.x-halfTextW,driveControl.overlayGears.y
    
        driveControl.overlayHourGlass = Overlay:new("overlayHourGlass", Utils.getFilename("hourGlass.dds", driveControl_directory), x+w+iconWidth,y+yIndent, 0.5*iconWidth,0.5*iconHeight);
        driveControl.hoursHudX,driveControl.hoursHudY = driveControl.overlayHourGlass.x+driveControl.overlayHourGlass.width,driveControl.overlayHourGlass.y

        driveControl.overlay4WD             = Overlay:new("overlay4WD",             Utils.getFilename("4wd.dds",            driveControl_directory), x+w+1.0*iconWidth,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
        driveControl.overlayDiffLockFront   = Overlay:new("overlayDiffLockFront",   Utils.getFilename("diffLockFront.dds",  driveControl_directory), x+w+2.0*iconWidth,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
        driveControl.overlayDiffLockBack    = Overlay:new("overlayDiffLockBack",    Utils.getFilename("diffLockBack.dds",   driveControl_directory), x+w+3.0*iconWidth,y+h-yIndent-iconHeight+yAdjust, iconWidth,iconHeight);
    end;
	
	self.driveControl.activeModules = {};
	for field,value in pairs(g_currentMission.driveControl.useModules) do
		self.driveControl.activeModules[field] = value;		
	end;
	self.driveControl.firstRunDone = false;
	self.dCcheckModule = driveControl.dCcheckModule;
	self.dCdeactivateModule = driveControl.dCdeactivateModule;
end;

function driveControl:dCdeactivateModule(module)
	print("driveControl module "..module.." externally turned off for this vehicle")
	self.driveControl.activeModules[module] = false;
end;

function driveControl:postLoad(xml) --testing only, postLoad is Tabu for dC
	-- if not self:dCcheckModule("manMotorStart") then
		-- self:dCdeactivateModule("manMotorKeepTurnedOn");
	-- end;
	
	-- -- if self.driveControl ~= nil then
		-- -- if self.dCdeactivateModule ~= nil then
			-- -- self:dCdeactivateModule("shuttle");		
		-- -- end;
	-- -- end;
end;

function driveControl:dCcheckModule(module)
	-- print("check module: "..module)
	return Utils.getNoNil(g_currentMission.driveControl.useModules[module],false) and Utils.getNoNil(self.driveControl.activeModules[module],false)
end;

function driveControl:loadConfigFile()
	local path = getUserProfileAppPath();
	
	local savegameIndex = g_currentMission.missionInfo.savegameIndex;
	local savegameFolderPath = g_currentMission.missionInfo.savegameDirectory;
	if savegameFolderPath == nil then
		savegameFolderPath = ('%ssavegame%d'):format(getUserProfileAppPath(), savegameIndex);
	end;	 
		
	if g_dedicatedServerInfo ~= nil or fileExists(savegameFolderPath .. '/driveControl_config.xml')then
		-- print("DEDI or save xml FOUND; DO CHANGED SAVE/LOAD!")
		path = savegameFolderPath;
		driveControl.savegameFolderPath = path.. '/driveControl_config.xml';
	end;
	
	local Xml;
	local file = path.."/driveControl_config.xml";
		
	if fileExists(file) then
		print("loading "..file.." for driveControl-Mod configuration");
		Xml = loadXMLFile("driveControl_XML", file, "driveControl");		
	else
		print("creating "..file.." for driveControl-Mod configuration");
		Xml = createXMLFile("driveControl_XML", file, "driveControl");
	end;
	
	-- local moduleList = {"shuttle", "manMotorStart","manMotorKeepTurnedOn","gasAndGearLimiter","hourCounter","sensibleSteering","handBrake","fourWDandDifferentials","inDoorSound","fruitDestruction"};
	local moduleList = {"shuttle", "manMotorStart","manMotorKeepTurnedOn","gasAndGearLimiter","hourCounter","sensibleSteering","handBrake","fourWDandDifferentials","inDoorSound","dirtModule"};
		
	for _,field in pairs(moduleList) do
		local XmlField = string.upper(string.sub(field,1,1))..string.sub(field,2);
		
		local res = getXMLBool(Xml, "driveControl.Modules."..XmlField);

		if res ~= nil then
			g_currentMission.driveControl.useModules[field] = res;
			if res then
				print("driveControl module "..field.." started")
			else
				print("driveControl module "..field.." not started");
			end;
		else
			setXMLBool(Xml, "driveControl.Modules."..XmlField, true);
			print("driveControl module "..field.." inserted into xml and started");
		end;
	end;
	
	if g_currentMission.driveControl.useModules.sensibleSteering then
		local res = getXMLFloat(Xml, "driveControl.SensibleSteering.deadZone");
		if res ~= nil then
			driveControl.loadedDeadZone = res;
			print("driveControl sensibleSteering deadZone set to "..tostring(math.floor(driveControl.loadedDeadZone*100)).."%")
		else
			driveControl.loadedDeadZone = getGamepadDefaultDeadzone();
			setXMLFloat(Xml, "driveControl.SensibleSteering.deadZone", driveControl.loadedDeadZone);
			print("driveControl sensibleSteering inserted into xml");
		end;		
	end;
	
	if g_currentMission.driveControl.useModules.inDoorSound then
		local res = getXMLFloat(Xml, "driveControl.inDoorSound.inDoorFactor");
		if res ~= nil then
			driveControl.inDoorSoundFactor  = res;
			print("driveControl inDoorSound set to "..tostring(math.floor(driveControl.inDoorSoundFactor*100)).."%")
		else
			setXMLFloat(Xml, "driveControl.inDoorSound.inDoorFactor", 0.45);
			print("driveControl inDoorSound inserted into xml");
		end;		
	end;
	if g_currentMission.driveControl.useModules.gasAndGearLimiter then
		local res = getXMLBool(Xml, "driveControl.gasAndGearLimiter.useAnalog");
		if res ~= nil then
			driveControl.gasAndGearLimiterAnalog = res;
			print("driveControl analog control for gas/gear limiter set to "..tostring(res))
		else
			setXMLBool(Xml, "driveControl.gasAndGearLimiter.useAnalog", false);
			driveControl.gasAndGearLimiterAnalog = false;
			print("driveControl analog control for gas/gear limiter inserted into xml (default off)");
		end;		
	end;
	
	
	if g_currentMission.driveControl.useModules.dirtModule then
		local res = getXMLFloat(Xml, "driveControl.dirtModule.timeFactor");
		if res ~= nil then
			driveControl.dirtModuleGlobalFactor  = res;
			print("driveControl dirtModule speed set to "..tostring(math.floor(res*100)).."%")
		else
			setXMLFloat(Xml, "driveControl.dirtModule.timeFactor", 1.0);
			print("driveControl dirtModule inserted into xml");
			driveControl.dirtModuleGlobalFactor = 1.0;
		end;
	end;
		
	saveXMLFile(Xml);
end;


function driveControl.driveControlFirstTimeRun(self)
	-- print("firstTimeRun()")
	-- if g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then
	
	if not self:dCcheckModule("manMotorStart") then
		self:dCdeactivateModule("manMotorKeepTurnedOn");
		self:dCdeactivateModule("toggleActive");		
	end;
	
	
	
	if self:dCcheckModule("manMotorKeepTurnedOn") then
		-- print("returned true")
		-- if g_currentMission.driveControl.useModules.manMotorStart then
		if self:dCcheckModule("manMotorStart") then
			self.stopMotorOnLeave = false;
			self.deactivateLightsOnLeave = false;
			self.deactivateOnLeave = false;
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.handBrake then
	if self:dCcheckModule("handBrake") then
		self.driveControl.handBrake.normalBrakeForce = self.motor.brakeForce;		
	end;
	
	--self.motor.minForwardGearRatio = 5*self.motor.minForwardGearRatio;    -- <== this makes full rpm at low speed
	 
	-- if g_currentMission.driveControl.useModules.gasAndGearLimiter then
	if self:dCcheckModule("gasAndGearLimiter") then
		self.driveControl.gasGearLimiter.originalMinForwardGearRatio = self.motor.minForwardGearRatio;
		self.driveControl.gasGearLimiter.originalMaxForwardGearRatio = self.motor.maxForwardGearRatio;
	
	end;
	
	self.driveControl.manMotorStart.motorMinRpm = self.motor.minRpm;
	
	-- if g_currentMission.driveControl.useModules.sensibleSteering then
	if self:dCcheckModule("sensibleSteering") then
		if driveControl.deadZone == nil then
			driveControl.deadZone = driveControl.loadedDeadZone; --getGamepadDefaultDeadzone();
			
			setGamepadDefaultDeadzone(0);
			InputBinding.update = Utils.overwrittenFunction(InputBinding.update,driveControl.IPTupdate);
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.fourWDandDifferentials then
	if self:dCcheckModule("fourWDandDifferentials") then
		if self.isServer then
			local hasStandardDiff = false;
			if self.differentials ~= nil then
				if table.getn(self.differentials) == 3 then
					local pattern = {true, true, false};
					hasStandardDiff = true;
					for k,differential in pairs(self.differentials) do
						hasStandardDiff = hasStandardDiff and differential.diffIndex1IsWheel==pattern[k] and differential.diffIndex2IsWheel==pattern[k];
					end;				
				end;
			end;
			if hasStandardDiff then
				self.driveControl.fourWDandDifferentials.orgFuelUsage = self.fuelUsage;
			else
				self.driveControl.fourWDandDifferentials.isSurpressed = true; --self.driveControl.fourWDandDifferentials.isSurpressed or not hasStandardDiff; 
			end;
		end;
	end;
	
	
	
	-- if g_currentMission.driveControl.useModules.inDoorSound then --sound
	if self:dCcheckModule("inDoorSound") then
		-- self.sampleMotorRun2
		-- self.motorRun2VolumeMax
		if self.sampleMotorRun2 ~= nil and self.motorRun2VolumeMax ~= nil then
			self.driveControl.inDoorSound.run2OutsideVolume = self.motorRun2VolumeMax;
		end;
	end;
	
end;

function driveControl.IPTupdate(self,oldFunc,dt)
	--
	oldFunc(dt)
	-- 
	for actionIndex, actionData in pairs(InputBinding.actions) do
		if actionData.isAnalogAction then
			if actionData.lastInputType == InputBinding.INPUTTYPE_GAMEPAD_AXIS then
				-- if actionIndex ~= InputBinding["AXIS_MOVE_SIDE_VEHICLE"] then 
				if actionIndex ~= InputBinding["AXIS_MOVE_SIDE_VEHICLE"] and actionIndex ~= InputBinding["driveControlGearLimiterUpDown"] then
					local deadZone = Utils.getNoNil(driveControl.deadZone,0.1);
					if math.abs(actionData.lastInputAxis) < deadZone then
						actionData.lastInputAxis = 0;
					else
						local minus = actionData.lastInputAxis < 0;
						actionData.lastInputAxis = (math.abs(actionData.lastInputAxis) - deadZone)/(1-deadZone);
						if minus then
							actionData.lastInputAxis = -actionData.lastInputAxis;
						end;
					end;
				end;
			end;
		end;
	end;
	
end;

function driveControl:motorStop(self,doStopSounds)	
	self.isMotorStarted = false;
	if Utils.getNoNil(doStopSounds,false) then 
		self:stopMotor(true);
	else
		Motorized.stopSounds(self);
		if self.exhaustParticleSystems ~= nil then
			Utils.setEmittingState(self.exhaustParticleSystems, false)
		end;
		
		if self.exhaustEffects~= nil then
			for _,effect in pairs(self.exhaustEffects) do
				setVisibility(effect.node,false);
			end;
		end;
	end;
	
	self.motor.minRpm = 0;
	--print("motor turned off on enter")
end;


function driveControl:motorStart(self)
	-- self:startMotor(g_server == nil);
	self:startMotor(true);
	if self.exhaustParticleSystems ~= nil then
		Utils.setEmittingState(self.exhaustParticleSystems, true)
	end;
	
	if self.exhaustEffects~= nil then
		for _,effect in pairs(self.exhaustEffects) do
			setVisibility(effect.node,true);
		end;
	end;
	self.motor.minRpm = self.driveControl.manMotorStart.motorMinRpm;
end;

function driveControl:onLeave()
	-- print("dC: leave")
	
	-- if g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then	
	if self:dCcheckModule("manMotorKeepTurnedOn") then	
		if true then
			local vehicles = driveControl.getAllConnectedVehicles(self);
			for k,vehicle in pairs(vehicles) do
				vehicle.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			end;
		else
			self.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			for _,implement in pairs(self.attachedImplements) do
				implement.object.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			end;
		end;
		if self.driveControl.manMotorStart.lastLightMask ~= nil then
			self:setLightsTypesMask(self.driveControl.manMotorStart.lastLightMask, true);
		end;
	end;
	
	
	self.axisForward = 0;
	if self.isServer then
		Drivable.updateVehiclePhysics(self, 0, false, 0, false, 15)
	end;
end;


function driveControl:onEnter()
	-- if g_currentMission.driveControl.useModules.manMotorStart then
	if self:dCcheckModule("manMotorKeepTurnedOn") then	
		if not self.driveControl.manMotorStart.isMotorStarted then
			driveControl:motorStop(self,false)
		end;
	end;
end;

function driveControl:mouseEvent(posX, posY, isDown, isUp, button)
end;

function driveControl:keyEvent(unicode, sym, modifier, isDown)
end;

function driveControl:updateTick(dt)

	-- local vehicles = driveControl.getAllConnectedVehicles(self);
	-- for k,vehicle in pairs(vehicles) do
		-- print(vehicle.typeDesc.." ",tostring(vehicle.forceIsActive))
	-- end;

	-- if g_currentMission.driveControl.useModules.manMotorStart and g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then
	if self:dCcheckModule("manMotorStart") and self:dCcheckModule("manMotorKeepTurnedOn") then	
		if not self.driveControl.manMotorStart.isMotorStarted then
			if self:getIsActive() then				
				local vehicles = driveControl.getAllConnectedVehicles(self);
				for k,vehicle in pairs(vehicles) do
					if vehicle.isTurnedOn then
						vehicle:setIsTurnedOn(false, true);
					end;
				end;
			end;
		end;
	end;
	
	-- if false and g_currentMission.driveControl.useModules.inDoorSound then
	if false and self:dCcheckModule("inDoorSound") then 
		if self:getIsActiveForSound() then
			if self.sampleMotor ~= nil then
				local isIndoor = false;
				for _,camera in pairs(self.cameras) do
					if camera.isInside and camera.isActivated then
						isIndoor = true;
						break;
					end;
				end;
				local samples = {self.sampleMotor, sampleMotorRun2, self.sampleMotorStart, self.sampleMotorStop, self.sampleThreshingStop, self.sampleHonk, self.sampleRefuel, self.samplePipe, self.sampleThreshingStart, self.sampleReverseDrive, self.sampleThreshing, self.sampleCompression, self.sampleHydraulic, self.sampleCompressedAir, self.sampleCylinderedHydraulic};
				for _,sample in pairs(samples) do
					if sample ~= nil then --and sample.isPlaying then
						--local volume = getSampleVolume(sample.sample)
						-- print(volume)
						
						-- self.sampleMotorRun2
						-- self.motorRun2VolumeMax
						
						local targetVolume = sample.volume;
						if isIndoor then
							targetVolume = driveControl.inDoorSoundFactor*targetVolume;
						end;
						if sample.sample~= nil then --or volume ~= targetVolume then
							setSampleVolume(sample.sample,targetVolume)
						end;					
					end;	
				end;
				
				if self.driveControl.inDoorSound.run2OutsideVolume > 0 then
					if isIndoor then
						self.motorRun2VolumeMax = driveControl.inDoorSoundFactor*self.driveControl.inDoorSound.run2OutsideVolume;
					else
						self.motorRun2VolumeMax = self.driveControl.inDoorSound.run2OutsideVolume;						
					end;
				end;
				
			end;
		end;
	end;
	
	
	-- if g_currentMission.driveControl.useModules.fourWDandDifferentials and not self.driveControl.fourWDandDifferentials.isSurpressed then
	if self:dCcheckModule("fourWDandDifferentials") and not self.driveControl.fourWDandDifferentials.isSurpressed then	
		if self.isServer then
			if self.driveControl.fourWDandDifferentials.fourWheel ~= self.driveControl.fourWDandDifferentials.fourWheelSet then
				if self.driveControl.fourWDandDifferentials.fourWheel then
					-- updateDifferential(self.rootNode,2,self.differentials[3].torqueRatio,self.differentials[3].maxSpeedRatio*1000); --reset 4wd (ON)
					updateDifferential(self.rootNode,2,self.differentials[3].torqueRatio,1.0); --reset 4wd (ON) --Slomo edition
				else
					updateDifferential(self.rootNode,2,0,0) --4wd off, traction to back
				end;		
				self.driveControl.fourWDandDifferentials.fourWheelSet = self.driveControl.fourWDandDifferentials.fourWheel;
			end;
			
			if self.driveControl.fourWDandDifferentials.diffLockFront ~= self.driveControl.fourWDandDifferentials.diffLockFrontSet then
				if self.driveControl.fourWDandDifferentials.diffLockFront then
					updateDifferential(self.rootNode,0,0.5,1.0)  --differential lock front
				else
					updateDifferential(self.rootNode,0,self.differentials[1].torqueRatio,self.differentials[1].maxSpeedRatio*1000); --reset diff-lock front
				end;		
				self.driveControl.fourWDandDifferentials.diffLockFrontSet = self.driveControl.fourWDandDifferentials.diffLockFront;
			end;
			
			if self.driveControl.fourWDandDifferentials.diffLockBack ~= self.driveControl.fourWDandDifferentials.diffLockBackSet then
				if self.driveControl.fourWDandDifferentials.diffLockBack then
					updateDifferential(self.rootNode,1,0.5,1.0) --differential lock back
				else
					updateDifferential(self.rootNode,1,self.differentials[2].torqueRatio,self.differentials[2].maxSpeedRatio*1000); --reset diff-lock front (ON)
				end;
				self.driveControl.fourWDandDifferentials.diffLockBackSet = self.driveControl.fourWDandDifferentials.diffLockBack;
			end;
		end;
		local factor = 1.0;
		if self.driveControl.fourWDandDifferentials.fourWheel then
			factor = factor*1.03;
		end;
		if self.driveControl.fourWDandDifferentials.diffLockFront then
			factor = factor*1.06;
		end;
		if self.driveControl.fourWDandDifferentials.diffLockBack then
			factor = factor*1.06;
		end;
		if self:getIsActive(false) then
			-- print(self.fuelFillLevel)
			-- print(self.fuelUsage*1e6)
			-- self.fuelUsage = self.driveControl.fourWDandDifferentials.orgFuelUsage * factor;
			-- print(self.fuelUsage*1e6)
			-- print("==========")
		end;
	end;
	
	
	
	if self:dCcheckModule("manMotorKeepTurnedOn") then
	-- if g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then
		-- if g_currentMission.driveControl.useModules.manMotorStart then
		if self:dCcheckModule("manMotorStart") then
			self.stopMotorOnLeave = false;
			self.deactivateLightsOnLeave = false;
			self.deactivateOnLeave = false;
		end;
	end;
	
	
	-- if g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then		
		-- if self.driveControl.manMotorStart.isMotorStarted then
			-- self.forceIsActive = true;
			-- -- self.onLeave = driveControl.newOnLeave;
			-- for _,implement in pairs(self.attachedImplements) do
				-- implement.object.forceIsActive = true;				
			-- end;
		-- end;
	-- end;
	
	-- if g_currentMission.driveControl.useModules.manMotorKeepTurnedOn then				
	if self:dCcheckModule("manMotorKeepTurnedOn") then
		if true then
			local vehicles = driveControl.getAllConnectedVehicles(self);
			for k,vehicle in pairs(vehicles) do
				vehicle.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			end;
		else
			self.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			for _,implement in pairs(self.attachedImplements) do
				implement.object.forceIsActive = self.driveControl.manMotorStart.isMotorStarted;
			end;
		end;	
	end;
		
	-- if g_currentMission.driveControl.useModules.hourCounter then
	if self:dCcheckModule("hourCounter") then
		if self.isMotorStarted then
			self.driveControl.hourCounter.hours = self.driveControl.hourCounter.hours + 1.0*dt/(1000*3600);			
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.handBrake then
	if self:dCcheckModule("handBrake") then
		if self.driveControl.handBrake.isActive then
			if self.cruiseControl.state > 0 then
				self:setCruiseControlState(0); --no cruise control with applied handbrake..
			end;
		end;
	end;
	
		
	if self.isHired then		
		-- if g_currentMission.driveControl.useModules.handBrake then
		if self:dCcheckModule("handBrake") then
			self.driveControl.handBrake.isActive = false;		
		end;
		-- if g_currentMission.driveControl.useModules.manMotorStart then
		if self:dCcheckModule("manMotorStart") then
			self.driveControl.manMotorStart.isMotorStarted = true;		
		end;
		self.driveControl.manMotorStart.wasHired = true;		
	else
		
		if self.driveControl.manMotorStart.wasHired then				
			if not self.isEntered then
				-- if g_currentMission.driveControl.useModules.manMotorStart then
				if self:dCcheckModule("manMotorStart") then
					self.driveControl.manMotorStart.isMotorStarted = false;		
				end;
				-- if g_currentMission.driveControl.useModules.handBrake then
				if self:dCcheckModule("handBrake") then
					self.driveControl.handBrake.isActive = true;		
				end;
			end;
		end;
		self.driveControl.manMotorStart.wasHired = false;
	end;
	
	
	
	-- if g_currentMission.driveControl.useModules.manMotorStart then
	if self:dCcheckModule("manMotorStart") then
		self.driveControl.manMotorStart.lastLightMask = self.lightsTypesMask; --TEST
		if self.fuelFillLevel < 0.1 then
			self.driveControl.manMotorStart.isMotorStarted = false;
		end;
		
		if self.driveControl.manMotorStart.isMotorStarted ~= self.isMotorStarted then
			if self.driveControl.manMotorStart.isMotorStarted then --turn on
				driveControl:motorStart(self)
			else --turn off
				driveControl:motorStop(self,true)
			end;		
		end;	
	end;
	
	-- if g_currentMission.driveControl.useModules.gasAndGearLimiter then
	if self:dCcheckModule("gasAndGearLimiter") then
		if self.isServer then
			local overDrive = 2.0;
			
			local factor = 1/self.driveControl.gasGearLimiter.gearLimiter;
			
			local maxFac = self.driveControl.gasGearLimiter.originalMaxForwardGearRatio/self.driveControl.gasGearLimiter.originalMinForwardGearRatio;
			--print(maxFac)
			
			factor = Utils.clamp(factor,1.0,overDrive*maxFac);
			
			self.motor.minForwardGearRatio = factor * self.driveControl.gasGearLimiter.originalMinForwardGearRatio;
			if factor > maxFac then --we do gear overdrive
				self.motor.maxForwardGearRatio = self.motor.minForwardGearRatio;
				--print("overdrive")
			else
				self.motor.maxForwardGearRatio = self.driveControl.gasGearLimiter.originalMaxForwardGearRatio;
			end;
			
			--self.motor.minForwardGearRatio = self.driveControl.gasGearLimiter.originalMinForwardGearRatio;
			
			
		end;
	end;
	
	-- if true then
		-- if self:getIsActive() then
			-- local rootVehicle = self:getRootAttacherVehicle();
			
			-- local maxSpeed = 120;
			-- if rootVehicle.cruiseControl ~= nil then
				-- if rootVehicle.cruiseControl.maxSpeed < maxSpeed then
					-- maxSpeed = rootVehicle.cruiseControl.maxSpeed;
				-- end;
			-- end;
			-- if rootVehicle.motor ~= nil then
				-- if rootVehicle.motor.speedLimit < maxSpeed then
					-- maxSpeed = rootVehicle.motor.speedLimit;
				-- end;
			-- end;
			
			-- local globalFactor = 2000; --get from XML!
			-- local speedFactor = self.lastSpeed*3600/maxSpeed;
			-- self.dirtDuration = globalFactor*speedFactor*self.driveControl.dirtModule.dirtDuration;			
		-- end;
	-- end;	
end;

function driveControl:update(dt)
	
	if not self.driveControl.firstRunDone then
		-- print("try run")
		driveControl.driveControlFirstTimeRun(self);
		self.driveControl.firstRunDone = true;
	end;

	if self:dCcheckModule("toggleActive") then
		if self:getIsActiveForInput(false) then
			if InputBinding.hasEvent(InputBinding.driveControlActiveVehicleSwitcher,true) then
				driveControl:toggleVehicle(1);
			end;
			if InputBinding.hasEvent(InputBinding.driveControlActiveVehicleSwitcherDown,true) then
				driveControl:toggleVehicle(-1);
			end;
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.inDoorSound then
	if self:dCcheckModule("inDoorSound") then
		if self:getIsActiveForSound() then
			if self.sampleMotor ~= nil then
				local isIndoor = false;
				for _,camera in pairs(self.cameras) do
					if camera.isInside and camera.isActivated then
						isIndoor = true;
						break;
					end;
				end;
				-- local samples = {self.sampleMotor, self.sampleMotorRun2, self.sampleMotorStart, self.sampleMotorStop, self.sampleThreshingStop, self.sampleHonk, self.sampleRefuel, self.samplePipe, self.sampleThreshingStart, self.sampleReverseDrive, self.sampleThreshing, self.sampleCompression, self.sampleHydraulic, self.sampleCompressedAir, self.sampleCylinderedHydraulic};
				local samples = {self.sampleMotor, self.sampleMotorStart, self.sampleMotorStop, self.sampleThreshingStop, self.sampleHonk, self.sampleRefuel, self.samplePipe, self.sampleThreshingStart, self.sampleReverseDrive, self.sampleThreshing, self.sampleCompression, self.sampleHydraulic, self.sampleCompressedAir, self.sampleCylinderedHydraulic};
				
				for _,sample in pairs(samples) do
					if sample ~= nil then --and sample.isPlaying then
						--local volume = getSampleVolume(sample.sample)
						-- print(volume)
						
						-- self.sampleMotorRun2
						-- self.motorRun2VolumeMax
						
						local targetVolume = sample.volume;
						if isIndoor then
							targetVolume = driveControl.inDoorSoundFactor*targetVolume;
						end;
						if sample.sample~= nil then --or volume ~= targetVolume then
							setSampleVolume(sample.sample,targetVolume)
						end;					
					end;	
				end;
				-- print(self.motorRun2VolumeMax)
				
				--
				-- local volume = getSampleVolume(self.sampleMotor.sample)				
				-- print(volume)
				
				if false and self.driveControl.inDoorSound.run2OutsideVolume > 0 then --doesnt work
					if isIndoor then
						self.motorRun2VolumeMax = driveControl.inDoorSoundFactor*self.driveControl.inDoorSound.run2OutsideVolume;
						local volume = getSampleVolume(self.sampleMotorRun2.sample)
						
						setSampleVolume(self.sampleMotorRun2.sample,driveControl.inDoorSoundFactor*volume)
						-- local offset = getSamplePlayOffset(self.sampleMotorRun2.sample);
						-- stopSample(self.sampleMotorRun2.sample);
						-- playSample(self.sampleMotorRun2.sample,0,driveControl.inDoorSoundFactor*volume,offset)						
					else
						self.motorRun2VolumeMax = self.driveControl.inDoorSound.run2OutsideVolume;						
					end;
				end;
				-- volume = getSampleVolume(self.sampleMotorRun2.sample)
				-- print(volume)
				-- print("==============")				
			end;
		end;
	end;
	
	
	
	if g_gui.currentGuiName == nil or g_gui.currentGuiName == "" then
		self.driveControl.noEnterCnt = math.max(self.driveControl.noEnterCnt - 1,-1);
	else
		self.driveControl.noEnterCnt = 20;
	end;
	
		
	if self:getIsActiveForInput(false) or (g_currentMission.controlledVehicle == self and (g_gui.currentGuiName == nil or g_gui.currentGuiName == "")) then 
		if self.driveControl.noEnterCnt > 0 then
			return;
		end;
		--local rot,clutch,motorLoad = getMotorRotationSpeed(self.rootNode);
		--print(rot," ",clutch," ",motorLoad)
		-- print(self.motor.clutchRpm)
		-- self.motor.maxClutchTorque = 50000;
		if self:dCcheckModule("fourWDandDifferentials") and not self.driveControl.fourWDandDifferentials.isSurpressed then
			if InputBinding.hasEvent(InputBinding.driveControl4WD) then
				self.driveControl.fourWDandDifferentials.fourWheel = not self.driveControl.fourWDandDifferentials.fourWheel;
				driveControlInputEvent.sendEvent(self)  
			end;
			
			if InputBinding.hasEvent(InputBinding.driveControlDiffLockFront) then
				self.driveControl.fourWDandDifferentials.diffLockFront = not self.driveControl.fourWDandDifferentials.diffLockFront;
				driveControlInputEvent.sendEvent(self) 
			end;
			
			if InputBinding.hasEvent(InputBinding.driveControlDiffLockBack) then
				self.driveControl.fourWDandDifferentials.diffLockBack = not self.driveControl.fourWDandDifferentials.diffLockBack;
				driveControlInputEvent.sendEvent(self) 
			end;
		end;
		
		
		
		-- if g_currentMission.driveControl.useModules.manMotorStart then --manual motor start
		if self:dCcheckModule("manMotorStart") then --manual motor start
			if self.driveControl.manMotorStart.isMotorStarted then
				if InputBinding.hasEvent(InputBinding.driveControlMotor) or InputBinding.isPressed(InputBinding.driveControlMotorOff) then --turn off
					self.driveControl.manMotorStart.isMotorStarted = false;
					driveControlInputEvent.sendEvent(self)
					--driveControl:motorStop(self,true)
				end;
				self.driveControl.manMotorStart.startCnt = 0;
			else
				if InputBinding.isPressed(InputBinding.driveControlMotor) or (InputBinding.isPressed(InputBinding.driveControlMotorOn) and not InputBinding.isPressed(InputBinding.driveControlMotorOff)) then
					self.driveControl.manMotorStart.startCnt = self.driveControl.manMotorStart.startCnt + dt;
				else
					self.driveControl.manMotorStart.startCnt = 0;
				end;
				
				if self.driveControl.manMotorStart.startCnt > 800 then --turn on
					--print("start")
					--driveControl:motorStart(self)
					self.driveControl.manMotorStart.isMotorStarted = true;
					driveControlInputEvent.sendEvent(self)
				end;
			
			end;
		end;
		---------------------------------
		
		-- if g_currentMission.driveControl.useModules.gasAndGearLimiter then
		if self:dCcheckModule("gasAndGearLimiter") then
			if driveControl.gasAndGearLimiterAnalog then
				local analogAxis = InputBinding.getAnalogInputAxis(InputBinding.driveControlGearLimiterUpDown);
				analogAxis = (analogAxis +1)/2;
				self.driveControl.gasGearLimiter.gearLimiter = Utils.clamp(analogAxis,0,1);
				
				analogAxis = InputBinding.getAnalogInputAxis(InputBinding.driveControlGasLimiterUpDown);
				analogAxis = (analogAxis +1)/2;
				self.driveControl.gasGearLimiter.gasLimiter = Utils.clamp(analogAxis,0,1);
			else
				local change = 0.0002*dt;
				if InputBinding.isPressed(InputBinding.driveControlGearLimiterUp) then
					local oldValue = self.driveControl.gasGearLimiter.gearLimiter;
					self.driveControl.gasGearLimiter.gearLimiter = self.driveControl.gasGearLimiter.gearLimiter + change;
					self.driveControl.gasGearLimiter.gearLimiter = Utils.clamp(self.driveControl.gasGearLimiter.gearLimiter,0,1);
					if self.driveControl.gasGearLimiter.gearLimiter ~= oldValue then
						driveControlInputEvent.sendEvent(self);
						-- print("gear: ",self.driveControl.gasGearLimiter.gearLimiter*100)
					end;
				end;
				
				if InputBinding.isPressed(InputBinding.driveControlGearLimiterDown) then
					local oldValue = self.driveControl.gasGearLimiter.gearLimiter;
					self.driveControl.gasGearLimiter.gearLimiter = self.driveControl.gasGearLimiter.gearLimiter - change;
					self.driveControl.gasGearLimiter.gearLimiter = Utils.clamp(self.driveControl.gasGearLimiter.gearLimiter,0,1);
					if self.driveControl.gasGearLimiter.gearLimiter ~= oldValue then
						driveControlInputEvent.sendEvent(self);
						-- print("gear: ",self.driveControl.gasGearLimiter.gearLimiter*100)
					end;
				end;
			
			
				if InputBinding.isPressed(InputBinding.driveControlGasLimiterUp) then
					local oldValue = self.driveControl.gasGearLimiter.gasLimiter;
					self.driveControl.gasGearLimiter.gasLimiter = self.driveControl.gasGearLimiter.gasLimiter + change;
					self.driveControl.gasGearLimiter.gasLimiter = Utils.clamp(self.driveControl.gasGearLimiter.gasLimiter,0,1);
					if self.driveControl.gasGearLimiter.gasLimiter ~= oldValue then
						driveControlInputEvent.sendEvent(self);
						-- print("gas: ",self.driveControl.gasGearLimiter.gasLimiter*100)
					end;
				end;
				
				if InputBinding.isPressed(InputBinding.driveControlGasLimiterDown) then
					local oldValue = self.driveControl.gasGearLimiter.gasLimiter;
					self.driveControl.gasGearLimiter.gasLimiter = self.driveControl.gasGearLimiter.gasLimiter - change;
					self.driveControl.gasGearLimiter.gasLimiter = Utils.clamp(self.driveControl.gasGearLimiter.gasLimiter,0,1);
					if self.driveControl.gasGearLimiter.gasLimiter ~= oldValue then
						driveControlInputEvent.sendEvent(self);
						-- print("gas: ",self.driveControl.gasGearLimiter.gasLimiter*100)
					end;
				end;				
			end;		
		end;
	
		---------------------------------
		
		-- if g_currentMission.driveControl.useModules.handBrake then
		if self:dCcheckModule("handBrake") then
			if InputBinding.hasEvent(InputBinding.driveControlHandbrake) then
				self.driveControl.handBrake.isActive = not self.driveControl.handBrake.isActive;
				--print("handbrake: "..tostring(self.driveControl.handBrake.isActive))
				driveControlInputEvent.sendEvent(self) 
			end;
		end;
		
		
		-- if g_currentMission.driveControl.useModules.shuttle then
		if self:dCcheckModule("shuttle") then
			if InputBinding.isPressed(InputBinding.driveControlShuttle) then
				self.driveControl.shuttle.onOffCnt = self.driveControl.shuttle.onOffCnt + dt;
			else
				self.driveControl.shuttle.onOffCnt = 0;
			end;
			if self.driveControl.shuttle.onOffCnt > 2500 or InputBinding.hasEvent(InputBinding.driveControlShuttleOnOff) then
				self.driveControl.shuttle.isActive = not self.driveControl.shuttle.isActive;
				self.driveControl.shuttle.onOffCnt = -100000000000000000000000;
				--print("shuttle turned ",self.driveControl.shuttle.isActive)				
				driveControlInputEvent.sendEvent(self) 
			end;
			
			
			
			if self.driveControl.shuttle.isActive then
				if InputBinding.hasEvent(InputBinding.driveControlShuttleForward) then
					self.driveControl.shuttle.direction = 1.0;					
					driveControlInputEvent.sendEvent(self)
				end;
				if InputBinding.hasEvent(InputBinding.driveControlShuttleBackward) then
					self.driveControl.shuttle.direction = -1.0;					
					driveControlInputEvent.sendEvent(self)
				end;
				if InputBinding.hasEvent(InputBinding.driveControlShuttle) then
					self.driveControl.shuttle.direction = -self.driveControl.shuttle.direction;					
					driveControlInputEvent.sendEvent(self)
				end;				
			end;
		end;
				
	end;
end;


function driveControl:draw()
	
	if self:dCcheckModule("handBrake") then
	-- if g_currentMission.driveControl.useModules.handBrake then
		if self.driveControl.handBrake.isActive then
			driveControl.overlayHandBrake:render();
		end;
	end;

	-- if g_currentMission.driveControl.useModules.fourWDandDifferentials then
	if self:dCcheckModule("fourWDandDifferentials") then
		if self.driveControl.fourWDandDifferentials.fourWheel then
			driveControl.overlay4WD:render();
		end;
		if self.driveControl.fourWDandDifferentials.diffLockFront then
			driveControl.overlayDiffLockFront:render();
		end;
		if self.driveControl.fourWDandDifferentials.diffLockBack then
			driveControl.overlayDiffLockBack:render();
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.hourCounter then
	if self:dCcheckModule("hourCounter") then
		--render icon:render();
		--self.driveControl.hourCounter.hours
		driveControl.overlayHourGlass:render();
		
		setTextBold(false);
		setTextAlignment(RenderText.ALIGN_LEFT);
		setTextColor(0.6307, 0.6307, 0.6307, 1);
		-- local str = tostring(math.floor(self.driveControl.hourCounter.hours*10)/10).." h"
		local str = string.format("%.1f h",self.driveControl.hourCounter.hours);
		renderText(driveControl.hoursHudX,driveControl.hoursHudY, g_currentMission.speedUnitTextSize,str)
	end;
	
	-- if g_currentMission.driveControl.useModules.manMotorStart then
	if self:dCcheckModule("manMotorStart") then
		if not self.driveControl.manMotorStart.isMotorStarted then
			if self.driveControl.manMotorStart.startCnt > 0 then
				driveControl.overlayPreHeat:render();
			else
				driveControl.overlayBattery:render();
			end;		
		end;
	end;
	
	if self:dCcheckModule("shuttle") then
	-- if g_currentMission.driveControl.useModules.shuttle then
		if self.driveControl.shuttle.isActive then
			if self.driveControl.shuttle.direction > 0 then
				driveControl.overlayArrowUp:render();
			else
				driveControl.overlayArrowDown:render();
			end;
		end;
	end;
	
	-- if g_currentMission.driveControl.useModules.gasAndGearLimiter then
	if self:dCcheckModule("gasAndGearLimiter") then
		driveControl.overlayGears:render()
		driveControl.overlayPedals:render()
		
		setTextBold(false);
		setTextAlignment(RenderText.ALIGN_CENTER);
		setTextColor(0.6307, 0.6307, 0.6307, 1);
		local str = tostring(math.floor(self.driveControl.gasGearLimiter.gasLimiter*100)).."%"
		renderText(driveControl.pedalsHudX,driveControl.pedalsHudY, g_currentMission.speedUnitTextSize,str)
		
		str = tostring(math.floor(self.driveControl.gasGearLimiter.gearLimiter*100)).."%"
		renderText(driveControl.gearsHudX,driveControl.gearsHudY, g_currentMission.speedUnitTextSize,str)
		setTextAlignment(RenderText.ALIGN_LEFT);
		setTextColor(1, 1, 1, 1);
	end;			
end;

function driveControl:getSaveAttributesAndNodes(nodeIdent)
	-- local attributes = "";	
	local hours = Utils.getNoNil(self.driveControl.hourCounter.hours,0);
	local gasLimiter = Utils.getNoNil(self.driveControl.gasGearLimiter.gasLimiter,1.0);
	local gearLimiter = Utils.getNoNil(self.driveControl.gasGearLimiter.gearLimiter,1.0);
	local attributes = 'gasLimiter="'..tostring(gasLimiter)..'" gearLimiter="'..tostring(gearLimiter)..'" workingHours="'..tostring(hours);
	
	
	
	
	attributes = attributes..'" fourWheel="'..tostring(Utils.getNoNil(self.driveControl.fourWDandDifferentials.fourWheel,false))
	attributes = attributes..'" diffLockFront="'..tostring(Utils.getNoNil(self.driveControl.fourWDandDifferentials.diffLockFront,false))
	attributes = attributes..'" diffLockBack="'..tostring(Utils.getNoNil(self.driveControl.fourWDandDifferentials.diffLockBack,false))
	
	attributes = attributes ..'"';
	--  = 1.0;
	-- self.driveControl.gasGearLimiter.gearLimiter = 1.0;
	
	return attributes
end;



function driveControl:loadFromAttributesAndNodes(xmlFile, key, resetVehicles)
	local hours = getXMLFloat(xmlFile, key.."#workingHours");
	self.driveControl.hourCounter.hours = Utils.getNoNil(hours,0);
	
	local gasLimiter = getXMLFloat(xmlFile, key.."#gasLimiter");
	local gearLimiter = getXMLFloat(xmlFile, key.."#gearLimiter");
	self.driveControl.gasGearLimiter.gasLimiter = Utils.getNoNil(gasLimiter,1.0);
	self.driveControl.gasGearLimiter.gearLimiter = Utils.getNoNil(gearLimiter,1.0);
	
	self.driveControl.fourWDandDifferentials.fourWheel = Utils.getNoNil(getXMLBool(xmlFile, key.."#fourWheel"),false);
	self.driveControl.fourWDandDifferentials.diffLockFront = Utils.getNoNil(getXMLBool(xmlFile, key.."#diffLockFront"),false);
	self.driveControl.fourWDandDifferentials.diffLockBack = Utils.getNoNil(getXMLBool(xmlFile, key.."#diffLockBack"),false);
	
	if not resetVehicles then
		
	end;
	return BaseMission.VEHICLE_LOAD_OK;
end

function driveControl:writeStream(streamId, connection)
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.shuttle);
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.manMotorStart);
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.gasAndGearLimiter);
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.hourCounter);
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.fourWDandDifferentials);
	streamWriteBool(streamId, g_currentMission.driveControl.useModules.handBrake);
	
	streamWriteBool(streamId, self.driveControl.shuttle.isActive);
	streamWriteFloat32(streamId, self.driveControl.shuttle.direction);
	streamWriteBool(streamId, self.driveControl.manMotorStart.isMotorStarted);
	streamWriteFloat32(streamId, self.driveControl.gasGearLimiter.gasLimiter);
	streamWriteFloat32(streamId, self.driveControl.gasGearLimiter.gearLimiter);
	streamWriteFloat32(streamId, self.driveControl.hourCounter.hours);
	streamWriteBool(streamId, self.driveControl.handBrake.isActive);
	
	streamWriteBool(streamId, self.driveControl.fourWDandDifferentials.isSurpressed);
	streamWriteBool(streamId, self.driveControl.fourWDandDifferentials.fourWheel);
	streamWriteBool(streamId, self.driveControl.fourWDandDifferentials.diffLockFront);
	streamWriteBool(streamId, self.driveControl.fourWDandDifferentials.diffLockBack);	
	
end;

function driveControl:readStream(streamId, connection) --sry, the server wins ;)
	
	g_currentMission.driveControl.useModules.shuttle = streamReadBool(streamId);
	g_currentMission.driveControl.useModules.manMotorStart = streamReadBool(streamId);
	g_currentMission.driveControl.useModules.gasAndGearLimiter = streamReadBool(streamId);
	g_currentMission.driveControl.useModules.hourCounter = streamReadBool(streamId);
	g_currentMission.driveControl.useModules.fourWDandDifferentials = streamReadBool(streamId);
	g_currentMission.driveControl.useModules.handBrake = streamReadBool(streamId);
	
	local shuttleActive = streamReadBool(streamId);
	local shuttle = streamReadFloat32(streamId);
	local isMotorStarted = streamReadBool(streamId);
	local gasLimiter = streamReadFloat32(streamId);
	local gearLimiter = streamReadFloat32(streamId);
	local hours = streamReadFloat32(streamId);
	local handBrake = streamReadBool(streamId);
	
	self.driveControl.shuttle.isActive = shuttleActive;
	self.driveControl.shuttle.direction = shuttle;
	self.driveControl.manMotorStart.isMotorStarted = isMotorStarted;
	self.driveControl.gasGearLimiter.gasLimiter = gasLimiter;
	self.driveControl.gasGearLimiter.gearLimiter = gearLimiter;
	self.driveControl.hourCounter.hours = hours;
	self.driveControl.handBrake.isActive = handBrake;
	
	
	self.driveControl.fourWDandDifferentials.isSurpressed = streamReadBool(streamId);
	self.driveControl.fourWDandDifferentials.fourWheel = streamReadBool(streamId);
	self.driveControl.fourWDandDifferentials.diffLockFront = streamReadBool(streamId);
	self.driveControl.fourWDandDifferentials.diffLockBack = streamReadBool(streamId);
end;

function driveControl:delete()	
end


function driveControl.getAllConnectedVehicles(self)	
	local res = {};
	res[1] = self;	
	if self.attachedImplements ~= nil then
		if table.getn(self.attachedImplements) > 0 then			
			for k,implement in pairs(self.attachedImplements) do	
				-- print(implement.object.typeName)
				local returnValue = driveControl.getAllConnectedVehicles(implement.object);
				for kk,value in pairs(returnValue) do				
					table.insert(res,value)
				end;
			end;
		end;
	end;	
	return res;	
end





if Drivable.driveControlInstalled == nil then
	print("--- installing driveControl by upsidedown into Drivable and Steerable...")
	local oldFunc = Drivable.updateVehiclePhysics;
	function Drivable.updateVehiclePhysics(self, axisForward, axisForwardIsAnalog, axisSide, axisSideIsAnalog, dt)
		--print(self, axisForward, axisForwardIsAnalog, axisSide, axisSideIsAnalog)
		-- if g_currentMission.driveControl.useModules.handBrake then				
		if self.dCcheckModule ~= nil and self:dCcheckModule("handBrake") then
			if self.driveControl.handBrake.isActive then
				axisForward = 0;				
				self.motor.brakeForce = 1000000;
				 -- if self.isServer then
                     -- for k,wheel in pairs(self.wheels) do
                         -- setWheelShapeProps(wheel.node, wheel.wheelShape, 0, self.motor.brakeForce, 0);
                     -- end;
                 -- end;
			else
				self.motor.brakeForce = self.driveControl.handBrake.normalBrakeForce; --reset to old stored value
			end;
		end;		
		
		if self.dCcheckModule ~= nil and self:dCcheckModule("shuttle") and self.driveControl.shuttle.isActive then
		-- if g_currentMission.driveControl.useModules.shuttle and self.driveControl.shuttle.isActive then --and not self.cruiseControl.isActive
			
			--print(self.movingDirection," ",self.driveControl.shuttle.direction," ",self.vehicleMovingDirection)			
			if self.driveControl.shuttle.direction < 0 and self.cruiseControl.state == 0 then
				axisForward = -axisForward;
				self.axisForward = -self.axisForward;
			end;
			
			if self.movingDirection ~= self.driveControl.shuttle.direction then
				if self.driveControl.shuttle.direction < 0 then
					axisForward = Utils.clamp(axisForward,0,1);			
				else
					axisForward = Utils.clamp(axisForward,-1,0);			
				end;
			end;
						
			self.GPSmovingDirection = self.driveControl.shuttle.direction;
			self.GPSmovingDirectionCnt = 40; --here we remotely handle direction mechanics from GPS. no problem if GPS is not installed			
		end;		
		
		if self.dCcheckModule ~= nil and self:dCcheckModule("gasAndGearLimiter") and self.cruiseControl.state == 0 then
		-- if g_currentMission.driveControl.useModules.gasAndGearLimiter and self.cruiseControl.state == 0  then
			if self.driveControl.gasGearLimiter.gasLimiter < 1.0 then
				local axisFactor = self.driveControl.gasGearLimiter.gasLimiter;
				
				local maxSpeed = Utils.getNoNil(self.cruiseControl.maxSpeed,40)*self.driveControl.gasGearLimiter.gasLimiter
				local alpha = (maxSpeed - self.lastSpeed*3600)/maxSpeed;
				alpha = Utils.clamp(alpha,0,1);
				--print(alpha)
				axisFactor = alpha*axisFactor;
				-- local directionAxis = axisForward;
				-- if g_currentMission.driveControl.useModules.shuttle and self.driveControl.shuttle.isActive and self.driveControl.shuttle.direction < 0 then
					-- directionAxis = -directionAxis;
				-- end;
				
				-- if directionAxis < 0 then
					axisForward = axisForward*axisFactor; 
					axisForwardIsAnalog = true; 
				-- end;
			end;
		end;
		
		local testSteeringModule = false;
		
		
		local oldRotatedTime = self.rotatedTime;
		if testSteeringModule then
			self.autoRotateBackSpeed = 0;
			axisSideIsAnalog = false;
		end;
		
		
		oldFunc(self, axisForward, axisForwardIsAnalog, axisSide, axisSideIsAnalog, dt)
		
		--begin of postFunc:
		
		if testSteeringModule then
			-- self.rotatedTime = oldRotatedTime;
		
		end;		
	end;

	
	
	local oldFunc2 = Steerable.update;
	function Steerable.update(self,dt)
		if g_currentMission.controlledVehicle == self then
			-- if g_currentMission.driveControl.useModules.gasAndGearLimiter then
			if self.dCcheckModule~= nil and self:dCcheckModule("gasAndGearLimiter")  then
				if InputBinding.isPressed(InputBinding.driveControlGasLimiterUp) then
					InputBinding.actions[InputBinding.AXIS_LOOK_UPDOWN_VEHICLE].lastInputAxis = 0;
				end;
				
				if InputBinding.isPressed(InputBinding.driveControlGasLimiterDown) then
					InputBinding.actions[InputBinding.AXIS_LOOK_UPDOWN_VEHICLE].lastInputAxis = 0;
				end;
				
				if InputBinding.isPressed(InputBinding.driveControlGearLimiterUp) then
					InputBinding.actions[InputBinding.AXIS_LOOK_LEFTRIGHT_VEHICLE].lastInputAxis = 0;
				end;
				
				if InputBinding.isPressed(InputBinding.driveControlGearLimiterDown) then
					InputBinding.actions[InputBinding.AXIS_LOOK_LEFTRIGHT_VEHICLE].lastInputAxis = 0;
				end;
			end;
		end;
		
		oldFunc2(self,dt);
	end;
	
	
	local oldFuncDetach = Vehicle.handleDetachAttachableEvent;
		
	function Vehicle.handleDetachAttachableEvent(self)
		local implement = self.selectedImplement;
		res = oldFuncDetach(self);
		if res and implement~= nil then
			implement.forceIsActive = false;
		end;		
	end;
	
	
	local oldFuncActiveForLights = Vehicle.getIsActiveForLights;
	function Vehicle.getIsActiveForLights(self)
		if self.forceIsActive then
			return true;
		end;
		return oldFuncActiveForLights(self);		
	end;
	
	oldVehicleUpdateTick = Vehicle.updateTick;
	function Vehicle.updateTick(self,dt)
		oldVehicleUpdateTick(self,dt)
		-- if g_currentMission.driveControl.useModules.fruitDestruction then
		if self.dCcheckModule~= nil and self:dCcheckModule("fruitDestruction")  then
			if self:getIsActive() then
				local rootVehicle = self:getRootAttacherVehicle();
				if not rootVehicle.isHired and not (self.drive or self.getIsCourseplayDriving and self:getIsCourseplayDriving()) then
					for k,wheel in pairs(self.wheels) do
						local wx, wy, wz = getWheelShapeContactPoint(wheel.node, wheel.wheelShape);						
						if wx ~= nil then --ground contact
							for fruitId,ids in pairs(g_currentMission.fruits) do
								if ids == nil or ids.id == 0 then

								else
									local id = ids.id
									local desc = FruitUtil.fruitIndexToDesc[fruitId];						
									local x, z, widthX, widthZ, heightX, heightZ = Utils.getXZWidthAndHeight(id, wx, wz, wx+.1, wz, wx, wz+.1);
									
									local valx = getDensityParallelogram(g_currentMission.fruits[fruitId].id, x, z, widthX, widthZ, heightX, heightZ, 0, g_currentMission.numFruitStateChannels);
									if valx>0 then
										local newValue = 0;
										if FruitUtil.FRUITTYPE_GRASS == fruitId then
											newValue = 2;
										end;
										setDensityMaskedParallelogram(g_currentMission.fruits[fruitId].id, x, z, widthX, widthZ, heightX, heightZ, 0,  g_currentMission.numFruitStateChannels, g_currentMission.fruits[fruitId].id, 0, g_currentMission.numFruitStateChannels, newValue);
										break; --no need to look for other fruits here!
									end;
								end;
							end;
						end;
					end;
				end;
			end;		
		end;
	end;
	
	local oldWashableUpdateTick = Washable.updateTick;
	function Washable.updateTick(self,dt)
		if g_currentMission.driveControl~= nil and self.dCcheckModule ~= nil and self:dCcheckModule("dirtModule") then
			if self:getIsActive() then				
				if self.isServer then
					local maxGround = WheelsUtil.GROUND_ROAD;
					local groundFactor = 1.0;
					local wheels = self.wheels;
					if wheels == nil or table.getn(wheels) == 0 then
						local rootVehicle = self:getRootAttacherVehicle();
						wheels = rootVehicle.wheels;
					end;
					
					for k,wheel in pairs(wheels) do
						local wx, _, wz = getWheelShapeContactPoint(wheel.node, wheel.wheelShape);	
						local isField = false;
						if wx ~= nil then
							isField = (getDensityAtWorldPos(g_currentMission.terrainDetailId, wx, wz) % 16) > 0;
						end;
						local res = WheelsUtil.getGroundType(isField,false,wheel.lastColor)
						-- print("Rad "..tostring(k)..": "..tostring(res))
						if res > maxGround then
							maxGround = res;
						end;						
					end;
					
					local maxDirt = {0.2, .4, .75, 1.0};
					
					if self.dirtAmount > maxDirt[maxGround] then
						groundFactor = 0;
					end;
				
					local oldValue = self.oldDirtDuration;
					if oldValue == nil then
						self.oldDirtDuration = self.dirtDuration;
						oldValue = Utils.getNoNil(self.dirtDuration,0);
					end;
					local rootVehicle = self:getRootAttacherVehicle();
					
					local maxSpeed = 120;
					local workFactor = 1.0;
					local offSet = 0;
					if rootVehicle.cruiseControl ~= nil then
						if rootVehicle.cruiseControl.maxSpeed < maxSpeed then
							maxSpeed = rootVehicle.cruiseControl.maxSpeed;
						end;
					end;
					if rootVehicle.motor ~= nil then
						if rootVehicle.motor.speedLimit < maxSpeed then
							maxSpeed = rootVehicle.motor.speedLimit;
							workFactor = 2.0;
						end;
					end;
					if self.isTurnedOn then
						workFactor = 2.0;
						offSet = 0.1;
					end;
					
					local globalFactor = driveControl.dirtModuleGlobalFactor;
					local speedFactor = self.lastSpeed*3600/maxSpeed;
					self.dirtDuration = globalFactor*(speedFactor+offSet)*workFactor*groundFactor*oldValue;
				end;
				
			end;
		end;
		oldWashableUpdateTick(self,dt);
	end;
	
		
	Drivable.driveControlInstalled = true;
end;




function driveControl:toggleVehicle(delta)
	-- print("toggle called")
  if not g_currentMission.isToggleVehicleAllowed then
    return
  end
  -- print("...")
  local numVehicles = table.getn(g_currentMission.steerables)
  if numVehicles > 0 then
    local index = 1
    local oldIndex = 1
    if not g_currentMission.controlPlayer and g_currentMission.controlledVehicle ~= nil then
      for i = 1, numVehicles do
        if g_currentMission.controlledVehicle == g_currentMission.steerables[i] then
          oldIndex = i
          index = i + delta
          if numVehicles < index then
            index = 1
          end
          if index < 1 then
            index = numVehicles
          end
          break
        end
      end
    end
	
	-- print("oldIndex: ",oldIndex)
    local found = false
    repeat
      if not g_currentMission.steerables[index].isBroken and not g_currentMission.steerables[index].isControlled and not g_currentMission.steerables[index].nonTabbable and g_currentMission.steerables[index].driveControl~= nil and g_currentMission.steerables[index].driveControl.manMotorStart.isMotorStarted then
        found = true
      else
        index = index + delta
        if numVehicles < index then
          index = 1
        end
        if index < 1 then
          index = numVehicles
        end
      end
    until found or index == oldIndex
	-- print(found," ",index," ",oldIndex)
    if found then
      g_client:getServerConnection():sendEvent(VehicleEnterRequestEvent:new(g_currentMission.steerables[index], g_settingsNickname))
    end
  end
end














driveControlInputEvent = {};
driveControlInputEvent_mt = Class(driveControlInputEvent, Event);

InitEventClass(driveControlInputEvent, "driveControlInputEvent");

function driveControlInputEvent:emptyNew()
    local self = Event:new(driveControlInputEvent_mt);
    self.className="driveControlInputEvent";
    return self;
end;

function driveControlInputEvent:new(vehicle)
    local self = driveControlInputEvent:emptyNew()
    self.vehicle = vehicle;
	self.shuttleActive = vehicle.driveControl.shuttle.isActive
	self.shuttle = vehicle.driveControl.shuttle.direction;
	self.isMotorStarted = vehicle.driveControl.manMotorStart.isMotorStarted;
	self.gasLimiter = vehicle.driveControl.gasGearLimiter.gasLimiter;
	self.gearLimiter = vehicle.driveControl.gasGearLimiter.gearLimiter;
	self.handBrake = vehicle.driveControl.handBrake.isActive
	
	self.fourWheel = vehicle.driveControl.fourWDandDifferentials.fourWheel;
	self.diffLockFront = vehicle.driveControl.fourWDandDifferentials.diffLockFront;
	self.diffLockBack = vehicle.driveControl.fourWDandDifferentials.diffLockBack;
	
	
	-- print("event new")
    return self;
end;

function driveControlInputEvent:writeStream(streamId, connection)
    streamWriteInt32(streamId, networkGetObjectId(self.vehicle));
	streamWriteBool(streamId, self.shuttleActive);
	streamWriteFloat32(streamId, self.shuttle);
	streamWriteBool(streamId, self.isMotorStarted);
	streamWriteFloat32(streamId, self.gasLimiter);
	streamWriteFloat32(streamId, self.gearLimiter);
	streamWriteBool(streamId, self.handBrake);
	streamWriteBool(streamId, self.fourWheel);
	streamWriteBool(streamId, self.diffLockFront);
	streamWriteBool(streamId, self.diffLockBack);
	-- print("event writeStream")
end;

function driveControlInputEvent:readStream(streamId, connection)
    local id = streamReadInt32(streamId);
    local vehicle = networkGetObject(id);
	
	local shuttleActive = streamReadBool(streamId);
	local shuttle = streamReadFloat32(streamId);
	local isMotorStarted = streamReadBool(streamId);
	local gasLimiter = streamReadFloat32(streamId);
	local gearLimiter = streamReadFloat32(streamId);
	local handBrake = streamReadBool(streamId);
	local fourWheel = streamReadBool(streamId);
	local diffLockFront = streamReadBool(streamId);
	local diffLockBack = streamReadBool(streamId);
	
	vehicle.driveControl.shuttle.isActive = shuttleActive;
	vehicle.driveControl.shuttle.direction = shuttle;
	vehicle.driveControl.manMotorStart.isMotorStarted = isMotorStarted;
	vehicle.driveControl.gasGearLimiter.gasLimiter = gasLimiter;
	vehicle.driveControl.gasGearLimiter.gearLimiter = gearLimiter;
	vehicle.driveControl.handBrake.isActive = handBrake;
	vehicle.driveControl.fourWDandDifferentials.fourWheel = fourWheel;
	vehicle.driveControl.fourWDandDifferentials.diffLockFront = diffLockFront;
	vehicle.driveControl.fourWDandDifferentials.diffLockBack = diffLockBack;
	
	-- print("event readStream")
	-- print(shuttleActive,shuttle,isMotorStarted,gasLimiter,gearLimiter)
	if g_server ~= nil then	
		g_server:broadcastEvent(driveControlInputEvent:new(vehicle), nil, nil, vehicle);
		-- print("broadcasting")
	end;
end;

function driveControlInputEvent.sendEvent(vehicle)
	if g_server ~= nil then	
		--g_server:broadcastEvent(driveControlInputEvent:new(vehicle), nil, nil, self);
		-- print("broadcasting")
	else
		g_client:getServerConnection():sendEvent(driveControlInputEvent:new(vehicle));
		-- print("sending event to server...")
	end;
end;






-- code taken with permission by Jakob Tischler from CP:
-- Giants - very intelligently - deletes any mod file in the savegame folder when saving. And now we get it back!
local function backupCpFiles(self)

	if g_server == nil and g_dedicatedServerInfo == nil then return end;

	if driveControl.savegameFolderPath == nil then return end;
	
		if not fileExists(driveControl.savegameFolderPath) then
			return;
		end;


	local savegameIndex = g_currentMission.missionInfo.savegameIndex;
	driveControl.cpTempSaveFolderPath = getUserProfileAppPath() .. 'dCBackupSavegame' .. savegameIndex;
	createFolder(driveControl.cpTempSaveFolderPath);

	driveControl.cpFileBackupPath = driveControl.cpTempSaveFolderPath .. '/driveControl_config.xml';
	copyFile(driveControl.savegameFolderPath, driveControl.cpFileBackupPath, true);

end;
g_careerScreen.saveSavegame = Utils.prependedFunction(g_careerScreen.saveSavegame, backupCpFiles);
 
local function getThatFuckerBack(self)

	if g_server == nil and g_dedicatedServerInfo == nil then return end;

	if not driveControl.cpFileBackupPath then return end;
	
	if driveControl.savegameFolderPath == nil then return end;

	local savegameIndex = g_currentMission.missionInfo.savegameIndex;
	local savegameFolderPath = g_currentMission.missionInfo.savegameDirectory;
	if savegameFolderPath == nil then
		savegameFolderPath = ('%ssavegame%d'):format(getUserProfileAppPath(), savegameIndex);
	end;

	if fileExists(savegameFolderPath .. '/careerSavegame.xml') then -- savegame isn't corrupted and has been saved correctly

		copyFile(driveControl.cpFileBackupPath, driveControl.savegameFolderPath, true);
		driveControl.cpFileBackupPath = nil;


		deleteFolder(driveControl.cpTempSaveFolderPath);

	else -- corrupt savegame: display backup info message
		 
		local msgTitle = 'driveControl';
		local msgTxt = 'This savegame has been corrupted.';
		if driveControl.cpFieldsFileBackupPath then
			msgTxt = msgTxt .. ('\nYour driveControl files have been backed up to the %q directory.'):format('dCBackupSavegame' .. savegameIndex);
		else
			msgTxt = msgTxt .. ('\nYour driveControl file has been backed up to the %q directory.'):format('dCBackupSavegame' .. savegameIndex);
		end;
		msgTxt = msgTxt .. ('\n\nFull path: %q'):format(driveControl.cpTempSaveFolderPath);
		g_currentMission.inGameMessage:showMessage(msgTitle, msgTxt, 15000, false);
	end;

end;
g_careerScreen.saveSavegame = Utils.appendedFunction(g_careerScreen.saveSavegame, getThatFuckerBack); 