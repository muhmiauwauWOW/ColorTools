local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")

--- HEX Input

function ColorTools:createHEXInput(label, position)
	local f = CreateFrame("Frame", nil, ColorPickerFrame, "ColorToolsHexInput")
	f:SetPoint("TOPLEFT", ColorTools.colorSwatchX, ColorTools.colorSwatchY - 50 - 5  - position * f.box:GetHeight() )
	f.Label:SetText(label)
	return f.box
end

function ColorTools:initHEXInput()
	ColorTools.editboxes["hex"] = ColorTools:createHEXInput("HEX", 3)
end

function ColorTools:UpdateHEXInput()
	local cr, cg, cb = ColorPickerFrame:GetColorRGB()
	ColorTools.editboxes["hex"]:SetText(format('%02x%02x%02x', ColorTools:getColor255(cr), ColorTools:getColor255(cg), ColorTools:getColor255(cb)))
end


ColorPickerFrame:HookScript('OnShow', function() ColorTools:UpdateHEXInput(); end)
--ColorPickerFrame:HookScript('OnColorSelect', function() ColorTools:UpdateHEXInput(); end)