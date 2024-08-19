--- RGB Inputs


function ColorTools:createRGBInput(label, position)
	local f = CreateFrame("Frame", nil, ColorPickerFrame, "ColorToolsRgbInputFrameTemplate")
	f:SetPoint("TOPLEFT", ColorPickerFrame.Content.HexBox, "BOTTOMLEFT", 0, 22 - (position * 26) )
	f.box.Hash:SetText(label)
	f.box.name = label
	return f.box
end

function ColorTools:initRGBInputs()
	ColorPickerFrame.Content.HexBox:ClearAllPoints()
	ColorPickerFrame.Content.HexBox:SetPoint("TOPLEFT", ColorPickerFrame.Content, "TOPRIGHT", -35, -35)

	table.foreach(ColorTools.rbgTable, function(k,v)
		ColorTools.editboxes[v] = ColorTools:createRGBInput(v, k)
	end)

end

function ColorTools:UpdateRGBInputs()
	table.foreach({ColorPickerFrame:GetColorRGB()}, function(k,v)
		ColorTools.editboxes[ColorTools.rbgTable[k]]:SetRGBNumber(v)
	end)
end


ColorPickerFrame:HookScript('OnShow', function() ColorTools:UpdateRGBInputs(); end)
ColorPickerFrame.Content.ColorPicker:HookScript('OnColorSelect', function() ColorTools:UpdateRGBInputs(); end)


