local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")



local function createDropdown(opts)
    local dropdown_name = '$parent_ColorTools_dropdown'
    local menu_items = opts['items'] or {}
    local default_val = opts['defaultVal'] or ''
    local change_func = opts['changeFunc'] or function (dropdown_val) end

    local dropdown = CreateFrame("Frame", dropdown_name, ColorPickerFrame, 'UIDropDownMenuTemplate')

    UIDropDownMenu_SetWidth(dropdown, 160)
    UIDropDownMenu_SetText(dropdown, default_val)

    UIDropDownMenu_Initialize(dropdown, function(self, level, _)
        local info = UIDropDownMenu_CreateInfo()
        for key, val in pairs(menu_items) do
            info.text = val;
            info.checked = false 
            info.menuList= key
            info.hasArrow = false
            info.func = function(b)
                UIDropDownMenu_SetSelectedValue(dropdown, b.value, b.value)
                UIDropDownMenu_SetText(dropdown, b.value)
                b.checked = true
                change_func(dropdown, b.menuList)
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    dropdown:SetPoint("TOPLEFT", 5, -160);
    return dropdown
end





 function ColorTools:initDropdown()
	local dropdown_opts = {
	    ['items'] = {},
	    ['defaultVal'] = ColorTools.colorPalettes[ColorTools.activeColorPalette].name, 
	    ['changeFunc'] = function(dropdown_frame, dropdown_val)
	    	ColorTools.activeColorPalette  = dropdown_val;
	    	ColorTools:updateColorPalette()
	    end
	}

	for k, v in pairs(ColorTools.colorPalettes) do
		dropdown_opts["items"][k] = v.name
	end

	colorDropdown = createDropdown(dropdown_opts)
	ColorTools:updateColorPalette()

end
