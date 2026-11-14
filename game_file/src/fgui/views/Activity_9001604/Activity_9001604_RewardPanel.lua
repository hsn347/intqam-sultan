local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001604_RewardPanel = class("Activity_9001604_RewardPanel", baseFguiPanel)
local activity_9001604_Read = include("activity_9001604_Read")
local activity_9001604_Ctrl = SoraDGetCtrl("activity_9001604_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
function Activity_9001604_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001604_RewardPanel:ctor", self.viewName)
end
function Activity_9001604_RewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001604_RewardPanel:onInit()
	print("=======Activity_9001604_RewardPanel:onInit")
	self.dataList, _ENV, self.tag = print, print, 1
	self.fields.Com_title:initData(i18n("soldier_rush_text_11"), handler(self, self.onClickClose))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
end
function Activity_9001604_RewardPanel:onRankRenderer(index, obj)
	obj:initData(self.dataList[index + 1], self.tag)
end
function Activity_9001604_RewardPanel:onShow()
	print("=======Activity_9001604_RewardPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("common_text_3143")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_3050")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function Activity_9001604_RewardPanel:onClickTab(tag)
	self.tag = tag
	self.fields.Text_notice:setString(self.tag == 1 and i18n("alliance_mobilize_text_02") or i18n("Ramadan_League_text_28"))
	if self.tag == 1 then
		self.dataList = activity_9001604_Read.getLvCfgs()
	elseif self.tag == 2 then
		self.dataList = activity_9001604_Read.getRankCfgs()
	end
	self.fields.List:setNumItems(#self.dataList)
	self.fields.List:jumpToTop()
end
return Activity_9001604_RewardPanel
