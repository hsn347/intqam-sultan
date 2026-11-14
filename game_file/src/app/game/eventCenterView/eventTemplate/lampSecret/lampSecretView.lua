local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local lampSecretRead = include("lampSecretRead")
local lampSecretCtrl = SoraDGetCtrl("lampSecretCtrl")
local lampSecretView = class("lampSecretView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("lampSecretView")
end)
_ENV = "lampSecretView"
;("lampSecretView").selectAndGet = 0
;("lampSecretView").selectState = 1
local ("lampSecretView").getState, activityStateType = 2, "lampSecretView"
local lampNum = 8
function lampSecretView:onEnterOther()
	lampSecretCtrl:reqLampSecretActivityInit()
end
function lampSecretView:ctor(properties)
	self.activityID = gActivityTimeActivityID.LAMP_SECRET_ACTIVITY
	self.activityState = nil
	self.lampList, _ENV, self.canPlead = gActivityTimeActivityID.LAMP_SECRET_ACTIVITY, gActivityTimeActivityID.LAMP_SECRET_ACTIVITY, true
	self.itemId = tonumber(lampSecretRead.getCostItemId())
	self.nodeImage = SoraDGetChildByName(self, "Top_Node_Image")
	self.imageBg = SoraDGetChildByName(self, "Center_Image_bg")
	self.nodeBgEffect = SoraDGetChildByName(self, "beijing")
	self.bgEffect = SoraDCreatAnimationEx("LampSecretBgEffect", nil, true)
	self.bgEffect:addTo(self.nodeBgEffect)
	self.bgEffect:setPosition(0, 0)
	self.imgGirl = SoraDGetChildByName(self.bgEffect, "Image_7")
	self.imgTaizi = SoraDGetChildByName(self.bgEffect, "bg_qdmy_02")
	self.nodeTimer = SoraDGetChildByName(self, "Top_Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.textActivityTime:setIsHtml(true)
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001312"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.node = SoraDGetChildByName(self, "Node_Bottom")
	self.nodeItemInfo = SoraDGetChildByName(self.node, "Node_ItemInfo")
	self.textDescribe = SoraDGetChildByName(self.nodeItemInfo, "Text_Describe")
	self.textDescribe:setString(i18n("common_text_3893"))
	self.textLeftNum = SoraDGetChildByName(self.nodeItemInfo, "Text_Num")
	self.btnAdd = SoraDGetChildByName(self.nodeItemInfo, "Button_Add")
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClick))
	self.btnPrayer = SoraDGetChildByName(self.node, "Button_Prayer")
	self.btnPrayer:addTouchEventListener(handler(self, self.btnPrayerClick))
	self.nodePrayer = SoraDGetChildByName(self, "Node_BtnPray")
	self.textPray = SoraDGetChildByName(self.btnPrayer, "Text_Pray")
	self.textPray:setString(i18n("pray_text_23"))
	self.textNeedNum = SoraDGetChildByName(self.btnPrayer, "Text_Num")
	self.btnOpenReset = SoraDGetChildByName(self, "Button_OpenReset")
	self.btnOpenReset:addTouchEventListener(handler(self, self.btnSelectClick))
	self.nodeLamp = SoraDGetChildByName(self, "Top_Node_Lamp")
	self.nodeList = SoraDGetChildsArrayByName(self, "hideEffect_", 4, 1)
	self.nodePBoxs = SoraDGetChildByName(self, "Node_Bar")
	self.lBarProgress = SoraDGetChildByName(self.nodePBoxs, "LoadingBar_progress")
	self.lBarProgressBg = SoraDGetChildByName(self.nodePBoxs, "LoadingBar_bg")
	self.scrollBar = SoraDGetChildByName(self, "ScrollView_Bar")
	self.btnBox = SoraDGetChildByName(self.nodePBoxs, "Button_box")
	self.textPressNum = SoraDGetChildByName(self, "Text_PressNum")
	self.textPressNum:setIsHtml(true)
	self:initActivityTime()
	self:fitView()
	self:initLampNode()
	self:initEffect()
	self:initProgressBar()
	self:initData()
