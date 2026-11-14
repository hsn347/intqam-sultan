local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local MAX_TASK = constantRead.getConstValue("FIREDRAGON_OF_ANGER_MAX_QUEST_NUM", 15)
local MAX_SURVEYNUM = constantRead.getConstValue("FIREDRAGON_OF_ANGER_MAX_SURVEYED_NUM", 20)
local HP_MIN_SURVEY_NEED = constantRead.getConstValue("FIREDRAGON_OF_ANGER_SURVEY_PHYSICAL", 1)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local CD_TIME = 1800
_ENV = nil
;(nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = activity_9001602_Ctrl
local (nil)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], activityCtrl = activity_9001696_Ctrl, nil
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001602_InvestigationPanel = class("Activity_9001602_InvestigationPanel", baseFguiPanel)
function Activity_9001602_InvestigationPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001602_InvestigationPanel:ctor", self.viewName)
end
function Activity_9001602_InvestigationPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001602_InvestigationPanel:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	print("=======Activity_9001602_InvestigationPanel:onInit")
	self.fields.txt_title:setString(i18n("firedragon_of_anger_text5"))
	self.fields.Button_help:addClickEventListener(handler(self, self.onClickHelp))
	self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_24"))
	self.fields.btn_investingation:addClickEventListener(handler(self, self.btnSurveyClick))
	self.fields.Usm_1:setPrivewImage("#activity_9001602_02_first.png", cc.size(852, 1136), true, true)
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.txt_time:setTimeLast(function(strTime)
		return i18n_html("common_text_2669") .. " " .. strTime
	end)
	local timer = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NORMAL_ACTIVITY_9001602)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	end
end
function Activity_9001602_InvestigationPanel:onShow()
	local prama = self.proxy.param
	if prama then
		self.activityID = prama.activityID
		self:setTilePoint(prama.titlePoint)
		self:initData(prama.instanceID)
	end
	_ENV = nil
	;(nil).num = activityCtrl[self.activityID]:getFinishNum()
	;(nil).limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", nil))
	self.fields.txt_desc:setString(i18n("firedragon_of_anger_text2"))
	local curNum = activityCtrl[self.activityID]:getSurveyNum()
	local maxNum = MAX_SURVEYNUM
	_ENV = i18n("firedragon_of_anger_text2")
	i18n("firedragon_of_anger_text2").num1 = curNum
	i18n("firedragon_of_anger_text2").num2 = maxNum
	self.fields.txt_limit:setString(i18n("firedragon_of_anger_text3", i18n("firedragon_of_anger_text2")))
	print("=======Activity_9001602_InvestigationPanel:onShow")
end
function Activity_9001602_InvestigationPanel:onHide()
	print("=======Activity_9001602_InvestigationPanel:onHide")
end
function Activity_9001602_InvestigationPanel:onDispose()
	print("=======Activity_9001602_InvestigationPanel:onDispose")
end
function Activity_9001602_InvestigationPanel:btnSurveyClick()
	SoraDPlaySound()
	local physical = lordInfoCtrl:getBaseInfo().physical
	if activityCtrl[self.activityID]:getSurveyNum() < MAX_SURVEYNUM then
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
function Activity_9001602_InvestigationPanel:initData(instanceID)
	_ENV, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if (v.to.objType == gMapObjTypeDef.firedragonOfAngerBuild or v.to.objType == gMapObjTypeDef.firedragonOfAnger2025Build) and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.fields.btn_investingation:setBright(false)
			self.fields.btn_investingation:setTouchEnabled(false)
			self.fields.btn_investingation:setTitle(i18n("lost_ruins_text_25"))
		end
	end
end
function Activity_9001602_InvestigationPanel:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function Activity_9001602_InvestigationPanel:getTilePoint()
	return self.tilePoint
end
function Activity_9001602_InvestigationPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("firedragon_of_anger_text1")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Activity_9001602_InvestigationPanel:close()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return Activity_9001602_InvestigationPanel
