local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()

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
	for index = 1, GetNumClasses() do
		local classDisplayName, classTag, classID = GetClassInfo(index)
		local classColor = C_ClassColor.GetClassColor(classTag);

		table.insert(classColors, {
			sort = classID,
			description = classDisplayName,
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





local ItemQualityColors = {}
table.foreach(Enum.ItemQuality, function(key, id)
	local entry = ITEM_QUALITY_COLORS[id]
	table.insert(ItemQualityColors, {
		sort = id,
		description = key,
		colorObj = entry.color,
		color = {entry.r, entry.g, entry.b, 1}
	})
end)

ColorTools.colorPalettes["ItemQuality"] = {
	order = 2,
	name = L["ItemQuality"],
	colors = ItemQualityColors
}



local PowerBarColorTable = {}
local PowerBarColori = 0

table.foreach(PowerBarColor, function(key, entry)
	if _.isNumber(key) then return  end
	if entry.r and entry.g and entry.b then 
		print(key, entry)
		PowerBarColori = PowerBarColori + 1
		table.insert(PowerBarColorTable, {
			sort = PowerBarColori,
			description = key,
			colorObj = CreateColor(entry.r, entry.g, entry.b, 1),
			color = {entry.r, entry.g, entry.b, 1}
		})
	end
end)



ColorTools.colorPalettes["powerBarColor"] = {
	order = 3,
	name = L["powerBarColor"],
	colors = PowerBarColorTable
}


ColorTools.colorPalettes["objectiveTrackerColor"] = {
	order = 3,
	name = L["objectiveTrackerColor"],
	colors = covertColors2(covertColors(OBJECTIVE_TRACKER_COLOR))
}


ColorTools.colorPalettes["debuffTypeColor"] = {
	order = 3,
	name = L["debuffTypeColor"],
	colors = covertColors2(covertColors(DebuffTypeColor))
}



