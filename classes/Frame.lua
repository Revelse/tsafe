local addonStorage = select(2,...)

Frame = inherit(Singleton)

local MAXGRID = 6

function Frame:constructor()
	
	self.m_Sets = addonStorage.SETS == nil and {} or addonStorage.SETS
	self.m_GridEntrys = {}
	self.m_EditMode = false
	self.m_EditContent = false
	self.m_GridOffset = 0
	self.m_Selected = false
	
	self:load()	
end

function Frame:load()

	self.m_Frame = CreateFrame("Frame",nil,UIParent)
	self.m_Frame:SetPoint("CENTER",0,0)
	self.m_Frame:SetWidth(500)
	self.m_Frame:SetHeight(480)
	EnableMovement(self.m_Frame)
	CreateBorder(self.m_Frame)	
	
	self.m_LoadMog = CreateFrame("Button",nil,self.m_Frame,"SecureActionButtonTemplate")
	self.m_LoadMog:SetPoint("CENTER",0,-210)
	self.m_LoadMog:SetWidth(120)
	self.m_LoadMog:SetHeight(30)
	self.m_LoadMog:SetText("|cffffffffMorph: None")
	self.m_LoadMog:RegisterForClicks("AnyUp")
	self.m_LoadMog:SetAttribute("type1", "macro")
	self.m_LoadMog:SetAttribute("macrotext1", LGET("Nothing Selected"))	
	CreateButtonBorder(self.m_LoadMog)
	
	self.m_NewSet = CreateFrame("Button",nil,self.m_Frame)
	self.m_NewSet:SetPoint("LEFT", 25 ,40)
	self.m_NewSet:SetWidth(120)
	self.m_NewSet:SetHeight(30)
	self.m_NewSet:SetText("|cffffffffNew set")
	self.m_NewSet:SetScript("onClick", 
		function (widget,btn,down)
			if btn == "LeftButton" and not down then 
				self:ShowEdit("Create")
			end
		end
	)
	CreateButtonBorder(self.m_NewSet)
	
	self.m_ModifySet = CreateFrame("Button",nil,self.m_Frame)
	self.m_ModifySet:SetPoint("RIGHT", -25 ,40)
	self.m_ModifySet:SetWidth(120)
	self.m_ModifySet:SetHeight(30)	
	self.m_ModifySet:SetText("|cffffffffModify set")
	self.m_ModifySet:SetScript("onClick", 
		function (widget,btn,down)
			if btn == "LeftButton" and not down and ( self.m_Selected and self.m_Sets[self.m_Selected] ) then 
				self:ShowEdit("Modify")
			end
		end
	)	
	CreateButtonBorder(self.m_ModifySet)
	
	self.m_DeleteSet = CreateFrame("Button",nil,self.m_Frame)
	self.m_DeleteSet:SetPoint("CENTER", 0 ,40)
	self.m_DeleteSet:SetWidth(120)
	self.m_DeleteSet:SetHeight(30)	
	self.m_DeleteSet:SetText("|cffffffffDelete set")
	self.m_DeleteSet:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down and ( self.m_Selected and self.m_Sets[self.m_Selected] ) then 
				table.remove(self.m_Sets,self.m_Selected)
				addonStorage.SETS = self.m_Sets
				self.m_Selected = false
				self.m_LoadMog:SetText("|cffffffffMorph: None")
				self.m_LoadMog:SetAttribute("macrotext1", LGET("Nothing Selected"))	
				self:RefreshSetList()
			end
		end
	)
	CreateButtonBorder(self.m_DeleteSet)

	self.m_Close = CreateFrame("Button",nil,self.m_Frame)
	self.m_Close:SetPoint("TOPRIGHT",0,0)
	self.m_Close:SetWidth(30)
	self.m_Close:SetHeight(30)
	self.m_Close:SetText("X")
	self.m_Close:SetScript("onClick", function (_,button,down) if button == "LeftButton" and not down then self.m_Frame:Hide() end end)
	CreateButtonBorder(self.m_Close)
	
	self.m_Gridlist = CreateFrame("Frame",nil,self.m_Frame)
	self.m_Gridlist:SetPoint("TOPLEFT", 0, -240)
	self.m_Gridlist:SetWidth(500)
	self.m_Gridlist:SetHeight(190)
	
	self.m_CreditString = self.m_Frame:CreateFontString(nil,"OVERLAY",self.m_Frame)
	self.m_CreditString:SetPoint("BOTTOMRIGHT",0,0)
	self.m_CreditString:SetFont("Fonts\\FRIZQT__.TTF", 8)
	self.m_CreditString:SetSize(150,20)
	self.m_CreditString:SetText("Written by Revelse")
	
	self.m_Gridlist:SetScript("OnMouseWheel",
		function( widget, delta )
			local mouseKind = delta == -1 and "mouse_wheel_down" or "mouse_wheel_up"
			
			if mouseKind == "mouse_wheel_down" then
				if self.m_GridOffset+2 <= #self.m_GridEntrys then
					self.m_GridOffset = self.m_GridOffset + 1
				end
			else
				if self.m_GridOffset-1 > -1 then
					self.m_GridOffset = self.m_GridOffset - 1
				end
			end
			
			self:RefreshSetList()
		end
	)

	self:loadGrid()
	self:loadEdit()
	self.m_Frame:Hide()
	
	SLASH_TSAFE1 = "/ts"
	SLASH_TSAFE2 = "/tsafe"
	SLASH_TSAFE3 = "/tsave"
	SlashCmdList.TSAFE = bind(self.m_Frame.Show, self.m_Frame)
