local activity_9001661_Read = include("activity_9001661_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_lvupReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_lvupReward", Com_lvupReward)
function Com_lvupReward:onInit()
	self.reward, _ENV = nil, nil
	self.fields.Text_tip:setString(i18n("bubble_farm_text35"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_lvupReward:onShow()
end
function Com_lvupReward:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_lvupReward:initData(lv)
	local cfg = activity_9001661_Read.getLevelConfig(lv)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.reward = serviceFunctions.tableFormat(cfg.levelitem, nil)
	self.fields.List:setNumItems(#self.reward)
end
return Com_lvupReward
