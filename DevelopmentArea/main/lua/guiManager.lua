--------------------------------------------------------------------------------------
-- prepair the position of your GUI, Hud
-- first steps in setting up a script that tells us the position of the image
local baseDirectory = g_currentModDirectory; -- main mod/project directory
local guiDir = baseDirectory .."gui/"; -- main GUI path
local hudDir = guiDir .."BG/"; -- background path 
local buttonDir = guiDir .."Buttons/"; -- buttons path 
local previewDir = guiDir .."HUD/"; -- hud path 
local bgDir = guiDir .."Preview/"; -- previews path 
local slideDir = guiDir .."sliders/"; -- sliders path
local directories = {}
guiManager = {};
guiManager_mt = Class(guiManager);
InitObjectClass(guiManager, "guiManager");
addModEventListener(guiManager);


----------------------------
-- functions needed by game
function guiManager:init()
	g_currentMission.fruitsConvertingTriggers = {}; -- only for testing
	overlayId = createOverlay("overlay", "sample/overlay/overlay.png");
end;

function guiManager:loadMap(name)
	print("guiManager name: " ..name);
	self.baseDirectory = baseDirectory;
  if g_currentMission.guiManager == nil then
     g_currentMission.guiManager = {};
  end;
  self.panelPath = Utils.getFilename("test.dds", buttonDir);
  self.overlayId = createOverlay("overlay", self.panelPath);
  self.panelHud = Overlay:new("panelHud",self.panelPath, 0, 0, 1, 1);--0.3, 0.2, 0.4, 0.6);
  --self.ledPath = Utils.getFilename("mods/fruitsConvertingMod/dioda.png", self.baseDirectory);
  --self.ledHud = Overlay:new("ledHud",self.ledPath, 0.763, 0.634, 0.011, 0.018);
  local sBOP=Utils.getFilename("64.dds", buttonDir);
  self.switchButtonOverlay = createImageOverlay(sBOP);
  local sBSOP=Utils.getFilename("128.dds", buttonDir);
  self.switchButtonSelectedOverlay = createImageOverlay(sBSOP);
  local sBGO=Utils.getFilename("256.dds", buttonDir);
  self.switchButtonGlowOverlay = createImageOverlay(sBGO);
  self.show = false;
  self.index = 0;
  self.panelsCount = 0;
  self.runOnce = true;
  self.changeIP = false;
  g_currentMission.guiManager = self;
  self.switchButtonsPos = {{x=0.220, y=0.265},{x=0.220, y=0.325},{x=0.220, y=0.385},{x=0.220, y=0.445},{x=0.220, y=0.505},{x=0.220, y=0.565},{x=0.220, y=0.625},{x=0.220, y=0.685},{x=0.220, y=0.745},{x=0.220, y=0.805}};
  self.switchButtonsCount = 0;
  self.switchButtonToGuiManagerTrigger = {};
  self.switchButtonWidth = 0.0395;
  self.switchButtonHeight = 0.054;
end;

function guiManager:load(id)
	print("guiManager ID: " ..tostring(id));
end;

function guiManager:mouseEvent(posX, posY, isDown, isUp, button)
if self.show then
    self.activeSwitchButton=0;
    for i=1, self.switchButtonsCount do
      if (posX>=self.switchButtonsPos[i].x) and (posX<=self.switchButtonsPos[i].x+self.switchButtonWidth) and
         (posY<=1-self.switchButtonsPos[i].y+self.switchButtonHeight) and (posY>=1-self.switchButtonsPos[i].y) then
         self.activeSwitchButton = i;
         if isDown and button==Input.MOUSE_BUTTON_LEFT then
           self.index= self.switchButtonToGuiManagerTrigger[i];
         end;
      end;
    end;
  end;
end;

