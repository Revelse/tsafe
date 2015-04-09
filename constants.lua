SetTempStorage("ADDON_NAME", select(1,...))
SetTempStorage("ADDON_FOUNDER", "Revelse")
SetTempStorage("ADDON_AUTHOR", "Revelse")
SetTempStorage("ADDON_VERSION", 0)
SetTempStorage("ADDON_DEBUG",   true)

SetTempStorage("ADDON_DESC", [[
	<html>
		<body>
			<h1 align='center'>Creation and Modifying</h1>
			<p>|cff44eeffHow to create?|r </p>
			<p>Just select the equipment-part and then type in the id.</p>
			<p>Race and Skincolor are selectable too, just type them into the editboxes.</p>
		</body>
	</html>
]])

SetTempStorage("ScrollPaneBackdrop",{
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  edgeSize = 20,
})


SetTempStorage("TOKEN_SLOT", {
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
})

local reverseSlot = {}

for k, v in pairs(GetTempStorage("TOKEN_SLOT")) do
	reverseSlot[v] = k
end

SetTempStorage("SLOT_TOKEN", reverseSlot)

SetTempStorage("ORDER_INFO", {
	[1] = {16,"Main Hand"},
	[2] = {17,"Off Hand"},
	[3] = {1,"Head"},
	[4] = {3,"Shoudlers"},
	[5] = {15,"Back"},
	[6] = {5,"Chest"},
	[7] = {4,"Shirt"}, 
	[8] = {19,"Tabard"},
	[9] = {9,"Wrist"},
	[10] = {10,"Gloves"},
	[11] = {6,"Waist"},
	[12] = {7,"Legs"},
	[13] = {8,"Feet"},
})

SetTempStorage("ENCHANT_INFO",{
	[0] = {0,"None"},
	[1] = {4097,"Power Torrent"},
	[2] = {5125,"Bloody Dancing Steel"},
	[3] = {2673,"Mungoose"},
	[4] = {3846,"Mayor Healing"},
	[5] = {3225,"Exe"},
	[6] = {4066,"Mending"},
	[7] = {3854,"41+ Mana"},
	[8] = {5397,"Primal Victory"},
	
})

local tbl = {}

for k, v in ipairs(GetTempStorage("ENCHANT_INFO")) do
	tbl[v[1]] = k
end

SetTempStorage("ENCHANT_INFO_REVERSE", tbl)

SetTempStorage("TITLES", {
[1] = "Coperal",
})