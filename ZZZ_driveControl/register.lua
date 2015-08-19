SpecializationUtil.registerSpecialization("driveControl", "driveControl", g_currentModDirectory.."driveControl.lua")

Inching_Register = {};

g_i18n.globalI18N.texts["driveControl"] = g_i18n:getText("driveControl"); 

local version = SpecializationUtil.getSpecialization("driveControl").Version;


function Inching_Register:loadMap(name)
	if self.firstRun == nil then
		self.firstRun = false;
		print("--- loading driveControl mod V"..string.format("%1.2f",version).." (by upsidedown)---")
		
		for k, v in pairs(VehicleTypeUtil.vehicleTypes) do
			if v ~= nil then
				local allowInsertion = true;
				for i = 1, table.maxn(v.specializations) do
					local vs = v.specializations[i];
					--if vs ~= nil and vs == SpecializationUtil.getSpecialization("steerable") then
					if vs ~= nil and vs == SpecializationUtil.getSpecialization("drivable") then
						local v_name_string = v.name 
						local point_location = string.find(v_name_string, ".", nil, true)
						if point_location ~= nil then
							local _name = string.sub(v_name_string, 1, point_location-1);
							if rawget(SpecializationUtil.specializations, string.format("%s.driveControl", _name)) ~= nil then
								allowInsertion = false;								
							end;							
						end;
						if allowInsertion then	
							table.insert(v.specializations, SpecializationUtil.getSpecialization("driveControl"));
						end;
					end;
				end;
			end;	
		end;
	end;
end;

function Inching_Register:deleteMap()
  
end;

function Inching_Register:keyEvent(unicode, sym, modifier, isDown)

end;

function Inching_Register:mouseEvent(posX, posY, isDown, isUp, button)

end;

function Inching_Register:update(dt)
	
end;

function Inching_Register:draw()
  
end;

addModEventListener(Inching_Register);