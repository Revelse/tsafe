local Main = {}

local addonStarted = false

local addonname = ...

local onChat = function (self,frame,addon)
	if addon == addonname then
		addonStarted = true
		storage_load()
		Frame:new()
	end
end

local f = CreateFrame("Frame")
f:SetScript("onEvent",onChat)
f:RegisterEvent("ADDON_LOADED")




