local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local constantRead = include("constantRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RunePopViewPanel = class("RunePopViewPanel", baseFguiPanel)
function RunePopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RunePopViewPanel:ctor", self.viewName)
end
function RunePopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RunePopViewPanel:onInit()
	print("=======RunePopViewPanel:onInit")
	self.data = self.param.data
	self.fields.Panel_bg:setTitle(i18n("Weapon_Rune_tips_052"))
	self.fields.Btn_replace:setString(i18n("Weapon_Rune_button_004"))
	self.fields.Btn_replace:addClickListener(handler(self, self.onReplaceClick))
	self.fields.Btn_random:setString(i18n("Weapon_Rune_button_005"))
	self.fields.Btn_random:addClickListener(handler(self, self.onRandomClick))
	self.fields.Btn_strength:initData(i18n("Weapon_Rune_button_010"), false)
	self.fields.Btn_strength:addClickListener(handler(self, self.onStrengthClick))
	self.fields.Btn_takeOff:setString(i18n("Weapon_Rune_button_003"))
	self.fields.Btn_takeOff:addClickListener(handler(self, self.onTakeOffClick))
	self.fields.Btn_reborn:setString(i18n("Weapon_Rune_tips_078"))
	self.fields.Btn_reborn:addClickListener(handler(self, self.onRebornClick))
	self.fields.Btn_lock:addClickListener(handler(self, self.onLockClick))
	self.fields.Btn_unlock:addClickListener(handler(self, self.onUnLockClick))
	self.fields.Btn_inherit:setString(i18n("Weapon_Rune_inherit_001"))
	self.fields.Btn_inherit:setVisible(false)
	self.fields.Btn_inherit:addClickListener(handler(self, self.onInheritClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.luckyLimit = artifactRuneRead.getLuckyValueLimit()
end
function RunePopViewPanel:onShow()
	print("=======RunePopViewPanel:onShow")
	self.controllers.c1:setSelectedIndex(self.param.cIndex or 0)
	self.fields.single:fixPos()
	self.fields.Btn_takeOff:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_stage:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.Text_lucky:fixPos()
	self.fields.Btn_lock:fixPos()
	self.fields.Text_baseBuff:fixPos()
	self.fields.Btn_replace:fixPos()
	self.fields.Btn_random:fixPos()
	self.fields.Btn_inherit:fixPos()
	self:initData()
end
function RunePopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.extraProperty[index + 1], self.data.rid, index + 1)
end
function RunePopViewPanel:updateView()
	local newData = godArmsRuneCtrl:getRuneInfo(self.data.uid)
	if newData == nil then
		return
	end
	dump(newData, "newData====")
	self.data.exp = newData.exp
	self.data.extraProperty = newData.extraProperty
	self.data.level = newData.level
	self.data.isLock = newData.isLock
	self.data.rid = newData.rid
	self.data.uid = newData.uid
	self:initData()
end
function RunePopViewPanel:checkExtra()
	local ret = false
	for k, v in ipairs(self.data.extraProperty) do
		if v[2] > 1 then
			ret = true
			break
		end
	end
	return ret
end
function RunePopViewPanel:initData()
	self.group = self.param.group or 1
	self.fields.single:initData(self.data)
	local info = artifactRuneRead.getRuneInfo(self.data.rid)
	local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, self.data.level)
	self.class = self.data.class or lvCfg.Class
	self.fields.Text_name:setString(i18n(info.RuneName))
	self.fields.Com_stage:initData(self.class)
	artifactRuneRead = i18n(info.RuneName)
	i18n(info.RuneName).level = lvCfg.Level
	self.fields.Text_lv:setString(i18n("common_text_600", i18n(info.RuneName)))
	local isWear = godArmsRuneCtrl:isRuneWear(self.data.uid)
	if self.data.godArmsID and self.data.godArmsCell then
		self.fields.Btn_takeOff:setVisible(true)
	else
		self.fields.Btn_takeOff:setVisible(isWear)
	end
	local curSelectedIndex = self.controllers.c1:getSelectedIndex()
	if (curSelectedIndex == 1 or curSelectedIndex == 3) and not isWear then
		self.controllers.c1:setSelectedIndex(3)
		if not self.data.isLock and (self.class > 0 or 1 < self.data.level or 0 < self.data.exp or self:checkExtra()) then
			self.fields.Btn_reborn:setEnabled(true)
		else
			self.fields.Btn_reborn:setEnabled(false)
		end
		self.fields.Btn_reborn:fixPos()
		self.fields.Btn_strength:fixPos()
	else
		self.fields.Btn_strength:fixPos()
	end
	self.fields.Btn_lock:setVisible(self.data.isLock)
	self.fields.Btn_unlock:setVisible(not self.data.isLock)
	self.fields.Lab_base:setString(i18n("Weapon_Rune_tips_007"))
	local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, self.data.level)
	local buffDes = buffDesRead.getBuffDes(info.BasicProperties.buffType, info.BasicProperties.buffVal + pLvCfg.GrowingValue, info.BasicProperties.buffMode)
	self.fields.Text_baseBuff:setString(buffDes)
	self.fields.Lab_random:setString(i18n("Weapon_Rune_tips_008"))
	if not self.data.extraProperty then
		artifactRuneRead = self.data.extraProperty
	end
	self.extraProperty = self.data.extraProperty
	self.fields.List:setNumItems(#self.extraProperty)
	local isUnlock, classLimit, levlLimit = artifactRuneRead.getLimitSeaonCfg(info.Season)
	self.isMax = levlLimit <= self.data.level
	self.fields.Btn_strength:initData(i18n("Weapon_Rune_button_010"), self.isMax)
	local value, ret = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_RUNE_INHERIT_FUNCTION)
	if ret then
		self.fields.Btn_inherit:setVisible(true)
	else
		local season = nebulaActivityCtrl:getCurSeason() or 1
		local state = nebulaActivityCtrl:getActivityCurState()
		local cfgSeason = constantRead.getConstValue("UNLOCK_RUNE_HERITCOST_SEASON")
		local cfgState = constantRead.getConstValue("UNLOCK_RUNE_HERITCOST_STAGE")
		if season > cfgSeason or season == cfgSeason and state >= cfgState then
			self.fields.Btn_inherit:setVisible(true)
		else
			self.fields.Btn_inherit:setVisible(false)
		end
	end
	artifactRuneRead = self.fields.Btn_inherit.setVisible
	self.fields.Btn_inherit.setVisible.var = SoradNumStringNoZero(self.data.luckyValue / self.luckyLimit * 100)
	self.fields.Text_lucky:setString(i18n("herovault_text_08", self.fields.Btn_inherit.setVisible))
