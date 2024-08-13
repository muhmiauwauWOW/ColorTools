local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")

--- RGB Inputs

function ColorTools:createRGBInput(label, position)
	local f = CreateFrame("Frame", nil, ColorPickerFrame, "ColorToolsRgbInput")
	f:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOMRIGHT", -7, 100 - position * f.box:GetHeight() )
	f.Label:SetText(label)
	return f.box
end

function ColorTools:initRGBInputs()
	ColorTools.editboxes["r"] = ColorTools:createRGBInput("R", 0)
	ColorTools.editboxes["g"] = ColorTools:createRGBInput("G", 1)
	ColorTools.editboxes["b"] = ColorTools:createRGBInput("B", 2)
end



function ColorTools:UpdateRGBInputs()
	local cr, cg, cb = ColorPickerFrame:GetColorRGB()
	ColorTools.editboxes["r"]:SetNumber(ColorTools:getColor255(cr))
	ColorTools.editboxes["g"]:SetNumber(ColorTools:getColor255(cg))
	ColorTools.editboxes["b"]:SetNumber(ColorTools:getColor255(cb))
end





ColorPickerFrame:HookScript('OnShow', function() ColorTools:UpdateRGBInputs(); end)
ColorPickerFrame.Content.ColorPicker:HookScript('OnColorSelect', function() ColorTools:UpdateRGBInputs(); end)


