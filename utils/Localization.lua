Localization = inherit(Singleton)

function Localization:constructor()
	self.m_Locals = {}
end

function Localization:AddNewStrings(l,id)
	local i = 0
	for key, value in pairs (l) do
		if not self.m_Locals[key] then
			if type(value) == "string" or #value == 1 then
				self.m_Locals[key] = value[1] or value
			else
				local patternWords = {}
				for patternWord = 2, #value, 1 do
					table.insert(patternWords,value[patternWord])
				end
				self.m_Locals[key] = value[1]:format(unpack(patternWords))
			end
			i = i + 1
		end
	end
	print(("[%s]Localization-Mananger: Added %d new strings (%s)"):format(GetTempStorage("ADDON_NAME"),i,id or "UNKNOWN"))
end

function LGET(t)
	return Localization:getSingleton().m_Locals[t]
end