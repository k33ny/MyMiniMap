--[[
  [] Author: Martynas Petuska
  [] E-mail: martynas.petuska@outlook.com
  [] Date:   January 2018
--]]
---------------- NAMESPACE ----------------
ADDON = {}
-------------------------------------------

ADDON.name = "MyMiniMap";
ADDON.baseSize = 512;
ADDON.pinBaseSize = 32;
ADDON.UI = {}
ADDON.UI.isSetup = false;
ADDON.EventHandlers = {}
ADDON.UpdateInfo = {
	Map = {
		mapId = 0,
		zoneId = 0,
		tileCountX = 0,
		tileCountY = 0,
		width = 0,
		height = 0
	},
	Player = {
		rotation = 0,
		normX = 0,
		normY = 0
	}
}
ADDON.Boundaries = {
	mapZoomMin = 0.45;
	mapZoomMax = 1.75;
}

ADDON.Settings = {
	MiniMap = {
		UpdateInfo = {
			Map = {},
			Player = {}
		}
	}
}
ADDON.DefaultSettings = {
	addonName = "My MiniMap",
	Theme = {
		hex = "00FF96"
	},
	MiniMap = {
		mapScale = 0.6,
		scrollScaleBase = 0.65,
		scrollScaleOffset = 0.15,
		mapZoom = 1,
		Position = {
			x = nil,
			y = nil
		}
	},
	isInCameraMode = true,
	isMapRotationEnabled = true,
	isUpdateEnabled = true,
	showUnexploredPins = true
};
