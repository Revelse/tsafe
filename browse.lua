local _,tSave = ...

tSave.Browse = {}

local MAX_ROT = math.pi*2
local STEP = (MAX_ROT)/720

function tSave.Browse.CreateWindow()
	
	tSave.Browse.MainFrame = CreateFrame("Frame","tSaveBrowseMainFrame",UIParent,"ButtonFrameTemplate")
	tSave.Browse.MainFrame:SetSize(600,500)
	tSave.Browse.MainFrame:SetPoint("CENTER",0,0)
	tSave.Browse.MainFrame.TitleText:SetText("tSave - Beta");
	tSave.Browse.MainFrame.portrait:SetTexture([[Interface\AddOns\tSave\Files\wrench]]);
	EnableFrameMovement(tSave.Browse.MainFrame)
	tinsert(UISpecialFrames,"tSaveBrowseMainFrame")
	tSave.Browse.MainFrame.onCloseCallback = tSave.main.CloseBrowser
	
	tSave.Browse.Dress = CreateFrame("DressUpModel",nil,tSave.Browse.MainFrame)
	tSave.Browse.Dress:SetSize(393,407)
	tSave.Browse.Dress:SetPoint("TOPLEFT",7,-62)
	tSave.Browse.Dress:SetUnit("player")
	tSave.Browse.Dress.Rotation = 0
	tSave.Browse.Dress:SetBackdrop({
	  edgeFile = "Interface/Tooltips/UI-Tooltip-Border"
	})
	
	tSave.Browse.Grid = CreateFrame("ScrollFrame","tSaveBrowseGrid",tSave.Browse.MainFrame,"UIPanelScrollFrameTemplate")
	tSave.Browse.Grid:SetPoint("TOPLEFT",400,-63)
	tSave.Browse.Grid:SetSize(168,305)
	tSave.Browse.Grid.scrollStep = 5

	tSave.Browse.Grid.Container = CreateFrame("Frame",nil,tSave.Browse.Grid)
	tSave.Browse.Grid.Container:SetSize(168,50)
	tSave.Browse.Grid:SetScrollChild(tSave.Browse.Grid.Container)
	
	tSave.Browse.Morph = CreateFrame("Button",nil,tSave.Browse.MainFrame,"UIPanelButtonTemplate,SecureActionButtonTemplate")
	tSave.Browse.Morph:SetSize(150,30)
	tSave.Browse.Morph:SetPoint("TOPLEFT",425,-370)
	tSave.Browse.Morph:SetText("Morph")
	tSave.Browse.Morph:RegisterForClicks("AnyUp")
	tSave.Browse.Morph:SetAttribute("type1", "macro")
	tSave.Browse.Morph:SetAttribute("macrotext1", "")
	
	tSave.Browse.Modify = CreateFrame("Button",nil,tSave.Browse.MainFrame,"UIPanelButtonTemplate")
	tSave.Browse.Modify:SetSize(150,30)
	tSave.Browse.Modify:SetPoint("TOPLEFT",425,-405)
	tSave.Browse.Modify:SetText("Modify")	
	tSave.Browse.Modify:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				tSave.main.ShowModify()
			end
		end
	)
	
	tSave.Browse.New = CreateFrame("Button",nil,tSave.Browse.MainFrame,"UIPanelButtonTemplate")
	tSave.Browse.New:SetSize(150,30)
	tSave.Browse.New:SetPoint("TOPLEFT",425,-440)
	tSave.Browse.New:SetText("New")		
	tSave.Browse.New:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				tSave.main.ShowModify("New")
			end
		end
	)
	
	tSave.Browse.Male = CreateFrame("CheckButton", "tSaveBrowseMaleCheckButton", tSave.Browse.MainFrame, "ChatConfigCheckButtonTemplate")
	tSave.Browse.Male:SetPoint("TOPLEFT",90, -20)
	getglobal(tSave.Browse.Male:GetName() .. "Text"):SetText("Male")
	tSave.Browse.Male.tooltip = "If you check this, your characters gender will be Male"
	tSave.Browse.Male:SetScript("onClick", tSave.main.GenderChange)
	
	tSave.Browse.Female = CreateFrame("CheckButton", "tSaveBrowseFemaleCheckButton", tSave.Browse.MainFrame, "ChatConfigCheckButtonTemplate")
	tSave.Browse.Female:SetPoint("TOPLEFT",90, -38)
	getglobal(tSave.Browse.Female:GetName() .. "Text"):SetText("Female")
	tSave.Browse.Female.tooltip = "If you check this, your characters gender will be Female"	
	tSave.Browse.Female:SetScript("onClick", tSave.main.GenderChange)
	
	tSave.Browse.DropAdd = CreateFrame("Frame", "tSaveBrowseDropAdd", tSave.Browse.MainFrame, "UIDropDownMenuTemplate")
	tSave.Browse.DropAdd:SetPoint("TOPLEFT", 175, -25)
	UIDropDownMenu_SetWidth(tSave.Browse.DropAdd, 100)
	UIDropDownMenu_SetText(tSave.Browse.DropAdd, tSave.Morph.Race)
	
	UIDropDownMenu_Initialize(tSave.Browse.DropAdd,
		function(self, level, menuList)
			local info = UIDropDownMenu_CreateInfo()
			if ( level or 1 ) == 1 then
				local i = 0
				for key, value in pairs(tSave.Constants.Races) do
					info.text = key
					info.func = function(...) return tSave.main.RaceChange(key) end
					info.checked = tSave.Morph.Race == key
					info.menuList = i
					info.hasArrow = false
					i = i + 1
					UIDropDownMenu_AddButton(info)
				end
			end
		end
	)
	
	tSave.Browse.DeleteButton = CreateFrame("Button",nil,tSave.Browse.MainFrame)
	local shortcut = tSave.Browse.DeleteButton
	shortcut:SetPoint("TOPLEFT", 420, -25)
	shortcut:SetSize(150,30)
	shortcut.String = shortcut:CreateFontString(nil,"ARTWORK")
	shortcut.String:SetFont("Fonts\\FRIZQT__.TTF", 16)
	shortcut.String:SetText("Delete")
	shortcut.String:SetPoint("CENTER",0,0)
	shortcut.String:SetSize(150,30)
	shortcut:SetScript("onEnter", function () shortcut.String:SetText("|c00FFFF00Delete") end )
	shortcut:SetScript("onLeave", function () shortcut.String:SetText("|c00FFFFFFDelete") end )
	shortcut:SetScript("onClick", tSave.main.RemoveSet)	
	
	tSave.Browse.MainFrame:Hide()
