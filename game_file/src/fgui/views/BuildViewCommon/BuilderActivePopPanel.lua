local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BuilderActivePopPanel = class("BuilderActivePopPanel", baseFguiPanel)
function BuilderActivePopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BuilderActivePopPanel:ctor", self.viewName)
end
function BuilderActivePopPanel:onInit()
	print("=======BuilderActivePopPanel:onInit")
	self.needCount = 1
	self.gold = gConstValue.OPEN_BUILD_CHARGE_QUEUE_GOLD
	self.buildTime = 0
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setVisible(false)
	self.fields.Button_tool:setString(i18n("common_text_3527"))
	self.fields.Button_tool:addClickListener(handler(self, self.btnToolCallBack))
	self.fields.Button_buy:setString(i18n("Secret_explore_text_14"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnBuyCallBack))
	self.fields.Button_gold:setString(i18n("common_text_843"))
	self.fields.Button_gold:addClickListener(handler(self, self.btnGoldCallBack))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.onClickClose))
end
function BuilderActivePopPanel:onShow()
	print("=======BuilderActivePopPanel:onShow")
	local param = self.param
	self:initData(param.style, param.msg, param.time, param.needCount)
end
function BuilderActivePopPanel:initData(style, msg, time, needCount)
	self.style = style
	if time then
		self.buildTime = time
		self.fields.Text_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).var = ticket
			return i18n("building_worker_text_09", nil)
		end)
		self.fields.Text_time:setVisible(true)
		self.fields.Text_time:beginTime(time)
		self.needCount = math.max(1, needCount)
	end
	if style == 1 then
		self.controllers.c_style:setSelectedIndex(0)
	elseif style == 2 then
		self.controllers.c_style:setSelectedIndex(1)
		local totalGold = self.gold * self.needCount
		self.fields.Button_gold:setCostTitle(string.formatnumberthousands(totalGold))
	elseif style == 3 then
		self.controllers.c_style:setSelectedIndex(2)
	elseif style == 4 then
		self.controllers.c_style:setSelectedIndex(3)
		local totalGold = self.gold * self.needCount
		self.fields.Button_gold:setCostTitle(string.formatnumberthousands(totalGold))
	end
	self.fields.Text_msg:setString(msg)
end
function BuilderActivePopPanel:btnToolCallBack()
	SoraDPlaySound()
	local itemId = 500501
	local itemCount = backpackCtrl:getItemCount(itemId)
	_ENV, _ENV = nil, nil
	;(nil).id = itemId
	;(nil).count = itemCount
	;(nil).itemData, (nil).bestNum = nil, math.max(1, math.min(math.ceil(self.buildTime / 28800), itemCount))
	uiManager:show("newItemSingleUse", nil)
	self:removeFromParent()
end
function BuilderActivePopPanel:btnBuyCallBack()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).toCategory = gRechargeCenterCategory.MONTH
		;(nil).toNodeTag = 1
		uiManager:show("rechargeView", nil)
	else
		local rechargeView = SoraDCreatePanel("rechargeView")
		rechargeView:jumpToWeeklyTab()
		rechargeView:show()
	end
	self:removeFromParent()
end
function BuilderActivePopPanel:btnGoldCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.gold * self.needCount) then
		SoraDPlaySound()
		cityCtrl:openChargeQueueReq(self.needCount)
		self:removeFromParent()
	end
end
function BuilderActivePopPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_tool" then
		if self.style == 1 or self.style == 3 then
			return self.fields.Button_tool
		else
			return self.fields.Button_gold
		end
	end
	return self.fields[itemName]
end
return BuilderActivePopPanel
