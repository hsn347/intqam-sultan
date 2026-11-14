local allianceEscortCtrl = SoraDGetCtrl("allianceEscortCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EscortrewardPanel = class("EscortrewardPanel", baseFguiPanel)
function EscortrewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EscortrewardPanel:ctor", self.viewName)
	self.tag = 1
	self.rewardList = allianceEscortCtrl:getEscortRewardList()
end
function EscortrewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EscortrewardPanel:onInit()
	print("=======EscortrewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("treasureEscort_text22"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	_ENV = handler(self, self.onRewardItemRenderer)
	_ENV, _ENV, handler(self, self.onRewardItemRenderer).defaultClick = handler(self, self.onRewardItemRenderer)
	_ENV, self.tag[1], handler(self, self.onRewardItemRenderer).title = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).tabsetArray, self.tag[2], handler(self, self.onRewardItemRenderer).title = self.tag, handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(handler(self, self.onRewardItemRenderer))
end
function EscortrewardPanel:onShow()
	print("=======EscortrewardPanel:onShow")
end
function EscortrewardPanel:onClickTab(tag)
	self.tag = tag
	self.fields.List_reward:setNumItems(#self.rewardList[self.tag])
end
function EscortrewardPanel:onRewardItemRenderer(index, obj)
	local difficulty = index + 1
	obj:getChild("Text_name"):setString(allianceEscortCtrl:getDifficultyName(difficulty))
	local AwardList = obj:getChild("AwardList")
	local data = self.rewardList[self.tag][difficulty]
	AwardList:setItemRenderer(function(_index, _obj)
		_obj:initData(data[_index + 1].id, data[_index + 1].count)
	end)
	AwardList:setNumItems(#data)
	if obj.isInit then
		return
	end
	obj.isInit = true
	obj:fixChildrenPos()
	obj:fixChildren()
end
return EscortrewardPanel
