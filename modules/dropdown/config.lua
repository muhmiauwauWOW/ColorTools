local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")
local _ = LibStub("Lodash"):Get()

local function createDropdown(opts)
    local menu_items = opts['items'] or {}
    local change_func = opts['changeFunc'] or function(dropdown_val) end
    
    local dropdown = CreateFrame("DropdownButton", 'ColorTools_dropdown', ColorPickerFrame, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("TOPRIGHT", -23, -210 + 44 + dropdown:GetHeight());
    dropdown:SetWidth(170);


    local options = {} 
    local selectedValue = ColorTools.activeColorPalette
    _.forEach(menu_items, function(v) tinsert(options, {v.name, v.key}) end)

    MenuUtil.CreateRadioMenu(dropdown,
        function(value)
            return value == selectedValue
        end, 
        function(value)
            selectedValue = value
            change_func(dropdown, selectedValue)
        end,
        unpack(options)
    )

    -- ugly fix for AceGUI 
    local function OnShow()
        dropdown.menu:SetFrameStrata("TOOLTIP")
	end

    dropdown:RegisterCallback(DropdownButtonMixin.Event.OnMenuOpen, OnShow);

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

    _.forEach(ColorTools.colorPalettes, function(v, k)
        table.insert(dropdown_opts["items"], {
            order = v.order,
            key = k,
            name = v.name
        })
    end)

    table.sort(dropdown_opts["items"], function (a, b) return a.order < b.order end)
    createDropdown(dropdown_opts)
end
