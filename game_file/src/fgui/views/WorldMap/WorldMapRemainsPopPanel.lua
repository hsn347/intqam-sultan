local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapRemainsPopPanel = class("WorldMapRemainsPopPanel", baseFguiPanel)
function WorldMapRemainsPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapRemainsPopPanel:ctor", self.viewName)
end
function WorldMapRemainsPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WorldMapRemainsPopPanel:onInit()
	print("=======WorldMapRemainsPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_459"))
	self.fields.Text_info:setString(i18n("common_text_461"))
	_UPVALUE4_ = self.fields.Text_info.setString
	_UPVALUE3_, self.tblDisappear, self.fields.Text_info.setString[1] = self.fields.Text_info.setString, self.fields.Text_info.setString, 900
	_UPVALUE3_, self.tblDisappear, self.fields.Text_info.setString[2] = self.fields.Text_info.setString, self.fields.Text_info.setString, 3600
	_UPVALUE3_, self.tblDisappear, self.fields.Text_info.setString[3] = self.fields.Text_info.setString, self.fields.Text_info.setString, 14400
	_UPVALUE3_, self.tblDisappear, self.fields.Text_info.setString[4] = self.fields.Text_info.setString, self.fields.Text_info.setString, 28800
	self.fields.Text_info.setString[1] = i18n("common_text_454")
	self.fields.Text_info.setString[2] = i18n("common_text_456")
	self.fields.Text_info.setString[3] = i18n("common_text_455")
	self.fields.Text_info.setString[4] = i18n("common_text_453")
	self.fields.Text_info.setString[5] = i18n("common_text_453")
	self.fields.Text_info.setString[6] = i18n("common_text_453")
	self.fields.Text_info.setString[7] = i18n("common_text_453")
	self.fields.Text_info.setString[8] = i18n("common_text_453")
	self.fields.Text_info.setString[9] = i18n("common_text_453")
	self.fields.Text_info.setString[10] = i18n("common_text_453")
	local self.fields.Text_info.setString[11], btnText = i18n("common_text_453")
	for i = 1, #btnText do
		local btnNew = self.fields["Button_go" .. i]
		btnNew:setString(btnText[i])
		btnNew:addClickListener(handlerEx(self, self.btnGoClick, i))
		btnNew:fixPos()
	end
	self.fields.Label_time:setTimeLast(function(tickes)
		_ENV = nil
		;(nil).time = tickes
		return i18n("common_text_460", nil)
	end)
	self.fields.Label_time:setTimeUpdateListener(handler(self, self.updateTime))
end
function WorldMapRemainsPopPanel:onShow()
	print("=======WorldMapRemainsPopPanel:onShow")
	self:initView(self.proxy.param)
end
function WorldMapRemainsPopPanel:initView(remainsData)
	self.remainsData = remainsData
	self.fields.Label_time:beginTime(self.remainsData.leftime)
end
function WorldMapRemainsPopPanel:updateTime(time)
	for i, v in ipairs(self.tblDisappear) do
		if time < v then
			self.fields["Button_go" .. i]:setEnabled(false)
		end
	end
end
function WorldMapRemainsPopPanel:btnGoClick(index)
	SoraDPlaySound()
	if SoraDEnoughTroops() then
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		_ENV = nil
		_ENV, (nil).toPoint = self.remainsData.parentArgToPoint, self.remainsData.parentArgToPoint
		;(nil).otherData, self.remainsData.parentArgToPoint.exploreTime = self.remainsData.parentArgToPoint, self.tblDisappear[index]
		;(nil).dispatchType = self.remainsData.parentArgDispatchType
		;(nil).instanceID = self.remainsData.instanceID
		;(nil).instanceType = gMapObjTypeDef.mapObjTypeRelics
		dispatchPanel:initData(nil)
	end
	self:removeFromParent()
end
return WorldMapRemainsPopPanel
