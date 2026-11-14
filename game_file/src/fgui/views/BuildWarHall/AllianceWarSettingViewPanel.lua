local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceWarSettingViewPanel = class("AllianceWarSettingViewPanel", baseFguiPanel)
local allianceWarSettingCtrl = include("allianceWarSettingCtrl")
local warLvToNormalLv = function(warLv)
	if 30 < warLv then
		return (warLv - 30) * 10 + 30
	end
	return warLv
end
local normalLvToWarLv = function(normalLv)
	if 30 < normalLv then
		return math.floor((normalLv - 30) / 10) + 30
	end
	return normalLv
end
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(240, 230, 210)
function AllianceWarSettingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("AllianceWarSettingViewPanel:ctor", self.viewName)
end
function AllianceWarSettingViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceWarSettingViewPanel:onInit()
	print("=======AllianceWarSettingViewPanel:onInit")
	self.view:fixChildrenPos()
	self.isFilerSingle = false
	self.isFilerMass = false
	self.newInputLevel = nil
	self.newInputPower = nil
	self.viewType = self.param and self.param.viewType or 2
	self.maxLv = self.viewType == 1 and 70 or 40
	self.fields.Panel_bg:setTitle(i18n("set_title_01"))
	self.fields.cbSingle:addClickEventListener(handler(self, self.onSingleCallBack))
	self.fields.txtSingle:setString(i18n("commom_text_4296"))
	self.fields.cbMass:addClickEventListener(handler(self, self.onMassCallBack))
	self.fields.txtMass:setString(i18n("common_text_292"))
	self.fields.cbLevel:addClickEventListener(handler(self, self.onLevelCallBack))
	self.fields.txtLevel:setString(i18n("commom_text_4297"))
	self.fields.cbPower:addClickEventListener(handler(self, self.onPowerCallBack))
	self.fields.txtPower:setString(i18n("arena_text_36"))
	SoraDSetTextWidthHeight(self.txtPower, cc.size(140, 60))
	self.fields.cbMoveLine:addClickEventListener(handler(self, self.onMovelineCallBack))
	self.fields.txtMoveLine:setString(i18n("commom_text_4299"))
	SoraDSetTextWidthHeight(self.txtMoveLine, cc.size(380, 60))
	self.fields.txtInputLevel:addEventListener(fgui.UIEventType.Submit, handler(self, self.inputLevelEvent))
	self.fields.txtInputPower:addEventListener(fgui.UIEventType.Submit, handler(self, self.inputPowerEvent))
	self.fields.txtInputLevel:addEventListener(fgui.UIEventType.Began, handler(self, self.OnEditBoxTouch))
	self.fields.txtInputPower:addEventListener(fgui.UIEventType.Began, handler(self, self.OnEditBoxTouch))
	self.fields.btnSetting:addClickEventListener(handler(self, self.btnSettingClick))
	self.fields.btnSetting:setTitle(i18n("common_text_204"))
	self.fields.Text_info:setString(i18n("commom_text_4298"))
end
function AllianceWarSettingViewPanel:onShow()
	print("=======AllianceWarSettingViewPanel:onShow")
	self:initView()
end
function AllianceWarSettingViewPanel:OnEditBoxTouch(eventContext)
	local target = eventContext:getSender()
	print("AllianceWarSettingViewPanel:OnEditBoxTouch")
	if tonumber(target:getText()) == 0 then
		target:setText("")
	end
end
function AllianceWarSettingViewPanel:update()
	if self.newInputLevel then
		self.fields.txtInputLevel:setText(self.newInputLevel)
		self.newInputLevel = nil
	end
	if self.newInputPower then
		self.fields.txtInputPower:setText(self.newInputPower)
		self.newInputPower = nil
	end
end
function AllianceWarSettingViewPanel:setViewType(viewType)
	self.viewType = viewType
	self.maxLv = self.viewType == 1 and 70 or 40
