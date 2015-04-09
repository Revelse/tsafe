local tempStorage = {}
local storage = select(2,...)

function GetTempStorage(key)
	return tempStorage[key]
end

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function SetTempStorage(key,value)
	tempStorage[key] = value
	return value
end

function EnableMovement(frame)
	frame:RegisterForDrag("MiddleButton")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)	
end

function CreateBorder (widget,nobg,alpha)
	local alpha = alpha or 1
	local tex = widget:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetPoint("BOTTOMRIGHT", 0, 0)
	--tex:SetTexture(0.27,0.93,1, 1)
	tex:SetTexture(0.2,0.2,0.2,0.45)
	local tex = widget:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(0,0,0)
	if not nobg then
		local tex = widget:CreateTexture(nil,"ARTWORK")
		tex:SetPoint("TOPLEFT", 0, 0)
		tex:SetPoint("BOTTOMRIGHT", 0, 0)
		tex:SetTexture("Interface\\AddOns\\TSafe\\Files\\tsafe.tga")
		tex:SetVertexColor(1,1,1,alpha)	
	end
	--tex:SetTexture(0, 0, 0, 1)
end	

function CreateButtonBorder(widget)
	widget:EnableMouse(true)
	local tex = widget:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetPoint("BOTTOMRIGHT", 0, 0)
	--tex:SetTexture(0.27,0.93,1, 0.5)
	tex:SetTexture(0.2,0.2,0.2,0.45)
	widget.m_Background = tex
	local tex = widget:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(0, 0, 0, 0.5)
	local tex = widget:CreateTexture(nil,"HIGHLIGHT")
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetPoint("BOTTOMRIGHT", 0, 0)	
	tex:SetTexture(1,1,1,0.3)
	widget:SetNormalFontObject(GameFontHighlight)
end

function CreateButtonBorderTemplate(widget)
	widget:EnableMouse(true)
	local tex = widget:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetPoint("BOTTOMRIGHT", 0, 0)
	--tex:SetTexture(0.27,0.93,1, 0.5)
	tex:SetTexture(0.2,0.2,0.2,0.45)
	widget.m_Background = tex
	local tex = widget:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(0, 0, 0, 0.5)
	local tex = widget:CreateTexture(nil,"HIGHLIGHT")
	tex:SetPoint("TOPLEFT", 0, 0)
	tex:SetPoint("BOTTOMRIGHT", 0, 0)	
	tex:SetTexture(1,1,1,0.3)
end

function storage_load()

tSafeDB = tSafeDB == nil and {} or tSafeDB

setmetatable(storage,{__index = tSafeDB,
					  __newindex = tSafeDB
					  })
end