
ColorToolsHSVInputMixin = {}

ColorToolsHSVInputEditboxMixin = {}


function ColorToolsHSVInputEditboxMixin:OnLoad()
    self:SetTextInsets(16, 0, 0, 0);
end
function ColorToolsHSVInputEditboxMixin:OnEscapePressed()
	self:ClearFocus()
	ColorTools:UpdateCPFHSV(self)
end

function ColorToolsHSVInputEditboxMixin:OnEditFocusGained()
	self:HighlightText(0, self:GetNumLetters())
end

function ColorToolsHSVInputEditboxMixin:OnEditFocusLost()
	self:HighlightText(self:GetNumLetters())
	ColorTools:UpdateCPFHSV(self)
end

function ColorToolsHSVInputEditboxMixin:OnEnterPressed()
	self:ClearFocus() 
	ColorTools:UpdateCPFHSV(self)
end