end

function tSave.Browse.AddGridEntry(int, data)
	local shortcut
	if not tSave.Browse.Grid.Container[int] then
		tSave.Browse.Grid.Container[int] = CreateFrame("CheckButton", "tSaveBrowseGridButton"..int, tSave.Browse.Grid.Container)
		shortcut = tSave.Browse.Grid.Container[int]
		shortcut:SetSize(168,38)
		shortcut:SetPoint("TOPLEFT",0,-(int-1)*40)
		shortcut.CheckedTexture = shortcut:CreateTexture(nil,"ARTWORK")
		shortcut.CheckedTexture:SetTexture(1,1,0,0.2)
		shortcut.CheckedTexture:SetAllPoints()
		shortcut:SetCheckedTexture(shortcut.CheckedTexture)
		shortcut.HightlightTexture = shortcut:CreateTexture(nil,"BORDER")
		shortcut.HightlightTexture:SetTexture(0.27,0.5,0.7,0.3)
		shortcut.HightlightTexture:SetAllPoints()
		shortcut:SetHighlightTexture(shortcut.HightlightTexture)
		shortcut.Name = shortcut:CreateFontString(nil,"OVERLAY")
		shortcut.Name:SetFont("Fonts\\FRIZQT__.TTF", 12)
		shortcut.Name:SetPoint("RIGHT",-10,0)
		shortcut:SetBackdrop({
		  edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		  edgeSize = 16,
		})		
		shortcut:SetScript("onClick", tSave.main.onGridClick)
		
	end
	shortcut = tSave.Browse.Grid.Container[int]
	shortcut.Name:SetText("|c00FFF000 ID: "..data.Name)
	shortcut:Show()
end

function tSave.Browse.OnShow()
	tSave.Browse.Dress:SetUnit("player")
	tSave.Browse.MainFrame:SetScript("onUpdate", tSave.Browse.OnUpdate)
	tSave.Browse.Dress:Undress()
	tSave.main.UpdateDemonstrationModel()
end

function tSave.Browse.OnUpdate()
	tSave.Browse.Dress.Rotation = tSave.Browse.Dress.Rotation + STEP
	tSave.Browse.Dress:SetRotation(tSave.Browse.Dress.Rotation,false)
end