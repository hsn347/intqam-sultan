local GameIdleGuideView = class("gameIdleGuideView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("gameIdleGuideView")
	end
	return target
end)
function GameIdleGuideView:ctor()
	self.adjustOffsetY = 25
	self.adjustGirlOffsetY = 35
	self.adjustBoxDown = 6
	self.adjustactionSpeed = 0.8333333333333334
	self.endHandle = nil
	self:setBackGround(127.5)
	self.spriteNotice = SoraDGetChildByName(self, "Sprite_notice")
	local blackSheer = display.newSprite("#frame_sheer_items.png", 0, 0)
	blackSheer:setContentSize(329, 640)
	blackSheer:setRotation(-90)
	blackSheer:addTo(self.spriteNotice:getParent(), 0)
	blackSheer:setPosition(320, -display.height / 2 + 164.5)
	blackSheer:setName("sheerBlack")
	self.blackSheer = blackSheer
	local blackSheer1 = display.newSprite("#frame_sheer_items.png", 0, 0)
	blackSheer1:setContentSize(329, 640)
	blackSheer1:setRotation(-90)
	blackSheer1:addTo(self.spriteNotice:getParent(), 0)
	blackSheer1:setPosition(320, -display.height / 2 + 164.5)
	blackSheer1:setName("sheerBlack")
	self.blackSheer1 = blackSheer1
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	_UPVALUE1_ = nil
	;(nil)[1] = cca.moveTo(1, self.spriteArr:getPositionX(), 38)
	;(nil)[2] = cca.moveTo(1, self.spriteArr:getPositionX(), 33)
	;(nil)[3] = cca.moveTo(1, self.spriteArr:getPositionX(), 33)
	;(nil)[4] = cca.moveTo(1, self.spriteArr:getPositionX(), 33)
	;(nil)[5] = cca.moveTo(1, self.spriteArr:getPositionX(), 33)
	self.spriteArr:runAction(cca.repeatForever(cca.seq(nil)))
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setColor(cc.c3b(68, 35, 17))
	self.labelShow = SoraDGetChildByName(self, "Text_show")
	self.labelShow:setString(i18n("common_text_503"))
	self.btnShow = SoraDGetChildByName(self, "CheckBox_show")
	self.btnShow:setVisible(false)
	self.labelShow:setVisible(false)
	self.spriteGirl = SoraDCreateGuideNPC(1, nil, false)
	self.spriteGirl:setPosition(cc.p(-display.width, -115 + self.adjustGirlOffsetY))
	self.spriteGirl:addTo(self.spriteNotice:getParent(), 1)
	self.spriteGirl:setName("spriteGirl")
	local showGirl = cca.callFunc(function(...)
		self:showGirlAction()
	end)
	local canTouch = cca.callFunc(function(...)
		self:addTouchEventListener(handler(self, self.layoutClickCallBack))
	end)
	_UPVALUE4_ = 1
	;(1)[1] = cca.delay(0.1)
	;(1)[2] = showGirl
	;(1)[3] = cca.delay(1.4)
	;(1)[4] = canTouch
	local action = cca.seq(1)
	action:setTag(1)
	self:runAction(action)
	self.btnShow:addEventListener(handler(self, self.btnClickCallBack))
	self.btnShow:setSelected(false)
