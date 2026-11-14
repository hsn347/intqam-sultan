local activityExchangeMallRead = include("activityExchangeMallRead")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillExchangePanel = class("MagicLampSkillExchangePanel", baseFguiPanel)
function MagicLampSkillExchangePanel:ctor(...)
	self.isLRU = true
	MagicLampSkillExchangePanel.super.ctor(self, ...)
	print("MagicLampSkillExchangePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010011
end
function MagicLampSkillExchangePanel:onInit()
	print("=======MagicLampSkillExchangePanel:onInit")
	self.fields.Com_title:setTitleWidthHeight(272, 60)
	self.fields.Com_title:setTitleFontSize(22)
	self.fields.Com_title:initData(i18n("activity_name_9001465"), handler(self, self.onClickClose))
	self.fields.List_exchange:setVirtual()
	self.fields.List_exchange:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, time
		;(nil).time, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_4720", nil, nil)
	end)
	self.tableData, _ENV = self.fields.Label_time.setTimeLast, self.fields.Label_time.setTimeLast
end
function MagicLampSkillExchangePanel:endShow()
	print("=======MagicLampSkillExchangePanel:endShow")
	_ENV = print
	_ENV, _ENV, print.defaultClick = nil, "=======MagicLampSkillExchangePanel:endShow", 1
	_ENV, ("=======MagicLampSkillExchangePanel:endShow")[1], (nil).title = nil, nil, i18n("jinn_skill_1")
	print.tabsetArray, ("=======MagicLampSkillExchangePanel:endShow")[2], (nil).title = "=======MagicLampSkillExchangePanel:endShow", nil, i18n("item_name_208001")
	local print.callback, tabData = function(index)
		if index == 2 and clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER, true) then
			self:close()
			_ENV = nil
			;(nil).id = gActivityTimeActivityID.EXCHANGE_MALL_GODPOWER
			uiManager:show("ExchangeEventPage", nil)
		end
	end, print
	self.fields.Com_tab:initView(tabData)
	self:setTime()
	self:initData()
end
function MagicLampSkillExchangePanel:setTime()
	local nextRefreshTime = SoraDGetSpecialActivityRefreshTime(self.activityID)
	if nextRefreshTime and nextRefreshTime - serviceFunctions.systemTime() > 0 then
		self.fields.Label_time:setVisible(true)
		self.fields.Label_time:beginTime(nextRefreshTime - serviceFunctions.systemTime())
	else
		self.fields.Label_time:setVisible(false)
	end
end
function MagicLampSkillExchangePanel:initData(target, data)
	self:getExchangeDataList()
	_UPVALUE0_ = self.getExchangeDataList
	self.otherData, self.getExchangeDataList.activityID = self.getExchangeDataList, self.activityID
	self.fields.List_exchange:setNumItems(#self.tableData)
end
function MagicLampSkillExchangePanel:getExchangeDataList()
	self.tableData = activityExchangeMallRead.getShopItemListFromOri(self.activityID)
	for i, v in ipairs(self.tableData) do
		v.remindStatus = activityExchangeMallCtrl:getRemindStatus(self.activityID, v.shopItemID)
		v.curExchangeNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, v.shopItemID)
	end
end
function MagicLampSkillExchangePanel:onItemRenderer(index, object)
	object:initData(self.tableData[index + 1], self.otherData)
end
return MagicLampSkillExchangePanel
