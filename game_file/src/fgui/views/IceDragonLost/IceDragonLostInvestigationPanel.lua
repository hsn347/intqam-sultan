local iceDragonLostCtrl = SoraDGetCtrl("iceDragonLostCtrl")
local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MAX_TASK = constantRead.getConstValue("ICEDRAGON_LOST_MAX_QUEST_NUM", 15)
local MAX_SURVEYNUM = constantRead.getConstValue("ICEDRAGON_LOST_MAX_SURVEYED_NUM", 20)
local HP_MIN_SURVEY_NEED = constantRead.getConstValue("ICEDRAGON_LOST_SURVEY_PHYSICAL", 1)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local CD_TIME = 1800
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonLostInvestigationPanel = class("IceDragonLostInvestigationPanel", baseFguiPanel)
function IceDragonLostInvestigationPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonLostInvestigationPanel:ctor", self.viewName)
end
function IceDragonLostInvestigationPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonLostInvestigationPanel:onInit()
	print("=======IceDragonLostInvestigationPanel:onInit")
	self.fields.Button_help:addClickEventListener(handler(self, self.onClickHelp))
	self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_24"))
	self.fields.btn_investingation:addClickEventListener(handler(self, self.btnSurveyClick))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return i18n_html("common_text_2669") .. " " .. strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.ICE_DRAGON_LOST)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	_ENV = SoraDConvertSecondToString(leftTime)
	SoraDConvertSecondToString(leftTime).num = iceDragonLostCtrl:getFinishNum()
	SoraDConvertSecondToString(leftTime).limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", SoraDConvertSecondToString(leftTime)))
	self.fields.txt_desc:setString(i18n("icedragon_lost_02"))
	self:fixChildrenPos()
end
function IceDragonLostInvestigationPanel:onShow()
	print("=======IceDragonLostInvestigationPanel:onShow")
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
end
function IceDragonLostInvestigationPanel:btnSurveyClick()
	SoraDPlaySound()
	local physical = lordInfoCtrl:getBaseInfo().physical
	if iceDragonLostCtrl:getSurveyNum() < MAX_SURVEYNUM then
		if SoraDEnoughTroops() then
			_ENV = SoraDEnoughTroops()
			_ENV, SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing, worldMapDefine.worldMapTipButtonType_zhanLing
			worldMapDefine.worldMapTipButtonType_zhanLing.x = self.point.x - 1
			SoraDEnoughTroops().toPoint, worldMapDefine.worldMapTipButtonType_zhanLing.y = worldMapDefine.worldMapTipButtonType_zhanLing, self.point.y - 1
			local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
			worldMapFunction.gotoDispatch(armyData, true)
			_ENV = armyData
			armyData.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(armyData)
		end
	elseif physical < HP_MIN_SURVEY_NEED then
		SoraDShowMsgTip(i18n("lost_ruins_text_13"))
	else
		SoraDShowMsgTip(i18n("lost_ruins_text_05"))
	end
end
function IceDragonLostInvestigationPanel:initData(instanceID)
	_ENV, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if v.to.objType == gMapObjTypeDef.iceDragonLostBuild and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.fields.btn_investingation:setBright(false)
			self.fields.btn_investingation:setTouchEnabled(false)
			self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_25"))
		end
	end
end
function IceDragonLostInvestigationPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function IceDragonLostInvestigationPanel:getTilePoint()
	return self.tilePoint
end
function IceDragonLostInvestigationPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("icedragon_lost_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function IceDragonLostInvestigationPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return IceDragonLostInvestigationPanel