end
function GameIdleGuideView:showGirlAction()
	self.spriteArr:stopAllActions()
	self.spriteNotice:setOpacity(0)
	self.blackSheer:setOpacity(0)
	self.blackSheer1:setOpacity(0)
	local posY = -display.cy + 120 + display.iPhoneXBottom - self.adjustBoxDown
	self.spriteNotice:setPosition(cc.p(320, posY - 29))
	_UPVALUE1_ = cc.p(320, posY - 29)
	cc.p(320, posY - 29)[1] = cca.fadeIn(0.333)
	cc.p(320, posY - 29)[2] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[3] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[4] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[5] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	cc.p(320, posY - 29)[6] = cca.moveTo(0.333 * self.adjustactionSpeed, 320, posY)
	self.spriteNotice:runAction(cca.spawn(cc.p(320, posY - 29)))
	self.blackSheer:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
	self.blackSheer1:runAction(cca.fadeIn(0.367 * self.adjustactionSpeed))
	_UPVALUE1_ = cca.fadeIn(0.367 * self.adjustactionSpeed)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[1] = cca.moveTo(1, self.arrX + 15, 35)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[2] = cca.moveTo(1, self.arrX, 33)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[3] = cca.moveTo(1, self.arrX, 33)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[4] = cca.moveTo(1, self.arrX, 33)
	cca.fadeIn(0.367 * self.adjustactionSpeed)[5] = cca.moveTo(1, self.arrX, 33)
	self.spriteArr:runAction(cca.repeatForever(cca.seq(cca.fadeIn(0.367 * self.adjustactionSpeed))))
	self.spriteGirl:setPosition(cc.p(410, self.spriteGirl:getPositionY()))
	self.spriteGirl:runAction(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY())))
	SoraDGetChildByName(self.spriteGirl, "Girl"):setOpacity(0)
	_UPVALUE1_ = cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[1] = cc.EaseSineOut:create(cca.fadeTo(0.417 * self.adjustactionSpeed, 0.4))
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[2] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[3] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[4] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[5] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))[6] = cca.fadeTo(0.083 * self.adjustactionSpeed, 1)
	SoraDGetChildByName(self.spriteGirl, "Girl"):runAction(cca.seq(cc.EaseCircleActionOut:create(cca.moveTo(0.5 * self.adjustactionSpeed, 320, self.spriteGirl:getPositionY()))))
end
function GameIdleGuideView:initNewUI(delay)
	self:stopActionByTag(1)
	if self.spriteGirl then
		self.spriteGirl:removeFromParent()
		self.spriteGirl = nil
	end
	self.spriteGirl = SoraDCreateGuideNPC(1.2, nil, false, cc.size(500, 500), cc.p(240, 0 + self.adjustGirlOffsetY))
	self.spriteGirl:setPosition(cc.p(-display.width, -display.cy + 130 + display.iPhoneXBottom + self.adjustGirlOffsetY))
	self.spriteGirl:addTo(self.spriteNotice:getParent(), 1)
	self.spriteGirl:setName("spriteGirl")
	self.spriteNotice:loadTexture("frame_xsyd_dhk.png", ccui.TextureResType.plistType)
	self.spriteNotice:setPosition(cc.p(960, -display.cy + 120 + display.iPhoneXBottom - self.adjustBoxDown))
	self.spriteNotice:setContentSize(cc.size(738, 239))
	self.spriteNotice:setScale9Enabled(false)
	self.spriteNotice:ignoreContentAdaptWithSize(true)
	self.spriteNotice:setLocalZOrder(2)
	self.labelNotice:setAnchorPoint(cc.p(0.5, 0.5))
	self.labelNotice:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self.labelNotice:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.labelNotice:setPosition(cc.p(320 + self.adjustOffsetY * 2, 120))
	self.labelNotice:setContentSize(cc.size(560, 120))
	self.spriteArr:stopAllActions()
	self.spriteArr:setSpriteFrame("icon_xsyd_tg.png")
	self.arrX = 550 + self.adjustOffsetY
	self.spriteArr:setPosition(cc.p(self.arrX, 35))
	_UPVALUE1_ = cc.p(self.arrX, 35)
	cc.p(self.arrX, 35)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	cc.p(self.arrX, 35)[2] = cca.moveTo(0.5, self.arrX, 35)
	cc.p(self.arrX, 35)[3] = cca.moveTo(0.5, self.arrX, 35)
	cc.p(self.arrX, 35)[4] = cca.moveTo(0.5, self.arrX, 35)
	cc.p(self.arrX, 35)[5] = cca.moveTo(0.5, self.arrX, 35)
	self.spriteArr:runAction(cca.repeatForever(cca.seq(cc.p(self.arrX, 35))))
	local showGirl = cca.callFunc(function(...)
		self:showGirlAction()
	end)
	local canTouch = cca.callFunc(function(...)
		self:addTouchEventListener(handler(self, self.layoutClickCallBack))
	end)
	_UPVALUE4_ = cca.repeatForever(cca.seq(cc.p(self.arrX, 35)))
	cca.repeatForever(cca.seq(cc.p(self.arrX, 35)))[1] = cca.delay(delay)
	cca.repeatForever(cca.seq(cc.p(self.arrX, 35)))[2] = showGirl
	cca.repeatForever(cca.seq(cc.p(self.arrX, 35)))[3] = cca.delay(1.4)
	cca.repeatForever(cca.seq(cc.p(self.arrX, 35)))[4] = canTouch
	local action = cca.seq(cca.repeatForever(cca.seq(cc.p(self.arrX, 35))))
	action:setTag(1)
	self:runAction(action)
	self:fitHieghtView()
