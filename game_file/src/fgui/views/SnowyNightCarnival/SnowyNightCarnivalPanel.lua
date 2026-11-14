local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local snowyNightCarnivalCtrl = SoraDGetCtrl("snowyNightCarnivalCtrl")
local snowyNightCarnivalltCtrl = include("snowyNightCarnivalltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowyNightCarnivalPanel = class("SnowyNightCarnivalPanel", baseFguiPanel)
function SnowyNightCarnivalPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowyNightCarnivalPanel:ctor", self.viewName)
end
function SnowyNightCarnivalPanel:getPackageList()
	if not self._packageList then
		_UPVALUE7_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[5] = self._packageList, "DesertSecretTreasure"
		self._packageList, self._packageList[6] = self._packageList, "NewHeroView"
		self._packageList, self._packageList[7] = self._packageList, "fonts"
	end
	return self._packageList
end
function SnowyNightCarnivalPanel:onInit()
	print("=======SnowyNightCarnivalPanel:onInit")
	self.activityID = gActivityTimeActivityID.SNOWY_NIGHT_CARNIVAL_ACTIVITY
	self.itemID = constantRead.getConstValue("SNOWY_NIGHT_REQ_ITEM", 1001)
	self.functionCol = self:initFunc()
	self.fields.Com_title:initData(i18n("activity_name_9001378"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = self.fields.Com_title.initData
	self.fields.Com_title.initData.itemid = self.itemID
	local self.fields.Com_title.initData.handle, data = function()
		SoraDPlaySound()
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
	end, self.fields.Com_title.initData
	self.fields.Com_ownNum:initData(data)
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).num = backpackCtrl:getItemCount(self.itemID)
	self.fields.Com_ownNum:setNum(i18n("snowy_night_text_004", handler(self, self.onClickHelp)))
	self.fields.Button_cost:setTitleText(i18n("snowy_night_text_003"))
	self.fields.Button_cost:addClickListener(handler(self, self.onClickDonate))
	self.fields.Button_cost:addLongPressListener(handler(self, self.onLevelUpgrade))
	self.fields.Button_cost:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onOutClick))
	self.fields.Particle_1:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Particle_1_2:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Particle_2:setBlendFunc(gl.ONE, gl.ONE)
	self.tableLabelSpare, _ENV, self.tableEXPLabelSpare, _ENV = self.fields.Particle_2.setBlendFunc, self.fields.Particle_2.setBlendFunc, self.fields.Particle_2.setBlendFunc, self.fields.Particle_2.setBlendFunc
	self:initData()
end
local LONG_EVENT_TIME = 1
function SnowyNightCarnivalPanel:onLevelUpgrade(context)
	self.isLongUse = true
	if backpackCtrl:getItemCount(self.itemID) >= 1 then
		local useNum = 1
		_ENV = self.itemID
		self.itemID[1] = ffa.callFunc(function()
			if backpackCtrl:getItemCount(self.itemID) >= 1 then
				snowyNightCarnivalCtrl:sendDonateMsg()
			else
				self.isLongUse = false
				self:stopAllActions()
			end
		end)
		self.itemID[2] = ffa.delay(0.25)
		self.itemID[3] = ffa.delay(0.25)
		local seq = ffa.seq(self.itemID)
		self:runAction(ffa.repeatForever(seq))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function SnowyNightCarnivalPanel:onOutClick()
	self:stopAllActions()
end
function SnowyNightCarnivalPanel:onClickDonate()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 1 then
		snowyNightCarnivalCtrl:sendDonateMsg()
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function SnowyNightCarnivalPanel:initData()
	self.level = snowyNightCarnivalCtrl:getCurLevel()
	self.fields.Com_main:initData()
	self.fields.Button_cost:setCost(self.itemID, 1)
	snowyNightCarnivalCtrl = nil
	;(nil).num = backpackCtrl:getItemCount(self.itemID)
	self.fields.Com_ownNum:setNum(i18n("snowy_night_text_004", nil))
	self.fields.Progress_score:setValue(snowyNightCarnivalCtrl:getCurScore(), snowyNightCarnivalltCtrl.getRewardScoreByLevel(self.level))
	snowyNightCarnivalCtrl = snowyNightCarnivalltCtrl.getRewardScoreByLevel(self.level)
	snowyNightCarnivalltCtrl.getRewardScoreByLevel(self.level).lv = self.level
	self.fields.Progress_score:setText(i18n("common_text_101", snowyNightCarnivalltCtrl.getRewardScoreByLevel(self.level)))
	local maxLevel = snowyNightCarnivalltCtrl.getLastLevel()
	if snowyNightCarnivalCtrl:getCanGetLevel() == maxLevel then
		self.fields.Progress_score:setMax()
	end
end
function SnowyNightCarnivalPanel:updateFurtherBtn()
	self.fields.Com_main:updateFurtherBtn()
end
function SnowyNightCarnivalPanel:initFunc()
	_ENV = nil
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	;(nil).further = function()
		SoraDShowMsgTip(i18n("callback_friend_text_04"))
		self.fields.Com_main:updateFurtherBtn()
		self.fields.Com_main:initData()
	end
	;(nil).donate = function()
		if snowyNightCarnivalCtrl:getIncScore() > 1 then
			local comp
			if table.nums(self.tableLabelSpare) > 10 then
				comp = table.remove(self.tableLabelSpare, 1)
				comp:setText("X" .. tostring(snowyNightCarnivalCtrl:getIncScore()))
				comp:getTransition("t0"):play()
			else
				comp = fgui.UIPackage:createObjectFromURL("ui://Activity2112/Label_pointEffect")
				comp:addTo(self.fields.Label_incScore)
				comp:setPositionX(math.random(-50, 50))
				comp:setPositionY(math.random(-50, 50))
				comp:setText("X" .. tostring(snowyNightCarnivalCtrl:getIncScore()))
				comp:getTransition("t0"):play()
			end
			table.insert(self.tableLabelSpare, comp)
		end
		self:initData()
	end
	;(nil).reward = function()
		self:showRewards()
		self:initData()
	end
	;(nil).noReward = function()
		SoraDShowMsgTip(i18n("common_text_1892"))
	end
	;(nil).alreadyFurther = function()
		SoraDShowMsgTip(i18n("common_text_3833"))
	end
	local (nil).notEnoughGold, functionCol = function()
		SoraDShowMsgTip(i18n("alliance_landSet_006"))
	end, nil
	return functionCol
end
function SnowyNightCarnivalPanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function SnowyNightCarnivalPanel:refreshView(data)
	if not data then
		return self:initData()
	end
	dump(data, "SnowyNightCarnivalPanel:refreshView")
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function SnowyNightCarnivalPanel:refreshItem()
	self.fields.Button_cost:setCost(self.itemID, 1)
	self.fields.Com_ownNum:refreshCount()
end
function SnowyNightCarnivalPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("snowy_night_text_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SnowyNightCarnivalPanel:onShow()
	print("=======SnowyNightCarnivalPanel:onShow")
end
function SnowyNightCarnivalPanel:onHide()
	print("=======SnowyNightCarnivalPanel:onHide")
end
function SnowyNightCarnivalPanel:onDispose()
	print("=======SnowyNightCarnivalPanel:onDispose")
end
return SnowyNightCarnivalPanel
