local publicRead = include("publicRead")
local starTreasureHuntRead = include("starTreasureHuntRead")
local starTreasureHuntCtrl = SoraDGetCtrl("starTreasureHuntCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local starsTreasureHuntView = class("starsTreasureHuntView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)
_ENV, _ENV = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, "starsTreasureHuntView"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = -210
_ENV, ("starsTreasureHuntView")[1], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -315
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = -100
_ENV, ("starsTreasureHuntView")[2], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -168
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = -235
_ENV, ("starsTreasureHuntView")[3], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -50
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = -80
_ENV, ("starsTreasureHuntView")[4], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, 0
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 120
_ENV, ("starsTreasureHuntView")[5], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, 45
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 60
_ENV, ("starsTreasureHuntView")[6], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, 150
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 230
_ENV, ("starsTreasureHuntView")[7], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, 45
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 210
_ENV, ("starsTreasureHuntView")[8], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -85
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 115
_ENV, ("starsTreasureHuntView")[9], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -95
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 205
_ENV, ("starsTreasureHuntView")[10], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -340
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).x = 70
_ENV, _ENV, ("starsTreasureHuntView")[11], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end).y = nil, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end, -230
local effectPosList = "starsTreasureHuntView"
;(nil).scaleFrom = 1.5
;(nil).scaleTo = 0.9
;(nil).rotation = 6
;(nil).beginPos = cc.p(-225, -400)
;(nil).toPos = cc.p(350, -70)
;(nil).remainsTime = 10
_ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)[1], (nil).delayTime = nil, nil, 1
;(nil).scaleFrom = 1.5
;(nil).scaleTo = 0.9
;(nil).rotation = -93
;(nil).beginPos = cc.p(360, -15)
;(nil).toPos = cc.p(-360, 290)
;(nil).remainsTime = 11
_ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)[2], (nil).delayTime = nil, nil, 2.5
;(nil).scaleFrom = 1.2
;(nil).scaleTo = 0.9
;(nil).rotation = 37
;(nil).beginPos = cc.p(-340, 290)
;(nil).toPos = cc.p(340, 435)
;(nil).remainsTime = 11
_ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)[3], (nil).delayTime = nil, nil, 2.5
;(nil).scaleFrom = 1
;(nil).scaleTo = 1.2
;(nil).rotation = -158
;(nil).beginPos = cc.p(350, 410)
;(nil).toPos = cc.p(-350, 150)
;(nil).remainsTime = 11
_ENV, (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)[4], (nil).delayTime = nil, nil, 2.5
;(nil).scaleFrom = 1.5
;(nil).scaleTo = 1.2
;(nil).rotation = 42
;(nil).beginPos = cc.p(-350, -30)
;(nil).toPos = cc.p(350, 30)
;(nil).remainsTime = 11
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end)[5], (nil).delayTime = nil, 2.5
local function eagleConfig(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("starsTreasureHuntView")
end
function starsTreasureHuntView:ctor(properties)
	self.rewardNodeList, _ENV, self.animationIndex = nil, nil, 1
	self.itemID = 728901
	self.activityID = gActivityTimeActivityID.STAR_MOON_TREASURE_ACTIVITY
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001341"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.btnReward = SoraDGetChildByName(self, "Button_Reward")
	self.btnReward:addTouchEventListener(handler(self, self.btnRewardClick))
	self.textReward = SoraDGetChildByName(self, "Text_Reward")
	self.textReward:setString(i18n("starMaze_text_02"))
	self.nodeAuto = SoraDGetChildByName(self, "Node_Auto_Center")
	self.btnBag = SoraDGetChildByName(self.nodeAuto, "Button_bag")
	self.btnBag:addTouchEventListener(handler(self, self.btnBagClick))
	self.textNum = SoraDGetChildByName(self.nodeAuto, "Text_Num")
	self.textNum = SoraDChangeTextToHtml(self.textNum)
	self.btnOpen = SoraDGetChildByName(self, "Btn_Open")
	self.btnOpen:addTouchEventListener(handler(self, self.btnOpenClick))
	self.btnOpen:setTitleText(i18n("common_text_060"))
	self.btnOpen:getTitleRenderer():setPositionY(50)
	self.nodeNum = SoraDGetChildByName(self.btnOpen, "Node_AutoCenter")
	self.textInfo = SoraDGetChildByName(self.btnOpen, "Text_Info")
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("starMaze_text_06"))
	self.eagleNode = SoraDGetChildByName(self, "xyxb_fx_01")
	if self:getPanelOffsetHeight() < 960 then
		local centerImage = SoraDGetChildByName(self, "Center_Image")
		centerImage:setPositionY(centerImage:getPositionY() - (960 - self:getPanelOffsetHeight()) / 2)
		self.centerNode:setPositionY(self.centerNode:getPositionY() - (960 - self:getPanelOffsetHeight()) / 2)
		SoraDGetChildByName(self, "Node_Eagle"):setPositionY(-(960 - self:getPanelOffsetHeight()))
	end
	self:initEffect()
	starTreasureHuntCtrl:reqStarMoonTreasureInit()
