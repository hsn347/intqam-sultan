local masteryViewSingleItem = class("masteryViewSingleItem", function(target)
	return target
end)
local specializationRead = include("specializationRead")
local MASTERY_STATE = specializationRead.MASTERY_STATE
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
function masteryViewSingleItem:ctor()
	self:initWidget()
	MASTERY_STATE = self.initWidget
	self.initWidget[MASTERY_STATE.lock] = handler(self, self.onState1_)
	self.initWidget[MASTERY_STATE.canLock] = handler(self, self.onState2_)
	self.initWidget[MASTERY_STATE.normal] = handler(self, self.onState3_)
	self.initWidget[MASTERY_STATE.canUpgrade] = handler(self, self.onState4_)
	self.initWidget[MASTERY_STATE.canStars] = handler(self, self.onState5_)
	self.initWidget[MASTERY_STATE.upgrading] = handler(self, self.onState6_)
	self.initWidget[MASTERY_STATE.invalid] = handler(self, self.onState7_)
	self.stateCallbacks, self.initWidget[MASTERY_STATE.canUpgradeAndStars] = self.initWidget, handler(self, self.onState8_)
end
function masteryViewSingleItem:initWidget(...)
	_UPVALUE1_ = nil
	;(nil)[1] = "Node_build"
	self.Node_build = SoraDGetChildByFullPath(self, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_3"
	self.Text_name = SoraDGetChildByFullPath(self.Node_build, nil)
	_UPVALUE1_ = nil
	;(nil)[1] = "Image_build"
	self.Image_build = SoraDGetChildByFullPath(self.Node_build, nil)
	self.Image_build:setTouchEnabled(true)
	self.Image_build:setSwallowTouches(false)
	self.Image_build:addTouchEventListener(handler(self, self.onClick_build))
	_UPVALUE2_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_up"
	handler(self, self.onClick_build)[2] = "Image_4"
	self.Sprite_up = SoraDGetChildByFullPath(self, handler(self, self.onClick_build))
	_UPVALUE2_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_up"
	handler(self, self.onClick_build)[2] = "Image_4_0"
	self.Sprite_down = SoraDGetChildByFullPath(self, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_text_1"
	self.Node_text_1 = SoraDGetChildByFullPath(self, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Text_1"
	self.Text_des = SoraDGetChildByFullPath(self.Node_text_1, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Image_6"
	self.Image_des = SoraDGetChildByFullPath(self.Node_text_1, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Image_6_0"
	self.Image_des_r = SoraDGetChildByFullPath(self.Node_text_1, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_icon_1"
	self.Node_icon_1 = SoraDGetChildByFullPath(self, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Image_icon"
	self.Image_icon = SoraDGetChildByFullPath(self.Node_icon_1, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_icon_2"
	self.Node_icon_2 = SoraDGetChildByFullPath(self, handler(self, self.onClick_build))
	_UPVALUE1_ = handler(self, self.onClick_build)
	handler(self, self.onClick_build)[1] = "Node_star"
	self.Node_star = SoraDGetChildByFullPath(self.Node_icon_2, handler(self, self.onClick_build))
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(self.Node_star)
	_ENV = self.Node_star
	self.Node_star.scale = 0.8
	starSingle:initData(self.Node_star)
	self.starSingle = starSingle
	self.loadingBar = SoraDGetExtendChildFromCCSByName(self, "CCS_commonProgressBar_time")
	_UPVALUE1_ = "CCS_commonProgressBar_time"
	;("CCS_commonProgressBar_time")[1] = "Text_time"
	self.loadingBar_time = SoraDGetChildByFullPath(self.loadingBar, "CCS_commonProgressBar_time")
	self.loadingBar_time = SoraDCreateTimerLabel(self, self.loadingBar_time)
end
function masteryViewSingleItem:initData(data)
	self.index = data.index
	local isFlipX = self.index % 2 == 0
	self.Sprite_up:setFlippedX(isFlipX)
	self.Sprite_down:setFlippedX(isFlipX)
	self.Sprite_up:setVisible(self.index <= 2)
	if not data.bid or data.bid == 0 then
		self:onStateEmpty_()
		return
	end
	self.bid = data.bid
	self.state = data.state
	self.mid = data.mid
	SoraChangeSpriteImage(self.Image_build, specializationRead.getBuildIcon(self.bid))
	self.Text_name:setString(specializationRead.getMasteryName(self.bid))
	self.Image_icon:setPositionX(self.Text_name:getContentSize().width / 2 + 20)
	local mastery = cityCtrl:getMasteryByMid(self.mid)
	if mastery then
		_ENV = self.Text_name
		self.Text_name.lev = mastery.lev
		self.starSingle:initData(self.Text_name)
	end
	self:doStateEvent(MASTERY_STATE.normal)
	self:doStateEvent(self.state)
	self:checkUpgrading()
end
function masteryViewSingleItem:checkUpgrading(...)
	if self.state == MASTERY_STATE.normal or self.state == MASTERY_STATE.canUpgrade or self.state == MASTERY_STATE.canStars or self.state == MASTERY_STATE.canUpgradeAndStars then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
		local upgradingBid = queue and queue.data.bid or 0
		if upgradingBid == self.bid then
			local totalTime = queue.totaltime
			local remainTime = queue.timerNode.timer:getRemainTime()
			MASTERY_STATE = nil
			;(nil).maxValue = totalTime
			;(nil).curValue = totalTime - remainTime
			self.loadingBar:setProgressDate(nil)
			self.loadingBar_time:beginTime(remainTime)
			self.loadingBar_time:setTimeUpdateListener(function(leftTime)
				local curValue = totalTime - leftTime
				self.loadingBar:updateData(curValue)
			end)
			self:doStateEvent(MASTERY_STATE.upgrading)
		end
	end
end
function masteryViewSingleItem:doStateEvent(state)
	local stateFun = self.stateCallbacks[state]
	if stateFun then
		stateFun()
	else
		self:onStateEmpty_()
	end
end
function masteryViewSingleItem:onState1_()
	SoraDSetGray(self.Node_build, true, true)
	self.Node_icon_2:setVisible(false)
	self.Node_text_1:setVisible(true)
	local needLv = specializationRead.getCondBuildingLv(self.bid)
	_ENV = nil
	;(nil).Lvl = needLv
	self.Text_des:setString(i18n("specialization_text_06", nil))
	self.Text_des:setColor(cc.c3b(240, 10, 10))
	local height = SoraDGetAutoHeightLabel(self.Text_des, 260)
	self.Image_des:setContentSize(cc.size(100, height))
	self.Image_des_r:setContentSize(cc.size(100, height))
	self.Text_name:setColor(cc.c3b(170, 170, 170))
end
function masteryViewSingleItem:onState2_()
	SoraDSetGray(self.Node_build, true, true)
	self.Node_icon_2:setVisible(false)
	local node = self:getChildByName("Node_lock")
	if not node then
		node = SoraDCreatAnimation("petLock")
		node:addTo(self)
		node:setName("Node_lock")
		SoraDMixtureGLONE(SoraDGetChildByName(node, "dh_lock_glow"))
	end
	node:setVisible(true)
	self.Text_name:setColor(cc.c3b(170, 170, 170))
end
function masteryViewSingleItem:onState3_()
	self.Node_build:setVisible(true)
	SoraDSetGray(self.Node_build, false, true)
	self.Node_icon_2:setVisible(true)
	SoraDSetGray(self.Node_icon_2, false, true)
	local node = self:getChildByName("Node_lock")
	if node then
		node:setVisible(false)
	end
	self.Node_text_1:setVisible(false)
	self.Node_icon_1:setVisible(false)
	self.Text_name:setColor(cc.c3b(255, 255, 255))
	self.loadingBar:setVisible(false)
	self.starSingle:showEffect()
	if self.Node_effect then
		self.Node_effect:setVisible(false)
	end
end
function masteryViewSingleItem:onState4_()
	if not self.Node_effect then
		local node = SoraDCreatAnimation("zhuanjingshengji", nil, true)
		node:addTo(self)
		node:setPosition(cc.p(90, 80))
		self.Node_effect = node
	else
		self.Node_effect:setVisible(true)
	end
end
function masteryViewSingleItem:onState5_()
	self.Node_text_1:setVisible(true)
	self.Text_des:setString(i18n("specialization_text_05"))
	self.Text_des:setColor(cc.c3b(30, 220, 25))
	local height = SoraDGetAutoHeightLabel(self.Text_des, 260)
	self.Image_des:setContentSize(cc.size(100, height))
	self.Image_des_r:setContentSize(cc.size(100, height))
	self.Node_icon_1:setVisible(true)
	SoraChangeSpriteImage(self.Image_icon, "icon_add.png")
end
function masteryViewSingleItem:onState8_(...)
	self:onState4_()
	self:onState5_()
end
function masteryViewSingleItem:onState6_()
	self.Node_text_1:setVisible(false)
	self.loadingBar:setVisible(true)
	if (self.state == MASTERY_STATE.canUpgrade or self.state == MASTERY_STATE.canUpgradeAndStars) and self.Node_effect then
		self.Node_effect:setVisible(false)
	end
end
function masteryViewSingleItem:onState7_()
	SoraDSetGray(self.Node_build, true, true)
	SoraDSetGray(self.Node_icon_2, true, true)
	self.Node_text_1:setVisible(true)
	self.Text_des:setString(i18n("specialization_text_07"))
	self.Text_des:setColor(cc.c3b(240, 10, 10))
	local height = SoraDGetAutoHeightLabel(self.Text_des, 260)
	self.Image_des:setContentSize(cc.size(100, height))
	self.Image_des_r:setContentSize(cc.size(100, height))
	self.Text_name:setColor(cc.c3b(170, 170, 170))
	self.starSingle:hideEffect()
end
function masteryViewSingleItem:onStateEmpty_()
	self.Node_build:setVisible(false)
	self.Node_text_1:setVisible(false)
	self.Node_icon_1:setVisible(false)
	self.Node_icon_2:setVisible(false)
	self.loadingBar:setVisible(false)
	local node = self:getChildByName("Node_lock")
	if node then
		node:setVisible(false)
	end
	if self.Node_effect then
		self.Node_effect:setVisible(false)
	end
end
function masteryViewSingleItem:onClick_build(button, event)
	if event == ccui.TouchEventType.ended then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchEndPosition()
		if math.abs(touchBeganPoint.x - touchmovePoint.x) < 10 and 10 > math.abs(touchBeganPoint.y - touchmovePoint.y) then
			SoraDPlaySound()
			if self.state == MASTERY_STATE.canLock then
				local buildLogic = include("buildLogic")
				if buildLogic.checkDemolishQueue(self.bid) then
					SoraDShowMsgTip(i18n("specialization_tips_03"))
				else
					local cityCtrl = SoraDGetCtrl("cityCtrl")
					cityCtrl:sendReqMasteryUnlock(self.mid)
				end
				return
			end
			if self.handler then
				self.handler(self.index)
			end
		end
	end
end
function masteryViewSingleItem:setClickBuildHandler(handler)
	self.handler = handler
end
return masteryViewSingleItem