end

function Frame:RefreshSetList()
	for i = 1+self.m_GridOffset, MAXGRID+self.m_GridOffset do
		if not self.m_Sets[i] then self.m_GridEntrys[i-self.m_GridOffset]:Hide() else 
		local set = self.m_Sets[i]
		self.m_GridEntrys[i-self.m_GridOffset]:SetText(("|cffffffffID %d: %s"):format(i,set["NICK"]))
		self.m_GridEntrys[i-self.m_GridOffset].m_GridId = i - self.m_GridOffset
		self.m_GridEntrys[i-self.m_GridOffset]:Show()
		end
	end	
end

function Frame:ShowEdit(mode)
	self.m_EditMode = mode
	self.m_Frame:Hide()
	self.m_Edit:Show()
	self.m_ModelEdit:SetUnit("player")
	self:loadModel(mode)
end

function Frame:loadModel(mode)
	self.m_EditContent = ".item 1 0\n.item 3 0\n.item 15 0\n.item 5 0\n.item 4 0\n.item 19 0\n.item 9 0\n.item 16 0\n.item 17 0\n.item 10 0\n.item 6 0\n.item 7 0\n.item 8 0\n.race 0\n.title 0\n.enchant 1 0\n.enchant 2 0"
	if mode == "Create" then self:ClearPane() return true; end
	if mode ~= "Modify" then return end
	local rows = string.split(self.m_Sets[self.m_Selected].VALUE,"\n")
	self.m_ModelEdit:Undress()
	self.m_EditEnchantMain = 0
	self.m_EditEnchantOff = 0
	-- First let's find the enchants
	for key, value in ipairs(rows) do
		local content = string.split(value," ")
		if content[1]:find(".enchant") then
			if content[2] == "1" then
				self.m_EditEnchantMain = tonumber(content[3])
				self.m_EditContent = string.gsub(self.m_EditContent,".enchant 1 0", ".enchant 1 "..content[3])
				self.m_EditScrollPane.content["16_BUTTON"].m_Selected = GetTempStorage("ENCHANT_INFO_REVERSE")[self.m_EditEnchantMain] or 0
				self.m_EditScrollPane.content["16_BUTTON"].m_FontString:SetText(self.m_EditScrollPane.content["16_BUTTON"].m_Selected)
			else
				self.m_EditEnchantOff = tonumber(content[3])
				self.m_EditContent = string.gsub(self.m_EditContent,".enchant 2 0", ".enchant 2 "..content[3])
				self.m_EditScrollPane.content["17_BUTTON"].m_Selected = GetTempStorage("ENCHANT_INFO_REVERSE")[self.m_EditEnchantOff] or 0
				self.m_EditScrollPane.content["17_BUTTON"].m_FontString:SetText(self.m_EditScrollPane.content["17_BUTTON"].m_Selected)
			end
		end
	end
	for key, value in ipairs(rows) do
		local content = string.split(value," ")
			if string.find(self.m_EditContent,("item %d"):format(content[2])) then
				self.m_EditContent = string.gsub(self.m_EditContent,("item %d 0"):format(content[2]),("item %d %d"):format(content[2],content[3]))
			end
		if content[1]:find(".item") then
			local _,link = GetItemInfo(content[3])
			self:TryOn(self:PrepareLink(link,tonumber(content[2])))
			local editBox = self.m_EditScrollPane.content.ITEM_EDITBOXES[tonumber(content[2])]
			editBox.realContent = content[3]
			editBox:SetText(editBox.realContent)
			self:OnEditFocusLost(editBox)
		end
		self.m_EditScrollPane.content.NAME:SetText(self.m_Sets[self.m_Selected]["NICK"])
	end
