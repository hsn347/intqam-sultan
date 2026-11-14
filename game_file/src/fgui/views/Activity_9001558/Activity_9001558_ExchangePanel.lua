local resDesRead = include("resDesRead")
local activity_9001558_Read = include("activity_9001558_Read")
local activity_9001558_Ctrl = SoraDGetCtrl("activity_9001558_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001558_ExchangePanel = class("Activity_9001558_ExchangePanel", baseFguiPanel)
function Activity_9001558_ExchangePanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001558_ExchangePanel:ctor", self.viewName)
end
function Activity_9001558_ExchangePanel:onInit()
	print("=======Activity_9001558_ExchangePanel:onInit")
	self.fields.Com_title:initData(i18n("Stellar_Odyssey_text_04"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onExchangeItemRender))
	self.fields.List:setVirtual()
	self.fields.Text_num = SoraDCreateTimerLabel(nil, self.fields.Text_num)
end
function Activity_9001558_ExchangePanel:onShow()
	print("=======Activity_9001558_ExchangePanel:onShow")
	self:updateTextNum()
	self:updateExchangeList()
end
function Activity_9001558_ExchangePanel:onExchangeItemRender(index, obj)
	local cfg = self.exchangeList[index + 1]
	obj:initData(cfg)
end
function Activity_9001558_ExchangePanel:updateExchangeList()
	local temp = activity_9001558_Read.getExchangeList()
	self.exchangeList = clone(temp)
	for i, v in ipairs(self.exchangeList) do
		v.isRemind = activity_9001558_Ctrl:getIsRemind(v.shopItemID)
		v.curExchangeNum = activity_9001558_Ctrl:getExchangeNum(v.shopItemID)
		if v.limit - v.curExchangeNum > 0 then
			v.weight = 1
		else
			v.weight = 0
		end
	end
	table.sort(self.exchangeList, function(a, b)
		if a.weight ~= b.weight then
			return a.weight > b.weight
		end
		return a.index < b.index
	end)
	self.fields.List:setNumItems(#self.exchangeList)
end
function Activity_9001558_ExchangePanel:updateTextNum()
	local remainTime = activity_9001558_Ctrl:getReceiveStageRemainTime()
	local itemID = gIDDef.STELLAR_ODYSSEY_POINT
	local itemName = resDesRead.getName(itemID)
	if 0 < remainTime then
		local num = activity_9001558_Ctrl:getFinishedQuestNum()
		local times = include("constantRead").getConstValue("STELLAR_ODYSSEY_TASK_REWARD", 1)
		self.fields.Text_num:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			;(nil).name = itemName
			;(nil).num1 = num * times
			return i18n("Stellar_Odyssey_text_05", nil)
		end)
		self.fields.Text_num:setTimeEndListener(function()
			self:updateTextNum()
		end)
		self.fields.Text_num:beginTime(remainTime)
	else
		local point = activity_9001558_Ctrl:getExchangePoint()
		activity_9001558_Ctrl = nil
		;(nil).name = itemName
		;(nil).num = point
		self.fields.Text_num:setString(i18n("Stellar_Odyssey_text_06", nil))
	end
end
function Activity_9001558_ExchangePanel:onMsgExchangeBack()
	self:updateTextNum()
	self:updateExchangeList()
end
return Activity_9001558_ExchangePanel
