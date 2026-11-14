local baseFguiPanel = require("fgui.base.baseFguiPanel")
local legendOfPegasusCtrl = SoraDGetCtrl("legendOfPegasusCtrl")
local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MAX_TASK = constantRead.getConstValue("LEGEND_OF_PEGASUS_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("LEGEND_OF_PEGASUS_SUMMON_ITEM_NUM", 5)
local MAX_SURVEYNUM = constantRead.getConstValue("LEGEND_OF_PEGASUS_MAX_SURVEYED_NUM", 20)
local HP_MIN_SURVEY_NEED = constantRead.getConstValue("LEGEND_OF_PEGASUS_SURVEY_PHYSICAL", 1)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local CD_TIME = 1800
local LegendOfPegasusInvestigationPanel = class("LegendOfPegasusInvestigationPanel", baseFguiPanel)
function LegendOfPegasusInvestigationPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LegendOfPegasusInvestigationPanel:ctor", self.viewName)
end
function LegendOfPegasusInvestigationPanel:getPackageList()
	if not self._packageList then
		_UPVALUE6_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LegendOfPegasus"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[5] = self._packageList, "CommonUI1"
		self._packageList, self._packageList[6] = self._packageList, "fonts"
	end
	return self._packageList
end
function LegendOfPegasusInvestigationPanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	print("=======LegendOfPegasusInvestigationPanel:onInit")
	self.fields.txt_title:setString(i18n("Legends_of_Pegasus_text_05"))
	self.fields.Button_help:addClickEventListener(handler(self, self.onClickHelp))
	self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_24"))
	self.fields.btn_investingation:addClickEventListener(handler(self, self.btnSurveyClick))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return i18n_html("common_text_2669") .. " " .. strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
	_ENV = SoraDConvertSecondToString(leftTime)
	SoraDConvertSecondToString(leftTime).num = legendOfPegasusCtrl:getFinishNum()
	SoraDConvertSecondToString(leftTime).limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", SoraDConvertSecondToString(leftTime)))
	self.fields.txt_desc:setString(i18n("Legends_of_Pegasus_text_02"))
	local curNum = legendOfPegasusCtrl:getSurveyNum()
	local maxNum = MAX_SURVEYNUM
	_ENV = i18n("Legends_of_Pegasus_text_02")
	i18n("Legends_of_Pegasus_text_02").var1 = curNum
	i18n("Legends_of_Pegasus_text_02").var2 = maxNum
	self.fields.txt_limit:setString(i18n("Legends_of_Pegasus_text_03", i18n("Legends_of_Pegasus_text_02")))
end
function LegendOfPegasusInvestigationPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	print("=======LegendOfPegasusInvestigationPanel:onShow")
end
function LegendOfPegasusInvestigationPanel:onHide()
	print("=======LegendOfPegasusInvestigationPanel:onHide")
end
function LegendOfPegasusInvestigationPanel:onDispose()
	print("=======LegendOfPegasusInvestigationPanel:onDispose")
end
function LegendOfPegasusInvestigationPanel:btnSurveyClick()
	SoraDPlaySound()
	local physical = lordInfoCtrl:getBaseInfo().physical
	if legendOfPegasusCtrl:getSurveyNum() < MAX_SURVEYNUM then
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
function LegendOfPegasusInvestigationPanel:initData(instanceID)
	_ENV, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if v.to.objType == gMapObjTypeDef.legendOfPegasusBuild and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.fields.btn_investingation:setBright(false)
			self.fields.btn_investingation:setTouchEnabled(false)
			self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_25"))
		end
	end
end
function LegendOfPegasusInvestigationPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function LegendOfPegasusInvestigationPanel:getTilePoint()
	return self.tilePoint
end
function LegendOfPegasusInvestigationPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Legends_of_Pegasus_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function LegendOfPegasusInvestigationPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return LegendOfPegasusInvestigationPanel
