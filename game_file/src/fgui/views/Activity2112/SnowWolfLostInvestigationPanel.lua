local baseFguiPanel = require("fgui.base.baseFguiPanel")
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MAX_TASK = constantRead.getConstValue("SNOWWOLF_LOST_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("SNOWWOLF_LOST_SUMMON_ITEM_NUM", 5)
local MAX_SURVEYNUM = constantRead.getConstValue("SNOWWOLF_LOST_MAX_SURVEYED_NUM", 20)
local HP_MIN_SURVEY_NEED = constantRead.getConstValue("SNOWWOLF_LOST_SURVEY_PHYSICAL", 1)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local CD_TIME = 1800
local SnowWolfLostInvestigationPanel = class("SnowWolfLostInvestigationPanel", baseFguiPanel)
function SnowWolfLostInvestigationPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("SnowWolfLostInvestigationPanel:ctor", self.viewName)
end
function SnowWolfLostInvestigationPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function SnowWolfLostInvestigationPanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	print("=======SnowWolfLostInvestigationPanel:onInit")
	self.fields.Button_help:addClickEventListener(handler(self, self.onClickHelp))
	self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_24"))
	self.fields.btn_investingation:addClickEventListener(handler(self, self.btnSurveyClick))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return i18n_html("common_text_2669") .. " " .. strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	_ENV = SoraDConvertSecondToString(leftTime)
	SoraDConvertSecondToString(leftTime).num = snowWolfLostCtrl:getFinishNum()
	SoraDConvertSecondToString(leftTime).limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", SoraDConvertSecondToString(leftTime)))
	self.fields.txt_desc:setString(i18n("snowWolfLost_002"))
end
function SnowWolfLostInvestigationPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	print("=======SnowWolfLostInvestigationPanel:onShow")
end
function SnowWolfLostInvestigationPanel:onHide()
	print("=======SnowWolfLostInvestigationPanel:onHide")
end
function SnowWolfLostInvestigationPanel:onDispose()
	print("=======SnowWolfLostInvestigationPanel:onDispose")
end
function SnowWolfLostInvestigationPanel:btnSurveyClick()
	SoraDPlaySound()
	local physical = lordInfoCtrl:getBaseInfo().physical
	if snowWolfLostCtrl:getSurveyNum() < MAX_SURVEYNUM then
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
function SnowWolfLostInvestigationPanel:initData(instanceID)
	_ENV, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if v.to.objType == gMapObjTypeDef.mapTypeSnowWolfLost and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.fields.btn_investingation:setBright(false)
			self.fields.btn_investingation:setTouchEnabled(false)
			self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_25"))
		end
	end
end
function SnowWolfLostInvestigationPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function SnowWolfLostInvestigationPanel:getTilePoint()
	return self.tilePoint
end
function SnowWolfLostInvestigationPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("snowWolfLost_001")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function SnowWolfLostInvestigationPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return SnowWolfLostInvestigationPanel
