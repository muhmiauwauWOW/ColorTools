-- ColorTools ColorConnector
-- Creates and manages color palettes for the addon

local addonName, ColorTools =  ...
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("LibLodash-1"):Get()

-- Converts a color table object to RGBA lists
local function convertColors(colors)
	if type(colors) ~= "table" then return {} end
	local newColors = {}
	for k, v in pairs(colors) do
		if v and v.r and v.g and v.b then
			newColors[k] = {v.r, v.g, v.b, v.a or 1}
		end
	end
	return newColors
end

local function convertColorsList(colors)
	if type(colors) ~= "table" then return {} end
	local newColors = {}
	for k, v in pairs(colors) do
		if v and type(v) == "table" then
			table.insert(newColors, {
				sort = k,
				description = tostring(k),
				color = v
			})
		end
	end
	return newColors
end

-- Helper for generic palette creation
local function createGenericPalette(tbl, name, order)
	return {
		order = order,
		name = L[name],
		colors = convertColorsList(convertColors(tbl))
	}
end

-- Creates the palette for last used colors
local function createLastUsedPalette()
	return {
		order = 0,
		name = L["lastUsedColors"],
		colors = {}
	}
end

-- Creates the favorites palette
local function createFavoritePalette()
	return {
		order = 0,
		name = L["favoriteColors"],
		colors = {}
	}
end

-- Creates the class colors palette
local function createClassPalette()
	local classNames = LocalizedClassList()
	local sortedClasses = {}
	for key, value in pairs(classNames) do
		table.insert(sortedClasses, { key = key, value = value })
	end
	table.sort(sortedClasses, function(a, b) return a.value < b.value end)

	local function processClassColors(colorsTable)
		local cTable = {}
		for idx, classObj in ipairs(sortedClasses) do
			local colorObj = colorsTable[classObj.key]
			if colorObj and colorObj.GetRGBA then
				table.insert(cTable, {
					sort = idx,
					description = classObj.value,
					color = {colorObj:GetRGBA()}
				})
			end
		end
		return cTable
	end

	local classTable = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
	return {
		order = 1,
		name = L["classColors"],
		colors = processClassColors(classTable)
	}
end

-- Creates the item quality colors palette
local function createItemQualityPalette()
	local ItemQualityColors = {}
	for key, id in pairs(Enum.ItemQuality) do
		local entry = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[id]
		if entry and entry.r and entry.g and entry.b then
			table.insert(ItemQualityColors, {
				sort = id,
				description = key,
				colorObj = entry.color,
				color = {entry.r, entry.g, entry.b, 1}
			})
		end
	end
	return {
		order = 2,
		name = L["ItemQuality"],
		colors = ItemQualityColors
	}
end

-- Creates the font colors palette
local function createFontColorsPalette()
	-- Alle festen Strings durch L["ColorTools_<Key>"] ersetzen
	local fontColors = {
		{color = WHITE_FONT_COLOR, name = L["White"]},
		{color = RED_FONT_COLOR, name = L["Red"]},
		{color = GREEN_FONT_COLOR, name = L["Green"]},
		{color = BLUE_FONT_COLOR, name = L["Blue"]},
		{color = GRAY_FONT_COLOR, name = L["Gray"]},
		{color = BLACK_FONT_COLOR, name = L["Black"]},
		{color = HIGHLIGHT_FONT_COLOR, name = L["Highlight"]},
		{color = DISABLED_FONT_COLOR, name = L["Disabled"]},
		{color = DIM_RED_FONT_COLOR, name = L["DimRed"]},
		{color = ORANGE_FONT_COLOR, name = L["Orange"]},
		{color = YELLOW_FONT_COLOR, name = L["Yellow"]},
		{color = BRIGHTBLUE_FONT_COLOR, name = L["BrightBlue"]},
		{color = LIGHTYELLOW_FONT_COLOR, name = L["LightYellow"]},
		{color = ARTIFACT_GOLD_COLOR, name = L["ArtifactGold"]},
	}
	local colors = {}
	for i, entry in ipairs(fontColors) do
		local colorObj = entry.color
		if colorObj and colorObj.r and colorObj.g and colorObj.b then
			table.insert(colors, { 
				sort = i, 
				description = entry.name,
				color = {colorObj.r, colorObj.g, colorObj.b, colorObj.a or 1} 
			})
		end
	end
	return {
		order = 10,
		name = L["FontColors"],
		colors = colors
	}
end



-- Creates the covenant colors palette
local function createCovenantColorsPalette()
	local colors = {}
	for k, v in pairs(COVENANT_COLORS) do
		if type(k) == "string" and v and type(v) == "table" and v.r and v.g and v.b then
			table.insert(colors, {
				sort = k,
				description = tostring(k),
				color = {v.r, v.g, v.b, v.a or 1}
			})
		end
	end
	-- Sort alphabetically by description
	table.sort(colors, function(a, b)
		return tostring(a.description) < tostring(b.description)
	end)
	return {
		order = 13,
		name = L["CovenantColors"],
		colors = colors
	}
