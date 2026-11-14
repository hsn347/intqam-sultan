local baseComponent = require("fgui.base.baseComponent")
local Com_ML_Skill = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_Skill", Com_ML_Skill)
function Com_ML_Skill:onInit()
end
function Com_ML_Skill:onShow()
end
function Com_ML_Skill:initData(data, isSelected, isUsing)
	self.fields.txt_active:setVisible(isUsing)
	if isUsing then
		self.fields.txt_active:setString(i18n("magic_lamp_text_115"))
	end
	self.fields.Com_skill:initData(data)
	self:setSelected(isSelected)
end
function Com_ML_Skill:setSelected(isSelected)
	self.isSelected = isSelected
	self.fields.selected:setVisible(isSelected)
end
return Com_ML_Skill
