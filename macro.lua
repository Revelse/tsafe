local _,tSave = ...

tSave.Macro = {}


function tSave.Macro.CreateWindow()
	tSave.Macro.MainFrame = CreateFrame("Frame","tSaveMacroMainFrame",UIParent,"ButtonFrameTemplate")
	tSave.Macro.MainFrame:SetSize(300,200)
	tSave.Macro.MainFrame:SetPoint("CENTER",0,0)
	tSave.Macro.MainFrame.TitleText:SetText("tSave - Macro administration")
	tSave.Macro.MainFrame.portrait:SetTexture([[Interface\AddOns\tSave\Files\wrench]])
	tSave.Macro.MainFrame:SetFrameLevel(5)
	EnableFrameMovement(tSave.Macro.MainFrame)
	tinsert(UISpecialFrames,"tSaveMacroMainFrame")
	
	tSave.Macro.Load = CreateFrame("Button",nil,tSave.Macro.MainFrame)
	local shortcut = tSave.Macro.Load
	shortcut:SetPoint("TOPLEFT", 60, -25)
	shortcut:SetSize(50,30)
	shortcut.String = shortcut:CreateFontString(nil,"ARTWORK")
	shortcut.String:SetFont("Fonts\\FRIZQT__.TTF", 16)
	shortcut.String:SetText("Load")
	shortcut.String:SetPoint("CENTER",0,0)
	shortcut.String:SetSize(50,30)
	shortcut:SetScript("onEnter", function () shortcut.String:SetText("|c00FFFF00| Load") end )
	shortcut:SetScript("onLeave", function () shortcut.String:SetText("|c00FFFFFFLoad") end )
	shortcut:SetScript("onClick",
		function(widget,btn,down)
			if btn == "LeftButton" and not down then
				tSave.Modify.CheckMacroText(tSave.Macro.Editbox:GetText())
			end
		end
	)	
	
	
	tSave.Macro.Grid = CreateFrame("ScrollFrame","tSaveMacroGrid",tSave.Macro.MainFrame,"UIPanelScrollFrameTemplate")
	tSave.Macro.Grid:SetPoint("TOPLEFT",7,-62)
	tSave.Macro.Grid:SetSize(261,110)
	tSave.Macro.Grid.scrollStep = 5
	tSave.Macro.Editbox = CreateFrame("Editbox", nil, tSave.Macro.MainFrame)
	tSave.Macro.Editbox:SetFont("Fonts\\FRIZQT__.TTF", 12)
	tSave.Macro.Editbox.NormalTexture = tSave.Macro.Editbox:CreateTexture(nil,"BACKGROUND")
	tSave.Macro.Editbox.NormalTexture:SetTexture(0,0,0,0.25)
	tSave.Macro.Editbox.NormalTexture:SetAllPoints()	
	tSave.Macro.Editbox:SetSize(261,110)
	tSave.Macro.Editbox:Raise()
	tSave.Macro.Editbox:SetMultiLine(true)
	tSave.Macro.Grid:SetScrollChild(tSave.Macro.Editbox)
end