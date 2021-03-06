--[[
  [] Author: Martynas Petuska
  [] E-mail: martynas.petuska@outlook.com
  [] Date:   January 2018
--]]
---------------- NAMESPACE ----------------
local UI = ADDON.UI;
local UpdateInfo = ADDON.UpdateInfo;
local Sizes = ADDON.Sizes;
local Settings = ADDON.Settings;
-------------------------------------------

---Checks is the given normalized map coordinates are inside the mini map wheel.
---@param normalizedX number
---@param normalizedY number
---@return boolean
function UI.AreCoordinatesInsideWheel(normalizedX, normalizedY)
	local centerX, centerY = UpdateInfo.Player.nX, UpdateInfo.Player.nY;
	local r = UI.miniMap:GetWidth() / UpdateInfo.Map.width;
	local dx, dy = normalizedX - centerX, normalizedY - centerY;
	
	return (math.sqrt((dx * dx) + (dy * dy)) <= r);
end

function UI.IsPinInsideWheel(pin)
	if (not pin) then
		return;
	end
	
	local nX, nY = pin:GetMapPos();
	local pinRadius = pin:GetDimensions() / 2;
	local nR = pinRadius / UpdateInfo.Map.width;
	
	return UI.AreCoordinatesInsideWheel(nX - nR, nY - nR) or
			UI.AreCoordinatesInsideWheel(nX + nR, nY - nR) or
			UI.AreCoordinatesInsideWheel(nX + nR, nY + nR) or
			UI.AreCoordinatesInsideWheel(nX - nR, nY + nR);
end

--- Collects all the UI elements into the convenience list.
---@return void
local function GatherUiElements()
	UI.miniMap = MyMiniMap
	UI.wheel = MyMiniMapWheel;
	UI.background = MyMiniMapBackground;
	UI.playerPin = MyMiniMapPlayerPin;
	UI.Scrolls = {
		center = MyMiniMapCenterScroll,
		horizontal = MyMiniMapHorizontalScroll,
		vertical = MyMiniMapVerticalScroll
	};
end

---Rescales the UI.
---@return void
function UI.Rescale()
	local size = Sizes.miniMapSize * Settings.MiniMap.mapScale;
	UI.playerPin:SetDimensions(Sizes.playerPinSize * Settings.MiniMap.mapScale, Sizes.playerPinSize * Settings.MiniMap.mapScale);
	
	UI.wheel:SetDimensions(size, size);
	UI.background:SetDimensions(size, size);
	UI.miniMap:SetDimensions(size, size);
	
	for name, scroll in pairs(UI.Scrolls) do
		scroll:ClearAnchors();
		scroll:SetAnchor(CENTER, UI.wheel, CENTER);
		scroll:SetScrollBounding(0);
	end
	local scrollScaleBase = Settings.MiniMap.scrollScaleBase;
	local scrollScaleOffset = Settings.MiniMap.scrollScaleOffset;
	UI.Scrolls.center:SetDimensions(size * scrollScaleBase, size * scrollScaleBase);
	UI.Scrolls.horizontal:SetDimensions(size * (scrollScaleBase + scrollScaleOffset), size * (scrollScaleBase - scrollScaleOffset));
	UI.Scrolls.vertical:SetDimensions(size * (scrollScaleBase - scrollScaleOffset), size * (scrollScaleBase + scrollScaleOffset));
end

---Reposition the UI.
---@return void
function UI.Reposition()
	UI.miniMap:ClearAnchors();
	UI.miniMap:SetAnchor(CENTER, GuiRoot, TOPLEFT, Settings.MiniMap.Position.x, Settings.MiniMap.Position.y);
end

---Handles initial UI setup.
---@return void
function UI.Setup()
	GatherUiElements();
	UI.Reposition();
	UI.Rescale();
	UI.isSetup = true;
end