local newServerReturnltCtrl = include("newServerReturnltCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local newstart_effect = require_data("newstart_effect", true).data
local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewStartPanel = class("NewStartPanel", baseFguiPanel)
function NewStartPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NewStartPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY
	self.isAddToPopManager = true
end
function NewStartPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
	end
	return self._packageList
end
function NewStartPanel:onInit()
	print("=======NewStartPanel:onInit")
	self.controllers.c_lang:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.fields.Button_question:addClickListener(handler(self, self.onClickBtnQuestion))
	self.fields.Text_des1:setString(i18n("newstart_text_1"))
	self.fields.Text_buff:setString(i18n("newstart_text_3"))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.List_buff:setNumItems(#newstart_effect)
	self.fields.Text_reward:setString(i18n("newstart_text_4"))
	self.rewardData = newServerReturnltCtrl.getNewServerReward().newStartReward
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.rewardData) / 2)
	local Com_gold = self.fields.Com_gold
	Com_gold:getChild("Text_name"):setString(i18n("common_text_020"))
	Com_gold:getChild("Text_des"):setString(i18n("newstart_opt_0001"))
	Com_gold:getChild("Text_x"):setString("X")
	if not SoraDFIsRA() then
		Com_gold:fixChildrenPos()
		Com_gold:getChild("icon_gold"):setPositionX(10)
	end
	local Com_coins = self.fields.Com_coins
	Com_coins:getChild("Text_name"):setString(i18n("item_name_1646"))
	Com_coins:getChild("Text_des"):setString(i18n("newstart_opt_0002"))
	Com_coins:getChild("Text_x"):setString("X")
	Com_coins:fixChildrenPos()
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.fields.Text_time:beginTime(leftTime)
	end
	local Com_code = self.fields.Com_code
	Com_code:getChild("Text_name"):setString(i18n("newstart_text_35"))
	Com_code:fixChildrenPos()
	self.List_code = Com_code:getChild("List_code")
	self.List_code:setItemRenderer(handler(self, self.onCodeItemRenderer))
	self.List_code:setNeedAutoFix(false)
	self.fields.Button_go:setString(i18n("newstart_opt_button_0001"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function NewStartPanel:onShow()
	print("=======NewStartPanel:onShow")
	newStartMainCtrl:reqInitOld()
	activityCenterUICtrl:sendClearNewMsg(self.activityID)
	SoraDShowLoading()
end
function NewStartPanel:refreshView(target, event)
	SoraDCloseLoading()
	local data = event.rspData
	self.kid = data.kingdomID
	local inheritGoldPro = newServerReturnltCtrl.getNewServerReward().inheritGoldPro
	local num = math.floor(data.gold * inheritGoldPro / 1000)
	self.fields.Com_gold:getChild("Text_value"):setString("x" .. string.formatnumberthousands(num))
	self.gold = num
	local dollor = data.dollor
	if 0 < dollor then
		local num = self.proxy:getInheritRewardGross(dollor)
		self.fields.Com_coins:getChild("Text_value"):setString("x" .. string.formatnumberthousands(num))
		self.fields.Com_coins:setVisible(true)
	else
		self.fields.Com_coins:setVisible(false)
	end
	self:refreshCode(nil, data)
end
function NewStartPanel:refreshCode(target, event)
	local correlationCode = event.correlationCode
	if correlationCode and correlationCode ~= "0" then
		self.code = correlationCode
		local _ENV, ret
		for i = 1, string.len(self.code) do
			ret[i] = string.sub(self.code, i, i)
		end
		self.codeList = ret
		self.List_code:setNumItems(#self.codeList)
	end
end
function NewStartPanel:onBuffItemRenderer(index, object)
	local data = newstart_effect[index + 1]
	object:getChild("Load_icon"):setURL(data.EffectIcon)
	local buffID = data.buffId
	local effectType = buffltCtrl:getEffectType(buffID)
	local buffNum1 = buffltCtrl:getEffect(buffID)
	local title, _ = buffDesRead.getTitleBase(effectType, true)
	object:getChild("Text_title"):setString(title)
	local value = buffDesRead.getTitleValueWithValue(effectType, buffNum1)
	object:getChild("Text_value"):setString(value)
	object:fixChildrenPos()
end
function NewStartPanel:onRewardItemRenderer(index, object)
	object:initData(self.rewardData[index * 2 + 1], self.rewardData[index * 2 + 2])
	object:setEffectShow(index < 2)
end
function NewStartPanel:onClickBtnQuestion()
	SoraDPlaySound()
	_ENV = nil
	;(nil).kid = self.kid
	;(nil).gold = self.gold
	uiManager:show("NewStartPopTipBox", nil)
end
function NewStartPanel:onClickBtnGo(...)
	SoraDPlaySound()
	if userSDKManager.isAccountBound() then
		_ENV = nil
		_ENV = nil
		;(nil).kid = self.kid
		;(nil).content = i18n("newstart_text_68", nil)
		;(nil).confirmFunc = function()
			userSDKManager.visitorRegister(self.code)
		end
		;(nil).cancelString = i18n("heroDes_text_07")
		;(nil).cancleColorIndex = 1
		;(nil).confirmString = i18n("newstart_opt_button_0001")
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	else
		_ENV = nil
		;(nil).content = i18n("newstart_text_62")
		;(nil).confirmFunc = function()
			userSDKManager.showBindView()
		end
		;(nil).cancelFunc = function()
			userSDKManager.visitorRegister(self.code)
		end
		;(nil).cancleColorIndex = 1
		;(nil).confirmString = i18n("newstart_text_64")
		;(nil).cancelString = i18n("newstart_text_65")
		uiManager:show("MessageBox", nil):setOwnerKey(self)
	end
end
function NewStartPanel:onCodeItemRenderer(index, object)
	object:setString(self.codeList[index + 1])
end
return NewStartPanel