end
function lampSecretView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_LAMP_SECRET_REFRESH", handler(self, self.msgCallBack))
end
function lampSecretView:fitView()
	local height = self:getPanelOffsetHeight()
	local offsetY = math.min(100, math.max(0, (math.floor((1136 - height) / 2))))
	self.nodeBgEffect:setPositionY(700 - offsetY)
	if height <= 960 then
		self.nodeLamp:setScale(0.9)
		self.nodeLamp:setPositionY(self.nodeLamp:getPositionY() + 10)
		self.nodeBgEffect:setScale(0.9)
	end
end
function lampSecretView:initEffect()
	local loop = false
	local cssFileName = "lampSecretView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	self.imgGirl:setScale(1.07)
	self.imgGirl:setPosition(0, -333)
	_UPVALUE1_ = -333
	_UPVALUE2_ = nil
	;(nil)[1] = cca.scaleTo(0.06666666666666667, 1.0629)
	;(nil)[2] = cca.scaleTo(0.23333333333333334, 1.0064)
	;(nil)[3] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[4] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[5] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[6] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[7] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[8] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[9] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[10] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[11] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[12] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[13] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[14] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[15] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[16] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[17] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[18] = cca.scaleTo(0.06666666666666667, 1.0)
	;(nil)[19] = cca.scaleTo(0.06666666666666667, 1.0)
	_UPVALUE2_ = cca.scaleTo(0.06666666666666667, 1.0629)
	cca.scaleTo(0.06666666666666667, 1.0629)[1] = cca.moveTo(0.06666666666666667, 0, -330)
	cca.scaleTo(0.06666666666666667, 1.0629)[2] = cca.moveTo(0.23333333333333334, 0, -313)
	cca.scaleTo(0.06666666666666667, 1.0629)[3] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[4] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[5] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[6] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[7] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[8] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[9] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[10] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[11] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[12] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[13] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[14] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[15] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[16] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[17] = cca.moveTo(0.06666666666666667, 0, -310)
	cca.scaleTo(0.06666666666666667, 1.0629)[18] = cca.moveTo(0.06666666666666667, 0, -310)
	;(-333)[1] = cca.seq(nil)
	;(-333)[2] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[3] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[4] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[5] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[6] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[7] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[8] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[9] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[10] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[11] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[12] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[13] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[14] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[15] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[16] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[17] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[18] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[19] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[20] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	;(-333)[21] = cca.seq((cca.scaleTo(0.06666666666666667, 1.0629)))
	self.imgGirl:runAction(cca.spawn(-333))
	self.imgTaizi:setScale(1.08)
	self.imgTaizi:setPosition(0, -568)
	_UPVALUE1_ = -568
	_UPVALUE2_ = cca.spawn(-333)
	cca.spawn(-333)[1] = cca.scaleTo(0.06666666666666667, 1.072)
	cca.spawn(-333)[2] = cca.scaleTo(0.23333333333333334, 1.0082)
	cca.spawn(-333)[3] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[4] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[5] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[6] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[7] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[8] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[9] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[10] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[11] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[12] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[13] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[14] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[15] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[16] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[17] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[18] = cca.scaleTo(0.06666666666666667, 1.0)
	cca.spawn(-333)[19] = cca.scaleTo(0.06666666666666667, 1.0)
	_UPVALUE2_ = cca.scaleTo(0.06666666666666667, 1.072)
	cca.scaleTo(0.06666666666666667, 1.072)[1] = cca.moveTo(0.06666666666666667, 0, -563)
	cca.scaleTo(0.06666666666666667, 1.072)[2] = cca.moveTo(0.23333333333333334, 0, -528)
	cca.scaleTo(0.06666666666666667, 1.072)[3] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[4] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[5] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[6] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[7] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[8] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[9] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[10] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[11] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[12] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[13] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[14] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[15] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[16] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[17] = cca.moveTo(0.06666666666666667, 0, -525)
	cca.scaleTo(0.06666666666666667, 1.072)[18] = cca.moveTo(0.06666666666666667, 0, -525)
	;(-568)[1] = cca.seq(cca.spawn(-333))
	;(-568)[2] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[3] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[4] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[5] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[6] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[7] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[8] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[9] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[10] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[11] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[12] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[13] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[14] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[15] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[16] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[17] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[18] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[19] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[20] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	;(-568)[21] = cca.seq((cca.scaleTo(0.06666666666666667, 1.072)))
	self.imgTaizi:runAction(cca.spawn(-568))
	local scale = math.max(1, self:getPanelOffsetHeight() / 1136) + 0.05
	self.imageBg:setScale(scale)
	_UPVALUE2_ = cca.spawn(-568)
	cca.spawn(-568)[1] = cca.scaleTo(0.06666666666666667, scale - 0.005)
	cca.spawn(-568)[2] = cca.scaleTo(0.23333333333333334, scale - 0.045)
	cca.spawn(-568)[3] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[4] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[5] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[6] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[7] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[8] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[9] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[10] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[11] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[12] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[13] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[14] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[15] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[16] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[17] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[18] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[19] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	cca.spawn(-568)[20] = cca.scaleTo(0.06666666666666667, scale - 0.05)
	self.imageBg:runAction(cca.seq(cca.spawn(-568)))
	for i = 1, 2 do
		local posX = self.lampList[i]:getPositionX()
		local posY = self.lampList[i]:getPositionY()
		_UPVALUE1_ = cca.seq(cca.spawn(-568))
		_ENV = cca.seq(cca.spawn(-568))
		_UPVALUE3_ = cca.seq(cca.spawn(-568))
		cca.seq(cca.spawn(-568))[1] = cca.moveTo(0.06666666666666667, posX, posY - 40)
		cca.seq(cca.spawn(-568))[2] = cca.moveTo(0.2, posX, posY - 300)
		cca.seq(cca.spawn(-568))[3] = cca.moveTo(0.06666666666666667, posX, posY - 335)
		cca.seq(cca.spawn(-568))[4] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[5] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[6] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[7] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[8] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[9] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.spawn(-568))[1] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[2] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[3] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[4] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[5] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[6] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[7] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[8] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[9] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[10] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[11] = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[1] = cca.delay(0.08333333333333333)
		cca.seq(cca.spawn(-568))[2] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[3] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[4] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[5] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[6] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[7] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[8] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[9] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[10] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[11] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[12] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[13] = cca.spawn(cca.seq(cca.spawn(-568)))
		cca.seq(cca.spawn(-568))[14] = cca.spawn(cca.seq(cca.spawn(-568)))
		self.lampList[i]:runAction(cca.seq(cca.seq(cca.spawn(-568))))
	end
	for i = 3, 4 do
		local posX = self.lampList[i]:getPositionX()
		local posY = self.lampList[i]:getPositionY()
		self.lampList[i]:setOpacity(0)
		_UPVALUE1_ = cca.seq(cca.seq(cca.spawn(-568)))
		_UPVALUE1_ = cca.seq(cca.seq(cca.spawn(-568)))
		_UPVALUE1_ = cca.seq(cca.seq(cca.spawn(-568)))
		cca.seq(cca.seq(cca.spawn(-568)))[1] = cca.fadeTo(0.06666666666666667, 0.4)
		cca.seq(cca.seq(cca.spawn(-568)))[2] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[3] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[4] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[5] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[6] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[7] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[8] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.spawn(-568)))[9] = cca.fadeTo(0.1, 1)
		_UPVALUE3_ = cca.fadeTo(0.06666666666666667, 0.4)
		cca.fadeTo(0.06666666666666667, 0.4)[1] = cca.moveTo(0.06666666666666667, posX, posY - 40)
		cca.fadeTo(0.06666666666666667, 0.4)[2] = cca.moveTo(0.2, posX, posY - 300)
		cca.fadeTo(0.06666666666666667, 0.4)[3] = cca.moveTo(0.06666666666666667, posX, posY - 335)
		cca.fadeTo(0.06666666666666667, 0.4)[4] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.fadeTo(0.06666666666666667, 0.4)[5] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.fadeTo(0.06666666666666667, 0.4)[6] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.fadeTo(0.06666666666666667, 0.4)[7] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.fadeTo(0.06666666666666667, 0.4)[8] = cca.moveTo(0.16666666666666666, posX, posY - 325)
		cca.seq(cca.seq(cca.spawn(-568)))[1] = cca.seq(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[2] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[3] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[4] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[5] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[6] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[7] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[8] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[9] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[10] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[11] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.spawn(-568)))[1] = cca.delay(0.08333333333333333)
		cca.seq(cca.seq(cca.spawn(-568)))[2] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[3] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[4] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[5] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[6] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[7] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[8] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[9] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[10] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[11] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[12] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[13] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.spawn(-568)))[14] = cca.spawn(cca.seq(cca.seq(cca.spawn(-568))))
		self.lampList[i]:runAction(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
	end
	for i = 5, 8 do
		local posX = self.lampList[i]:getPositionX()
		local posY = self.lampList[i]:getPositionY()
		self.lampList[i]:setOpacity(0)
		_UPVALUE1_ = cca.seq(cca.seq(cca.seq(cca.spawn(-568))))
		_UPVALUE1_ = cca.seq(cca.seq(cca.seq(cca.spawn(-568))))
		_UPVALUE1_ = cca.seq(cca.seq(cca.seq(cca.spawn(-568))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[1] = cca.fadeTo(0.06666666666666667, 0.4)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[2] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[3] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[4] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[5] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[6] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[7] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[8] = cca.fadeTo(0.1, 1)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[9] = cca.fadeTo(0.1, 1)
		_UPVALUE4_ = cca.fadeTo(0.06666666666666667, 0.4)
		cca.fadeTo(0.06666666666666667, 0.4)[1] = cca.moveTo(0.06666666666666667, posX, posY - 40)
		cca.fadeTo(0.06666666666666667, 0.4)[2] = cca.moveTo(0.1, posX, posY - 180)
		cca.fadeTo(0.06666666666666667, 0.4)[3] = cca.moveTo(0.1, posX, posY - 320)
		cca.fadeTo(0.06666666666666667, 0.4)[4] = cca.moveTo(0.06666666666666667, posX, posY - 355)
		cca.fadeTo(0.06666666666666667, 0.4)[5] = cca.moveTo(0.16666666666666666, posX, posY - 350)
		cca.fadeTo(0.06666666666666667, 0.4)[6] = cca.moveTo(0.16666666666666666, posX, posY - 350)
		cca.fadeTo(0.06666666666666667, 0.4)[7] = cca.moveTo(0.16666666666666666, posX, posY - 350)
		cca.fadeTo(0.06666666666666667, 0.4)[8] = cca.moveTo(0.16666666666666666, posX, posY - 350)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[1] = cca.seq(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[2] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[3] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[4] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[5] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[6] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[7] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[8] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[9] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[10] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[11] = cca.seq((cca.fadeTo(0.06666666666666667, 0.4)))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[1] = cca.delay(0.11666666666666667)
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[2] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[3] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[4] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[5] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[6] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[7] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[8] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[9] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[10] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[11] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[12] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[13] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		cca.seq(cca.seq(cca.seq(cca.spawn(-568))))[14] = cca.spawn(cca.seq(cca.seq(cca.seq(cca.spawn(-568)))))
		self.lampList[i]:runAction(cca.seq(cca.seq(cca.seq(cca.seq(cca.spawn(-568))))))
	end
end
function lampSecretView:initLampNode()
	for i = 1, lampNum do
		local single = include("lampSecretItem").new()
		single:addTo(self.nodeLamp, 9 - i)
		single:initData(i, self)
		table.insert(self.lampList, single)
	end
end
function lampSecretView:initProgressBar()
	self.boxData = lampSecretRead:getStageAwardConfig(lampSecretCtrl:getClassType())
	local perDis = 116
	local totalWidth = perDis * (table.nums(self.boxData) - 1) + perDis / 2
	self.lBarProgress:setContentSize(cc.size(totalWidth, 11))
	self.lBarProgressBg:setContentSize(cc.size(totalWidth + 4, 11))
	self.scrollBar:setInnerContainerSize(cc.size(totalWidth + 50, 110))
	self.nodePBoxs:setPositionX((totalWidth + SoraDFPosX(90, 100)) / 2)
	SoraDGetChildByName(self, "frame_cjxt_square_zs_l"):setPositionX(-totalWidth / 2)
	SoraDGetChildByName(self, "frame_cjxt_square_zs_r"):setPositionX(totalWidth / 2)
	local caculatePosX = function(num)
		if SoraDFIsRA() then
			return totalWidth / 2 - num * perDis + perDis / 2
		else
			return num * perDis - totalWidth / 2 - perDis / 2
		end
	end
	self.stagePointArray, lampSecretRead = SoraDGetChildByName(self, "frame_cjxt_square_zs_r"), SoraDGetChildByName(self, "frame_cjxt_square_zs_r")
	if not self.ocxBoxs then
		self.ocxBoxs, lampSecretRead = self.ocxBoxs, self.ocxBoxs
		for i, v in ipairs(self.boxData) do
			local single
			if i == 1 then
				single = self.btnBox
			else
				single = self.btnBox:clone()
				single:addTo(self.nodePBoxs)
			end
			single:setCascadeOpacityEnabled(true)
			SoraDGetChildByName(single, "Text_price"):setString(string.formatnumberthousands(v.num))
			single:setTag(i)
			single:setPosition(caculatePosX(i), 0)
			single = include("commonBtnInstance").new(single)
			single:setHandle(handler(self, self.btnBoxClick))
			single:setSwallowTouches(false)
			table.insert(self.ocxBoxs, single)
			self.stagePointArray[i] = v.num
		end
	end
end
function lampSecretView:refreshProgressBar(...)
	self.receivedReward = lampSecretCtrl:getReceivedReward()
	self.curNum = lampSecretCtrl:getPleadCount()
	lampSecretCtrl = nil
	lampSecretCtrl, lampSecretCtrl, (nil).num = nil, self.curNum, self.curNum
	self.curNum.num, (nil).color = nil, "#FFDF2D"
	self.textPressNum:setString(i18n_html("Lamp_secret_text_15", nil, self.curNum))
	local lampSecretCtrl, styleArray = self.textPressNum.setString, self.textPressNum.setString
	for i, v in ipairs(self.boxData) do
		local status = gBtnTargetStatusDef.GO
		if self.curNum >= self.stagePointArray[i] then
			if self.receivedReward[tostring(i)] then
				status = gBtnTargetStatusDef.GOT
			else
				status = gBtnTargetStatusDef.GET
			end
		end
		self.ocxBoxs[i].status = status
		table.insert(styleArray, math.min(i, 8))
		SoraDGetCommonBox(styleArray[i], status, SoraDGetChildByName(self.ocxBoxs[i], "Sprite_box"))
		SoraDSetGray(SoraDGetChildByName(self.ocxBoxs[i], "Sprite_box"), status == gBtnTargetStatusDef.GOT)
	end
	local percent = SoraDGetStagePercentNew(self.curNum, self.stagePointArray)
	print("percent====", point, percent)
	self.lBarProgress:setPercent(percent)
	self.scrollBar:scrollToPercentHorizontal(SoraDFPosX(100 - percent, 100), 0.5, false)
end
function lampSecretView:refreshLampNode()
	for i, single in ipairs(self.lampList) do
		single:refrshItem(tostring(9 - i))
	end
end
function lampSecretView:initData(target, data)
	self.activityState = lampSecretCtrl:getActivityState()
	self.costItemInfo = lampSecretCtrl:getCostItemInfo()
	self:initItemInfo()
	self:initButtonInfo()
	for _, v in pairs(self.nodeList) do
		v:setVisible(self.activityState ~= activityStateType.selectState)
	end
	self.btnOpenReset:setVisible(not lampSecretCtrl:isFirstChoose())
	if lampSecretCtrl:isFirstChoose() then
		self.btnPrayer:setTitleText(i18n("Lamp_secret_text_12"))
		self.textPray:setVisible(false)
		self.nodePrayer:setVisible(false)
	elseif self.activityState == activityStateType.selectState then
		self.btnPrayer:setTitleText(i18n("Lamp_secret_btn_02"))
		self.textPray:setVisible(false)
		self.nodePrayer:setVisible(false)
	else
		self.btnPrayer:setTitleText("")
		self.textPray:setVisible(true)
		self.nodePrayer:setVisible(true)
	end
	self:refreshProgressBar()
end
function lampSecretView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, ticket
		_ENV, (nil).time, (nil).color = nil, nil, "#ffffff"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("common_text_607", nil, nil)
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 10, SoraDFIsRA())
end
function lampSecretView:initItemInfo()
	self.haveItemNum = backpackCtrl:getItemCount(self.itemId) or 0
	self.textLeftNum:setString(self.haveItemNum)
	SoraDToCenter(self.nodeItemInfo, 10, SoraDFIsRA())
end
function lampSecretView:initButtonInfo()
	self.textNeedNum:setString(string.formatnumberthousands(self.costItemInfo.count))
	if self.costItemInfo.count and self.costItemInfo.count <= self.haveItemNum then
		self.textNeedNum:setTextColor(cc.c3b(255, 200, 0))
	else
		self.textNeedNum:setTextColor(cc.c3b(255, 0, 0))
	end
	SoraDToCenter(self.nodePrayer, 10, not SoraDFIsRA())
end
function lampSecretView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("Lamp_secret_text_01"))
	end
end
function lampSecretView:btnSelectClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if lampSecretCtrl:getLeftResetCont() <= 0 then
			SoraDShowMsgTip(i18n("Lamp_secret_text_16"))
			return
		end
		if lampSecretCtrl:isCanReset() then
			_ENV = i18n("Lamp_secret_text_16")
			i18n("Lamp_secret_text_16").num = lampSecretCtrl:getLeftResetCont()
			SoraDShowMsgBox(i18n("Lamp_secret_text_14", i18n("Lamp_secret_text_16")), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("lampSecretSelectView"):show()
				end
			end)
		else
			SoraDShowMsgTip(i18n("Lamp_secret_text_06"))
		end
	end
end
function lampSecretView:btnAddClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:jumpToGift(MSGBOX_CALLBACK_YES)
	end
end
function lampSecretView:jumpToGift(type)
	if type == MSGBOX_CALLBACK_YES then
		local giftData = self:getGiftInfo()
		if giftData then
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNode(giftData.category, tonumber(giftData.ID))
			panel:show()
		else
			SoraDShowMsgTip(i18n("HeroVault_text_03"))
		end
	end
end
function lampSecretView:getGiftInfo()
	_UPVALUE5_ = nil
	;(nil)[1] = 14146
	;(nil)[2] = 14145
	;(nil)[3] = 14144
	;(nil)[4] = 14143
	local (nil)[5], idTbl = 14142, nil
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 1, 5 do
		local item = giftInfo[tostring(idTbl[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
end
function lampSecretView:btnPrayerClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if lampSecretCtrl:isFirstChoose() then
			SoraDCreatePanel("lampSecretSelectView"):show()
		elseif self.activityState == activityStateType.selectState then
			SoraDShowMsgTip(i18n("Lamp_secret_text_08"))
		elseif self.costItemInfo.count <= self.haveItemNum then
			if self.canPlead then
				self.canPlead = false
				lampSecretCtrl:reqLampSecretActivityPlead()
			end
		else
			SoraDShowMsgBox(i18n("Canyon_Treasur_text_16"), i18n("common_text_054"), i18n("common_text_185"), handler(self, self.jumpToGift))
		end
	end
end
function lampSecretView:btnBoxClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		local idx = target:getTag()
		local buttonStatus = target.status
		local panel = SoraDCreatePanel("lampSecretStageReward")
		panel:initData(self.boxData[idx], buttonStatus)
		panel:show()
	end
end
function lampSecretView:msgCallBack(target, data)
	if data and data.reward then
		print("data.position", data.position)
		local index = 9 - data.position
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(1)
		;(nil)[2] = cca.callFunc(function()
			local panel = SoraDPopGainItem(data.reward[1].id, data.reward[1].count, false)
			panel:setBackGround(0)
			self.canPlead = true
		end)
		;(nil)[3] = cca.callFunc(function()
			local panel = SoraDPopGainItem(data.reward[1].id, data.reward[1].count, false)
			panel:setBackGround(0)
			self.canPlead = true
		end)
		self:runAction(cca.seq(nil))
		self:initData()
		self.lampList[index]:playGetAnimation()
		return
	end
	self.canPlead = true
	self:initData()
	self:refreshLampNode()
end
function lampSecretView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return lampSecretView