end
function GameIdleGuideView:fitHieghtView()
	if display.width / display.height <= 0.5633802816901409 then
		return
	end
	if not self.originSize then
		self.originSize = self.spriteNotice:getContentSize()
	end
	local scale = self.originSize.width / 640
	self.spriteNotice:ignoreContentAdaptWithSize(false)
	self.spriteNotice:setScale9Enabled(false)
	self.spriteNotice:setContentSize(cc.size(self.originSize.width / scale, self.originSize.height))
	self.labelNotice:setContentSize(cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height))
	self.arrX = 500
	self.labelNotice:setPositionX(320)
	self.spriteArr:stopAllActions()
	self.spriteArr:setPositionX(self.arrX)
	_UPVALUE1_ = cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)
	cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)[1] = cca.moveTo(0.5, self.arrX + 15, 35)
	cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)[2] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)[3] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)[4] = cca.moveTo(0.5, self.arrX, 35)
	cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height)[5] = cca.moveTo(0.5, self.arrX, 35)
	self.spriteArr:runAction(cca.repeatForever(cca.seq(cc.size(self.labelNotice:getContentSize().width / scale, self.labelNotice:getContentSize().height))))
end
function GameIdleGuideView:setDelay(delay)
	self:stopActionByTag(1)
	local showGirl = cca.callFunc(function(...)
		self:showGirlAction()
	end)
	local canTouch = cca.callFunc(function(...)
		self:addTouchEventListener(handler(self, self.layoutClickCallBack))
	end)
	_UPVALUE4_ = nil
	;(nil)[1] = cca.delay(delay)
	;(nil)[2] = showGirl
	;(nil)[3] = cca.delay(1.4)
	;(nil)[4] = canTouch
	local action = cca.seq(nil)
	action:setTag(1)
	self:runAction(action)
end
function GameIdleGuideView:btnClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		GAME_DLE_GUIDE_SHOW = false
	elseif type == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		GAME_DLE_GUIDE_SHOW = true
	end
end
function GameIdleGuideView:setMsg(msg)
	self.labelNotice:setString(msg)
