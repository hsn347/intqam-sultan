local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ReinforcementsMsgBoxPanel = class("ReinforcementsMsgBoxPanel", baseFguiPanel)
function ReinforcementsMsgBoxPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ReinforcementsMsgBoxPanel:ctor", self.viewName)
end
function ReinforcementsMsgBoxPanel:onInit()
	print("=======ReinforcementsMsgBoxPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_554"))
	self.fields.Text_1:setString(i18n("common_text_557"))
	self.fields.Text_des:setString(i18n("common_text_559"))
	self.fields.Button_doIt:setString(i18n("common_text_560"))
	self.fields.Button_doIt:addClickListener(handler(self, self.btnDoItClick))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
end
function ReinforcementsMsgBoxPanel:onShow()
	print("=======ReinforcementsMsgBoxPanel:onShow")
	self.controllers.c1:setSelectedIndex(1)
	self:initData(self.param.cityArmyData)
end
function ReinforcementsMsgBoxPanel:initData(cityArmyData)
	self.toCityArmyData = cityArmyData
	SoraDShowLoading(self:displayObject())
	kingdomMapCtrl:reqArmyHelpNum(self.toCityArmyData.uid, self.toCityArmyData.instanceID)
	lordInfoCtrl:checkBetrayByUidReq(self.toCityArmyData.uid)
end
function ReinforcementsMsgBoxPanel:initView(target, redata)
	SoraDCloseLoading(self:displayObject())
	if redata.err then
		self:removeFromParent()
		return
	end
	self.toCityArmyData.cur = redata.data.curNum
	self.toCityArmyData.max = redata.data.maxNum
	_ENV = redata.data.maxNum
	redata.data.maxNum.x = redata.data.x
	self.toCityArmyData.uPos, redata.data.maxNum.y = redata.data.maxNum, redata.data.y
	self.toCityArmyData.instanceID = redata.data.id
	if self.toCityArmyData.max == 0 then
		local mapObjUtil = include("mapObjUtil")
		if mapObjUtil.isAllowArmyEmpty(self.toCityArmyData.instanceType) then
			self.toCityArmyData.cur = 0
			local buildLogic = include("buildLogic")
			local max = buildLogic.getHallofwarCapacity().total
			self.toCityArmyData.max = max
		end
	end
	if self.toCityArmyData.max <= self.toCityArmyData.cur then
		self.controllers.c1:setSelectedIndex(1)
		if tonumber(self.toCityArmyData.max) == 0 then
			self.fields.Text_noEmbass:setString(i18n("common_text_558"))
		else
			self.fields.Text_noEmbass:setString(i18n("common_text_1463"))
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Text_count:setString(string.formatnumberthousands(self.toCityArmyData.cur) .. "/" .. string.formatnumberthousands(self.toCityArmyData.max))
	end
end
function ReinforcementsMsgBoxPanel:isBetrayBack(target, redata)
	dump(redata, "ReinforcementsMsgBoxPanel:isBetrayBack")
	if redata then
		self.isBetray = redata.result
	end
end
function ReinforcementsMsgBoxPanel:setSelfCallBack(handl)
	self.reinforcementsHandl = handl
end
function ReinforcementsMsgBoxPanel:btnDoItClick()
	SoraDPlaySound()
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	if lordInfoCtrl:getIsTraitor() and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_06"))
		return
	end
	local remainsWarUtil = include("remainsWarUtil")
	if remainsWarUtil.isForbitWarByInBorn() then
		SoraDShowMsgTip(i18n("remains_text_142"))
		return
	end
	if self.isBetray and conquestWarCtrl:isConquestWarOpenningAndNotInWar() then
		SoraDShowMsgTip(i18n("worldwar_text_02"))
		return
	end
	if SoraDEnoughTroops() then
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		local instanceType = self.toCityArmyData.instanceType or gMapObjTypeDef.mapObjTypePlayer
		_ENV = i18n("worldwar_text_02")
		i18n("worldwar_text_02").toPoint = self.toCityArmyData.uPos
		i18n("worldwar_text_02").dispatchType = self.toCityArmyData.dispatchType
		i18n("worldwar_text_02").instanceID = self.toCityArmyData.instanceID
		i18n("worldwar_text_02").instanceType = instanceType
		i18n("worldwar_text_02").maxCount = self.toCityArmyData.max - self.toCityArmyData.cur
		dispatchPanel:initData(i18n("worldwar_text_02"))
	end
	self:closePanel()
end
return ReinforcementsMsgBoxPanel
