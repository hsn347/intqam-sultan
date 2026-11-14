local baseComponent = require("fgui.base.baseComponent")
local Com_ELG_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://EliminateGame/Com_ELG_single", Com_ELG_single)
function Com_ELG_single:onInit()
	self:fixChildrenPos()
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_ELG_single:onShow()
end
function Com_ELG_single:initData(data, index, curLevel)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.rewards = serviceFunctions.tableFormat(data.Rewards or data.reward, nil)
	local level = data.level or index + 1
	self.isGot = curLevel > level
	self.controllers.c1:setSelectedIndex(self.isGot and 1 or 0)
	_ENV = nil
	;(nil).lv = level
	self.fields.text_lv:setString(i18n("common_text_100", nil))
	self.fields.selectSp:setVisible(curLevel == level)
	self.fields.bg:setVisible(index % 2 == 0)
	self.fields.list:setNumItems(#self.rewards)
end
function Com_ELG_single:onItemRenderer(index, object)
	local fields = fguiHelper.get_fields(object)
	local controllers = fguiHelper.get_controllers(object)
	dump(controllers, "Com_ELG_single:onItemRenderer")
	local reward = self.rewards[index + 1]
	fields.Com_item:initData(reward.id, reward.count)
	controllers.c1:setSelectedIndex(self.isGot and 1 or 0)
end
return Com_ELG_single
