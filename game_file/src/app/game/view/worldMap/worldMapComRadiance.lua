local gametop = gModuleMgr.getObject("gametop")
local radianceWarCtrl = gametop.playertop_:getModule("radianceWarCtrl")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local constantRead = include("constantRead")
local worldMapComRadiance = class("worldMapComRadiance", include("worldMapCom"))
function worldMapComRadiance:ctor()
	worldMapComRadiance.super.ctor(self, "worldMapComRadiance")
end
function worldMapComRadiance:init()
	self:createMapTip()
	self.nodeRemainsWar = SoraDGetChildByName(self.target_, "Node_war")
	self.nodeRemainsWar:setPositionY(display.iPhoneXBottom + 10)
	local btnIntegral = SoraDGetChildByName(self.nodeRemainsWar, "Button_integral")
	btnIntegral:addTouchEventListener(handler(self, self.btnIntegralCall))
	local btnSituation = SoraDGetChildByName(self.nodeRemainsWar, "Button_situation")
	btnSituation:addTouchEventListener(handler(self, self.btnSituationCickCallBack))
	self.situationRedIcon = SoraDGetChildByName(btnSituation, "red_Icon")
	local btnTask = btnSituation:clone()
	btnTask:setName("btnTask")
	btnTask:addTo(self.nodeRemainsWar)
	btnTask:addTouchEventListener(handler(self, self.btnTaskCickCallBack))
	btnTask:setPositionY(405)
	btnTask:getChild("btn_worldmap_shop_1"):setURL("bg_wwzdz_record.png")
	self.taskRedIcon = SoraDGetChildByName(btnTask, "red_Icon")
	self.btnNotice = btnSituation:clone()
	self.btnNotice:setName("btnNotice")
	self.btnNotice:addTo(self.nodeRemainsWar)
	self.btnNotice:addTouchEventListener(handler(self, self.btnNoticeCickCallBack))
	self.btnNotice:setPositionY(485)
	self.btnNotice:getChild("btn_worldmap_shop_1"):setURL("icon_map_operate_07.png")
	self.noticeRedIcon = SoraDGetChildByName(self.btnNotice, "red_Icon")
	local showTime = constantRead.getConstValue("BRIGHT_WAR_EXPLAIN_SHOW")
	self.btnNotice:setVisible(showTime > serviceFunctions.systemTime())
	_ENV = showTime > serviceFunctions.systemTime()
	;(showTime > serviceFunctions.systemTime()).byUID = true
	local isShowRed = SoraDConfigGet("Game:radianceWar:changeNoticeRed~bool", showTime > serviceFunctions.systemTime()) or false
	self.noticeRedIcon:setVisible(not isShowRed)
	local buttonHospital = SoraDGetChildByName(self.target_, "Button_hospital")
	buttonHospital:setPositionY(self.btnNotice:isVisible() and 565 or 485)
	self:fitNodeBottom()
end
function worldMapComRadiance:fitNodeBottom()
	local fitHeight = 1136
	if fitHeight <= display.height then
		return
	end
	local fitWidth = fitHeight / display.height * 640
	local fitScale = 640 / fitWidth
	self.nodeRemainsWar:setScale(fitScale)
end
function worldMapComRadiance:createMapTip()
	local Z_ORDER = worldMapDefine.Z_ORDER
	local height = display.height + display.iPhoneXBottom
	local pyramidTip = include("worldMapPyramidTip").new()
	pyramidTip:setPosition(cc.p(display.cx, height - 270))
	pyramidTip:addTo(self.target_, Z_ORDER.topTipView)
end
function worldMapComRadiance:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_HAS_UNREAD_WAR_LOG", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateBtnTaskRedPoint))
end
function worldMapComRadiance:onEnter()
	self:updateRedPoint()
	self:updateBtnTaskRedPoint()
end
function worldMapComRadiance:updateRedPoint()
	local hasUnReadResWarLog = radianceWarCtrl:isHasUnReadResWarLog()
	if self.situationRedIcon and not tolua.isnull(self.situationRedIcon) then
		self.situationRedIcon:setVisible(hasUnReadResWarLog)
	end
end
function worldMapComRadiance:updateBtnTaskRedPoint(...)
	local isRed = false
	if radianceActivityCtrl:getTaskReceiveStatusAndNum(1) then
		isRed = true
	elseif radianceActivityCtrl:getTaskReceiveStatusAndNum(2) then
		isRed = true
	end
	self.taskRedIcon:setVisible(isRed)
end
function worldMapComRadiance:onExit()
	worldMapComRadiance.super.onExit(self)
end
function worldMapComRadiance:doReqestData()
end
function worldMapComRadiance:btnIntegralCall(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarIntegralView"):show()
	end
end
function worldMapComRadiance:btnSituationCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarSituationView"):show()
	end
end
function worldMapComRadiance:btnTaskCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("radianceWarTaskMainView"):show()
	end
end
function worldMapComRadiance:btnNoticeCickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		uiManager:show("radianceWarChangeNotice")
		self.noticeRedIcon:setVisible(false)
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:radianceWar:changeNoticeRed~bool", true, nil)
	end
end
return worldMapComRadiance