end
function starsTreasureHuntView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_STARSTREASUREHUNT_REFRESH", handler(self, self.updateItemNum))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNum))
end
function starsTreasureHuntView:initEffect()
	self.effectNode = SoraDGetChildByName(self, "Effect_Node")
	local effectNode = SoraDCreatAnimationEx("starsTreasureEffect", nil, false)
	self.effectNode.action = effectNode.action
	self.effectNode:addChild(effectNode)
	self.effectNode:setVisible(false)
	self.treasureEffect = SoraDGetChildByName(self.effectNode, "Node_Effect_xyxb03_003")
	local effectBg = SoraDCreatAnimationEx("starsTreasureEffectBg", nil, true)
	SoraDGetChildByName(self, "EffectBg"):addChild(effectBg)
	self.wayList = SoraDGetChildsArrayByName(self.effectNode, "dh_Tex_XL_xyxb", 12, 1)
	SoraDMixtureGLONEByParent(self.effectNode)
	SoraDMixtureGLONE(self.wayList[1])
	self.finalTreasureEffect = SoraDGetChildByName(self.effectNode, "Node_Effect_xyxb01_004")
	local loop = false
	local cssFileName = "starsTreasureHuntView"
	local cssFilePath = getCCSPath(cssFileName)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
	local frames_1 = display.newFrames("dh_Tex_XL_xyxb15_0%.2d.png", 0, 14)
	local animation_1 = display.newAnimation(frames_1, 0.13333333333333333)
	SoraDGetChildByName(self, "G_dh_Tex_XL_xyxb15"):playAnimationForever(animation_1)
	local frames_2 = display.newFrames("dh_Tex_XL_xyxb16_0%.2d.png", 0, 14)
	local animation_2 = display.newAnimation(frames_2, 0.13333333333333333)
	SoraDGetChildByName(self, "G_dh_Tex_XL_xyxb16"):playAnimationForever(animation_2)
	local animation_3 = display.newAnimation(display.newFrames("xyxb_dj_%.2d.png", 1, 24), 0.13333333333333333)
	SoraDGetChildByName(self, "xyxb_dj_01_177"):playAnimationForever(animation_3)
	local frameYun = SoraDGetChildByName(self, "Top_frame_xyxb_xiayun")
	_ENV = nil
	;(nil)[1] = cca.moveTo(1.1666666666666667, 320, 80 + frameYun:getPositionY())
	;(nil)[2] = cca.moveTo(1.1666666666666667, 320, 80 + frameYun:getPositionY())
	;(nil)[3] = cca.moveTo(1.1666666666666667, 320, 80 + frameYun:getPositionY())
	;(nil)[4] = cca.moveTo(1.1666666666666667, 320, 80 + frameYun:getPositionY())
	;(nil)[5] = cca.moveTo(1.1666666666666667, 320, 80 + frameYun:getPositionY())
	frameYun:runAction(cca.seq(nil))
	self:runEagle(eagleConfig[1])
	self.index = 2
	eagleConfig = cca.seq(nil)
	cca.seq(nil)[1] = cca.delay(32)
	cca.seq(nil)[2] = cca.callFunc(function()
		self:runEagle(eagleConfig[self.index])
		self.index = self.index + 1
		if self.index > 5 then
			self.index = 2
		end
	end)
	cca.seq(nil)[3] = cca.callFunc(function()
		self:runEagle(eagleConfig[self.index])
		self.index = self.index + 1
		if self.index > 5 then
			self.index = 2
		end
	end)
	cca.seq(nil)[4] = cca.callFunc(function()
		self:runEagle(eagleConfig[self.index])
		self.index = self.index + 1
		if self.index > 5 then
			self.index = 2
		end
	end)
	self:runAction(cca.repeatForever(cca.seq(cca.seq(nil))))