end

function Frame:onRaceChange()

end

function Frame:onSexChange()
	
end

function Frame:TryOn(item)
	if item ~= nil then
		self.m_ModelEdit:TryOn(item)
	end
	return false
end

function Frame:ClearPane()
	self.m_ModelEdit:Undress()
	for key, value in pairs(self.m_EditScrollPane.content.ITEM_EDITBOXES) do
		value:SetText(0)
		self:OnEditFocusLost(value)
	end
end

function Frame:GetCurrentEquipLink(slot)
	return select(2,GetItemInfo(self:GetCurrentEquipID(slot)))
end

function Frame:GetCurrentEquipID(slotID)
	local rows = string.split(self.m_EditContent,"\n")
	for key, value in ipairs (rows) do
		local content = string.split(value," ")
		if content[1]:find(".item") and tonumber(content[2]) == slotID then
			return content[3]
		end
	end
	return false
end

function Frame:Equip(itemID,slotID)
	self.m_EditContent = string.gsub(self.m_EditContent,("item %d %d"):format(slotID, self:GetCurrentEquipID(slotID)),("item %d %d"):format(slotID,itemID))
end

function Frame:Enchant(oldEnchant,enchantID,enchantSlot)
	self.m_EditContent = string.gsub(self.m_EditContent,("enchant %d %d"):format(enchantSlot,oldEnchant),("enchant %d %d"):format(enchantSlot,enchantID))
end

function Frame:PrepareLink(item,slot)
	if slot == 16 or slot == 17 and item ~= nil then
		return string.format(string.gsub(item or 0, "item:(%d+):0", "item:%1:%%d"), slot == 16 and self.m_EditEnchantMain or self.m_EditEnchantOff)
	end
	return item
end

function Frame:loadEdit()
	self.m_EditEnchantMain = 0
	self.m_EditEnchantOff  = 0
	self.m_Edit = CreateFrame("Frame",nil,UIParent)
	self.m_Edit:SetPoint("CENTER",0,0)
	self.m_Edit:SetWidth(600)
	self.m_Edit:SetHeight(480)
	EnableMovement(self.m_Edit)
	CreateBorder(self.m_Edit,false,0.2)

	self.m_ModelEdit = CreateFrame("DressUpModel",nil,self.m_Edit,"ModelWithControlsTemplate")
	self.m_ModelEdit:SetPoint("RIGHT",0,-25)
	self.m_ModelEdit:SetWidth(300)
	self.m_ModelEdit:SetHeight(275)	
	self.m_ModelEdit:SetUnit("player")
	
	-- Add the 'click' set-modifying
	-- Todo: Add transmog-support -> GetInventoryItemID
	hooksecurefunc("HandleModifiedItemClick", 
		function(link)
			local _,_,_,_,_,_,_,_,inv_type = GetItemInfo(link)
			local id = GetTempStorage("TOKEN_SLOT")[inv_type]
			if id and self.m_Edit:IsVisible() and IsShiftKeyDown() then
				local itemID = string.split(link,":")[2]
				self:Equip(itemID,id)
				self:TryOn(self:PrepareLink(link,id))
				local editBox = self.m_EditScrollPane.content.ITEM_EDITBOXES[id]
				editBox:ClearFocus()
				editBox.realContent = itemID
				editBox:SetText(link)
				editBox:SetSize(190,20)
				self:TryOn(self:PrepareLink(link,id))
				self:Equip(itemID,id)			
			end
	end)
	
	self.m_CloseEdit = CreateFrame("Button",nil,self.m_Edit)
	self.m_CloseEdit:SetPoint("TOPRIGHT",0,0)
	self.m_CloseEdit:SetWidth(30)
	self.m_CloseEdit:SetHeight(30)
	self.m_CloseEdit:SetText("X")	
	self.m_CloseEdit:SetScript("onClick", 
		function (widget,btn,down)
			if btn == "LeftButton" and not down then
				self.m_Edit:Hide()
				self.m_Frame:Show() 
			end
		end 
	)
	CreateButtonBorder(self.m_CloseEdit)
	
	self.m_AcceptEdit = CreateFrame("Button", nil, self.m_Edit)
	self.m_AcceptEdit:SetPoint("CENTER", 0, -200 )
	self.m_AcceptEdit:SetWidth(120)
	self.m_AcceptEdit:SetHeight(30)
	self.m_AcceptEdit:SetText("|cffffffffAccept")
	self.m_AcceptEdit:SetScript("onClick", bind(self.onEditAccept,self))
	CreateButtonBorder(self.m_AcceptEdit,true)	
	
	self.m_CloseDesc = CreateFrame("SimpleHTML", nil, self.m_Edit)
	self.m_CloseDesc:SetPoint("TOPLEFT",25,-25)
	self.m_CloseDesc:SetFont("Fonts\\FRIZQT__.TTF", 11)
	self.m_CloseDesc:SetFont("h1", "Fonts\\FRIZQT__.TTF", 35)
	self.m_CloseDesc:SetText(GetTempStorage("ADDON_DESC"))
	self.m_CloseDesc:SetWidth(500)
	self.m_CloseDesc:SetHeight(300)
	
	self.m_EditScrollPane = CreateFrame("ScrollFrame","TSafe_EditScrollPane",self.m_Edit,"UIPanelScrollFrameTemplate")
	self.m_EditScrollPane:SetPoint("LEFT", 0, -25 )
	self.m_EditScrollPane:SetWidth(275)
	self.m_EditScrollPane:SetHeight(250)
	self.m_EditScrollPane.scrollStep = 5
	
	
	self.m_EditScrollPane.content = self:loadEditContent()	
	
	self.m_EditScrollPane:SetScrollChild(self.m_EditScrollPane.content) 
	
	self.m_Edit:Hide()	
