local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local nebulaWonderlandRead = include("nebulaWonderlandRead")
local dailyRemindManager = include("dailyRemindManager")
local nebulaWonderlandCtrl = SoraDGetCtrl("nebulaWonderlandCtrl")
local constantRead = include("constantRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWonderlandPanel = class("NebulaWonderlandPanel", baseFguiPanel)
function NebulaWonderlandPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NebulaWonderlandPanel:ctor", self.viewName)
end
function NebulaWonderlandPanel:getPackageList()
	if not self._packageList then
		_UPVALUE3_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
		self._packageList, self._packageList[2] = self._packageList, "StarryNightCarnival"
		self._packageList, self._packageList[3] = self._packageList, "ThemTake"
	end
	return self._packageList
end
function NebulaWonderlandPanel:onInit()
	print("=======NebulaWonderlandPanel:onInit")
	self.activityID = gActivityTimeActivityID.NEBULA_WONDERLAND_ACTIVITY
	self.maxMile = nebulaWonderlandRead.getMaxMile()
	self.fields.Usm_1136:setCompleteCallback(function()
		self.fields.Usm_1136:setVisible(false)
		self.transitions.t0:play()
	end)
	self.fields.Usm_1386:setCompleteCallback(function()
		self.fields.Usm_1386:setVisible(false)
		self.transitions.t1:play()
	end)
	if display.width / display.height < 0.5 then
		self.controllers.pos:setSelectedIndex(1)
	end
	local key = dailyRemindManager.REMIND_TYPE.nebulaWonderlandEnter
	if dailyRemindManager.checkNeedRemindOnce(key, self.activityID) then
		self.fields.Com_mileage:setAlpha(0)
		self.fields.Effect_1:setAlpha(0)
		self.fields.Usm_bgUp:setAlpha(0)
		self.fields.Usm_bgBottom:setAlpha(0)
		self.fields.Com_mileage:getController("c1"):setSelectedIndex(0)
		if display.width / display.height < 0.5 then
			self.fields.Com_mileage:setYOff()
			self.controllers.pos:setSelectedIndex(1)
			self.fields.Usm_1136:setVisible(false)
			self.fields.Usm_1386:setVisible(true)
		else
			self.fields.Usm_1386:setVisible(false)
			self.fields.Usm_1136:setVisible(true)
		end
		local opencount = activityShowCtrl:getOpenCount(self.activityID)
		dailyRemindManager.addRemindToManager(key, opencount)
	else
		self.fields.Usm_1136:setVisible(false)
		self.fields.Usm_1386:setVisible(false)
	end
	self.itemID = constantRead.getConstValue("NEBULA_WONDERLAND_SUBMIT", 847701)
	self.fields.Com_title:initData(i18n("activity_name_9001433"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	local str = self:setNumGreenColor()
	self.fields.Text_tip:setString(str)
	self.fields.Com_ownNum:setTitle(i18n("nebula_wonderland_003"))
	self.fields.Button_Donate:setTitle(i18n("nebula_wonderland_005"))
	self.fields.Button_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_task:setTitle(i18n("common_text_675"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickReward))
	self.fields.Button_task:addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_Donate:addClickListener(handler(self, self.onClickDonate))
	_ENV = self.fields.Button_Donate.addClickListener
	self.fields.Button_Donate.addClickListener.itemid = self.itemID
	local self.fields.Button_Donate.addClickListener.handle, data = self.onClickAdd, self.fields.Button_Donate.addClickListener
	self.fields.Com_ownNum:initData(data)
	self.fields.Com_ownNum:setAddButtonPos()
	self:initData()
end
function NebulaWonderlandPanel:setNumGreenColor(str)
	local str = i18n("nebula_wonderland_004")
	str = string.gsub(str, "1", fguiHelper.getColorString("#7FCC56", "1"))
	str = string.gsub(str, "0", fguiHelper.getColorString("#7FCC56", "0"))
	return str
end
function NebulaWonderlandPanel:initData()
	self.fields.Com_mileage:initData()
	self:updateTaskRedDot()
	local progress = nebulaWonderlandCtrl:getProgress()
	self.fields.Text_mile:setString(i18n("nebula_wonderland_002") .. string.formatnumberthousands(progress > self.maxMile and self.maxMile or progress))
	self.fields.Com_ownNum:setNum(string.formatnumberthousands(backpackCtrl:getItemCount(self.itemID)))
	self.fields.Com_ownNum:setAddButtonPos()
end
function NebulaWonderlandPanel:popIncScore(data)
	if data.count and data.count > 0 then
		self.fields.Label_point:setText("x" .. tostring(data.count))
		self.fields.Label_point:getTransition("t0"):play()
		self:initData()
	end
end
function NebulaWonderlandPanel:setGiftState(data)
	dump(data, "fskdjfkd56565jfk")
	if data.index and data.index > 0 then
		self.fields.Com_mileage:setGiftState(data.index)
	end
end
function NebulaWonderlandPanel:updateTaskRedDot()
	local show, num = false, 0
	show, num = activityTaskComponentCtrl:getReceiveStatusAndNum(self.activityID)
	self.fields.Button_task:getChild("Label_reddot"):initData(show, num)
end
function NebulaWonderlandPanel:setPageChange(data)
	if data.pageIndex then
		self.fields.Com_scrollLine:getController("page"):setSelectedIndex(data.pageIndex)
	elseif data.top then
		self.fields.Com_scrollLine:getController("top"):setSelectedIndex(1)
	elseif data.bottom then
		self.fields.Com_scrollLine:getController("top"):setSelectedIndex(0)
	end
end
function NebulaWonderlandPanel:onClickAdd()
	SoraDPlaySound()
	uiManager:show("NebulaWonderlandTask"):setOwnerKey(self)
end
function NebulaWonderlandPanel:onClickReward()
	SoraDPlaySound()
	uiManager:show("NebulaWonderlandReward"):setOwnerKey(self)
end
function NebulaWonderlandPanel:onClickDonate()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 1 then
		_ENV = backpackCtrl:getItemCount(self.itemID)
		backpackCtrl:getItemCount(self.itemID).title = i18n("nebula_wonderland_005")
		backpackCtrl:getItemCount(self.itemID).itemDes = i18n("nebula_wonderland_004")
		backpackCtrl:getItemCount(self.itemID).btnTitle = i18n("common_text_3628")
		backpackCtrl:getItemCount(self.itemID).itemID = self.itemID
		backpackCtrl:getItemCount(self.itemID).minValue = 1
		backpackCtrl:getItemCount(self.itemID).maxValue = backpackCtrl:getItemCount(self.itemID)
		backpackCtrl:getItemCount(self.itemID).btnHandle = function(buyCount)
			SoraDPlaySound()
			nebulaWonderlandCtrl:sendDonateStarMap(buyCount)
		end
		backpackCtrl:getItemCount(self.itemID).panelFixFlag = true
		local backpackCtrl:getItemCount(self.itemID).inputFixFlag, param = true, backpackCtrl:getItemCount(self.itemID)
		uiManager:show("NebulaWonderlandDonate", param):setOwnerKey(self)
	else
		SoraDShowMsgTip(i18n("nebula_wonderland_007"))
	end
end
function NebulaWonderlandPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_wonderland_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function NebulaWonderlandPanel:onShow()
	print("=======NebulaWonderlandPanel:onShow")
end
return NebulaWonderlandPanel
