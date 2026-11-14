local baseComponent = require("fgui.base.baseComponent")
local Com_dayAwardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Anniversary2022/Com_dayAwardSingle", Com_dayAwardSingle)
function Com_dayAwardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRedererReward))
end
function Com_dayAwardSingle:initData(index, reward, state)
	self.index = index
	self.reward = reward
	self.state = state
	self.controllers.c1:setSelectedIndex(self.state - 1)
	if index == 1 then
		self.fields.title:setString(i18n("celebrationgift_text_6"))
	else
		_ENV = i18n("celebrationgift_text_6")
		i18n("celebrationgift_text_6").num = index
		self.fields.title:setString(i18n("celebrationgift_text_7", i18n("celebrationgift_text_6")))
	end
	if self.reward and next(self.reward) then
		self.fields.List_reward:setNumItems(table.nums(self.reward) / 2)
	end
end
function Com_dayAwardSingle:onItemRedererReward(index, object)
	object:initData(self.reward[2 * index + 1], self.reward[2 * index + 2], self.state == 3)
	object:setState(self.state - 1)
end
function Com_dayAwardSingle:onShow()
end
return Com_dayAwardSingle
