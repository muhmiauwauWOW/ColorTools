ColorTools = LibStub("AceAddon-3.0"):NewAddon("ColorTools")

local CPF, OSF = ColorPickerFrame, OpacitySliderFrame





ColorTools.colorPalettes = {}

ColorTools.activeColorPalette =  "lastUsedColors"

ColorTools.editboxes = {};

ColorTools.colorSwatchX = 240;
ColorTools.colorSwatchY = -32;



function ColorTools:OnInitialize()


	if ColorToolsLastUsed == nil then 
		ColorToolsLastUsed = {}
	end
	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed



	-- activate debug
	local name, realm = UnitName("player")
	if(name == "Evangelinmuh") then 
		ColorTools:initTestFrame()
	end

	ColorTools:makeMovable()

	ColorTools:initRGBInputs()

	ColorTools:initHEXInput()


	ColorTools:initDropdown()

end 

function ColorTools:OnEnable()
    -- Called when the addon is enabled
end

function ColorTools:OnDisable()
    -- Called when the addon is disabled
end



ColorPickerFrame:SetHeight(280)
ColorPickerFrame:SetWidth(380)


ColorSwatch:SetPoint('TOPLEFT', ColorTools.colorSwatchX, ColorTools.colorSwatchY)



function ColorTools:makeMovable()
	-- Make the color picker movable.
	local mover = CreateFrame('Frame', nil, CPF)
	mover:SetPoint('TOPLEFT', CPF, 'TOP', -80, 15)
	mover:SetPoint('BOTTOMRIGHT', CPF, 'TOP', 80, -20)
	mover:EnableMouse(true)
	mover:SetScript('OnMouseDown', function() CPF:StartMoving() end)
	mover:SetScript('OnMouseUp', function() CPF:StopMovingOrSizing() end)
	CPF:SetUserPlaced(true)
	CPF:EnableKeyboard(false)



	--mover.Texture = mover:CreateTexture()
	--mover.Texture:SetAllPoints()
	--mover.Texture:SetColorTexture(255, 255, 255, 1)
end



















function ColorTools:initTestFrame()
	local r,g,b,a = 1, 0, 0, 1;

	ColortestFrame = CreateFrame("Frame", nil, UIParent)
	ColortestFrame:SetSize(200, 200)

	ColortestFrame:SetPoint("Center", 0, 0)
	--ColortestFrame:SetPoint("BOTTOMRIGHT", 0, 0)
	 
	ColortestFrame.Texture = ColortestFrame:CreateTexture()
	ColortestFrame.Texture:SetAllPoints()
	ColortestFrame.Texture:SetColorTexture(r, g, b, a)

	


	ColorTestButton = CreateFrame("Button", nil, UIParent)
	ColorTestButton:SetSize(200, 200)
	ColorTestButton:SetPoint("Center", 0, 0)
	ColorTestButton:SetScript("OnClick", function(self, arg1)
	    ShowColorPicker(r, g, b, a, myColorCallback);
	end)


		
	function ShowColorPicker(r, g, b, a, changedCallback)
	 ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
	 ColorPickerFrame.previousValues = {r,g,b,a};
	 ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
	  changedCallback, changedCallback, changedCallback;
	 ColorPickerFrame:SetColorRGB(r,g,b,a);
	 --ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	 --ColorPickerFrame:Show();
	 ShowUIPanel(ColorPickerFrame);
	end


	function myColorCallback(restore)

		local newR, newG, newB, newA;
		if restore then
			--print("restore",restore)
			-- The user bailed, we extract the old color from the table created by ShowColorPicker.
			newR, newG, newB, newA = unpack(restore);
		else
			-- Something changed
			newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
		end

		-- Update our internal storage.
		r, g, b, a = newR, newG, newB, newA;
		-- And update any UI elements that use this color...

		--print(restore, r, g, b, a)


		ColortestFrame.Texture:SetColorTexture(r, g, b,  a)
	end

end








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
			CPF:SetColorRGB(cr, cg, cb)
		-- 0 - 255 based
		else
			--print(cr, cg, cb)
			CPF:SetColorRGB(cr / 255, cg / 255, cb / 255)
		end
	else
		print('|cffFF0000ColorTools|r: Error converting fields to numbers. Please check the values.')
	end
	
	-- update opacity
	--OpacitySliderFrame:SetValue(tonumber(editboxes.Alpha:GetText()) / 100)
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







ColorPickerOkayButton:HookScript('OnClick', function()  
	local r, g, b = ColorPickerFrame:GetColorRGB();


	local i = 0
	for k, v in pairs(ColorToolsLastUsed) do
		i = i + 1
	end
	local index = i + 1

	ColorToolsLastUsed["usercolor" .. string.format("%03d", index)] = {r, g ,b, 1}

	ColorTools.colorPalettes["lastUsedColors"].colors = ColorToolsLastUsed

end)


ColorPickerFrame:HookScript('OnShow', function() 
	--ColorTools.activeColorPalette = "lastUsedColors"
	ColorTools:updateColorPalette(); 
end)