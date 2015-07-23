-- API and Useful

local _,tSave = ...

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function EnableFrameMovement(frame)
	frame:RegisterForDrag("LeftButton")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)	
end

function table.copy(orig)
	-- ToDo:
	return orig
end


function DressUpModelWithSet(model,set)
	-- suppress headglitch
	model:TryOn(44742)
	model:UndressSlot(1)

	for slot, item in pairs(set.Items) do
		if slot == 16 or slot == 17 then
			local enchant = set.Enchants[slot-15] or 0
			local link = SetEnchantLink(item,slot,enchant)	
			model:TryOn(link)
		else
			model:TryOn(tonumber(item))
		end
	end
end

function SetEnchantLink(item,slot,enchant)
	local _,link,_,_,_,_,_,_,kind = GetItemInfo(item)
	if ( slot == 16 or slot == 17 ) and enchant then
		return string.format(string.gsub(link or "", "item:(%d+):0", "item:%1:%%d"), enchant or 0)
	end
	return item
end

function FormSetToMacroString(set)
	local str = ""
	-- Items
		for key, value in pairs(set.Items) do
			str = str .. (".item %d %d\n"):format(key, value)
		end
	-- Enchants
		for key, value in pairs(set.Enchants) do
			str = str .. (".enchant %d %d\n"):format(key,value)
		end
	-- Gender
		if tSave.Client.Sex ~= tSave.Morph.Sex then
			str = str .. ".gender\n"
		end
	-- Race
		str = str .. (".race %d\n"):format(tSave.Constants.Races[tSave.Morph.Race])
	--
		str = str .. "/run tSaveChangeGender()"
	
	return str
end