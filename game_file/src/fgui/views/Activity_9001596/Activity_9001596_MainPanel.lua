local activityTimeRead = include("activityTimeRead")
local activity_9001596_Read = include("activity_9001596_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001596_Ctrl = SoraDGetCtrl("activity_9001596_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001596_MainPanel = class("Activity_9001596_MainPanel", baseFguiPanel)
function Activity_9001596_MainPanel:ctor(...)
	Activity_9001596_MainPanel.super.ctor(self, ...)
	print("Activity_9001596_MainPanel:ctor", self.viewName)
end
function Activity_9001596_MainPanel:onInit()
	print("=======Activity_9001596_MainPanel:onInit")
	self.activityID = gActivityTimeActivityID.RAMADAN_BUILD_SALYUT_ACTIVITY
	self.clickTag = 0
	self.operateType = 1
	self.fields.Com_title:initData(i18n("activity_name_9001596"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Btn_gift:setString(i18n("kindofwar_btn_01"))
	self.fields.Btn_gift:addClickListener(handler(self, self.btnGiftClick))
	self.fields.Btn_warehouse:setString(i18n("buildDes_name_105"))
	self.fields.Btn_warehouse:addClickListener(handler(self, self.btnWarehouseClick))
	self.fields.Btn_gun:addClickListener(handler(self, self.btnGunClick))
	self.fields.Btn_go:setString(i18n("starlight_btn_01"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Btn_gift:fixPos()
	self.fields.Btn_warehouse:fixPos()
end
function Activity_9001596_MainPanel:onShow()
	print("=======Activity_9001596_MainPanel:onShow")
	self.giftArray = activityTimeRead.getRechargeId(self.activityID, activityShowCtrl:getParamClassType(self.activityID))
	if #self.giftArray > 0 then
		self.fields.Btn_gift:setVisible(true)
		self.fields.Btn_warehouse:setPositionY(220)
	else
		self.fields.Btn_gift:setVisible(false)
		self.fields.Btn_warehouse:setPositionY(120)
	end
	self:setPartInfo()
end
function Activity_9001596_MainPanel:setPartInfo()
	SoraDCloseLoading(self)
	self.fields.Btn_part1:initData(activity_9001596_Read.partType.carriage, self.clickTag)
	self.fields.Btn_part2:initData(activity_9001596_Read.partType.barrel, self.clickTag)
	self.fields.Btn_part3:initData(activity_9001596_Read.partType.wheel, self.clickTag)
	self:setDetailInfo()
	self.operateType = 1
	if self.clickTag == 0 then
		self.fields.Btn_go:setString(i18n("starlight_btn_01"))
		self.fields.Btn_go:setEnabled(true)
		self.fields.Btn_go:setReddot(false)
	else
		local isMerged = activity_9001596_Ctrl:isMerged(self.clickTag)
		if isMerged then
			self.fields.Btn_go:setString(i18n("Ramadan_2024_text14"))
			self.fields.Btn_go:setEnabled(false)
			self.fields.Btn_go:setReddot(false)
		else
			local itemID = activity_9001596_Read.getPartID(self.clickTag)
			local num = backpackCtrl:getItemCount(itemID)
			local need = activity_9001596_Read.getPartNum(self.clickTag)
			if num >= need then
				self.fields.Btn_go:setString(i18n("Ramadan_2024_text13"))
				self.fields.Btn_go:setReddot(true)
				self.operateType = 2
			else
				self.fields.Btn_go:setString(i18n("starlight_btn_01"))
				self.fields.Btn_go:setReddot(false)
			end
			self.fields.Btn_go:setEnabled(true)
		end
	end
end
function Activity_9001596_MainPanel:partSelect(target, data)
	self.clickTag = data.part
	self:setPartInfo()
end
function Activity_9001596_MainPanel:setDetailInfo()
	self.fields.Com_info:initData(self.clickTag)
end
function Activity_9001596_MainPanel:btnGunClick()
	SoraDPlaySound()
	self.clickTag = 0
	self:setPartInfo()
end
function Activity_9001596_MainPanel:btnGoClick()
	SoraDPlaySound()
	if self.operateType == 1 then
		_ENV = nil
		;(nil).part = self.clickTag
		uiManager:show("Activity_9001596_gain", nil)
	elseif self.operateType == 2 then
		activity_9001596_Ctrl:sendSalyutMerge(self.clickTag)
		SoraDShowLoading(self)
	end
end
function Activity_9001596_MainPanel:btnGiftClick()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = self.giftArray
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, giftList)
		panel:show()
	end
end
function Activity_9001596_MainPanel:btnWarehouseClick()
	SoraDPlaySound()
	uiManager:show("Activity_9001596_warehouse")
end
function Activity_9001596_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Ramadan_2024_text4")
	uiManager:show("RuleView", nil)
end
return Activity_9001596_MainPanel
