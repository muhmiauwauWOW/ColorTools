--ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()




ColorToolsPaletteMixin = {}

function ColorToolsPaletteMixin:OnLoad()
	self.scrollBarHideable = false;
	ScrollFrame_OnLoad(self);

	self.swatchSize = ColorTools.config.swatchSize;
	self.spacer = ColorTools.config.spacer

	self.swatchSpace = self.swatchSize + self.spacer
	self.scrollheight = self.swatchSpace * 2

	self.pool = CreateFramePool("Button", self.Contents, "ColorToolsColorButton")
end


function ColorToolsPaletteMixin:updateColorPalette(width)
	if width then
		self:SetWidth(width)
		self.Contents:SetWidth(width)
		self:SetHeight(self.scrollheight)
		self.cols = math.floor(width/self.swatchSpace) - 1
	end


	self.pool:ReleaseAll();
	local colors = ColorTools.colorPalettes[ColorToolsDropdown.selected].colors

	if ColorToolsDropdown.selected ~= "lastUsedColors" then 
		table.sort(colors, function(a,b) return a.sort < b.sort end)
	end

	-- set child height
	local height = math.ceil(#colors / self.cols) * self.swatchSpace;
	self.Contents:SetHeight(height)

	function getPos(type, index)
		index = index -1
		local row = math.floor(index / self.cols) 
		if type == "y" then return row * self.swatchSpace end
		return (index - (row * self.cols)) *  self.swatchSpace
	end

	table.foreach(colors, function(k, v)
		local frame = self.pool:Acquire()
		frame:SetPoint("TOPLEFT", self.Contents, "TOPLEFT", getPos("x", k), getPos("y", k) *-1)
		frame.Color:SetColorTexture(table.unpack(v.color))
		frame.color = v.color
		frame.description = v.description
		frame:Show()
	end)
end






ColorToolsColorButtonMixin = {}


function ColorToolsColorButtonMixin:OnClick()
	ColorPickerFrame.Content.ColorPicker:SetColorRGB(table.unpack(self.color));
	if ColorPickerFrame.hasOpacity then
		ColorPickerFrame.Content.ColorPicker:SetColorAlpha(self.color[4])
	end
end




function ColorToolsColorButtonMixin:OnEnter()
	if not self.description then return end
	GameTooltip:SetOwner(ColorPickerFrame, "ANCHOR_CURSOR");
	GameTooltip:SetText(self.description, 1, 1, 1, 1, 1)
	GameTooltip:Show() 
end

function ColorToolsColorButtonMixin:OnLeave()
	GameTooltip:Hide() 
end























ColorToolsDropdownMixin = {}


function ColorToolsDropdownMixin:OnLoad()
	self:SetWidth(170);

	ColorToolsDropdown.selected = "lastUsedColors"
	
	self:SetSelectionTranslator(function(selection)		
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
          	return value == ColorToolsDropdown.selected
        end, 
        function(value)
			self.selected = value
			ColorToolsPaletteFrame:updateColorPalette()
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
	colorsTable["R"], colorsTable["G"], colorsTable["B"] = CreateColor(ColorPickerFrame.Content.ColorPicker:GetColorRGB()):GetRGBAAsBytes()
	colorsTable["X"], colorsTable["Y"], colorsTable["Z"] = ColorPickerFrame.Content.ColorPicker:GetColorHSV()

	table.foreach({self:GetChildren()}, function(k, input)
		local type = input.text
		local color = colorsTable[type];
		if type == "Y" or type == "Z"  then
			color = color * 100
		end

		if color < 0  then color = 0 end
		input:SetNumber(math.floor(color))
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