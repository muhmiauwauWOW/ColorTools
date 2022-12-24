local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")


local spacer = 5

local cols = 8





function ColorTools:updateColorPalette()


	local pFrame = ColorTools.colorPalettes[ColorTools.activeColorPalette].frame




	for k, v in pairs(ColorTools.colorPalettes) do

		local f = ColorTools.colorPalettes[k].frame;

		if(f == nil) then 
			--
		else
		
			if(k == ColorTools.activeColorPalette) then 
				f:Show()
			else
				f:Hide()
			end
		end
	end	




	if (pFrame == nil) then 
		 pFrame = CreateFrame("Frame", nil, ColorPickerFrame, "ColorToolsColorPalette")
		 pFrame:SetPoint("TOPLEFT", 25, -190 )
		 pFrame:SetPoint("BOTTOMRIGHT", -25, 30 )


		ColorTools.colorPalettes[ColorTools.activeColorPalette].frame = pFrame

		local colors = ColorTools.colorPalettes[ColorTools.activeColorPalette].colors
		local i = 0
		for k, v in pairs(colors) do
			ColorTools:createColorPaletteButton(colors[k], i, pFrame)
			i = i + 1;
		end	
	end
end





function ColorTools:createColorPaletteButton(color, index, parent)
	local r, g, b, a = unpack(color);
	
	row = math.floor(index / cols)
	x = (index - (row * cols)) * (32 + spacer)
	y = row * (32 + spacer)

	local f = CreateFrame("Button", nil, parent, "ColorToolsColorButton")
	f:SetPoint("TOPLEFT", parent,"TOPLEFT", x, -y )
	f.Texture = f:CreateTexture()
	f.Texture:SetAllPoints()
	f.Texture:SetColorTexture(r, g, b)

	

	f:SetScript("OnClick", function (self, button, down)
		ColorPickerFrame:SetColorRGB(r, g, b);
	end);

	return f;
end