end

-- Creates the material text colors palette
local function createMaterialTextColorsPalette()
	return createGenericPalette(MATERIAL_TEXT_COLOR_TABLE, "MaterialTextColors", 14)
end

-- Creates the power bar colors palette
local function createPowerBarPalette()
	local colors = {}
	for k, v in pairs(PowerBarColor) do
		-- Only use string keys, skip numeric fallback keys
		if type(k) == "string" and v and type(v) == "table" and v.r and v.g and v.b then
			-- Standard color definition
			table.insert(colors, {
				sort = k,
				description = tostring(k),
				color = {v.r, v.g, v.b, v.a or 1}
			})
		elseif type(k) == "string" and v and type(v) == "table" then
			-- Special case: nested color definitions (e.g. STAGGER)
			for subKey, subVal in pairs(v) do
				if type(subVal) == "table" and subVal.r and subVal.g and subVal.b then
					table.insert(colors, {
						sort = k .. "-" .. subKey,
						description = tostring(k) .. "-" .. tostring(subKey),
						color = {subVal.r, subVal.g, subVal.b, subVal.a or 1}
					})
				end
			end
		end
	end
	-- Sort alphabetically by description
	table.sort(colors, function(a, b)
		return tostring(a.description) < tostring(b.description)
	end)
	return {
		order = 15,
		name = L["PowerBarColor"],
		colors = colors
	}
end

-- Creates the objective tracker colors palette
local function createObjectiveTrackerPalette()
	return createGenericPalette(OBJECTIVE_TRACKER_COLOR, "ObjectiveTrackerColor", 16)
end

-- Creates the player faction colors palette
local function createPlayerFactionColorsPalette()
	local colors = {}
	local factionNames = {
		[0] = "Horde",
		[1] = "Alliance"
	}
	for k, v in pairs(PLAYER_FACTION_COLORS) do
		if (k == 0 or k == 1) and v and type(v) == "table" and v.r and v.g and v.b then
			table.insert(colors, {
				sort = k,
				description = factionNames[k] or tostring(k),
				color = {v.r, v.g, v.b, v.a or 1}
			})
		end
	end
	-- Sort by sort key (0 first, then 1)
	table.sort(colors, function(a, b)
		return a.sort < b.sort
	end)
	return {
		order = 20,
		name = L["PlayerFactionColors"],
		colors = colors
	}
end

-- Creates the material title text colors palette
local function createMaterialTitleTextColorsPalette()
	local colors = {}
	for k, v in pairs(MATERIAL_TITLETEXT_COLOR_TABLE) do
		if v and type(v) == "table" and v.r and v.g and v.b then
			table.insert(colors, {
				sort = k,
				description = tostring(k),
				color = {v.r, v.g, v.b, v.a or 1}
			})
		end
	end
	-- Sort alphabetically by description
	table.sort(colors, function(a, b)
		return tostring(a.description) < tostring(b.description)
	end)
	return {
		order = 22,
		name = L["MaterialTitleTextColors"],
		colors = colors
	}
end

-- Register palettes alphabetically
local palettes = {
	{"lastUsedColors", createLastUsedPalette},
	{"favoriteColors", createFavoritePalette},
	{"classColors", createClassPalette},
	{"CovenantColors", createCovenantColorsPalette},
	{"FontColors", createFontColorsPalette},
	{"ItemQuality", createItemQualityPalette},
	{"MaterialTextColors", createMaterialTextColorsPalette},
	{"MaterialTitleTextColors", createMaterialTitleTextColorsPalette},
	{"ObjectiveTrackerColor", createObjectiveTrackerPalette},
	{"PlayerFactionColors", createPlayerFactionColorsPalette},
	{"PowerBarColor", createPowerBarPalette},
}

for _, entry in ipairs(palettes) do
	local key, fn = entry[1], entry[2]
	ColorTools.colorPalettes[key] = fn()
end


-- ColorTools.colorPalettes["lastUsedColors"] = createLastUsedPalette()
-- ColorTools.colorPalettes["favoriteColors"] = createFavoritePalette()
-- ColorTools.colorPalettes["classColors"] = createClassPalette()
-- ColorTools.colorPalettes["ItemQuality"] = createItemQualityPalette()
-- ColorTools.colorPalettes["powerBarColor"] = createPowerBarPalette()
-- ColorTools.colorPalettes["objectiveTrackerColor"] = createObjectiveTrackerPalette()
-- ColorTools.colorPalettes["debuffTypeColor"] = createDebuffTypePalette()
