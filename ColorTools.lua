ColorTools = LibStub("AceAddon-3.0"):NewAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()


ColorTools.rbgTable =  {"R", "G", "B"}
ColorTools.hsvTable =  {"X", "Y", "Z"}

ColorTools.colorPalettes = {}

ColorTools.activeColorPalette =  "lastUsedColors"


ColorTools.editboxes = {};

ColorTools.colorSwatchX = 300;
ColorTools.colorSwatchY = -32;


function ColorTools:OnInitialize()
	if ColorToolsLastUsed == nil then 
		ColorToolsLastUsed = {}
	end
	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed

	--ColorTools:initDropdown()

	ColorTools:initColorPalette()

end 

ColorPickerFrame:SetHeight(ColorPickerFrame:GetHeight() +  90)




ColorPickerFrame.Footer.OkayButton:HookScript('OnClick', function()  
	local function sortColor(colors)
		return _.reverse(_.sortBy(ColorToolsLastUsed, function(a) return a.sort end))
	end
	local r, g, b = ColorPickerFrame:GetColorRGB();
	local alpha = ColorPickerFrame:GetColorAlpha()

	if not _.isEmpty(ColorToolsLastUsed) then 
		ColorToolsLastUsed = sortColor(ColorToolsLastUsed)
		if ColorToolsLastUsed[1].color[1] == r and  ColorToolsLastUsed[1].color[2] == g and ColorToolsLastUsed[1].color[3] == b  and ColorToolsLastUsed[1].color[4] == alpha then 
			return
		end
	end

	tinsert(ColorToolsLastUsed, {
		sort = time(),
		color = {r, g ,b, alpha}
	})

	ColorToolsLastUsed = sortColor(ColorToolsLastUsed)
	ColorToolsLastUsed = _.slice(ColorToolsLastUsed, 1, 30)

	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed

end)



local frameExtend = 90

ColorPickerFrame:HookScript('OnShow', function(self)
	self.Content:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", frameExtend * -1, 0 )

	local w = 331 + frameExtend
	if self.hasOpacity then
		w = 388 + frameExtend
    end

	ColorTools.hasOpacity = self.hasOpacity

	self:SetWidth(w);
	
	ColorTools:updateColorPalette(w, self.hasOpacity)
end)