end
function GameIdleGuideView:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
	local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local armyCtrl = gametop.playertop_:getModule("armyCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local buildLogic = include("buildLogic")
	local _ENV, tableNotice = "buildLogic", "buildLogic"
	local buildBid1 = 0
	local buildBid2 = 0
	if queueCtrl:queryQueue(gQueueTypeDef.free_build_queue) then
		buildBid1 = tonumber(queueCtrl:queryQueue(gQueueTypeDef.free_build_queue).data.bid)
	end
	if queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue) then
		buildBid2 = tonumber(queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue).data.bid)
	end
	if loginRewardCtrl:getCanReceive() then
		table.insert(tableNotice, "common_text_1080")
	elseif timeRewardCtrl:getTimeRewardData() and timeRewardCtrl:getTimeRewardData().isReceive == 2 then
		table.insert(tableNotice, "common_text_1081")
	elseif kingdomMapCtrl:isHasQueue() < buildLogic.getExpQueueCount().total then
		table.insert(tableNotice, "common_text_1097")
		table.insert(tableNotice, "common_text_1098")
		table.insert(tableNotice, "common_text_1099")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.chariot_plant_queue) and buildBid1 ~= BUILDID.CHARIOT_PLANT and buildBid2 ~= BUILDID.CHARIOT_PLANT then
		table.insert(tableNotice, "common_text_1102")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.stables_queue) and buildBid1 ~= BUILDID.STABLES and buildBid2 ~= BUILDID.STABLES then
		table.insert(tableNotice, "common_text_1103")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.range_queue) and buildBid1 ~= BUILDID.RANGE and buildBid2 ~= BUILDID.RANGE then
		table.insert(tableNotice, "common_text_1101")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.barracks_queue) and buildBid1 ~= BUILDID.BARRACKS and buildBid2 ~= BUILDID.BARRACKS then
		table.insert(tableNotice, "common_text_1104")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.frotress_queue) and buildBid1 ~= BUILDID.FORTRESS and buildBid2 ~= BUILDID.FORTRESS then
		table.insert(tableNotice, "common_text_1100")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.free_build_queue) or cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue) and nil == queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue) then
		_ENV = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.WATCH_TOWER] = "common_text_1082"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.EMBASSY] = "common_text_1083"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.MARKET] = "common_text_1084"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.HOSTPITAL] = "common_text_1085"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.BARRACKS] = "common_text_1087"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.DEPOT] = "common_text_1088"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.CASTLE] = "common_text_1089"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.WISHING_WELL] = "common_text_1090"
		queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.STABLES] = "common_text_1091"
		local queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)[BUILDID.WALLS], mapBuildKey = "common_text_1092", queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
		for k, v in pairs(mapBuildKey) do
			local _iscanbuild, retdata = buildLogic.isCanBuild(k)
			if _iscanbuild then
				table.insert(tableNotice, v)
			end
		end
		if #tableNotice <= 0 then
			for k, v in pairs(mapBuildKey) do
				table.insert(tableNotice, v)
			end
		end
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.hostpital_queue) and 0 < armyCtrl:getTotalWoundedArmyCount() and buildBid1 ~= BUILDID.HOSTPITAL and buildBid2 ~= BUILDID.HOSTPITAL then
		table.insert(tableNotice, "common_text_1086")
	elseif nil == queueCtrl:queryQueue(gQueueTypeDef.technology_upgrade_queue) and buildBid1 ~= BUILDID.COLLEGE and buildBid2 ~= BUILDID.COLLEGE then
		table.insert(tableNotice, "common_text_1093")
		table.insert(tableNotice, "common_text_1094")
		table.insert(tableNotice, "common_text_1095")
		table.insert(tableNotice, "common_text_1096")
	else
		table.insert(tableNotice, "common_text_1107")
	end
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local noticeKey = tableNotice[math.random(#tableNotice)]
	self.labelNotice:setString(i18n(noticeKey))
end
function GameIdleGuideView:setEndCallBack(handle)
	self.endHandle = handle
end
function GameIdleGuideView:setChapterID(id)
	self.curChapterID = id
end
function GameIdleGuideView:layoutClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if self.endHandle then
			self.endHandle()
		end
		self.curChapterID = nil
		self:removeFromParent()
	end
end
function GameIdleGuideView:setAutoClose(delay)
	local actDelay = cca.delay(delay)
	local actCallFunc = cca.callFunc(function()
		self:layoutClickCallBack(nil, ccui.TouchEventType.ended)
	end)
	_UPVALUE2_ = nil
	;(nil)[1] = actDelay
	;(nil)[2] = actCallFunc
	local seq = cca.seq(nil)
	self:runAction(seq)
end
return GameIdleGuideView
