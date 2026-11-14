local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local magicLampRead = include("magicLampRead")
local magicLampHatchRead = include("magicLampHatchRead")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampHatchFirePanel = class("MagicLampHatchFirePanel", baseFguiPanel)
function MagicLampHatchFirePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MagicLampHatchFirePanel:ctor", self.viewName)
end
function MagicLampHatchFirePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampHatchFirePanel:onInit()
	print("=======MagicLampHatchFirePanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("common_text_3534"))
	self.timerLabel = SoraDCreateTimerLabel(self, self.fields.text_tip3)
	self.jinnType = self.param.jinnType
	self.hatchType = self.param.hatchType
	self.hatchCfg = magicLampHatchRead.getHatchCfg(self.hatchType)
	self.desireItems = magicLampHatchRead.getDesireItems(self.hatchType)
	self.fields.tips1:setString(i18n("Jinn_hatch_text_47"))
	self.fields.Button_get:setTitle(i18n("common_text_1146"))
	self.fields.Button_get:addClickEventListener(handler(self, self.onReceiveClick))
	self.fields.btn_add:addClickEventListener(handler(self, self.onChooseClick))
	self.fields.com_item:setClickCallback(handler(self, self.onChooseClick))
	self.fields.button_more:addClickEventListener(handler(self, self.onMoreClick))
	self.fields.desire:setTitle(i18n("Jinn_hatch_text_12"))
end
function MagicLampHatchFirePanel:onShow()
	print("=======MagicLampHatchFirePanel:onShow")
	self:updateView()
	magicLampHatchCtrl:sendReqInitDataMsg()
end
function MagicLampHatchFirePanel:updateView()
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	if self.hatchData == nil then
		return
	end
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv)
	self.desireInfo = self.hatchData.desireInfo
	self.chooseItemID = self.desireInfo.chooseItemID
	self.isCanReceive = self.desireInfo.lastChooseItemID and self.desireInfo.isReceive == 0 and self.desireInfo.lastDesire ~= 0
	if self.isCanReceive then
		self.controllers.c2:setSelectedIndex(1)
		magicLampHatchCtrl = nil
		;(nil).item = publicRead.getName(self.desireInfo.lastChooseItemID)
		self.fields.text_tip1:setString(i18n("Jinn_hatch_text_42", nil))
		magicLampHatchCtrl = self.fields.text_tip1.setString
		self.fields.text_tip1.setString.id = self.desireInfo.lastChooseItemID
		local self.fields.text_tip1.setString.num, curItemData = 0, self.fields.text_tip1.setString
		for i, v in ipairs(self.desireItems) do
			if v.item.id == self.desireInfo.lastChooseItemID then
				curItemData = v.item
				break
			end
		end
		magicLampHatchRead = (for generator)
		self.rewardList, ipairs(self.desireItems)[1] = ipairs(self.desireItems)
		self.fields.com_item:setVisible(true)
		self.fields.btn_add:setVisible(false)
		self.fields.icon_switch:setVisible(false)
		self:setChooseItem(curItemData)
		self.timerLabel:endTime()
		self.timerLabel:setString(i18n("Jinn_hatch_text_45"))
	else
		if self.chooseItemID ~= 0 then
			magicLampHatchCtrl = i18n("Jinn_hatch_text_45")
			i18n("Jinn_hatch_text_45").item = publicRead.getName(self.chooseItemID)
			self.fields.text_tip1:setString(i18n("Jinn_hatch_text_41", i18n("Jinn_hatch_text_45")))
			self.fields.com_item:setVisible(true)
			self.fields.icon_switch:setVisible(true)
			self.fields.btn_add:setVisible(false)
			self:setChooseItem(nil)
		else
			self.fields.text_tip1:setString(i18n("Jinn_hatch_text_8"))
			self.fields.com_item:setVisible(false)
			self.fields.icon_switch:setVisible(false)
			self.fields.btn_add:setVisible(true)
			self.fields.btn_add:setReddot(true)
		end
		self.timerLabel:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n(self.chooseItemID ~= 0 and "Jinn_hatch_text_44" or "Jinn_hatch_text_43", nil)
		end)
		local nextWeekDayUTC = serviceFunctions.getNextWeekDayUTC(1)
		self.timerLabel:beginTime(nextWeekDayUTC - serviceFunctions.systemTime())
		self.controllers.c2:setSelectedIndex(0)
	end
	self.fields.Button_get:setGrayed(not self.isCanReceive)
	self.fields.progress:setMax(self.desireCfg.desire)
	self.fields.progress:setValue(self.desireInfo.desire)
	local txtColor = self.desireInfo.desire >= self.desireCfg.desire and cc.c3b(0, 255, 0) or cc.c3b(255, 255, 255)
	fguiHelper.get_fields(self.fields.progress).title:setColor(txtColor)
end
function MagicLampHatchFirePanel:setChooseItem(data)
	if data == nil then
		for i, v in ipairs(self.desireItems) do
			if v.item.id == self.chooseItemID then
				data = v.item
				break
			end
		end
	end
	if data == nil then
		return
	end
	local realNum = magicLampHatchCtrl:getRealItemNum(self.hatchData.desireInfo.desire, data.num)
	self.fields.com_item:initData(data.id, realNum)
end
function MagicLampHatchFirePanel:onReceiveClick()
	SoraDPlaySound()
	if self.isCanReceive then
		magicLampHatchCtrl:reqMagicLampHatchDesireReward(self.hatchType)
		return
	end
	if not self.chooseItemID then
		SoraDShowMsgTip(i18n("Jinn_hatch_text_14"))
		return
	end
	SoraDShowMsgTip(i18n("Jinn_hatch_text_15"))
end
function MagicLampHatchFirePanel:onChooseClick()
	if self.isCanReceive then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	uiManager:show("MagicLampHatchChoose", nil)
end
function MagicLampHatchFirePanel:onMoreClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	uiManager:show("MagicLampHatchGet", nil)
end
return MagicLampHatchFirePanel
