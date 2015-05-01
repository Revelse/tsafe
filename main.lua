local f = CreateFrame("Frame") -- Setup Frame

local addonName, tSave = ...
tSaveDB = tSaveDB == nil and {} or tSaveDB
tSaveDB.Sets = tSaveDB.Sets == nil and {} or tSaveDB.Sets
tSave.Client = {}
tSave.Morph = {}
tSave.Client.RealSex = UnitSex("player") == 2 and "Male" or "Female"
tSave.Client.Sex = UnitSex("player") == 2 and "Male" or "Female"
tSave.Client.Race = select(2,UnitRace("player"))

tSave.Morph.Race = tSave.Client.Race
tSave.Morph.Sex = tSave.Client.Sex
tSave.Morph.Selected = false
tSave.Morph.Mode = false

function f:onEvent(frame,addon)
	if addon == addonName then
		tSave.Browse.CreateWindow()
		tSave.main.Init()
		tSave.Modify.CreateWindow()
		tSave.Macro.CreateWindow()
		--CreateSettingsWindow()
		f:UnregisterEvent("ADDON_LOADED")
	end
end
f:SetScript("onEvent", f.onEvent)
f:RegisterEvent("ADDON_LOADED")

tSave.main = CreateFrame("Frame")

function tSave.main.ShowBrowser()
	tSave.Browse.MainFrame:Show()
	tSave.Browse.OnShow()
end

SLASH_TSAVE1 = "/ts"
SLASH_TSAVE2 = "/tsave"
SlashCmdList.TSAVE = tSave.main.ShowBrowser

function tSave.main.CloseBrowser()
	tSave.Browse.MainFrame:SetScript("onUpdate", nil)
	tSave.Browse.MainFrame:Hide()
end

function tSave.main.ShowModify(mode)
	tSave.Browse.MainFrame:Hide()
	tSave.Modify.MainFrame:Show()
	tSave.Modify.OnShow(mode)
end

function tSave.main.CloseModify()
	tSave.Modify.MainFrame:SetScript("onUpdate", nil)
	tSave.Modify.MainFrame:Hide()
	tSave.Morph.Mode = false
	tSave.main.ShowBrowser()
end

function tSave.main.Init()
	tSave.main.FillDemonstrationGrid()
	tSave.Browse.Male:SetChecked(tSave.Client.Sex == "Male")
	tSave.Browse.Female:SetChecked(tSave.Client.Sex == "Female")
end

function tSave.main.FillDemonstrationGrid()
	for key, value in ipairs(tSaveDB.Sets) do
		tSave.Browse.AddGridEntry(key,value)
	end
end

function tSave.main.SaveSet(set)
	if tSave.Modify.Mode == "New" then
		tSave.Morph.Selected = #tSaveDB.Sets
		tSave.main.AddNewSet(set)
	else
		tSaveDB.Sets[tSave.Morph.Selected] = set
	end
	tSave.main.FillDemonstrationGrid()
	tSave.main.UpdateDemonstrationModel()
	tSave.main.CloseModify()
end

function tSave.main.RemoveSet()
	if tSave.Morph.Selected then
		tSave.Browse.Grid.Container[tSave.Morph.Selected]:Hide()
		table.remove(tSaveDB.Sets,tSave.Morph.Selected)
		tSave.Morph.Selected = false
		tSave.main.UpdateDemonstrationModel()
		tSave.main.FillDemonstrationGrid()
	end
end

function tSave.main.AddNewSet(set)
	local currentTotal = #tSaveDB.Sets
	tSaveDB.Sets[currentTotal+1] = set
end

function tSave.main.onGridClick(widget)
	if not widget then return end
	local widgetNick = widget:GetName()
	local id = tonumber(widgetNick:sub(widgetNick:len(),widgetNick:len()))
	tSave.Morph.Selected = id
	for key, value in ipairs(tSave.Browse.Grid.Container) do
		if key ~= tSave.Morph.Selected then
			value:SetChecked(false)
		end
	end
	if id then
		tSave.Browse.Morph:SetAttribute("macrotext1", FormSetToMacroString(tSaveDB.Sets[id]))	
	end
	tSave.main.UpdateDemonstrationModel()
end

function tSave.main.GenderChange(widget)
	tSave.Morph.Sex = widget:GetName():find("Male") and "Male" or "Female"
	tSave.Browse.Male:SetChecked(tSave.Morph.Sex == "Male")
	tSave.Browse.Female:SetChecked(tSave.Morph.Sex == "Female")
	if tSave.Morph.Selected then tSave.Browse.Morph:SetAttribute("macrotext1", FormSetToMacroString(tSaveDB.Sets[tSave.Morph.Selected])) end
	tSave.main.UpdateDemonstrationModel()
end

function tSave.main.RaceChange(race)
	tSave.Morph.Race = race
	UIDropDownMenu_SetText(tSave.Browse.DropAdd, race)
	if tSave.Morph.Selected then tSave.Browse.Morph:SetAttribute("macrotext1", FormSetToMacroString(tSaveDB.Sets[tSave.Morph.Selected])) end
	tSave.main.UpdateDemonstrationModel()
end

function tSave.main.UpdateDemonstrationModel()
	tSave.Browse.Dress:SetCustomRace(tSave.Constants.Races[tSave.Morph.Race], tSave.Morph.Sex == "Male" and 0 or 1)
	tSave.Browse.Dress:Undress();tSave.Browse.Dress:UndressSlot(1);
	DressUpModelWithSet(tSave.Browse.Dress,tSaveDB.Sets[tSave.Morph.Selected] or {Items={}})
end

-- Important Callback

function tSaveChangeGender()
	tSave.Client.Sex = tSave.Morph.Sex
end