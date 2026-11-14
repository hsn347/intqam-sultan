local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WeaponEnhance/Com_list", Com_list)
function Com_list:onInit()
	self.fields.Text_lv:fixPos()
	self.fields.Text_des:fixPos()
end
function Com_list:onShow()
end
function Com_list:initData(data, index, slv)
	self.controllers.c1:setSelectedIndex(index % 2 == 1 and 0 or 1)
	if slv and data.sumLv == slv then
		self.controllers.c1:setSelectedIndex(2)
	end
	self.fields.Text_lv:setString(data.sumLv)
	local des = ""
	for k, v in ipairs(data.growth) do
		if k == #data.growth then
			des = des .. buffDesRead.getTitleWithValue(v.buffType, v.buffVal)
		else
			des = des .. buffDesRead.getTitleWithValue(v.buffType, v.buffVal) .. ","
		end
	end
	self.fields.Text_des:setString(des)
end
return Com_list