end
function starsTreasureHuntView:runEagle(config)
	self.eagleNode:stopAllActions()
	self.eagleNode:setScale(config.scaleFrom)
	self.eagleNode:setRotation(config.rotation)
	self.eagleNode:setPosition(config.beginPos)
	_ENV = nil
	_UPVALUE2_ = nil
	_UPVALUE1_ = config.toPos.x
	config.toPos.x[1] = cca.delay(config.delayTime)
	config.toPos.x[2] = cca.callFunc(function()
		local animation_4 = display.newAnimation(display.newFrames("xyxb_fx_%.2d.png", 1, 29), 0.1)
		self.eagleNode:playAnimationOnce(animation_4)
	end)
	config.toPos.x[3] = cca.callFunc(function()
		local animation_4 = display.newAnimation(display.newFrames("xyxb_fx_%.2d.png", 1, 29), 0.1)
		self.eagleNode:playAnimationOnce(animation_4)
	end)
	;(nil)[1] = cca.scaleTo(config.remainsTime, config.scaleTo)
	;(nil)[2] = cca.moveTo(config.remainsTime, config.toPos.x, config.toPos.y)
	;(nil)[3] = cca.seq(config.toPos.x)
	;(nil)[4] = cca.seq(config.toPos.x)
	;(nil)[5] = cca.seq(config.toPos.x)
	;(nil)[6] = cca.seq(config.toPos.x)
	;(nil)[7] = cca.seq(config.toPos.x)
	;(nil)[1] = cca.spawn(nil)
	;(nil)[2] = cca.spawn(nil)
	;(nil)[3] = cca.spawn(nil)
	;(nil)[4] = cca.spawn(nil)
	;(nil)[5] = cca.spawn(nil)
	;(nil)[6] = cca.spawn(nil)
	;(nil)[7] = cca.spawn(nil)
	;(nil)[8] = cca.spawn(nil)
	;(nil)[9] = cca.spawn(nil)
	self.eagleNode:runAction(cca.seq(nil))
