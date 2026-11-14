local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Hospital/Com_list", Com_list)
function Com_list:onInit()
	self:fixChildrenPos()
end
function Com_list:onShow()
end
function Com_list:initData(info)
	self.controllers.c1:setSelectedIndex(info.armyType % 2 == 0 and 1 or 0)
	local numStr = fguiHelper.getColorString("#FFEBB9", string.formatnumberthousands(info.count))
	if info.count > info.limit then
		numStr = fguiHelper.getColorString("#E02B2B", string.formatnumberthousands(info.count))
	end
	_ENV = string.formatnumberthousands(info.count)
	string.formatnumberthousands(info.count).var1 = numStr
	string.formatnumberthousands(info.count).var2 = string.formatnumberthousands(info.limit)
	self.fields.Text_num:setString(i18n("%{var1}/%{var2}", string.formatnumberthousands(info.count)))
	_ENV = self.fields.Text_num.setString
	self.fields.Text_num.setString[1] = i18n("legendaryking_text_76")
	self.fields.Text_num.setString[2] = i18n("legendaryking_text_77")
	local self.fields.Text_num.setString[3], nameCfg = i18n("legendaryking_text_78"), self.fields.Text_num.setString
	self.fields.Text_name:setString(nameCfg[info.armyType])
end
return Com_list
