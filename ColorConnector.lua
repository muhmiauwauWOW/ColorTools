local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")




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




ColorTools.colorPalettes["lastUsedColors"] = {
	order = 0,
	name = "Last Used Colors",
	colors = {}
}

ColorTools.colorPalettes["classColors"] = {
	order = 1,
	name = "Class Colors",
	colors = CLASS_ICON_TCOORDS
}



ColorTools.colorPalettes["powerBarColor"] = {
	order = 2,
	name = "PowerBar Colors",
	colors = covertColors(PowerBarColor)
}


ColorTools.colorPalettes["objectiveTrackerColor"] = {
	order = 2,
	name = "Objective Tracker Color",
	colors = covertColors(OBJECTIVE_TRACKER_COLOR)
}


ColorTools.colorPalettes["debuffTypeColor"] = {
	order = 2,
	name = "Debuff TypeColor",
	colors = covertColors(DebuffTypeColor)
}

