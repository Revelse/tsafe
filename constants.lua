local _,tSave = ...

tSave.Constants = {}

tSave.Constants.Races = {
	["Human"] = 1,
	["Orc"] = 2,
	["Dwarf"] = 3,
	["NightElf"] = 4,
	["Scourge"] = 5,
	["Tauren"] = 6,
	["Gnome"] = 7,
	["Troll"] = 8,
	["Goblin"] = 9,
	["BloodElf"] = 10,
	["Draenei"] = 11,
	["Worgen"] = 22,
	["Pandaren"] = 24
}

tSave.Constants.SlotInfo = {
	[1] = {16,"Main Hand","MainHandSlot"},
	[2] = {17,"Off Hand","SecondaryHandSlot"},
	[3] = {1,"Head","HeadSlot"},
	[4] = {3,"Shoudlers","ShoulderSlot"},
	[5] = {15,"Back","BackSlot"},
	[6] = {5,"Chest","ChestSlot"},
	[7] = {4,"Shirt","ShirtSlot"}, 
	[8] = {19,"Tabard","TabardSlot"},
	[9] = {9,"Wrist","WristSlot"},
	[10] = {10,"Gloves","HandsSlot"},
	[11] = {6,"Waist","WaistSlot"},
	[12] = {7,"Legs","LegsSlot"},
	[13] = {8,"Feet","FeetSlot"}
}

tSave.Constants.ValidNicks = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_BODY"] = 4,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5,
	["INVTYPE_WAIST"] = 6,
	["INVTYPE_LEGS"] = 7,
	["INVTYPE_FEET"] = 8,
	["INVTYPE_WRIST"] = 9, 
	["INVTYPE_HAND"] = 10,
	["INVTYPE_CLOAK"] = 15,
	["INVTYPE_WEAPON"] = 16,
	["INVTYPE_SHIELD"] = 17,
	["INVTYPE_2HWEAPON"] = 16,
	["INVTYPE_WEAPONMAINHAND"] = 16,
	["INVTYPE_WEAPONOFFHAND"] = 17,
	["INVTYPE_HOLDABLE"] = 17,
	["INVTYPE_RANGED"] = 16,
	["INVTYPE_RELIC"] = 17
}

tSave.Constants.SlotIdToSlot = {}

for key, value in ipairs(tSave.Constants.SlotInfo) do
	tSave.Constants.SlotIdToSlot[value[1]] = value[3]
end