
-- This file become loaded independent by the language of the client, thereby the Localization-Manager has replacements for missing strings.

local L = {}

L["Welcome Message"	  ]	= {"Welcome to the AddOn \'%s\' rev. %d by %s!",GetTempStorage("ADDON_NAME"),GetTempStorage("ADDON_VERSION"),GetTempStorage("ADDON_FOUNDER")}
L["Nothing Selected"] = "/run print(\"nothing selected.\")"

Localization:getSingleton():AddNewStrings(L,"enUS")