end

function Frame:loadEditContent()
	
	local frame = CreateFrame("Frame", nil, scrollframe)
	frame:SetSize(275, 750)
	local texture = frame:CreateTexture()
	texture:SetAllPoints()
	texture:SetTexture(0.2,0.2,0.2,0.15)
	frame.texture = texture
	frame.ITEM_EDITBOXES = {}
	--frame:SetBackdrop(GetTempStorage("ScrollPaneBackdrop"))

	frame.NAME_TEXT = frame:CreateFontString(nil,"OVERLAY",frame)
	frame.NAME_TEXT:SetPoint("TOPLEFT",0,-5)
	frame.NAME_TEXT:SetFont("Fonts\\FRIZQT__.TTF", 12)
	frame.NAME_TEXT:SetSize(300,20)
	frame.NAME_TEXT:SetText("Nick")
	
	frame.NAME = CreateFrame("Editbox", nil, frame)
	frame.NAME:SetPoint("TOPLEFT",20,-25)
	frame.NAME:SetFont("Fonts\\FRIZQT__.TTF", 12)
	frame.NAME:SetSize(100,20)
	local tex = frame.NAME:CreateTexture(nil,"BACKGROUND")
	tex:SetAllPoints()
	tex:SetTexture(0.3,0.3,0.3,0.4)
	
	local i = 0
	for key, value in ipairs(GetTempStorage("ORDER_INFO")) do
		
		frame[value[1].."_TEXT"] = frame:CreateFontString(nil,"OVERLAY",frame)
		frame[value[1].."_TEXT"]:SetPoint("TOPLEFT",0, -75 + -50*i)
		frame[value[1].."_TEXT"]:SetFont("Fonts\\FRIZQT__.TTF", 12)
		frame[value[1].."_TEXT"]:SetSize(300,20)
		frame[value[1].."_TEXT"]:SetText(value[2])		
		
		frame.ITEM_EDITBOXES[value[1]] = CreateFrame("Editbox", nil, frame)
		frame.ITEM_EDITBOXES[value[1]]:SetPoint("TOPLEFT", 20, -100 + -50*i)
		frame.ITEM_EDITBOXES[value[1]]:SetFont("Fonts\\FRIZQT__.TTF", 12)
		frame.ITEM_EDITBOXES[value[1]]:SetSize(100,20)	
		
		if value[1] == 16 or value[1] == 17 then
			frame[value[1].."_BUTTON"] = CreateScrollFrame(self,frame,self.EnchantScroll)
			frame[value[1].."_BUTTON"]:SetPoint("TOPLEFT", 230, - 100 + -50*i)
			frame[value[1].."_BUTTON"]:SetSize(20,20)
			frame[value[1].."_BUTTON"].m_MaxScroll = #GetTempStorage("ENCHANT_INFO")
			frame[value[1].."_BUTTON"].Slot = value[1]
		end
		
		local tex = frame.ITEM_EDITBOXES[value[1]]:CreateTexture(nil,"BACKGROUND")
		tex:SetAllPoints()
		tex:SetTexture(0.3,0.3,0.3,0.4)	
		frame.ITEM_EDITBOXES[value[1]].realContent = 0
		frame.ITEM_EDITBOXES[value[1]].Slot = value[1]
		frame.ITEM_EDITBOXES[value[1]]:SetText(0)
		frame.ITEM_EDITBOXES[value[1]]:SetScript("OnEditFocusGained", bind(self.onEditBoxFocusGained,self))
		frame.ITEM_EDITBOXES[value[1]]:SetScript("OnEditFocusLost", bind(self.OnEditFocusLost,self))
		i = i + 1
	end
	
	return frame