end
function AllianceWarSettingViewPanel:initView()
	local isFilerSingle = allianceWarSettingCtrl:isFilerSingle()
	self.fields.cbSingle:setSelected(isFilerSingle)
	local isFilerMass = allianceWarSettingCtrl:isFilerMass()
	self.fields.cbMass:setSelected(isFilerMass)
	local isFilerLevel = allianceWarSettingCtrl:isFilerLevel()
	self:setLevelEnable(isFilerLevel)
	local isFilerPower = allianceWarSettingCtrl:isFilerPower()
	self:setPowerEnable(isFilerPower)
	local isFilerMoveLine = allianceWarSettingCtrl:isFilerMoveLine()
	self.fields.cbMoveLine:setSelected(isFilerMoveLine)
	if self.viewType ~= 1 then
		local filerLevelNum = allianceWarSettingCtrl:getFilerLevel()
		local warLvNum = normalLvToWarLv(filerLevelNum)
		self.fields.txtInputLevel:setText(tostring(warLvNum))
		self.fields.txtLevel:setString(i18n("commom_text_4297"))
	else
		local filerStarNum = allianceWarSettingCtrl:getFilerStar()
		self.fields.txtInputLevel:setText(tostring(filerStarNum))
		self.fields.txtLevel:setString(i18n("recharge_label_022"))
		local isFilterStar = allianceWarSettingCtrl:isFilerStar()
		self:setLevelEnable(isFilterStar)
	end
	local filerPowerNum = allianceWarSettingCtrl:getFilerPower()
	self.fields.txtInputPower:setText(string.formatnumberthousands(filerPowerNum))
	self.isFilerSingle = isFilerSingle
	self.isFilerMass = isFilerMass
	self:updateView()
end
function AllianceWarSettingViewPanel:updateSetting()
	local _ENV, data
	data.single = self.fields.cbSingle:isSelected()
	data.mass = self.fields.cbMass:isSelected()
	data.level = self.fields.cbLevel:isSelected()
	data.power = self.fields.cbPower:isSelected()
	data.moveline = self.fields.cbMoveLine:isSelected()
	local levelNum = tonumber(self.fields.txtInputLevel:getText()) or 0
	local normalLv = warLvToNormalLv(levelNum)
	data.levelNum = normalLv
	if self.viewType == 1 then
		data.levelNum = 0
		data.star = data.level
		data.level = false
		data.starNum = levelNum
	end
	local powerNum = 0
	local oldInput = self.fields.txtInputPower:getText()
	if oldInput ~= "" then
		local subString = string.gsub(oldInput, "[^%d]+", "")
		powerNum = tonumber(subString) or 0
	end
	data.powerNum = powerNum
	dump(data, "AllianceWarSettingViewPanel:updateSetting")
	allianceWarSettingCtrl:updateSetting(data)
	SoraDShowMsgTip(i18n("common_text_4131"))
	local atype = 0
	if data.single and data.mass then
		atype = 3
	elseif data.single then
		atype = 1
	elseif data.mass then
		atype = 2
	end
	_ENV = i18n("common_text_4131")
	i18n("common_text_4131").position = self.viewType
	i18n("common_text_4131").atype = atype
	i18n("common_text_4131").road = atype ~= 0 and data.moveline and 1 or 2
	i18n("common_text_4131").lvl = atype ~= 0 and data.level and levelNum or 0
	i18n("common_text_4131").totalbp = atype ~= 0 and data.power and powerNum or 0
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_alliance_settingview, i18n("common_text_4131"))
end
function AllianceWarSettingViewPanel:updateView()
	local isEnable = self.isFilerSingle or self.isFilerMass
	self.fields.cbLevel:setTouchEnabled(isEnable)
	self.fields.txtInputLevel:setTouchable(isEnable)
	self.fields.txtInputLevel:setVisible(isEnable)
	self.fields.cbPower:setTouchEnabled(isEnable)
	self.fields.txtInputPower:setTouchable(isEnable)
	self.fields.txtInputPower:setVisible(isEnable)
	self.fields.cbMoveLine:setTouchEnabled(isEnable)
	self.controllers.c1:setSelectedIndex(isEnable and 0 or 1)
