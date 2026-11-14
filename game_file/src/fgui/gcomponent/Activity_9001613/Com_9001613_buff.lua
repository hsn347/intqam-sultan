local baseComponent = require("fgui.base.baseComponent")
local Com_9001613_buff = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001613_Read = include("activity_9001613_Read")
fgui.register_extension("ui://Activity_9001613/Com_9001613_buff", Com_9001613_buff)
function Com_9001613_buff:onInit()
	self:fixChildrenPos()
end
function Com_9001613_buff:onShow()
end
function Com_9001613_buff:initData(buffDesCfg)
	self.fields.text_name:setString(i18n(buffDesCfg.buffName))
	self.fields.text_des:setString(i18n(buffDesCfg.buffDes))
	if buffDesCfg.buffIcon then
		self.fields.icon:setURL(i18n(buffDesCfg.buffIcon))
	end
end
return Com_9001613_buff
