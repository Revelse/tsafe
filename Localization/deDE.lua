if not GetTempStorage("ADDON_DEBUG") then if GetLocale() ~= "deDE" then return end end

local L = {}

L["Welcome Message"	  ]	= {"Willkommen zum AddOn \'%s\' rev. %d von %s!",GetTempStorage("ADDON_NAME"),GetTempStorage("ADDON_VERSION"),GetTempStorage("ADDON_FOUNDER")}

Localization:getSingleton():AddNewStrings(L,"deDE")