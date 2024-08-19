--- RGB Inputs


function ColorTools:createHSVInput(label, position)
	local f = CreateFrame("Frame", nil, ColorPickerFrame, "ColorToolsHSVInputFrameTemplate")
	f:SetPoint("TOPLEFT", ColorPickerFrame.Content.HexBox, "BOTTOMLEFT", 57, 22 - (position * 26) )
	f.box.Hash:SetText(label)
	f.box.name = label
	return f.box
end

function ColorTools:initHSVInputs()

	table.foreach(ColorTools.hsvTable, function(k,v)
		ColorTools.editboxes[v] = ColorTools:createHSVInput(v, k)
	end)

end

function ColorTools:UpdateHSVInputs()
	table.foreach({ColorPickerFrame.Content.ColorPicker:GetColorHSV()}, function(k, v)
		if k ~= "x" then v = v * 100 end 
		ColorTools.editboxes[ColorTools.hsvTable[k]]:SetNumber(math.floor(v))
	end)
end


ColorPickerFrame:HookScript('OnShow', function() ColorTools:UpdateHSVInputs(); end)
ColorPickerFrame.Content.ColorPicker:HookScript('OnColorSelect', function() ColorTools:UpdateHSVInputs(); end)