end
function RunePopViewPanel:onReplaceClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	;(nil).group = self.group
	uiManager:show("RuneReplaceView", nil)
	self:close()
end
function RunePopViewPanel:onRandomClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("RuneQHXLView", nil)
	self:close()
end
function RunePopViewPanel:onStrengthClick()
	SoraDPlaySound()
	if self.isMax then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_009"))
		return
	end
	_ENV = i18n("Weapon_Rune_tips_009")
	i18n("Weapon_Rune_tips_009").data = self.data
	uiManager:show("RuneRintensify", i18n("Weapon_Rune_tips_009"))
	self:close()
end
function RunePopViewPanel:onTakeOffClick()
	SoraDPlaySound()
	if self.data.godArmsID and self.data.godArmsCell then
		if artifactRuneRead.isRuneSetLock(self.group - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
		else
			godArmsRuneCtrl:sendTakeoff(self.data.godArmsID, self.data.godArmsCell, self.group)
			self:close()
		end
	else
		local wearRuneInfo = godArmsRuneCtrl:getWearRuneInfo(self.data.uid)
		if wearRuneInfo == nil then
			self:close()
			return
		end
		if artifactRuneRead.isRuneSetLock(wearRuneInfo.group - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
		else
			godArmsRuneCtrl:sendTakeoff(wearRuneInfo.armid, wearRuneInfo.cell, wearRuneInfo.group)
			self:close()
		end
	end
end
function RunePopViewPanel:onLockClick()
	SoraDPlaySound()
	SoraDCheckSecondaryLock(function()
		godArmsRuneCtrl:sendLock(self.data.uid, 0)
	end, gSecondaryLockType.ArmsRuneUnlock, "RunePopView")
end
function RunePopViewPanel:onUnLockClick()
	SoraDPlaySound()
	SoraDIsNeedOpenVerifySecondaryLock(function()
		local dailyRemindManager = include("dailyRemindManager")
		if not dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.armsrune_lock) or not userSDKManager.isNeedVerify() then
			godArmsRuneCtrl:sendLock(self.data.uid, 1)
			return
		end
		_ENV = 1
		;(1).content = i18n("Safety_lock_text_25")
		;(1).confirmFunc = function()
			if not tolua.isnull(self) then
				godArmsRuneCtrl:sendLock(self.data.uid, 1)
			end
		end
		;(1).remindString = i18n("coffeeCraftsman_text_27")
		;(1).remindFunc = function(value)
			if value then
				dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.armsrune_lock)
			end
		end
		uiManager:show("MessageBox", 1)
	end)
end
function RunePopViewPanel:onInheritClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).target = self.data
	uiManager:show("RuneInheritView", nil)
end
function RunePopViewPanel:onRebornClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.data
	;(nil).parent = self
	uiManager:show("RuneRebornPop", nil)
end
return RunePopViewPanel
