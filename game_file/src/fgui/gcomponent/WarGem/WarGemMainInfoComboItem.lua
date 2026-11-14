local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainInfoComboItem = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainInfoComboItem", WarGemMainInfoComboItem)
function WarGemMainInfoComboItem:onInit()
	self:fixChildrenPos()
end
function WarGemMainInfoComboItem:onShow()
end
function WarGemMainInfoComboItem:initData(ctype, index, isActive)
	local title = combinationCtrl:getSetName(ctype, index)
	if combinationCtrl:checkSetUnLock(ctype, index, false) then
		self.controllers.c1:setSelectedIndex(0)
		local name = title
		if isActive then
			local strActive = fguiHelper.getColorString("#68DE21", i18n("gemEnchant_text_56"))
			combinationCtrl = i18n("gemEnchant_text_56")
			i18n("gemEnchant_text_56").var1 = title
			i18n("gemEnchant_text_56").var2 = strActive
			name = i18n("gemEnchant_text_60", i18n("gemEnchant_text_56"))
		end
		self.fields.Text_name:setString(name)
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_unlock:setString(title)
	end
end
return WarGemMainInfoComboItem
