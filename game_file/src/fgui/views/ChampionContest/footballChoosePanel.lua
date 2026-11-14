local footballChampionRead = include("footballChampionRead")
local footballChampionCtrl = SoraDGetCtrl("footballChampionCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local footballChoosePanel = class("footballChoosePanel", baseFguiPanel)
function footballChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("footballChoosePanel:ctor", self.viewName)
end
function footballChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function footballChoosePanel:onInit()
	print("=======footballChoosePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("activity_name_9001474"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.List:setNumItems(table.nums(self.proxy.param.answer))
end
function footballChoosePanel:onShow()
	print("=======footballChoosePanel:onShow")
end
function footballChoosePanel:onItemRederer(index, target)
	local config = footballChampionRead.getAnswerConfig(self.proxy.param.answer[index + 1])
	target:setString(i18n(config.country))
	target:setIcon(config.flag)
	target:getController("c1"):setSelectedIndex(index % 2)
end
function footballChoosePanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex() + 1
	print("self.fields.List", index)
	_ENV = index
	index.matchIndex = self.proxy.param.matchIndex
	index.answerIndex = index
	footballChampionCtrl:reqFootballChampionGuess(index)
	self:removeFromParent()
end
return footballChoosePanel
