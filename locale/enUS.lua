local L = LibStub("AceLocale-3.0"):NewLocale("ColorTools", "enUS", true)

if not L then
	return
end

-- color connectors
L["lastUsedColors"] = "Last Used Colors"
L["classColors"] = "Class Colors"
L["powerBarColor"] = "PowerBar Colors"
L["objectiveTrackerColor"] = "Objective Tracker Color"
L["debuffTypeColor"] = "Debuff TypeColor"
L["ItemQuality"] = "Item Quality"
L["favoriteColors"] = "Favorites"
L["favoriteRemove"] = "Remove from Favorits"
L["favoriteAdd"] = "Add to Favorits"
L["infavoriteColors"] = "In favorites colors"


L["EditBox_tooltip_R"] = "Red"
L["EditBox_tooltip_R_description"] = "Red part of the color 0-255."
L["EditBox_tooltip_G"] = "Green"
L["EditBox_tooltip_G_description"] = "Green part of the color 0-255."
L["EditBox_tooltip_B"] = "Blue"
L["EditBox_tooltip_B_description"] = "Blue part of the color 0-255."
L["EditBox_tooltip_A"] = "Alpha"
L["EditBox_tooltip_A_description"] = "Alpha part of the color 0-100."
L["EditBox_tooltip_H"] = "Hue"
L["EditBox_tooltip_H_description"] = "Hue part of the color 0-360."
L["EditBox_tooltip_S"] = "Saturation"
L["EditBox_tooltip_S_description"] = "Saturation part of the color 0-100."
L["EditBox_tooltip_V"] = "Value"
L["EditBox_tooltip_V_description"] = "Value part of the color 0-100."



L["Options_lastUsedColors_duplicates_name"] = "Allow duplicates"
L["Options_lastUsedColors_duplicates_desc"] = "Allow duplicates in \"Last Used Colors\""


L["Options_lastUsedColors_alpha_as_new_name"] = "Different alpha = new color"
L["Options_lastUsedColors_alpha_as_new_desc"] = "Same color with different alpha values will displayed as different colors in \"Last Used Colors\" \n\nNote: This will remove the alpha value of all colors currently saved in the \"Last Used Colors\""

L["Options_lastUsedColors_clearButton"] = "Clear \"Last Used Colors\""

L["Options_lastUsedColors_clearConfirm_text"] = "Do you want to clear the Color Tools Last Used ?"
L["Options_lastUsedColors_clearConfirm_yes"] = "Yes"
L["Options_lastUsedColors_clearConfirm_no"] = "No"
