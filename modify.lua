local _,tSave = ...

local MAX_ROT = math.pi*2
local STEP = MAX_ROT/720

tSave.Modify = {}
tSave.Modify.TempSet = {}
tSave.Modify.Mode = false

tSave.Modify.SaveEntrys = {
	[1] = { text = "Save", func = function(...) return tSave.main.SaveSet(tSave.Modify.TempSet) end, tooltip = "Save the Set", hasArrow = false, MenuList = nil},
	[2] = { text = "Copy", func = nil, tooltip = "Copy a Set", hasArrow = true, MenuList = "CopyEntrys"},
	[3] = { text = "Load Macro", func = function(...) tSave.Macro.MainFrame:Show() end, tooltip = "Load Macro", hasArrow = false },
	[4] = { text = "Add Item", func = function(...) print("Use the editbox called \"Add Item\"") end, tooltip ="Add Item", hasArrow = false }
}

tSave.Modify.EnchantEntrys = {
	[1] = { text = "Main Hand", MenuList = "Main Hand" },
	[2] = { text = "Off Hand", MenuList = "Off Hand" },
}

tSave.Modify.Enchants = {
{0,"None"},
{4097,"Power Torrent"},
{257,"Bloody Dancing Steel"},
{2673,"Mongoose"},
{3846,"Mayor Healing"},
{3225,"Executioner"},
{4066,"Mending"},
{5397,"Primal Victory"},
{3854,"41+ Mana"},  
{258,"Windzorn Buff"},
}