end
function AllianceWarSettingViewPanel:setLevelEnable(enable)
	_UPVALUE4_ = nil
	;(nil)[1] = "cbLevel"
	;(nil)[2] = "txtLevel"
	;(nil)[3] = "txtInputLevel"
	local (nil)[4], levelObjects = "inputLevelBg", nil
	self.fields.cbLevel:setSelected(enable)
	self.fields.txtInputLevel:setTouchable(enable)
	self.fields.txtInputLevel:setVisible(enable)
	for i, v in ipairs(levelObjects) do
		self.fields[v]:setColor(enable and display.COLOR_WHITE or colorGray)
	end
	if enable then
		self.fields.txtLevel:setColor(colorNormal)
		self.fields.txtInputLevel:setColor(cc.c3b(65, 35, 15))
	end
end
function AllianceWarSettingViewPanel:setPowerEnable(enable)
	_UPVALUE4_ = nil
	;(nil)[1] = "cbPower"
	;(nil)[2] = "txtPower"
	;(nil)[3] = "txtInputPower"
	local (nil)[4], powerObjects = "inputPowerBg", nil
	self.fields.cbPower:setSelected(enable)
	self.fields.txtInputPower:setTouchable(enable)
	self.fields.txtInputPower:setVisible(enable)
	for i, v in ipairs(powerObjects) do
		self.fields[v]:setColor(enable and display.COLOR_WHITE or colorGray)
	end
	if enable then
		self.fields.txtPower:setColor(colorNormal)
		self.fields.txtInputPower:setColor(cc.c3b(65, 35, 15))
	end
end
function AllianceWarSettingViewPanel:onSingleCallBack(button, event)
	SoraDPlaySound()
	self.isFilerSingle = self.fields.cbSingle:isSelected()
	self:updateView()
end
function AllianceWarSettingViewPanel:onMassCallBack(button, event)
	SoraDPlaySound()
	self.isFilerMass = self.fields.cbMass:isSelected()
	self:updateView()
end
function AllianceWarSettingViewPanel:onLevelCallBack(button, event)
	SoraDPlaySound()
	self:setLevelEnable(self.fields.cbLevel:isSelected())
end
function AllianceWarSettingViewPanel:onPowerCallBack(button, event)
	SoraDPlaySound()
	self:setPowerEnable(self.fields.cbPower:isSelected())
end
function AllianceWarSettingViewPanel:onMovelineCallBack(button, event)
	SoraDPlaySound()
end
function AllianceWarSettingViewPanel:btnSettingClick(button, type)
	self:updateSetting()
	self:close()
end
function AllianceWarSettingViewPanel:inputLevelEvent(event, target)
	local oldInput = self.fields.txtInputLevel:getText()
	if oldInput ~= "" then
		local newInput = math.floor(tonumber(string.match(oldInput, "([%d]+)")) or 0)
		if newInput <= 0 then
			newInput = 0
		elseif newInput > self.maxLv then
			newInput = self.maxLv
		end
		self.newInputLevel = newInput
		self.fields.txtInputLevel:setString(newInput)
	else
		self.newInputLevel = 0
	end
end
function AllianceWarSettingViewPanel:inputPowerEvent(event, target)
	local oldInput = self.fields.txtInputPower:getText()
	print("oldInput , ", oldInput)
	if oldInput ~= "" then
		local subString = string.gsub(oldInput, "[^%d]+", "")
		local newInput = math.floor(tonumber(subString) or 0)
		if newInput <= 0 then
			newInput = 0
		end
		local strInput = string.formatnumberthousands(newInput)
		self.newInputPower = strInput
		self.fields.txtInputPower:setString(strInput)
	else
		self.newInputPower = 0
	end
end
return AllianceWarSettingViewPanel
