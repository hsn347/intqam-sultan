local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_rewardSingle", Com_rewardSingle)
fgui.register_extension("ui://vipCenterView/Com_rewardSingle2", Com_rewardSingle)
function Com_rewardSingle:onInit()
	self:fixChildrenPos()
end
function Com_rewardSingle:onShow()
end
function Com_rewardSingle:initData(data)
	self.fields.item:initData(data.id)
	self.fields.Text_name:setString(publicRead.getName(data.id))
	publicRead = publicRead.getName(data.id)
	publicRead.getName(data.id).num = "X"
	publicRead.getName(data.id).char = data.count
	self.fields.Text_num:setString(i18n("common_text_1470", publicRead.getName(data.id)))
end
return Com_rewardSingle