function tSave.Modify.CreateWindow()
	tSave.Modify.MainFrame = CreateFrame("Frame","tSaveModifyMainFrame",UIParent,"ButtonFrameTemplate")
	tSave.Modify.MainFrame:SetSize(600,500)
	tSave.Modify.MainFrame:SetPoint("CENTER",0,0)
	tSave.Modify.MainFrame.TitleText:SetText("tSave - Creation and Modifying");
	tSave.Modify.MainFrame.portrait:SetTexture([[Interface\AddOns\tSave\Files\wrench]]);
	tSave.Modify.MainFrame.onCloseCallback = tSave.main.CloseModify
	EnableFrameMovement(tSave.Modify.MainFrame)
	tinsert(UISpecialFrames,"tSaveModifyMainFrame")
	
	tSave.Modify.Dress = CreateFrame("DressUpModel",nil,tSave.Modify.MainFrame)
	tSave.Modify.Dress:SetSize(293,407)
	tSave.Modify.Dress:SetPoint("TOPLEFT",7,-62)
	tSave.Modify.Dress:SetUnit("player")
	tSave.Modify.Dress.Rotation = 0
	tSave.Modify.Dress:SetBackdrop({
	  edgeFile = "Interface/Tooltips/UI-Tooltip-Border"
	})	
	
	hooksecurefunc("HandleModifiedItemClick", tSave.Modify.OnItemClick)	
	
	-- Dress Itemframes
	
	tSave.Modify.Dress.ItemFrames = {}

	for key, value in ipairs(tSave.Constants.SlotInfo) do
		tSave.Modify.Dress.ItemFrames[value[1]] = CreateFrame("Button", nil, tSave.Modify.Dress,"ItemButtonTemplate")
		local shortcut = tSave.Modify.Dress.ItemFrames[value[1]]
		shortcut.InfoSlot = key
		shortcut.Item = false
		shortcut.RealSlot = value[1]
		if key >= 1 and key <= 2 then
			shortcut:SetPoint("BOTTOM",(key-1)*40-20,10)
		elseif key >= 3 and key <= 8 then
			shortcut:SetPoint("TOPLEFT",10,-(key-3)*40-30)
		else
			shortcut:SetPoint("TOPRIGHT",-10,-(key-9)*40-30)
		end
		shortcut.icon:SetTexture(select(2, GetInventorySlotInfo(value[3])))
		shortcut:SetScript("onEnter", tSave.Modify.OnItemButtonHover)
		shortcut:SetScript("onLeave", GameTooltip_Hide)
		shortcut:RegisterForClicks("AnyUp")
	end
	
	tSave.Modify.LoadSaveButton = CreateFrame("Button",nil,tSave.Modify.MainFrame)
	local shortcut = tSave.Modify.LoadSaveButton
	shortcut:SetPoint("TOPLEFT", 60, -25)
	shortcut:SetSize(150,30)
	shortcut.String = shortcut:CreateFontString(nil,"ARTWORK")
	shortcut.String:SetFont("Fonts\\FRIZQT__.TTF", 16)
	shortcut.String:SetText("Save & Useful")
	shortcut.String:SetPoint("CENTER",0,0)
	shortcut.String:SetSize(150,30)
	shortcut:SetScript("onEnter", function () shortcut.String:SetText("|c00FFFF00| Save & Useful") end )
	shortcut:SetScript("onLeave", function () shortcut.String:SetText("|c00FFFFFFSave & Useful") end )
	shortcut:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				ToggleDropDownMenu(1,nil,tSave.Modify.DropSave,shortcut,0,0)
			end
		end
	)
	
	tSave.Modify.DropSave = CreateFrame("Frame", "tSaveModifyDropAdd", tSave.Modify.MainFrame, "UIDropDownMenuTemplate")
	local shortcut = tSave.Modify.DropSave
	shortcut:Hide()
	tSave.Modify.DropSave:SetPoint("TOPLEFT", 60, -25)
	UIDropDownMenu_SetButtonWidth(shortcut,120)
	
	UIDropDownMenu_Initialize(tSave.Modify.DropSave,
		function(self,level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			if (level or 1) == 1 then
				for key, value in ipairs(tSave.Modify.SaveEntrys) do
					info.text = value.text
					info.func = value.func
					info.hasArrow = value.hasArrow
					info.notCheckable = true
					info.menuList = value.MenuList
					UIDropDownMenu_AddButton(info)
				end
			elseif menuList == "CopyEntrys" then
				for key, value in ipairs(tSaveDB.Sets) do
					info.text = value.Name
					info.notCheckable = true
					info.func = function () tSave.Modify.CopySet(key) end
					UIDropDownMenu_AddButton(info,level)
				end
			end
		end
	)
	
	tSave.Modify.EnchantButton = CreateFrame("Button",nil,tSave.Modify.MainFrame)
	local shortcut = tSave.Modify.EnchantButton
	shortcut:SetPoint("TOPLEFT", 200, -25)
	shortcut:SetSize(150,30)
	shortcut.String = shortcut:CreateFontString(nil,"ARTWORK")
	shortcut.String:SetFont("Fonts\\FRIZQT__.TTF", 16)
	shortcut.String:SetText("Enchant")
	shortcut.String:SetPoint("CENTER",0,0)
	shortcut.String:SetSize(150,30)
	shortcut:SetScript("onEnter", function () shortcut.String:SetText("|c00FFFF00| Enchant") end )
	shortcut:SetScript("onLeave", function () shortcut.String:SetText("|c00FFFFFFEnchant") end )
	shortcut:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				ToggleDropDownMenu(1,nil,tSave.Modify.DropEnchant,shortcut,0,0)
			end
		end
	)
	
	tSave.Modify.DropEnchant = CreateFrame("Frame", "tSaveModifyDropAdd", tSave.Modify.MainFrame, "UIDropDownMenuTemplate")
	local shortcut = tSave.Modify.DropEnchant
	shortcut:Hide()
	tSave.Modify.DropEnchant:SetPoint("TOPLEFT", 60, -25)
	UIDropDownMenu_SetButtonWidth(shortcut,120)
	
	UIDropDownMenu_Initialize(tSave.Modify.DropEnchant,
		function(self,level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			if (level or 1) == 1 then
				for key, value in ipairs(tSave.Modify.EnchantEntrys) do
					info.text = value.text
					info.notCheckable = true
					info.hasArrow = true
					info.menuList = value.MenuList
					UIDropDownMenu_AddButton(info)
				end
			else
				for key, value in ipairs(tSave.Modify.Enchants) do
					info.text = value[2]
					info.Slot = menuList == "Main Hand" and 1 or 2
					info.checked = value[1] == tSave.Modify.TempSet.Enchants[info.Slot]
					info.func = function ()
						tSave.Modify.SetEnchant(info.Slot, value[1])
					end
					UIDropDownMenu_AddButton(info,level)
				end
			end
		end
	)
	
	tSave.Modify.Grid = CreateFrame("ScrollFrame","tSaveModifyGrid",tSave.Modify.MainFrame,"UIPanelScrollFrameTemplate")
	tSave.Modify.Grid:SetPoint("TOPLEFT",300,-63)
	tSave.Modify.Grid:SetSize(268,400)
	tSave.Modify.Grid.scrollStep = 5
	
	tSave.Modify.Grid.Container = CreateFrame("Frame",nil,tSave.Browse.Grid)
	tSave.Modify.Grid.Container:SetSize(268,50)
	tSave.Modify.Grid:SetScrollChild(tSave.Modify.Grid.Container)	
	
	tSave.Modify.Grid.Container.Name = tSave.Modify.CreateEditBox("TOPLEFT",0, -20, tSave.Modify.Grid.Container, "Name: ")
	tSave.Modify.Grid.Container.Name.onCallBack = tSave.Modify.NickChange
	
	tSave.Modify.Grid.Container.AddItem = tSave.Modify.CreateEditBox("TOPLEFT", 0, -80, tSave.Modify.Grid.Container, "Add Item: ")
	tSave.Modify.Grid.Container.AddItem.onCallBack = tSave.Modify.ItemEditAdd
	
	tSave.Modify.Grid.Container.Items = {}
	local i = 0
	for key, value in ipairs(tSave.Constants.SlotInfo) do
		tSave.Modify.Grid.Container.Items[value[1]] = tSave.Modify.CreateEditBox("TOPLEFT", 0, -140+(-(i*60)), tSave.Modify.Grid.Container, value[2]..": ")
		tSave.Modify.Grid.Container.Items[value[1]].InfoSlot = key
		tSave.Modify.Grid.Container.Items[value[1]].Slot = value[1]
		tSave.Modify.Grid.Container.Items[value[1]].onCallBack = tSave.Modify.ItemEditApply
		i = i + 1
	end	
	
	tSave.Modify.Macro = CreateFrame("Frame", "tSaveModifyMacroFrame", UIParent, "ButtonFrameTemplate")
	
	tSave.Modify.MainFrame:Hide()
end

function tSave.Modify.ItemEditAdd(widget,item)
	local item = tonumber(item)
	local _,_,_,_,_,_,_,_,kind = GetItemInfo(item)
	if not item or not kind then return end
	local slot = tSave.Constants.ValidNicks[kind]
	tSave.Modify.EquipItem(item,slot)
end

function tSave.Modify.CheckMacroText(text)
	-- Split text when ; or \n appears
	local text = string.split(text:gsub(";","\n") or "","\n") or {}
	-- Check for items
	for key, value in ipairs(text) do
		local valueSplitted = string.split(value," ")
		if value:find(".item") then
			tSave.Modify.EquipItem(tonumber(valueSplitted[3]),tonumber(valueSplitted[2]))
		end
	end
end

function tSave.Modify.CopySet(setId)
	local setData = tSaveDB.Sets[setId]
	for key, value in ipairs(tSave.Constants.SlotInfo) do
		tSave.Modify.RemoveItem(value[1],true)
	end	
	for key, value in pairs(tSaveDB.Sets[setId].Items) do
		tSave.Modify.EquipItem(tonumber(value),key)
	end		
end

function tSave.Modify.SetEnchant(slot,enchantId)
	tSave.Modify.TempSet.Enchants[slot] = enchantId
	local realSlot = slot == 1 and 16 or 17
	if tSave.Modify.TempSet.Items[realSlot] then
		tSave.Modify.EquipItem(tSave.Modify.TempSet.Items[realSlot],realSlot)
	end
end

function tSave.Modify.NickChange(widget,content)
	tSave.Modify.TempSet.Name = content or "none"
	tSave.Modify.Grid.Container.Name.Editbox:SetText(content)
end

function tSave.Modify.OnItemClick(link)
	local _,_,_,_,_,_,_,_,kind = GetItemInfo(link)
	local slot = tSave.Constants.ValidNicks[kind]
	if slot and tSave.Modify.MainFrame:IsVisible() and IsShiftKeyDown() then
		local item = string.split(link,":")[2]
		tSave.Modify.EquipItem(item,slot)
	end
end

function tSave.Modify.ItemEditApply(widget,content)
	if tonumber(content) and tonumber(content) ~= 0 then
		if GetItemInfo(content) then
			tSave.Modify.EquipItem(tonumber(content),widget.Slot)
		end
	else
		tSave.Modify.RemoveItem(widget.Slot)
	end
end

function tSave.Modify.RemoveItem(slot,arg)
	tSave.Modify.Dress.ItemFrames[slot].icon:SetTexture(select(2, GetInventorySlotInfo(tSave.Constants.SlotIdToSlot[slot])))
	tSave.Modify.Dress:UndressSlot(slot)
	tSave.Modify.Grid.Container.Items[slot].Editbox:SetText("")
	if not arg then
		tSave.Modify.TempSet.Items[slot] = nil
	end
	tSave.Modify.Dress.ItemFrames[slot].Item = false
end

function tSave.Modify.EquipItem(item,slot)
	-- Change Item Frames
	local _,_,_,_,_,_,_,_,kind,texture = GetItemInfo(item)
	if tSave.Constants.ValidNicks[kind] ~= slot then return end
	tSave.Modify.Dress.ItemFrames[slot].icon:SetTexture(texture)
	tSave.Modify.Dress.ItemFrames[slot].Item = item
	tSave.Modify.Grid.Container.Items[slot].Editbox:SetText(item)
	tSave.Modify.TempSet.Items[slot] = item
	if slot == 16 or slot == 17 then
		local enchant = tSave.Modify.TempSet.Enchants[slot-15] or 0
		local link = SetEnchantLink(item,slot,enchant)
		tSave.Modify.Dress:TryOn(link)
	else
		tSave.Modify.Dress:TryOn(tonumber(item))
	end
end

function tSave.Modify.CreateEditBox(anchor,x,y,parent,name,func)

	local f = CreateFrame("Frame",nil,parent)
	f:SetSize(250,30)
	f:SetPoint(anchor,x,y)
	f.onCallBack = func
	f.String = f:CreateFontString(nil,"ARTWORK")
	f.String:SetFont("Fonts\\FRIZQT__.TTF", 12)
	f.String:SetPoint("TOPLEFT", 0, 0)
	f.String:SetSize(70,30)
	f.String:SetText(name)
	f.Editbox = CreateFrame("Editbox", nil, f)
	f.Editbox:SetFont("Fonts\\FRIZQT__.TTF", 12)
	f.Editbox:SetPoint("TOPLEFT", 70, 0)
	f.Editbox.NormalTexture = f.Editbox:CreateTexture(nil,"BACKGROUND")
	f.Editbox.NormalTexture:SetTexture(0,0,0,1)
	f.Editbox.NormalTexture:SetAllPoints()	
	f.Editbox:SetSize(150,30)
	f.Editbox:SetBackdrop({
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		edgeSize = 16,
	})		
	f.ApplyButton = CreateFrame("Button",nil,f)
	f.ApplyButton:ClearAllPoints()
	f.ApplyButton:SetPoint("TOPLEFT", 220, 0)
	f.ApplyButton:SetSize(30,30)
	f.ApplyButton:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
	f.ApplyButton:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
	f.ApplyButton:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
	f.ApplyButton:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				f.onCallBack(f,f.Editbox:GetText())
			end
		end
	)
	
	return f
