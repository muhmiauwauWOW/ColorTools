local swatchSize = 32;
local spacer = 5
local swatchSpace = swatchSize + spacer
local cols

local scrollheight = swatchSpace * 2


function ColorTools:initColorPalette()
	
	self.Palette = CreateFramePool("Button", ColorToolsPaletteScrollFrame.Contents, "ColorToolsColorButton", nil, nil, function(f)

		f.checkerboard = f:CreateTexture(nil, "BACKGROUND")
		f.checkerboard:SetAllPoints()
		f.checkerboard:SetAtlas("colorpicker-checkerboard", true)
		f.checkerboard:SetTexCoord(0, 1, 0, 0.25)

		f.Color = f:CreateTexture(nil, "ARTWORK")
		f.Color:SetAllPoints()
		f.Color:SetColorTexture(1, 0, 1, 1)


		f:SetScript("OnClick", function(self, arg1)
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(self.color[1], self.color[2], self.color[3]);
			if ColorTools.hasOpacity then
				ColorPickerFrame.Content.ColorPicker:SetColorAlpha(self.color[4])
			end
		end)
		
		return f
	end)
end

function ColorTools:updateColorPalette(width)

	if width then
		ColorToolsPaletteScrollFrame:SetWidth(width)
		ColorToolsPaletteScrollFrame.Contents:SetWidth(width)
		ColorToolsPaletteScrollFrame:SetHeight(scrollheight)
		cols = math.floor(width/swatchSpace) - 1
	end

	self.Palette:ReleaseAll();
	local colors = ColorTools.colorPalettes[ColorTools.activeColorPalette].colors

	-- set child height
	local height = math.ceil(#colors / cols) * swatchSpace;
	ColorToolsPaletteScrollFrame.Contents:SetHeight(height)
	
	function getPos(type, index)
		index = index -1
		local row = math.floor(index / cols) 
		if type == "y" then return row* swatchSpace end
		return (index - (row * cols)) *  swatchSpace
	end

	table.foreach(colors, function(k, v)
		local frame = self.Palette:Acquire()
		frame:SetPoint("TOPLEFT", ColorToolsPaletteScrollFrame.Contents, "TOPLEFT", getPos("x", k), getPos("y", k) *-1)
		frame.Color:SetColorTexture(table.unpack(v.color))
		frame.color = v.color
		frame:Show()
	end)
end