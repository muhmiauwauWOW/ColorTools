local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")


local swatchSize = 32;
local spacer = 5
local cols = 5


local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

local colorSwatches = {}

-- setWidth of scroll child
ColorToolsPaletteScrollFrame.Contents:SetWidth(ColorToolsPaletteScrollFrame:GetWidth())


function ColorTools:updateColorPalette()

	local colors = ColorTools.colorPalettes[ColorTools.activeColorPalette].colors

	-- hide all present ColorSwatches
	for k, v in pairs(colorSwatches) do
		colorSwatches[k]:Hide()
	end

	local i = 1


	local sortFunc = function(a, b) return a < b end

	

	for k, v in pairsByKeys(colors, sortFunc) do
		if colorSwatches[i] == nil then 
			-- create new color swatch
			if ColorTools.activeColorPalette == "lastUsedColors" then 
				table.insert(colorSwatches, ColorTools:createColorPaletteButton(colors[k].color, i, pFrame));
			else
				table.insert(colorSwatches, ColorTools:createColorPaletteButton(colors[k], i, pFrame));
			end
		else
			-- update existing color swatch
			if ColorTools.activeColorPalette == "lastUsedColors" then 
				ColorTools:upodateColorPaletteButton(colors[k].color, colorSwatches[i])
			else
				ColorTools:upodateColorPaletteButton(colors[k], colorSwatches[i])
			end

		end
		i = i + 1;
	end	


	-- update height on scroll child
	local height = math.floor(i / cols) * (swatchSize + spacer) + swatchSize;
	ColorToolsPaletteScrollFrame.Contents:SetHeight(height)


end


function ColorTools:upodateColorPaletteButton(color, frame)
	local r, g, b, a = unpack(color);

	frame.Texture:SetColorTexture(r, g, b)
	frame:SetScript("OnClick", function (self, button, down)
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(r, g, b);
	end);

	frame:Show();
end





function ColorTools:createColorPaletteButton(color, index)
	local r, g, b, a = unpack(color);

	index = index - 1;
	
	row = math.floor(index / cols)
	x = (index - (row * cols)) * (swatchSize + spacer)
	y = row * (swatchSize + spacer)

	local f = CreateFrame("Button", nil, ColorToolsPaletteScrollFrame.Contents, "ColorToolsColorButton")
	f:SetPoint("TOPLEFT", x, -y )
	f.Texture = f:CreateTexture()
	f.Texture:SetAllPoints()
	f.Texture:SetColorTexture(r, g, b)

	f:SetScript("OnClick", function (self, button, down)
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(r, g, b);
	end);

	return f;
end