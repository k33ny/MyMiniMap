--[[
  [] Author: Martynas Petuska
  [] E-mail: martynas.petuska@outlook.com
  [] Date:   March 2018
--]]
local UI = ADDON.UI;
local UpdateInfo = ADDON.UpdateInfo;
--====================================================== CLASS =======================================================--
---Class representing map tiles.
--- 
---@class MapTile
local MapTile = {};
ADDON.Classes.MapTile = MapTile;
MapTile.Objects = {};
local Objects = MapTile.Objects;
--====================================================================================================================--
---Constructor
---@param zoneId number
---@param subZoneName string
---@param tileId number
---@param xPos number
---@param yPos number
---@param size number
---@return MapTile
function MapTile:New(zoneId, subZoneName, tileId, xPos, yPos, size)
	local obj = setmetatable({}, { __index = self });
	table.insert(Objects, obj);
	obj.objectId = #Objects;
	obj:Init(zoneId, subZoneName, tileId, xPos, yPos, size);
	return obj;
end

---Initialises the new object.
---@param zoneId number
---@param subZoneName string
---@param tileId number
---@param xPos number
---@param yPos number
---@param size number
function MapTile:Init(zoneId, subZoneName, tileId, xPos, yPos, size)
	self.enabled = true;
	self.zoneId = zoneId;
	self.subZoneId = subZoneName;
	self.tileId = tileId;
	self.Position = {
		x = xPos,
		y = yPos
	}
	self.size = size;
	
	self.Controls = self.Controls or {};
	local tileTexture = GetMapTileTexture(self.tileId);
	local objectId = self.objectId;
	for group, scroll in pairs(UI.Scrolls) do
		if (not self.Controls[group]) then
			local controlName = scroll:GetName() .. "_MapTile" .. tostring(objectId);
			self.Controls[group] = WINDOW_MANAGER:CreateControl(controlName, scroll, CT_TEXTURE);
		end
		self.Controls[group]:SetTexture(tileTexture);
		self.Controls[group]:SetDimensions(self.size, self.size);
		self.Controls[group]:SetDrawLevel(0);
		self.Controls[group]:SetHidden(not self.enabled);
	end
	self:Update();
end

---Returns whether the tile is enabled.
---@return boolean
function MapTile:IsEnabled()
	return self.enabled;
end

---Enables/disables the tile.
---@param isEnabled boolean
function MapTile:SetEnabled(isEnabled)
	for _, control in pairs(self.Controls) do
		control:SetHidden(not isEnabled);
	end
	self.enabled = isEnabled;
end

---Resizes the tile.
---@param newSize number
function MapTile:Resize(newSize)
	self.size = newSize;
	for _, control in pairs(self.Controls) do
		control:SetDimensions(self.size, self.size);
	end
end

---Updates map tile's position.
function MapTile:UpdatePosition()
	local playerX, playerY = UpdateInfo.Player.nX, UpdateInfo.Player.nY;
	local mapW, mapH = UpdateInfo.Map.width, UpdateInfo.Map.height;
	
	local offsetX = (self.Position.x - playerX) * mapW;
	local offsetY = (self.Position.y - playerY) * mapH;
	
	for _, control in pairs(self.Controls) do
		control:ClearAnchors();
		control:SetAnchor(TOPLEFT, control:GetParent(), CENTER, offsetX, offsetY);
	end
end

---Updates map tile's rotation.
function MapTile:UpdateRotation()
	local rotation = 0;
	if (ADDON.Settings.isMapRotationEnabled) then
		rotation = UpdateInfo.Player.rotation;
	end
	local tileCenterX, tileCenterY = self.Controls.center:GetCenter();
	local wheelCenterX, wheelCenterY = UI.playerPin:GetCenter();
	
	local dx, dy = wheelCenterX - tileCenterX, wheelCenterY - tileCenterY;
	local normalizedRotationPointX = ((self.size / 2) + dx) / self.size;
	local normalizedRotationPointY = ((self.size / 2) + dy) / self.size;
	
	for _, control in pairs(self.Controls) do
		control:SetTextureRotation(-rotation, normalizedRotationPointX, normalizedRotationPointY);
	end
end

---Updates the map tile.
function MapTile:Update()
	if (self.enabled) then
		self:UpdatePosition();
		self:UpdateRotation();
	end
end
--====================================================================================================================--
return MapTile;
