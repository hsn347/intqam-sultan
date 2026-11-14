local constantRead = include("constantRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lostRuinsCtrl = SoraDGetCtrl("lostRuinsCtrl")
local worldMapLostRuinsSurveyView = class("worldMapLostRuinsSurveyView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("worldMapLostRuinsSurveyView")
end)
local MAX_TASK = constantRead.getConstValue("LOST_RUINS_MAX_QUEST_NUM", 15)
local MAX_SURVEYNUM = constantRead.getConstValue("LOST_RUINS_MAX_SURVEYED_NUM", 20)
local HP_MIN_SURVEY_NEED = constantRead.getConstValue("LOST_RUINS_MIN_SURVEYED_HP", 1)
local CD_TIME = 1800
function worldMapLostRuinsSurveyView:ctor(properties)
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTitle:setString(i18n("lost_ruins_text_11"))
	self.btnSurvey = SoraDGetChildByName(self, "Button_Survey")
	self.btnSurvey:setTitleText(i18n("lost_ruins_text_24"))
	self.btnSurvey:addTouchEventListener(handler(self, self.btnSurveyClick))
	self.textDescribe = SoraDGetChildByName(self, "Text_Describe")
	self.textDescribe:setString(i18n("lost_ruins_text_12"))
	self.textLeftTask = SoraDGetChildByName(self, "Text_LeftTask")
	local loop = true
	local cssFileName = "worldMapLostRuinsSurveyView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function worldMapLostRuinsSurveyView:initData(instanceID)
	_ENV = nil
	;(nil).num = lostRuinsCtrl:getFinishNum()
	;(nil).limitNum = MAX_TASK
	self.textLeftTask:setString(i18n("lost_ruins_text_38", nil))
	_ENV = self.textLeftTask.setString
	self.textLeftTask.setString.x = self.tilePoint.x + 1
	self.point, self.textLeftTask.setString.y = self.textLeftTask.setString, self.tilePoint.y + 1
	self.instanceID = instanceID
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local queues = kingdomMapCtrl:getMapEventList()
	for _, v in ipairs(queues) do
		if v.to.objType == gMapObjTypeDef.mapTypeLostRuins and v.to.x == self.point.x - 1 and v.to.y == self.point.y - 1 then
			self.btnSurvey:setBright(false)
			self.btnSurvey:setTouchEnabled(false)
			self.btnSurvey:setTitleText(i18n("lost_ruins_text_25"))
		end
	end
end
function worldMapLostRuinsSurveyView:btnSurveyClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local physical = lordInfoCtrl:getBaseInfo().physical
		if lostRuinsCtrl:getSurveyNum() < MAX_SURVEYNUM then
			if SoraDEnoughTroops() then
				_ENV = SoraDEnoughTroops()
				_ENV, SoraDEnoughTroops().dispatchType = worldMapDefine.worldMapTipButtonType_zhanLing, worldMapDefine.worldMapTipButtonType_zhanLing
				worldMapDefine.worldMapTipButtonType_zhanLing.x = self.point.x - 1
				SoraDEnoughTroops().toPoint, worldMapDefine.worldMapTipButtonType_zhanLing.y = worldMapDefine.worldMapTipButtonType_zhanLing, self.point.y - 1
				local SoraDEnoughTroops().instanceID, armyData = self.instanceID, SoraDEnoughTroops()
				worldMapFunction.gotoDispatch(armyData, true)
				self:close(self, eventType)
			end
		elseif physical < HP_MIN_SURVEY_NEED then
			SoraDShowMsgTip(i18n("lost_ruins_text_13"))
		else
			SoraDShowMsgTip(i18n("lost_ruins_text_05"))
		end
	end
end
function worldMapLostRuinsSurveyView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapLostRuinsSurveyView:getTilePoint()
	return self.tilePoint
end
function worldMapLostRuinsSurveyView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
return worldMapLostRuinsSurveyView