end

function tSave.Modify.OnItemButtonHover(widget)
	if widget.Item then
		GameTooltip:SetOwner(widget,"ANCHOR_RIGHT")
		local link = select(2,GetItemInfo(widget.Item))
		GameTooltip:SetHyperlink(link)
		GameTooltip:SetText(link)
	else
		GameTooltip:SetOwner(widget,"ANCHOR_RIGHT")
		GameTooltip:SetText(tSave.Constants.SlotInfo[widget.InfoSlot][2])
	end
end

function tSave.Modify.OnShow(mode)
	tSave.Modify.Mode = "Modify"
	for key, value in ipairs(tSave.Constants.SlotInfo) do
		tSave.Modify.RemoveItem(value[1],true)
	end	
	if mode == "New" then
		tSave.Modify.TempSet = {}
		tSave.Modify.TempSet.Name = math.random(999999)
		tSave.Modify.TempSet.Items = {}
		tSave.Modify.TempSet.Enchants = {}
		tSave.Modify.Mode = "New"	
	else
		tSave.Modify.TempSet = table.copy(tSaveDB.Sets[tSave.Morph.Selected])
	end
	tSave.Modify.Dress:SetUnit("player")
	tSave.Modify.Dress:SetCustomRace(tSave.Client.Race,tSave.Morph.RealSex == "Male" and 0 or 1)
	tSave.Modify.Dress:Undress()
	tSave.Modify.MainFrame:SetScript("onUpdate", tSave.Modify.OnUpdate)	
	tSave.Modify.NickChange(nil,tSave.Modify.TempSet.Name)
	-- suppress headglitch
	if type(tSave.Modify.TempSet[1]) == "nil" then
		tSave.Modify.Dress:TryOn(44742)
		tSave.Modify.Dress:UndressSlot(1)
	end
	for key, value in pairs(tSave.Modify.TempSet.Items) do
		tSave.Modify.EquipItem(tonumber(value),key)
	end	
end

function tSave.Modify.OnUpdate()
	tSave.Modify.Dress.Rotation = tSave.Modify.Dress.Rotation + STEP
	tSave.Modify.Dress:SetRotation(tSave.Modify.Dress.Rotation,false)
end