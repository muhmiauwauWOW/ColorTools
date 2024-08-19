ColorTools = LibStub("AceAddon-3.0"):NewAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()



ColorTools.rbgTable =  {"R", "G", "B"}


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

	ColorTools:initRGBInputs()
	ColorTools:initDropdown()

end 

ColorPickerFrame:SetHeight(340)
ColorPickerFrame.Content.HexBox:SetPoint("BOTTOMRIGHT", -23, 134)


function ColorTools:UpdateCPFRGB(editbox)
	local cr, cg, cb = tonumber(ColorTools.editboxes["R"]:GetNumber()), tonumber(ColorTools.editboxes["G"]:GetNumber()), tonumber(ColorTools.editboxes["B"]:GetNumber())

	-- lazy way to prevent most errors with invalid entries (letters)
	if cr and cg and cb then
		-- % based
		if cr <= 1 and cg <= 1 and cb <= 1 then
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(cr, cg, cb)
		-- 0 - 255 based
		else
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(cr / 255, cg / 255, cb / 255)
		end
	else
		print('|cffFF0000ColorTools|r: Error converting fields to numbers. Please check the values.')
	end
end









ColorPickerFrame.Footer.OkayButton:HookScript('OnClick', function()  


	local function sortColor(colors)
		return _.reverse(_.sortBy(ColorToolsLastUsed, function(a) return a.sort end))
	end
	local r, g, b = ColorPickerFrame:GetColorRGB();

	if not _.isEmpty(ColorToolsLastUsed) then 
		ColorToolsLastUsed = sortColor(ColorToolsLastUsed)
		if ColorToolsLastUsed[1].color[1] == r and  ColorToolsLastUsed[1].color[2] == g and  ColorToolsLastUsed[1].color[3] == b then 
			return
		end
	end

	tinsert(ColorToolsLastUsed, {
		sort = time(),
		color = {r, g ,b, 1}
	})

	ColorToolsLastUsed = sortColor(ColorToolsLastUsed)
	ColorToolsLastUsed = _.slice(ColorToolsLastUsed, 1, 20)

	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed

end)


ColorPickerFrame:HookScript('OnLoad', function(self) 
	--ColorTools.activeColorPalette = "lastUsedColors"

	if self.hasOpacity then
    	

	   self.Content:SetWidth(388);

	   self.Content:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -80, 0 )
	 --  self.Content:ClearPoint("BOTTOMRIGHT")
       self:SetWidth(388 + 80);
    else
        self.Content.ColorPicker:SetWidth(200);
        self:SetWidth(331 + 80);
    end
	

	ColorTools:updateColorPalette();
end)


ColorPickerFrame:HookScript('OnShow', function(self) 
	--ColorTools.activeColorPalette = "lastUsedColors"

	if self.hasOpacity then
    	

	   self.Content:SetWidth(388);

	   self.Content:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -80, 0 )
	 --  self.Content:ClearPoint("BOTTOMRIGHT")
       self:SetWidth(388 + 80);
    else
        self.Content.ColorPicker:SetWidth(200);
        self:SetWidth(331 + 80);
    end
	

	--ColorTools:updateColorPalette();
end)