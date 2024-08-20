local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")

function covertColors(colors)
	local newColors = {};

	for k, v in pairs(colors) do
		if type(k) == "string" then
			
			if colors[k].r == nil then

			else
				newColors[k] = {
					colors[k].r,
					colors[k].g,
					colors[k].b,
					1
				};
			end
		end
	end

	return newColors;

end


function covertColors2(colors)
	local newColors = {};
	
	table.foreach(colors,function(k,v) 

		table.insert(newColors, {
			sort = k,
			color = v
		})



	end)


	return newColors;

end



ColorTools.colorPalettes["lastUsedColors"] = {
	order = 0,
	name = L["lastUsedColors"],
	colors = {}
}


local classColors = {}
do
	local classes = {"HUNTER", "WARLOCK", "PRIEST", "PALADIN", "MAGE", "ROGUE", "DRUID", "SHAMAN", "WARRIOR", "DEATHKNIGHT", "MONK", "DEMONHUNTER", "EVOKER"};

	for i, className in ipairs(classes) do
		local classColor = C_ClassColor.GetClassColor(className);
		table.insert(classColors, {
			sort = i,
			color = {
				classColor.r,
				classColor.g,
				classColor.b,
				1
			}
		})
	end
end


ColorTools.colorPalettes["classColors"] = {
	order = 1,
	name = L["classColors"],
	colors = classColors
}


ColorTools.colorPalettes["powerBarColor"] = {
	order = 2,
	name = L["powerBarColor"],
	colors = covertColors2(covertColors(PowerBarColor))
}


ColorTools.colorPalettes["objectiveTrackerColor"] = {
	order = 2,
	name = L["objectiveTrackerColor"],
	colors = covertColors2(covertColors(OBJECTIVE_TRACKER_COLOR))
}


ColorTools.colorPalettes["debuffTypeColor"] = {
	order = 2,
	name = L["debuffTypeColor"],
	colors = covertColors2(covertColors(DebuffTypeColor))
}