end
function starsTreasureHuntView:updateItemNum(target, data)
	if data and data.reward then
		self.rewardGet = data.reward
		SoraDCloseLoading(self)
		self:runAnimation(starTreasureHuntRead.getPosByReward(data.reward))
	end
	if data.subMsg and data.subMsg == "init" then
		self:initData()
	end
	if not starTreasureHuntCtrl:canSearch() then
		self.btnOpen:setBright(true)
		self.btnOpen:setTitleText(i18n("starMaze_text_07"))
		self.btnOpen:getTitleRenderer():setPositionY(40)
		self.nodeNum:setVisible(false)
	end
	local costInfo = starTreasureHuntRead.getCostByRound(starTreasureHuntCtrl:getNowRound())
	self.itemID = costInfo[1]
	self.needCost = costInfo[2]
	self.itemNum = backpackCtrl:getItemCount(self.itemID) or 0
	self.textInfo:setString(string.formatnumberthousands(self.needCost))
	_ENV = string.formatnumberthousands(self.needCost)
	_ENV, _ENV, string.formatnumberthousands(self.needCost).num = self.itemNum, string.formatnumberthousands(self.itemNum), string.formatnumberthousands(self.itemNum)
	_ENV, string.formatnumberthousands(self.itemNum).num, self.itemNum.color = self.itemNum, self.itemNum, "#FFFF00"
	string.formatnumberthousands(self.itemNum).__default, self.itemNum.color = self.itemNum, "#FFFFFF"
	self.textNum:setString(i18n_html("common_text_063", string.formatnumberthousands(self.needCost)))
	SoraDGetChildByName(self.nodeNum, "Image_Icon"):loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	SoraDGetChildByName(self.nodeAuto, "image_IconBox"):loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	SoraDToCenter(self.nodeAuto, 10, not SoraDFIsRA())
	SoraDToCenter(self.nodeNum, 10, not SoraDFIsRA())
end
function starsTreasureHuntView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function starsTreasureHuntView:initRewardNode()
	_ENV, _ENV = nil, nil
	;(nil).x = -210
	_ENV, (nil)[1], (nil).y = nil, nil, -315
	;(nil).x = -100
	_ENV, (nil)[2], (nil).y = nil, nil, -155
	;(nil).x = -235
	_ENV, (nil)[3], (nil).y = nil, nil, -40
	;(nil).x = -90
	_ENV, (nil)[4], (nil).y = nil, nil, 5
	;(nil).x = 130
	_ENV, (nil)[5], (nil).y = nil, nil, 65
	;(nil).x = 65
	_ENV, (nil)[6], (nil).y = nil, nil, 180
	;(nil).x = 240
	_ENV, (nil)[7], (nil).y = nil, nil, 75
	;(nil).x = 215
	_ENV, (nil)[8], (nil).y = nil, nil, -65
	;(nil).x = 120
	_ENV, (nil)[9], (nil).y = nil, nil, -80
	;(nil).x = 215
	_ENV, (nil)[10], (nil).y = nil, nil, -335
	;(nil).x = 70
	_ENV, (nil)[11], (nil).y = nil, nil, -215
	;(nil).x = -50
	;(nil)[12], (nil).y = nil, 235
	local posList
	for i, v in ipairs(starTreasureHuntRead.getAwardByValue()) do
		local single = include("starsTreasureSingle").new()
		single:addTo(self.centerNode)
		single:setPosition(posList[v.position])
		single:initData(self, v)
		starTreasureHuntRead = v
		v[1] = cca.delay(math.random(25, 45) / 60)
		v[2] = cca.callFunc(function()
			single:runAnimationAppear()
		end)
		v[3] = cca.callFunc(function()
			single:runAnimationAppear()
		end)
		v[4] = cca.callFunc(function()
			single:runAnimationAppear()
		end)
		single:runAction(cca.seq(v))
		if v.position == 12 or starTreasureHuntCtrl:itemIsLock(v.itemid) then
			single:setVisible(true)
		else
			single:setVisible(false)
		end
		self.rewardNodeList[v.position] = single
	end
end
function starsTreasureHuntView:initData(target, data)
	self:initActivityTime()
	self:initRewardNode()
end
function starsTreasureHuntView:runAnimation(position)
	self.isInAction = true
	for i, v in ipairs(self.wayList) do
		v:setVisible(i == position)
	end
	self.finalTreasureEffect:setVisible(position == 12)
	self.treasureEffect:setVisible(position ~= 12)
	local delayTime = 0
	if effectPosList[position] then
		delayTime = 1
		self.treasureEffect:setPosition(effectPosList[position])
		SoraDGetChildByName(self.treasureEffect, "et_Par_xyxb_001"):resetSystem()
	else
		delayTime = 1
	end
	self.effectNode:setVisible(true)
	self.effectNode.action:gotoFrameAndPlay(0, false)
	_UPVALUE3_ = false
	;(false)[1] = cca.delay(1)
	;(false)[2] = cca.callFunc(function()
		self.rewardNodeList[position]:setVisible(true)
		self.rewardNodeList[position]:updateSingleStatus()
		self:playAwardItem_imp(position, self.rewardGet)
	end)
	;(false)[3] = cca.delay(delayTime)
	;(false)[4] = cca.callFunc(function()
		self.isInAction = false
		self.effectNode:setVisible(false)
	end)
	;(false)[5] = cca.callFunc(function()
		self.isInAction = false
		self.effectNode:setVisible(false)
	end)
	self:runAction(cca.seq(false))
