-- ColorTools ColorConnector
-- Creates and manages color palettes for the addon

local addonName, ColorTools =  ...
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("LibLodash-1"):Get()

-- Color conversion utilities
local ColorUtils = {}

-- Validates if a table has valid color properties
function ColorUtils.isValidColor(color)
	return color and type(color) == "table" and color.r and color.g and color.b
end

-- Extracts RGBA values from a color object
function ColorUtils.extractRGBA(color)
	return {color.r, color.g, color.b, color.a or 1}
end

-- Creates a color entry for palettes
function ColorUtils.createColorEntry(sort, description, color)
	return {
		sort = sort,
		description = description,
		color = color
	}
end

-- Sorts colors alphabetically by description
function ColorUtils.sortColorsByDescription(colors)
    return _.sortBy(colors, function(a) return tostring(a.description) end)
end

-- Generic function to process color tables into palette format
function ColorUtils.processColorTable(colorTable, nameProvider, sortProvider)
    local colors = {}
    _.forEach(colorTable, function(v, k)
        if ColorUtils.isValidColor(v) then
            local name = nameProvider and nameProvider(k, v) or tostring(k)
            local sort = sortProvider and sortProvider(k, v) or k
            table.insert(colors, ColorUtils.createColorEntry(
                sort,
                name,
                ColorUtils.extractRGBA(v)
            ))
        end
    end)
    return colors
end

-- Process nested color tables (like PowerBarColor)
function ColorUtils.processNestedColorTable(colorTable, nameProvider)
    local colors = {}
    _.forEach(colorTable, function(v, k)
        if type(k) == "string" and v and type(v) == "table" then
            if ColorUtils.isValidColor(v) then
                local name = nameProvider and nameProvider(k, v) or tostring(k)
                table.insert(colors, ColorUtils.createColorEntry(k, name, ColorUtils.extractRGBA(v)))
            else
                -- Handle nested structures
                _.forEach(v, function(subVal, subKey)
                    if ColorUtils.isValidColor(subVal) then
                        local combinedKey = k .. "-" .. subKey
                        local combinedName = nameProvider and nameProvider(combinedKey, subVal) or combinedKey
                        table.insert(colors, ColorUtils.createColorEntry(combinedKey, combinedName, ColorUtils.extractRGBA(subVal)))
                    end
                end)
            end
        end
    end)
    return colors
end

-- Generic palette creation helpers
local function createBasicPalette(name, colors)
	return {
		name = L[name],
		colors = colors or {}
	}
end

local function createGenericPalette(colorTable, name, customProcessor)
	local colors = customProcessor and customProcessor(colorTable) or ColorUtils.processColorTable(colorTable)
	return createBasicPalette(name, ColorUtils.sortColorsByDescription(colors))
end

-- Palette creation functions
local PaletteCreators = {}

function PaletteCreators.createLastUsedPalette()
    return { name = L["lastUsedColors"], colors = {} }
end
function PaletteCreators.createFavoritePalette()
    return { name = L["favoriteColors"], colors = {} }
end
function PaletteCreators.createClassPalette()
    local classNames = LocalizedClassList()
    local sortedClasses = _.sortBy(
        _.map(classNames, function(value, key) return { key = key, value = value } end),
        function(a) return a.value end
    )
    local function processClassColors(colorsTable)
        return _.map(sortedClasses, function(classObj, idx)
            local colorObj = colorsTable[classObj.key]
            if colorObj and colorObj.GetRGBA then
                return ColorUtils.createColorEntry(idx, classObj.value, {colorObj:GetRGBA()})
            end
        end)
    end
    local classTable = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    return {
        name = L["classColors"],
        colors = _.filter(processClassColors(classTable), function(v) return v ~= nil end)
    }
end
function PaletteCreators.createCovenantColorsPalette()
    local filtered = {}
    _.forEach(COVENANT_COLORS, function(v, k)
        if type(k) == "string" and ColorUtils.isValidColor(v) then
            table.insert(filtered, ColorUtils.createColorEntry(k, k, ColorUtils.extractRGBA(v)))
        end
    end)
    return createBasicPalette("CovenantColors", ColorUtils.sortColorsByDescription(filtered))
end
function PaletteCreators.createPlayerFactionColorsPalette()
    local factionNames = { [0] = "Horde", [1] = "Alliance" }
    local nameProvider = function(k, v) return factionNames[k] or tostring(k) end
    local colors = ColorUtils.processColorTable(PLAYER_FACTION_COLORS, nameProvider)
    local filteredColors = _.filter(colors, function(color) return color.sort == 0 or color.sort == 1 end)
    return createBasicPalette("PlayerFactionColors", _.sortBy(filteredColors, function(a) return a.sort end))
end
-- Generische Palette-Erstellung für alle anderen
local genericPalettes = {
    FontColors = { table = {
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
    }, name = "FontColors" },
    ItemQuality = { table = Enum.ItemQuality, name = "ItemQuality", custom = function(tbl)
        return _.filter(_.map(tbl, function(id, key)
            local entry = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[id]
            if ColorUtils.isValidColor(entry) then
                return ColorUtils.createColorEntry(id, key, ColorUtils.extractRGBA(entry))
            end
        end), function(v) return v ~= nil end)
    end },
    MaterialTextColors = { table = MATERIAL_TEXT_COLOR_TABLE, name = "MaterialTextColors" },
    MaterialTitleTextColors = { table = MATERIAL_TITLETEXT_COLOR_TABLE, name = "MaterialTitleTextColors" },
    ObjectiveTrackerColor = { table = OBJECTIVE_TRACKER_COLOR, name = "ObjectiveTrackerColor" },
    PowerBarColor = { table = PowerBarColor, name = "PowerBarColor", custom = ColorUtils.processNestedColorTable },
}
for key, def in pairs(genericPalettes) do
    PaletteCreators["create" .. key .. "Palette"] = function()
        local colors
        if def.custom then
            colors = def.custom(def.table)
        else
            colors = ColorUtils.processColorTable(def.table)
        end
        return createBasicPalette(def.name, ColorUtils.sortColorsByDescription(colors))
    end
end

-- Register palettes alphabetically
local paletteRegistry = {
	{"lastUsedColors", PaletteCreators.createLastUsedPalette},
	{"favoriteColors", PaletteCreators.createFavoritePalette},
	{"classColors", PaletteCreators.createClassPalette},
	{"CovenantColors", PaletteCreators.createCovenantColorsPalette},
	{"FontColors", PaletteCreators.createFontColorsPalette},
	{"ItemQuality", PaletteCreators.createItemQualityPalette},
	{"MaterialTextColors", PaletteCreators.createMaterialTextColorsPalette},
	{"MaterialTitleTextColors", PaletteCreators.createMaterialTitleTextColorsPalette},
	{"ObjectiveTrackerColor", PaletteCreators.createObjectiveTrackerPalette},
	{"PlayerFactionColors", PaletteCreators.createPlayerFactionColorsPalette},
	{"PowerBarColor", PaletteCreators.createPowerBarPalette},
}

-- Initialize all palettes
_.forEach(paletteRegistry, function(entry, order)
    local key, creatorFn = entry[1], entry[2]
    local palette = creatorFn()
    palette.order = order
    ColorTools.colorPalettes[key] = palette
end)
