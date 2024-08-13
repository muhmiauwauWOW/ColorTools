local ColorTools = LibStub("AceAddon-3.0"):GetAddon("ColorTools")
local L = LibStub("AceLocale-3.0"):GetLocale("ColorTools")


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

        for order, val in pairs(menu_items) do
            info.text = val.name;
            info.checked = (val.key == ColorTools.activeColorPalette) 
            info.menuList= val.key
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

    dropdown:SetPoint("TOPLEFT", 5, -170);
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


  
    function getKeysSortedByValue(tbl, sortFunction)
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end

        table.sort(keys, function(a, b)
            return sortFunction(tbl[a], tbl[b])
        end)
        return keys
    end


    local sortedKeys = getKeysSortedByValue(ColorTools.colorPalettes, function(a, b) 
        return a.order < b.order
    end)



    for k, v in pairs(sortedKeys) do
      dropdown_opts["items"][k] = {
            key = v,
            name = ColorTools.colorPalettes[v].name
        }
    end

	colorDropdown = createDropdown(dropdown_opts)
end
