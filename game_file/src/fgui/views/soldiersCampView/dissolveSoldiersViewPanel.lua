local armyCtrl = SoraDGetCtrl("armyCtrl")
local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dissolveSoldiersViewPanel = class("dissolveSoldiersViewPanel", baseFguiPanel)
function dissolveSoldiersViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("dissolveSoldiersViewPanel:ctor", self.viewName)
end
function dissolveSoldiersViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function dissolveSoldiersViewPanel:onInit()
	print("=======dissolveSoldiersViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4745"))
	self.fields.Text_tip:setString(i18n("common_text_4744"))
	self.fields.Button_dissolve:setString(i18n("common_text_326"))
	self.fields.Button_dissolve:addClickListener(handler(self, self.btnDissolveClickCallBack))
	self.fields.slider:setInpuBoxFixPos()
end
function dissolveSoldiersViewPanel:onShow()
	print("=======dissolveSoldiersViewPanel:onShow")
	self.armyID = self.param.armyID
	self.trainType = self.param.trainType
	self:initData()
end
function dissolveSoldiersViewPanel:initData()
	self.armyCount = armyCtrl:getArmyCount(self.armyID, ARMY_OPTYPE.NORMAL_ARMY)
	armyCtrl = self.armyID
	self.armyID.maxValue = self.armyCount
	self.armyID.minValue = 1
	self.armyID.curValue = 1
	self.fields.slider:initData(self.armyID)
	if self.trainType == TRAIN_TYPE.TRAP then
		self.fields.Panel_bg:setString(i18n("common_text_4743"))
		self.fields.Text_tip:setString(i18n("common_text_4748"))
		self.fields.Button_dissolve:setString(i18n("common_text_985"))
	end
end
function dissolveSoldiersViewPanel:btnDissolveClickCallBack()
	SoraDPlaySound()
	local msg = self.trainType == TRAIN_TYPE.TRAP and i18n("common_text_986") or i18n("common_text_812")
	local armyID = self.armyID
	local armyCount = self.fields.slider:getSliderCurValue()
	SoraDShowMsgBox(msg, i18n("common_text_204"), nil, function(event)
		if event == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
			armyCtrl:fireArmyReq(armyID, armyCount, ARMY_OPTYPE.NORMAL_ARMY)
			self:close()
		end
	end)
end
return dissolveSoldiersViewPanel