end
function starsTreasureHuntView:playAwardItem_imp(position, data)
	local targetItem = self.rewardNodeList[position]
	if targetItem and data.id then
		local showItem
		showItem = include("commonItemAward").new()
		showItem:initData(data.id, data.count)
		showItem:setScale(0.8)
		showItem:setTouchEnabled(false)
		local pos = cc.p(targetItem:getPositionX(), targetItem:getPositionY() + 64)
		showItem:setPosition(pos.x, pos.y)
		showItem:addTo(self.centerNode, 2)
		_UPVALUE7_ = showItem.addTo
		showItem.addTo[1] = cca.delay(0.2)
		showItem.addTo[2] = cca.callFunc(function()
			if showItem.showEffect then
			end
		end)
		showItem.addTo[3] = cc.EaseExponentialOut:create(cca.moveTo(0.5, 0, 150))
		showItem.addTo[4] = cca.delay(1)
		showItem.addTo[5] = cc.EaseExponentialIn:create(cca.moveTo(0.5, 0, -1000))
		showItem.addTo[6] = cc.EaseExponentialIn:create(cca.scaleTo(0.5, 0.25))
		showItem.addTo[7] = cca.delay(0.25)
		showItem.addTo[8] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		showItem.addTo[9] = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		local showItem.addTo[10], action = cca.callFunc(function()
			showItem:removeFromParent()
		end)
		local seq = cca.seq(action)
		showItem:runAction(seq)
	end
end
function starsTreasureHuntView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).var = starTreasureHuntRead.getConfigNum()
		SoraDShowHelpMsgTip(i18n("starMaze_text_01", nil))
	end
end
function starsTreasureHuntView:btnRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDCreatePanel("starsTreasureRewardView"):show()
	end
end
function starsTreasureHuntView:btnBagClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:jumpToGift(MSGBOX_CALLBACK_YES)
	end
end
function starsTreasureHuntView:getGiftInfo()
	_UPVALUE3_ = nil
	;(nil)[1] = 14357
	;(nil)[2] = 14358
	local (nil)[3], idTbl = 14359, nil
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 3, 1, -1 do
		local item = giftInfo[tostring(idTbl[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
end
function starsTreasureHuntView:jumpToGift(type)
	if type == MSGBOX_CALLBACK_YES then
		local giftData = self:getGiftInfo()
		if giftData then
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).rechargeID = tonumber(giftData.ID)
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
				panel:show()
			end
		else
			SoraDShowMsgTip(i18n("HeroVault_text_03"))
		end
	end
end
function starsTreasureHuntView:btnOpenClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.isInAction or self.needCost == nil or self.itemNum == nil then
			return
		end
		if not starTreasureHuntCtrl:canSearch() then
			SoraDShowMsgTip(i18n("starMaze_text_04"))
			return
		end
		if self.needCost > self.itemNum then
			_ENV = i18n("starMaze_text_04")
			i18n("starMaze_text_04").item = publicRead.getName(self.itemID)
			SoraDShowMsgTip(i18n("common_text_1806", i18n("starMaze_text_04")))
			return
		end
		SoraDShowLoading(self)
		starTreasureHuntCtrl:reqStarMoonTreasureSearch()
	end
end
function starsTreasureHuntView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return starsTreasureHuntView
