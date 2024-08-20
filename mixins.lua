local _ = LibStub("Lodash"):Get()


ColorToolsDropdownMixin = {}


function ColorToolsDropdownMixin:OnLoad()
	self:SetWidth(170);
	
	self:SetSelectionTranslator(function(selection)
		ColorTools.activeColorPalette = selection.data
		return ColorTools.colorPalettes[selection.data].name;
	end);

	local items = {}
    table.foreach(ColorTools.colorPalettes, function(k, v)
        table.insert(items, {order = v.order, key = k, name = v.name})
    end)

    table.sort(items, function (a, b) return a.order < b.order end)
	items = _.map(items, function(entry) return {entry.name, entry.key}; end)

    MenuUtil.CreateRadioMenu(self,
        function(value)
          	return value == ColorTools.activeColorPalette
        end, 
        function(value)
            ColorTools.activeColorPalette = value
			ColorTools:updateColorPalette()
        end,
        table.unpack(items)
    )


	-- ugly fix for AceGUI 
	local function OnShow()
        self.menu:SetFrameStrata("TOOLTIP")
	end

 	self:RegisterCallback(DropdownButtonMixin.Event.OnMenuOpen, OnShow);
end











ColorToolsInputMixin = {}

function ColorToolsInputMixin:OnLoad()
	ColorPickerFrame.Content.HexBox:ClearAllPoints()
	ColorPickerFrame.Content.HexBox:SetPoint("TOPLEFT", ColorPickerFrame.Content, "TOPRIGHT", -35, -35)


	ColorPickerFrame.Content.ColorPicker:HookScript('OnColorSelect', function() self:UpdateInputs(); end)
end

function ColorToolsInputMixin:OnShow()
	self:UpdateInputs();
end


function ColorToolsInputMixin:UpdateInputs()

	local colorsTable = {}
	colorsTable["R"], colorsTable["G"], colorsTable["B"] = ColorPickerFrame.Content.ColorPicker:GetColorRGB()
	colorsTable["X"], colorsTable["Y"], colorsTable["Z"] = ColorPickerFrame.Content.ColorPicker:GetColorHSV()


	table.foreach({self:GetChildren()}, function(k, v)
		local type = v.text
		local color = colorsTable[type];
		if type == "R" or type == "G" or type == "B"  then
			color = color * 255
		elseif type == "Y" or type == "Z"  then
			color = color * 100
		end

		if color < 0  then color = 0 end
		v:SetNumber(math.floor(color))
	end)
end


function ColorToolsInputMixin:SetColor(mode, type, value)
	local colorsTable = {}
	if mode == "RGB" then 
		colorsTable["R"], colorsTable["G"], colorsTable["B"] = ColorPickerFrame.Content.ColorPicker:GetColorRGB()
		colorsTable[type] = value / 255
		ColorPickerFrame.Content.ColorPicker:SetColorRGB(colorsTable["R"], colorsTable["G"], colorsTable["B"])
	elseif mode == "HSV" then 
		colorsTable["X"], colorsTable["Y"], colorsTable["Z"] = ColorPickerFrame.Content.ColorPicker:GetColorHSV()
		colorsTable[type] = (type ~= "X") and value / 100 or value
		ColorPickerFrame.Content.ColorPicker:SetColorHSV(colorsTable["X"], colorsTable["Y"], colorsTable["Z"])
	end
end




ColorToolsInputEditboxMixin = {}

function ColorToolsInputEditboxMixin:OnLoad()
    self:SetTextInsets(16, 0, 0, 0);
	self.Text:SetText(self.text)
end
function ColorToolsInputEditboxMixin:OnEscapePressed()
	self:ClearFocus()
	self:GetParent():SetColor(self.mode, self.text, self:GetNumber())
end

function ColorToolsInputEditboxMixin:OnEditFocusGained()
	self:HighlightText(0, self:GetNumLetters())
end

function ColorToolsInputEditboxMixin:OnEditFocusLost()
	self:HighlightText(self:GetNumLetters())
	self:GetParent():SetColor(self.mode, self.text, self:GetNumber())
end

function ColorToolsInputEditboxMixin:OnEnterPressed()
	self:ClearFocus() 
	self:GetParent():SetColor(self.mode, self.text, self:GetNumber())
end