function guiManager:keyEvent(unicode, sym, modifier, isDown)
--if self.switchButtonsCount>0 then
    if (InputBinding.isPressed(InputBinding.SHOW_FC_PANEL)) then
      --self.changeIP = true;
      self.show = not self.show;
      if self.show then
        g_mouseControlsHelp.active = false;
        InputBinding.setShowMouseCursor(true);
        InputBinding.wrapMousePositionEnabled = false;
        if (g_currentMission.player.isEntered) then
          g_currentMission.player.isFrozen = true;
        end;
      else
        g_mouseControlsHelp.active = true;
        InputBinding.setShowMouseCursor(false);
        if (g_currentMission.player.isEntered) then
          g_currentMission.player.isFrozen = false;
        end;
      end;
    end;
  --end;
end;

function guiManager:updateTick(dt)

end;

function guiManager:update(dt)
if self.runOnce then
    self.runOnce = false;
    if g_currentMission.fruitsConvertingTriggers~=nil then
      self.panelsCount = table.maxn(g_currentMission.fruitsConvertingTriggers);
      for i=1, self.panelsCount do
        if (g_currentMission.fruitsConvertingTriggers[i]~=nil) and (g_currentMission.fruitsConvertingTriggers[i].infoPanelFile~=nil) then
          if self.index==0 then
            self.index=i;
          end;
          self.switchButtonsCount = self.switchButtonsCount + 1;
          self.switchButtonToGuiManagerTrigger[self.switchButtonsCount]=i;
        end;
      end;
    else
      self.panelsCount = 0;
    end;
end;
end;

function guiManager:draw()
renderOverlay(self.overlayId, 128, 128, 0.16, 0.04);
if g_currentMission.fruitsConvertingTriggers~=nil then
    if self.show and (self.index > 0) then
      g_mouseControlsHelp.active = false;
      InputBinding.setShowMouseCursor(true);
      InputBinding.wrapMousePositionEnabled = false;

      if g_currentMission.fruitsConvertingTriggers[self.index]~=nil and g_currentMission.fruitsConvertingTriggers[self.index].draw~=nil then
        self.panelHud:render();
        setTextAlignment(RenderText.ALIGN_CENTER);
        for i=1, self.switchButtonsCount do
          if self.activeSwitchButton==i then
            renderOverlay(self.switchButtonGlowOverlay, self.switchButtonsPos[i].x-0.002, (1-self.switchButtonsPos[i].y)-0.0019, self.switchButtonWidth+0.002, self.switchButtonHeight+0.005);
          end;
          if self.switchButtonTofruitsConvertingTrigger[i]==self.index then
            renderOverlay(self.switchButtonSelectedOverlay, self.switchButtonsPos[i].x, 1-self.switchButtonsPos[i].y, self.switchButtonWidth, self.switchButtonHeight);
            setTextColor(1,1,1,1);
          else
            renderOverlay(self.switchButtonOverlay, self.switchButtonsPos[i].x, 1-self.switchButtonsPos[i].y, self.switchButtonWidth, self.switchButtonHeight);
            setTextColor(1,1,1,1);
          end;
          renderText(self.switchButtonsPos[i].x+(self.switchButtonWidth/2.5), 1-self.switchButtonsPos[i].y+0.015, 0.025, tostring(i));
        end;
        setTextAlignment(RenderText.ALIGN_LEFT);
        setTextColor(1,1,1,1);
        if g_currentMission.fruitsConvertingTriggers[self.index].running then
          self.ledHud:render();
        end;
        g_currentMission.fruitsConvertingTriggers[self.index]:draw();
      end;
    end;
    for i=1, table.maxn(g_currentMission.fruitsConvertingTriggers) do
      if g_currentMission.fruitsConvertingTriggers[i]~=nil then
        local fct = g_currentMission.fruitsConvertingTriggers[i];
        for a=1, table.maxn(fct.tipTriggers) do
          if (fct.tipTriggers[a] ~= nil) and (fct.tipTriggers[a].draw~=nil) then
            fct.tipTriggers[a]:draw();
          end;
        end;
      end;
    end;
  end;
end;

function guiManager:deleteMap(name)

end;

function guiManager:delete(id)

end;
------------------------------------------------

 print ("guiManager loaded");