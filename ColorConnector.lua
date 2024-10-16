local addonName, ColorTools =  ...
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("LibLodash-1"):Get()


local function covertColors(colors)
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


local function covertColors2(colors)
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

ColorTools.colorPalettes["favoriteColors"] = {
	order = 0,
	name = L["favoriteColors"],
	colors = {}
}






local classNames = LocalizedClassList()
local sortedClasses = {}
for key, value in pairs(classNames) do
	tinsert(sortedClasses, {
		key = key,
		value = value,
	})
end

sort(sortedClasses, function(a, b) return a.value < b.value end)


local function processClassColors(colorsTable)
	local cTable = {}
	_.forEach(sortedClasses, function(classObj, idx)
		if not colorsTable[classObj.key] then return end
		table.insert(cTable, {
			sort = idx,
			description = classObj.value,
			color = {colorsTable[classObj.key]:GetRGBA()}
		})
	end)

	return cTable
end

local classTable = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
ColorTools.colorPalettes["classColors"] = {
	order = 1,
	name = L["classColors"],
	colors = processClassColors(classTable)
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
