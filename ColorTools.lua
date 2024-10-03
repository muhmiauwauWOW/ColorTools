local addonName, ColorTools =  ...
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("LibLodash-1"):Get()

ColorTools.colorPalettes = {}


ColorTools.config = {
	frameExtend = 90,
	swatchSize = 32,
	spacer = 5,
	maxLastUsedColors = 30,
	selected = "lastUsedColors"
}

-- ColorTools.config.


ColorTools.init = CreateFrame("Frame")
ColorTools.init:RegisterEvent("PLAYER_LOGIN")
ColorTools.init:SetScript("OnEvent", function()
	ColorToolsLastUsed = ColorToolsLastUsed or {}
	ColorToolsFavorites = ColorToolsFavorites or {}
	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed
	ColorTools.colorPalettes["favoriteColors"].colors = ColorToolsFavorites
	ColorPickerFrame:SetHeight(ColorPickerFrame:GetHeight() + 90)
end)


ColorPickerFrame.Footer.OkayButton:HookScript('OnClick', function()  
	local r, g, b = ColorPickerFrame:GetColorRGB();
	local alpha = ColorPickerFrame:GetColorAlpha()
	local color = {r, g ,b, alpha}
	
	if not _.isEmpty(ColorToolsLastUsed) then
		if CreateColor(table.unpack(ColorToolsLastUsed[1].color)):IsEqualTo(CreateColor(table.unpack(color))) then 
			return
		end
	end

	table.insert(ColorToolsLastUsed, 1, { sort = time(), color = color })
	ColorToolsLastUsed = _.slice(ColorToolsLastUsed, 1, ColorTools.config.maxLastUsedColors)
	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed
end)





ColorPickerFrame:HookScript('OnShow', function(self)
	self.Content:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", ColorTools.config.frameExtend * -1, 0 )

	local w = 331 + ColorTools.config.frameExtend
	if self.hasOpacity then
		w = 388 + ColorTools.config.frameExtend
    end

	self:SetWidth(w);
	ColorToolsPaletteFrame:updateColorPalette(w)
end)   


function ColorTools.updateColorPalette(pallete)
	if ColorToolsDropdown.selected == "favoriteColors" then
		ColorToolsPaletteFrame:updateColorPalette()
	end
end










ColorTools.favorits = {}

function ColorTools.favorits:is(color, i)
	local fn = i and _.findIndex or _.find
	return fn(ColorToolsFavorites, function(entry)
		return CreateColor(table.unpack(entry.color)):IsEqualTo(CreateColor(table.unpack(color)))
	end)
end

function ColorTools.favorits:add(color)
	if self:is(color.color)then return end
	table.insert(ColorToolsFavorites, 1, color)
	ColorTools:updateColorPalette("favoriteColors")
end

function ColorTools.favorits:remove(color)
	local index = self:is(color, true)
	table.remove(ColorToolsFavorites, index)
	ColorTools:updateColorPalette("favoriteColors")
end