end

function Frame:EnchantScroll(widget)
	local oldEnchant = widget.Slot == 16 and self.m_EditEnchantMain or self.m_EditEnchantOff
	if widget.Slot == 16 then
		self.m_EditEnchantMain = GetTempStorage("ENCHANT_INFO")[widget.m_Selected][1]
	else
		self.m_EditEnchantOff = GetTempStorage("ENCHANT_INFO")[widget.m_Selected][1]
	end
	local link = self:GetCurrentEquipLink(widget.Slot)
	self:TryOn(self:PrepareLink(link,widget.Slot))
	self:Enchant(oldEnchant,GetTempStorage("ENCHANT_INFO")[widget.m_Selected][1],widget.Slot-15)
end

function Frame:onEditBoxFocusGained (this)
	this:SetText(this.realContent or 0)
	this:SetSize(100,20)	
end

function Frame:OnEditFocusLost (this)
	this.realContent = this:GetText()
	local _,link,_,_,_,_,_,_,inv_type = GetItemInfo(this.realContent)
	if type(link) ~= "nil" and GetTempStorage("TOKEN_SLOT")[inv_type] == this.Slot then
		this.realContent = this:GetText()
		this:SetText(link)
		this:SetSize(190,20)
		self:TryOn(self:PrepareLink(link,this.Slot))
		self:Equip(this.realContent,this.Slot)
	else
		this:SetText("0")
		this.realContent = 0
		this:SetSize(100,20)
		self:Equip(this.realContent,this.Slot)
		self.m_ModelEdit:UndressSlot(this.Slot)
	end	
end

function Frame:onEditAccept(widget,button,down)
	if button == "LeftButton" and not down then
		if self.m_EditMode == "Create" then
			table.insert(self.m_Sets, { ["NICK"] = self.m_EditScrollPane.content.NAME:GetText() or math.random(999999), ["VALUE"] = self.m_EditContent} )
		else
			local set = self.m_Sets[self.m_Selected]
			local nick = set["NICK"]
			local editNick = self.m_EditScrollPane.content.NAME:GetText()
			if editNick ~= nick then nick = editNick end
			self.m_Sets[self.m_Selected] = { ["NICK"] = nick or "NO NAME", ["VALUE"] = self.m_EditContent} 
		end
		addonStorage.SETS = self.m_Sets
		self.m_Edit:Hide()
		self.m_Frame:Show() 
		self:RefreshSetList()
	end
end


function Frame:onGridClick(widget,button,down)
	if ( widget.m_GridId and button == "LeftButton" and not down ) then
		self.m_Selected = widget.m_GridId + self.m_GridOffset
		self.m_LoadMog:SetText("|cffffffffMorph: "..self.m_Selected)
		self.m_LoadMog:SetAttribute("macrotext1", self.m_Sets[self.m_Selected].VALUE)
	end
end

function Frame:loadGrid()
	for i = 1, MAXGRID, 1 do
		self.m_GridEntrys[i] = CreateFrame("Button",nil,self.m_Gridlist)
		self.m_GridEntrys[i]:SetWidth(450)
		self.m_GridEntrys[i]:SetHeight(190/MAXGRID)
		self.m_GridEntrys[i]:SetPoint("TOP",0,(i-1)*-190/MAXGRID)	
		self.m_GridEntrys[i]:Hide()
		self.m_GridEntrys[i].m_GridId = i
		self.m_GridEntrys[i]:SetScript("OnClick", bind(self.onGridClick,self))
		CreateButtonBorder(self.m_GridEntrys[i])
		
		if self.m_Sets[i] then
			local set = self.m_Sets[i]
			self.m_GridEntrys[i]:SetText(("|cffffffffID %d: %s"):format(i,set["NICK"]))
			self.m_GridEntrys[i]:Show()
		end
		
	end
end
