ColorTools = LibStub("AceAddon-3.0"):NewAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()


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

	--@debug@
		local name, realm = UnitName("player")
		if(name == "Muhmiauwaudk") then 
			ColorTools:initTestFrame()
		end
	--@end-debug@

	ColorTools:initRGBInputs()
	ColorTools:initDropdown()

end 

function ColorTools:OnEnable()
    -- Called when the addon is enabled
end

function ColorTools:OnDisable()
    -- Called when the addon is disabled
end


ColorPickerFrame:SetHeight(340)
ColorPickerFrame.Content.HexBox:SetPoint("BOTTOMRIGHT", -23, 134)





--@debug@
function ColorTools:initTestFrame()
	local r,g,b,a = 1, 0, 0, 1;

	ColortestFrame = CreateFrame("Frame", nil, UIParent)
	ColortestFrame:SetSize(1000, 1000)

	ColortestFrame:SetPoint("CENTER", 0, 0)
	 
	ColortestFrame.Texture = ColortestFrame:CreateTexture()
	ColortestFrame.Texture:SetAllPoints()
	ColortestFrame.Texture:SetColorTexture(r, g, b, a)

	


	ColorTestButton = CreateFrame("Button", nil, UIParent)
	ColorTestButton:SetSize(200, 200)
	ColorTestButton:SetPoint("CENTER", 0, 0)
	ColorTestButton:SetScript("OnClick", function(self, arg1)
	   -- ShowColorPicker(r, g, b, a, myColorCallback);

	   local function OnCancel()
		print("OnCancel");
	  end
		local options = {
			swatchFunc = myColorCallback,
			opacityFunc = myColorCallback,
			cancelFunc = OnCancel,
			hasOpacity = true,
			opacity = a,
			r = r,
			g = g,
			b = b,
		  };
		
		  ColorPickerFrame:SetupColorPickerAndShow(options);
	end)


		
	function ShowColorPicker(r, g, b, a, changedCallback)
		ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
		ColorPickerFrame.hasOpacity = false
		ColorPickerFrame.previousValues = {r,g,b,a};
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
			changedCallback, changedCallback, changedCallback;
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(r,g,b,a);
		ShowUIPanel(ColorPickerFrame);
	end


	function myColorCallback(restore)
	

		local newR, newG, newB = ColorPickerFrame:GetColorRGB();
		local newA = ColorPickerFrame:GetColorAlpha();
		if restore then
			--print("restore",restore)
			-- The user bailed, we extract the old color from the table created by ShowColorPicker.
			newR, newG, newB, newA = unpack(restore);
		else
			-- Something changed
			-- TODO
			--newA, newR, newG, newB = ColorPickerFrame:GetColorAlpha(), ColorPickerFrame:GetColorRGB();
		end

		-- Update our internal storage.
		r, g, b, a = newR, newG, newB, newA;
		-- And update any UI elements that use this color...



		ColortestFrame.Texture:SetColorTexture(r, g, b,  newA)
	end

end
--@end-debug@







function ColorTools:UpdateCPFRGB(editbox)
	local cr, cg, cb
	-- hex value
	if #editbox:GetText() == 6 then 
		local rgb = editbox:GetText()
		cr, cg, cb = tonumber('0x'..strsub(rgb, 0, 2)), tonumber('0x'..strsub(rgb, 3, 4)), tonumber('0x'..strsub(rgb, 5, 6))
	-- numerical value
	else
		cr, cg, cb = tonumber(ColorTools.editboxes["r"]:GetNumber()), tonumber(ColorTools.editboxes["g"]:GetNumber()), tonumber(ColorTools.editboxes["b"]:GetNumber())
	end
	
	-- lazy way to prevent most errors with invalid entries (letters)
	if cr and cg and cb then
		-- % based
		if cr <= 1 and cg <= 1 and cb <= 1 then
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(cr, cg, cb)
		-- 0 - 255 based
		else
			--print(cr, cg, cb)
			ColorPickerFrame.Content.ColorPicker:SetColorRGB(cr / 255, cg / 255, cb / 255)
		end
	else
		print('|cffFF0000ColorTools|r: Error converting fields to numbers. Please check the values.')
	end
end









function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function ColorTools:getColor255(c)
	return round(c * 255)
end



function dump(arg)
	DevTools_Dump(arg)
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


ColorPickerFrame:HookScript('OnShow', function(self) 
	--ColorTools.activeColorPalette = "lastUsedColors"
	ColorTools:updateColorPalette();
end)