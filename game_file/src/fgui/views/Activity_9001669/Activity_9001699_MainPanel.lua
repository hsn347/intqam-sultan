local activityCommonKitchenCtrl = SoraDGetCtrl("activityCommonKitchenCtrl")
local activityCommonKitchenRead = include("activityCommonKitchenRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001699_MainPanel = class("Activity_9001699_MainPanel", baseFguiPanel)
function Activity_9001699_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001699_MainPanel.super.ctor(self, ...)
	print("Activity_9001699_MainPanel:ctor", self.viewName)
end
function Activity_9001699_MainPanel:onInit()
	print("=======Activity_9001699_MainPanel:onInit")
	self.fields.Text_tip:setString(i18n("snow_competition_text_07"))
	self.fields.Text_reward1:setString(i18n("warmongering_text_7"))
	self.fields.Text_day:setString(i18n("snow_competition_text_08"))
	self.fields.Text_reward2:setString(i18n("StarlitNight_text_07"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_receive:setString(i18n("summoned_btn_01"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickBtnReceive))
	self.fields.Button_levelLock:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_levelLock:addClickListener(handler(self, self.onClickBtnLock))
	if not SoraDFIsRA() then
		_UPVALUE6_ = self.fields.Button_levelLock
		self.fields.Button_levelLock[1] = self.fields.Text_reward1
		self.fields.Button_levelLock[2] = self.fields.Text_day
		self.fields.Button_levelLock[3] = self.fields.Text_reward2
		self.fields.Button_levelLock[4] = self.fields.Button_levelLock
		self.fields.Button_levelLock[5] = self.fields.mask
		self.fields.Button_levelLock[6] = self.fields.Com_Bar
		for __, v in ipairs(self.fields.Button_levelLock) do
			v:fixPos()
		end
	end
end
function Activity_9001699_MainPanel:endShow()
	print("=======Activity_9001699_MainPanel:endShow")
	if not self.param then
		_ENV = self.param
	end
	self.param = self.param
	self.activityID = self.param.activityID or gActivityTimeActivityID.NORMAL_ACTIVITY_9001699
	self.proxy:registerActivityCloseEvent(self.activityID)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.battlePassConfig = activityCommonKitchenRead.getBattlePassConfig(self.activityID)
	local count = #self.battlePassConfig
	self.fields.Com_Bar:setMax(count)
	self.curLv = activityCommonKitchenCtrl:getCurLv(self.activityID)
	self.fields.Com_Bar:setValue(self.curLv - 0.5)
	if count == 5 then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.Button_levelLock:resetUnlockEffect()
	self:updateBtnReceive()
	self:updateAdvanceReward()
	self:updateListReward()
	_ENV = self.updateListReward
	_ENV, _ENV, self.updateListReward.defaultClick = 1, self, 1
	_ENV, self[1], (1).title = 1, 1, i18n("eidal_kitchen_text_01")
	self.updateListReward.tabsetArray, self[2], (1).title = self, 1, i18n("eidal_kitchen_text_02")
	local self.updateListReward.callback, param = handler(self, self.onClickTab), self.updateListReward
	self.fields.Com_title:initTab(param)
	local isRed = activityCommonKitchenCtrl:getReceiveStatusAndNum1(self.activityID, true)
	self.fields.Com_title:setBtnRedDot(2, isRed)
end
function Activity_9001699_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("octopus_kitchen_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001699_MainPanel:onClickTab(tag)
	if tag == 2 then
		_ENV = nil
		;(nil).activityID = self.activityID
		uiManager:show("Activity_9001669_Main", nil)
		self:closePanel()
	end
end
function Activity_9001699_MainPanel:onItemRenderer(index, obj)
	local cfg = self.battlePassConfig[index + 1]
	obj:initData(self.activityID, cfg, index + 1, self.curLv)
end
function Activity_9001699_MainPanel:onClickBtnReceive(...)
	SoraDPlaySound()
	activityCommonKitchenCtrl:reqDecreeReward(self.activityID)
end
function Activity_9001699_MainPanel:onClickBtnLock(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("CommonBuyGift", nil)
end
function Activity_9001699_MainPanel:updateBtnReceive(...)
	local _ret = activityCommonKitchenCtrl:getBattlePassRedNum(self.activityID)
	self.fields.Button_receive:setEnabled(_ret)
end
function Activity_9001699_MainPanel:updateAdvanceReward(...)
	if activityCommonKitchenCtrl:getIsAdvanceRewardUnlock(self.activityID) then
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
	end
end
function Activity_9001699_MainPanel:updateListReward(...)
	self.fields.List_reward:setNumItems(#self.battlePassConfig)
end
function Activity_9001699_MainPanel:onMsgUpdateData(target, event)
	if event.activityID ~= self.activityID then
		return
	end
	local subMsg = event.subMsg
	if subMsg == "decreeReward" then
		self:updateListReward()
		self:updateBtnReceive()
	elseif subMsg == "buyGift" then
		self.fields.Button_levelLock:showUnlockEffect(function(...)
			self:updateAdvanceReward()
			self:updateListReward()
			self:updateBtnReceive()
		end)
	end
end
return Activity_9001699_MainPanel
