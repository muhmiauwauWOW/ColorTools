
ColorToolsRgbInputMixin = {}

ColorToolsRgbInputEditboxMixin = {}


function ColorToolsRgbInputEditboxMixin:OnLoad()
    self:SetTextInsets(16, 0, 0, 0);
end
function ColorToolsRgbInputEditboxMixin:OnEscapePressed()
	self:ClearFocus()
    ColorTools:UpdateCPFRGB(self)
end

function ColorToolsRgbInputEditboxMixin:OnEditFocusGained()
	self:HighlightText(0, self:GetNumLetters())
end

function ColorToolsRgbInputEditboxMixin:OnEditFocusLost()
	self:HighlightText(self:GetNumLetters())
    ColorTools:UpdateCPFRGB(self)
end

function ColorToolsRgbInputEditboxMixin:OnEnterPressed()
	self:ClearFocus() 
    ColorTools:UpdateCPFRGB(self)
end

function ColorToolsRgbInputEditboxMixin:OnTextChanged()
	--ColorTools:UpdateCPFRGB(self)
end
function ColorToolsRgbInputEditboxMixin:SetRGBNumber(value)
    if not value then return end
    local function round(num, numDecimalPlaces)
		local mult = 10^(numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end
	
    self:SetNumber(round(value * 255))
end

