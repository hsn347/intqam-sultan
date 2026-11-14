local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local devoutEntreatCtrl = SoraDGetCtrl("devoutEntreatCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local devoutEntreatRead = include("devoutEntreatRead")
local itemDesRead = include("itemDesRead")
local devoutEntreatView = class("devoutEntreatView", function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end)
_ENV = "devoutEntreatView"
;("devoutEntreatView").normal = 1
;("devoutEntreatView").geted = 2
local _ENV, ("devoutEntreatView").selected, stateType = function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end, 3, "devoutEntreatView"
;(function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end).selectState = 1
;(function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end).getState = 2
local _UPVALUE5_, _ENV, (function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end).resetState, activityStateType = nil, nil, 3, function(target)
	return target or SoraDCreateBasePanel("devoutEntreatView")
end
_UPVALUE5_, (nil).kohGift, (nil)[1] = nil, nil, 13441
_UPVALUE5_, (nil).kohGift, (nil)[2] = nil, nil, 13442
_UPVALUE5_, (nil).kohGift, (nil)[3] = nil, nil, 13443
_UPVALUE5_, (nil).kohGift, (nil)[4] = nil, nil, 13444
_UPVALUE5_, (nil).kohGift, (nil)[5] = nil, nil, 13445
;(nil).rosGift, (nil)[1] = nil, 13441
;(nil).rosGift, (nil)[2] = nil, 13442
;(nil).rosGift, (nil)[3] = nil, 13443
;(nil).rosGift, (nil)[4] = nil, 13444
;(nil).rosGift, (nil)[5] = nil, 13445
local giftID
function devoutEntreatView:onEnterOther()
	devoutEntreatCtrl:sendInitMsg()
end
function devoutEntreatView:ctor()
	self.firesTbl, _ENV, self.candlesTbl, _ENV, self.altarTbl, _ENV = nil, nil, nil, nil, nil, nil
	self.activityState = nil
	self.activityTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_devoutEntreat")
	self.activityTitle:setTitle(i18n("activity_name_9001164"))
	self.btnBag = SoraDGetChildByName(self, "Button_bag")
	self.btnBag:addTouchEventListener(handler(self, self.btnClickOpenBag))
	self.textItemNum = SoraDGetChildByName(self.btnBag, "Text_Num")
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.resetTime = SoraDGetChildByName(self, "Text_Number")
	self.resetTime = SoraDChangeTextToHtml(self.resetTime)
	self.btnQuest = SoraDGetChildByName(self, "Button_Question")
	self.btnQuest:addTouchEventListener(handler(self, self.btnClickQuestion))
	self.middleNode = SoraDGetChildByName(self, "Middle_Node")
	self.btnEntreat = SoraDGetChildByName(self.middleNode, "Btn_Entreat")
	self.btnEntreat:addTouchEventListener(handler(self, self.btnClickEntreat))
	self.textCoin = SoraDGetChildByName(self.btnEntreat, "Text_Coins", true)
	self.bottomWall = SoraDGetChildByName(self, "Node_Wall")
	self.downTips = SoraDGetChildByName(self, "Text_DownTips")
	self.downTips:setString(i18n("begging_text_04"))
	self:initAltar()
end
function devoutEntreatView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_DEVOUTENTREAT_INITDATA", handler(self, self.updateAltar))
end
function devoutEntreatView:initAltar()
	self:initTimer()
	self:initEffect()
	for i = 1, 8 do
		local _ENV, single
		devoutEntreatRead = nil
		;(nil)[1] = "Center_Node"
		;(nil)[2] = "singleNode_" .. i
		;(nil)[3] = "ItemShow"
		single.itemSelected = include("commonItemAward").new(SoraDGetChildByFullPath(self.middleNode, nil))
		single.itemSelected:setOwnView(self)
		devoutEntreatRead = self
		self[1] = "Center_Node"
		self[2] = "singleNode_" .. i
		self[3] = "ItemNormal"
		single.itemNormal = SoraDGetChildByFullPath(self.middleNode, self)
		devoutEntreatRead = self
		self[1] = "Center_Node"
		self[2] = "singleNode_" .. i
		self[3] = "ItemGet"
		single.itemGet = SoraDGetChildByFullPath(self.middleNode, self)
		_UPVALUE4_ = self
		self[1] = "Center_Node"
		self[2] = "singleNode_" .. i
		self[3] = "Door"
		self[4] = "Button_Change"
		single.btnSelectItem = SoraDGetChildByFullPath(self.middleNode, self)
		single.btnSelectItem:addTouchEventListener(handlerEx(self, self.btnClickSelectItem, i))
		_UPVALUE4_ = handlerEx(self, self.btnClickSelectItem, i)
		handlerEx(self, self.btnClickSelectItem, i)[1] = "Center_Node"
		handlerEx(self, self.btnClickSelectItem, i)[2] = "singleNode_" .. i
		handlerEx(self, self.btnClickSelectItem, i)[3] = "ItemNormal"
		handlerEx(self, self.btnClickSelectItem, i)[4] = "Button_item"
		single.btnSelect = SoraDGetChildByFullPath(self.middleNode, handlerEx(self, self.btnClickSelectItem, i))
		single.btnSelect:addTouchEventListener(handlerEx(self, self.btnClickSelectItem, i))
		single.itemStateType = stateType.normal
		single.itemInfo = nil
		SoraDMixtureGLONEByParent(single.itemNormal)
		self.altarTbl[i] = single
	end
	SoraDGetChildByName(self.btnBag, "image_IconBox"):loadTexture(itemDesRead.getIcon(devoutEntreatRead.getCostItemId()), ccui.TextureResType.plistType)
	SoraDGetChildByName(self.btnEntreat, "Image_Icon_Small", true):loadTexture(itemDesRead.getIcon(devoutEntreatRead.getCostItemId()), ccui.TextureResType.plistType)
	self:fitView()
end
function devoutEntreatView:initTimer()
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	self.activityTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PLEAD_ACTIVITY)
	if activityTime then
		self.activityTime:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
	local posX = SoraDFIsRA() and -(self.activityTime:getContentSize().width / 2 + 37) or self.activityTime:getContentSize().width / 2 + 7
	SoraDGetChildByName(self, "Sprite_time"):setPositionX(posX)
end
function devoutEntreatView:fitView()
	SoraDSetTextWidthHeight(self.downTips, cc.size(490, 165))
	self.downTips:setFontSize(18)
	self.bottomWall:setPositionY(self.bottomWall:getPositionY() + 5)
	local height = self:getPanelOffsetHeight() - 1000
	if 380 < height then
		SoraDGetChildByName(self, "Node_IphoneX"):setVisible(true)
		SoraDGetChildByName(self, "Node_Cloth"):setPositionY(-137)
		SoraDGetChildByName(self, "Top_Size_Right"):setPositionY(SoraDGetChildByName(self, "Top_Size_Right"):getPositionY() - 135)
		SoraDGetChildByName(self, "Top_Size_Left"):setPositionY(SoraDGetChildByName(self, "Top_Size_Left"):getPositionY() - 135)
		SoraDGetChildByName(self, "Statue_Left"):setContentSize(cc.size(108, 308))
		SoraDGetChildByName(self, "Statue_Right"):setContentSize(cc.size(108, 308))
		self.activityTime:setPositionY(self.activityTime:getPositionY() - 40)
		self.resetTime:setPositionY(self.resetTime:getPositionY() - 35)
		SoraDGetChildByName(self, "Sprite_time"):setPositionY(SoraDGetChildByName(self, "Sprite_time"):getPositionY() - 40)
		self.btnQuest:setPosition(self.btnQuest:getPositionX() - 20, self.btnQuest:getPositionY() - 55)
		SoraDGetChildByName(self, "Node_Wall"):setPositionY(SoraDGetChildByName(self, "Node_Wall"):getPositionY() + 30)
		self.middleNode:setPositionY(self.middleNode:getPositionY() + 40)
		self.btnEntreat:setPositionY(self.btnEntreat:getPositionY() - 10)
	end
	if height < 0 then
		height = height < -146 and -110 or height
		SoraDGetChildByName(self.middleNode, "Center_Node"):setScale(1 + height / 460)
		self.middleNode:setPositionY(self.middleNode:getPositionY() - 30)
		self.btnEntreat:setPositionY(self.btnEntreat:getPositionY() + 15)
	end
end
function devoutEntreatView:initEffect()
	_ENV, _UPVALUE6_ = nil, nil
	;(nil).posX = 24
	_ENV, (nil).posY = nil, 54
	;(nil).posX = 12
	_ENV, (nil).posY = nil, 54
	;(nil).posX = 17
	_ENV, (nil).posY = nil, 40
	;(nil).posX = 19
	_ENV, (nil).posY = nil, 40
	;(nil).posX = 27
	_ENV, (nil).posY = nil, 44
	;(nil).posX = 20
	;(nil).posY = 44
	_ENV, _UPVALUE6_, (nil)[1] = nil, nil, nil
	_ENV, _UPVALUE6_, (nil)[2] = nil, nil, nil
	_ENV, _UPVALUE6_, (nil)[3] = nil, nil, nil
	_ENV, _UPVALUE6_, (nil)[4] = nil, nil, nil
	_ENV, _UPVALUE6_, (nil)[5] = nil, nil, nil
	local _ENV, _UPVALUE6_, (nil)[6], candlePos
	;(nil).posX = 24
	_ENV, (nil).posY = nil, 54
	;(nil).posX = 138
	_ENV, (nil).posY = nil, 54
	;(nil).posX = 25
	_ENV, (nil).posY = nil, 53
	;(nil).posX = 142
	_ENV, (nil).posY = nil, 52
	;(nil).posX = 30
	_ENV, (nil).posY = nil, 59
	;(nil).posX = 157
	;(nil).posY = 59
	;(nil)[1] = nil
	;(nil)[2] = nil
	;(nil)[3] = nil
	;(nil)[4] = nil
	;(nil)[5] = nil
	local (nil)[6], firesPos
	for i = 1, 6 do
		local candleEffect = SoraDCreatAnimationEx("EntreatCandleEffect", nil, false)
		SoraDMixtureGLONEByParent(candleEffect)
		local action = candleEffect.action
		action:gotoFrameAndPause(114)
		if action and tolua.cast(action, "cc.Action") then
			action:setFrameEventCallFunc(handlerEx(self, self.candleCallBack, i))
		end
		local target = SoraDGetChildByName(self.middleNode, "frame_candle_" .. i)
		local node = display.newNode()
		node:addTo(target:getParent())
		local pos = cc.p(target:getPosition())
		local size = target:getContentSize()
		node:setPosition(cc.p(pos.x - size.width / 2, pos.y - size.height / 2))
		candleEffect:setPosition(candlePos[i].posX, candlePos[i].posY)
		node:addChild(candleEffect)
		SoraDGetChildByName(candleEffect, "Node_Small"):setVisible(false)
		if i == 5 or i == 6 then
			SoraDGetChildByName(candleEffect, "Node_Small"):setVisible(true)
			SoraDGetChildByName(candleEffect, "Node_Small"):setPositionX(i == 5 and -10 or 10)
		end
		self.candlesTbl[i] = candleEffect
	end
	self.doorEffect = SoraDGetChildByName(self.middleNode, "G_Effect")
	SoraDMixtureGLONE(self.doorEffect)
	self.copyDoor = self.doorEffect:clone()
	self.copyDoor:setPosition(self.doorEffect:getPosition())
	self.copyDoor:addTo(self.doorEffect:getParent())
	self.copyDoor:setVisible(true)
	self.copyDoor:setOpacity(0)
	SoraDMixtureGLONE(self.copyDoor)
	self.lightEffect = SoraDCreatAnimationEx("EntreatLightEffect", nil, false)
	SoraDMixtureGLONEByParent(self.lightEffect)
	self.lightEffect.action:gotoFrameAndPause(0)
	self.lightEffect:setVisible(false)
	self.lightEffect:setPosition(0, 0)
	self.lightEffect:addTo(SoraDGetChildByName(self, "Top_Node_Effect"))
	_UPVALUE16_ = self.lightEffect.addTo
	self.lightEffect.addTo[1] = 1
	self.lightEffect.addTo[2] = 2
	self.lightEffect.addTo[3] = 1
	self.lightEffect.addTo[4] = 2
	self.lightEffect.addTo[5] = 3
	self.lightEffect.addTo[6] = 4
	self.lightEffect.addTo[7] = 3
	self.lightEffect.addTo[8] = 4
	self.lightEffect.addTo[9] = 3
	self.lightEffect.addTo[10] = 4
	self.lightEffect.addTo[11] = 5
	self.lightEffect.addTo[12] = 6
	self.lightEffect.addTo[13] = 5
	self.lightEffect.addTo[14] = 6
	self.lightEffect.addTo[15] = 5
	local self.lightEffect.addTo[16], indextmp = 6, self.lightEffect.addTo
	for i = 1, 16 do
		local fireEffect = SoraDCreatAnimationEx("EntreatFireEffect", nil, false)
		SoraDMixtureGLONEByParent(fireEffect)
		local action = fireEffect.action
		action:gotoFrameAndPause(0)
		if action and tolua.cast(action, "cc.Action") then
			action:setFrameEventCallFunc(handlerEx(self, self.fireCallBack, i))
		end
		_UPVALUE3_ = handlerEx(self, self.fireCallBack, i)
		handlerEx(self, self.fireCallBack, i)[1] = "Center_Node"
		handlerEx(self, self.fireCallBack, i)[2] = "singleNode_" .. math.floor((i + 1) / 2)
		handlerEx(self, self.fireCallBack, i)[3] = "Door"
		local target = SoraDGetChildByFullPath(self.middleNode, handlerEx(self, self.fireCallBack, i))
		fireEffect:setPosition(firesPos[indextmp[i]].posX, firesPos[indextmp[i]].posY)
		target:addChild(fireEffect)
		self.firesTbl[i] = fireEffect
	end
	self.topNormalEffect = SoraDCreatAnimation("devoutNormalEffect", nil, true)
	SoraDMixtureGLONEByParent(self.topNormalEffect)
	self.topNormalEffect:setPosition(0, 0)
	self.topNormalEffect:addTo(SoraDGetChildByName(self, "Top_Normal_Effect"))
	self.resetLightEffect = SoraDCreatAnimationEx("devoutCanResetEffect", nil, false)
	self.resetLightEffect:setVisible(false)
	self.resetLightEffect.action:gotoFrameAndPause(0)
	if self.resetLightEffect.action and tolua.cast(self.resetLightEffect.action, "cc.Action") then
		self.resetLightEffect.action:setFrameEventCallFunc(function(frameEventName)
			local frameEvent = frameEventName:getEvent()
			print("frameEvent", frameEvent)
			if frameEvent and frameEvent == "HIDESHLF" then
				SoraDGetChildByName(self.resetLightEffect, "Node_Effect_qckq"):setVisible(false)
			end
		end)
	end
	SoraDMixtureGLONEByParent(self.resetLightEffect)
	self.resetLightEffect:setPosition(0, 0)
	self.resetLightEffect:addTo(SoraDGetChildByName(self, "Top_Reset_Effect"))
end
function devoutEntreatView:updateAltar(target, data)
	if data and data.reward then
		print("data.position", data.position)
		local index = 9 - data.position
		local itenParentNode = SoraDGetChildByName(self, "singleNode_" .. index)
		local itemEffect = SoraDCreatAnimation("devoutGetLightEffect", nil, false)
		SoraDMixtureGLONEByParent(itemEffect)
		itemEffect:setPosition(0, 0)
		itemEffect:addTo(itenParentNode)
		devoutEntreatCtrl = 0
		;(0)[1] = cca.delay(0.6666666666666666)
		;(0)[2] = cca.callFunc(function()
			itemEffect:removeFromParent()
			SoraDPopGainItem(data.reward[1].id, data.reward[1].count, false)
			self:updateAltar()
		end)
		;(0)[3] = cca.callFunc(function()
			itemEffect:removeFromParent()
			SoraDPopGainItem(data.reward[1].id, data.reward[1].count, false)
			self:updateAltar()
		end)
		itenParentNode:runAction(cca.seq(0))
		return
	end
	self.costItemInfo = devoutEntreatCtrl:getCostItemInfo()
	self.costItemNum = backpackCtrl:getItemCount(tonumber(devoutEntreatRead.getCostItemId())) or 0
	if self.activityState ~= devoutEntreatCtrl:getActivityState() then
		self.activityState = devoutEntreatCtrl:getActivityState()
		self:updateButton()
		if self.btnIsClick then
			if self.activityState == activityStateType.getState then
				self:showClickChangeEffect()
				self.btnIsClick = false
			elseif self.activityState == activityStateType.selectState then
				self.resetLightEffect.action:gotoFrameAndPause(0)
				self.resetLightEffect:setVisible(false)
				self:resetRotate(1)
				self:resetRotate(3)
				self:resetRotate(6)
				self.btnIsClick = false
				return
			else
				self.resetLightEffect:setVisible(true)
				self.resetLightEffect.action:gotoFrameAndPlay(0, 88, true)
				SoraDGetChildByName(self.resetLightEffect, "Node_Effect_qckq"):setVisible(true)
			end
		else
			self:updateEffect()
		end
	end
	self.textItemNum:setString(string.formatnumberthousands(self.costItemNum))
	self.textCoin:setString(string.formatnumberthousands(self.costItemInfo.count))
	if self.costItemInfo.count and self.costItemInfo.count <= self.costItemNum then
		self.textCoin:setTextColor(cc.c3b(255, 200, 0))
	else
		self.textCoin:setTextColor(cc.c3b(255, 0, 0))
	end
	local poolTbl = devoutEntreatCtrl:getPrizePoolTbl()
	for i, v in ipairs(self.altarTbl) do
		v.itemStateType = self.activityState == activityStateType.selectState and stateType.normal or stateType.selected
		v.itemStateType = poolTbl[tostring(9 - i)] and poolTbl[tostring(9 - i)].get and stateType.geted or v.itemStateType
		v.itemInfo = devoutEntreatRead.getItemInfo(poolTbl[tostring(9 - i)] and poolTbl[tostring(9 - i)].index)
		v.itemSelected:setVisible(false)
		v.btnSelectItem:setVisible(false)
		if v.itemInfo then
			v.itemSelected:setVisible(true)
			v.btnSelectItem:setVisible(v.itemStateType == stateType.normal)
			self:showNormalEffect(v.itemNormal, false)
			v.itemSelected:initData(v.itemInfo.id, v.itemInfo.count)
		else
			self:showNormalEffect(v.itemNormal, true)
		end
		v.itemGet:setScale(1)
		v.itemNormal:setVisible(v.itemStateType == stateType.normal and not v.itemInfo)
		v.itemGet:setVisible(v.itemStateType == stateType.geted)
		self.firesTbl[2 * i - 1]:setVisible(v.itemStateType == stateType.selected)
		self.firesTbl[2 * i]:setVisible(v.itemStateType == stateType.selected)
	end
end
function devoutEntreatView:updateButton()
	local textReset = SoraDGetChildByName(self.btnEntreat, "Text_Reset", true)
	self.textCoin:setVisible(self.activityState == activityStateType.getState)
	SoraDGetChildByName(self.btnEntreat, "Image_Icon_Small", true):setVisible(self.activityState == activityStateType.getState)
	textReset:setPositionY(42)
	if self.activityState == activityStateType.selectState then
		textReset:setString(i18n("begging_btn_01"))
		textReset:setFontSize(22)
	elseif self.activityState == activityStateType.getState then
		textReset:setPositionY(28)
		textReset:setFontSize(20)
		textReset:setString(i18n("begging_btn_02"))
	elseif self.activityState == activityStateType.resetState then
		textReset:setString(i18n("begging_btn_03"))
		textReset:setFontSize(22)
	end
end
function devoutEntreatView:updateEffect()
	self:showDoorEffect(false)
	if self.activityState == activityStateType.selectState then
		self.lightEffect:setVisible(false)
		for i, v in ipairs(self.candlesTbl) do
			v:setVisible(true)
			v.action:gotoFrameAndPlay(2 * (i - 1), 40, true)
		end
	else
		if self.activityState == activityStateType.resetState then
			self.resetLightEffect:setVisible(true)
			self.resetLightEffect.action:gotoFrameAndPlay(0, 88, true)
			SoraDGetChildByName(self.resetLightEffect, "Node_Effect_qckq"):setVisible(false)
		end
		self.lightEffect:setVisible(true)
		self.lightEffect.action:gotoFrameAndPause(100)
		_UPVALUE16_ = self.lightEffect.action.gotoFrameAndPause
		self.lightEffect.action.gotoFrameAndPause[1] = 255
		self.lightEffect.action.gotoFrameAndPause[2] = 220
		self.lightEffect.action.gotoFrameAndPause[3] = 185
		self.lightEffect.action.gotoFrameAndPause[4] = 150
		self.lightEffect.action.gotoFrameAndPause[5] = 248
		self.lightEffect.action.gotoFrameAndPause[6] = 213
		self.lightEffect.action.gotoFrameAndPause[7] = 178
		self.lightEffect.action.gotoFrameAndPause[8] = 143
		self.lightEffect.action.gotoFrameAndPause[9] = 241
		self.lightEffect.action.gotoFrameAndPause[10] = 204
		self.lightEffect.action.gotoFrameAndPause[11] = 171
		self.lightEffect.action.gotoFrameAndPause[12] = 234
		self.lightEffect.action.gotoFrameAndPause[13] = 199
		self.lightEffect.action.gotoFrameAndPause[14] = 164
		self.lightEffect.action.gotoFrameAndPause[15] = 227
		local self.lightEffect.action.gotoFrameAndPause[16], tmp = 192, self.lightEffect.action.gotoFrameAndPause
		for i, v in ipairs(self.firesTbl) do
			if self.candlesTbl[i] then
				self.candlesTbl[i]:setVisible(false)
			end
			v.action:gotoFrameAndPlay(tmp[i] - 77, tmp[i], true)
		end
	end
end
function devoutEntreatView:btnClickOpenBag(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:jumpToGift(MSGBOX_CALLBACK_YES)
	end
end
function devoutEntreatView:btnClickQuestion(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).Num1 = devoutEntreatRead.getGroupNum(devoutEntreatCtrl:getClassType(), 3)
		;(nil).Num2 = devoutEntreatRead.getGroupNum(devoutEntreatCtrl:getClassType(), 2)
		;(nil).Num3 = devoutEntreatRead.getGroupNum(devoutEntreatCtrl:getClassType(), 1)
		SoraDShowHelpMsgTip(i18n("begging_text_05", nil))
	end
end
function devoutEntreatView:btnClickSelectItem(index, button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("devoutSelectView")
		panel:initData(index)
		panel:show()
	end
end
function devoutEntreatView:btnClickEntreat(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.activityState == activityStateType.selectState then
			if devoutEntreatCtrl:isCanBeginEntreat() then
				SoraDShowMsgBox(i18n("begging_tips_02"), i18n("common_text_054"), i18n("common_text_185"), function(type)
					if type == MSGBOX_CALLBACK_YES then
						self.btnIsClick = true
						devoutEntreatCtrl:sendBeginEntreatMsg()
					end
				end)
			else
				SoraDShowMsgTip(i18n("begging_tips_01"))
			end
		elseif self.activityState == activityStateType.getState then
			if self.costItemInfo.count <= self.costItemNum then
				self.btnEntreat:setTouchEnabled(false)
				self.btnIsClick = true
				devoutEntreatCtrl:sendPleadMsg()
				activityStateType = devoutEntreatCtrl
				devoutEntreatCtrl[1] = cca.delay(1)
				devoutEntreatCtrl[2] = cca.callFunc(function()
					self.btnEntreat:setTouchEnabled(true)
				end)
				devoutEntreatCtrl[3] = cca.callFunc(function()
					self.btnEntreat:setTouchEnabled(true)
				end)
				devoutEntreatCtrl[4] = cca.callFunc(function()
					self.btnEntreat:setTouchEnabled(true)
				end)
				devoutEntreatCtrl[5] = cca.callFunc(function()
					self.btnEntreat:setTouchEnabled(true)
				end)
				local seq = cca.seq(devoutEntreatCtrl)
				button:runAction(seq)
			else
				SoraDShowMsgBox(i18n("begging_tips_03"), i18n("common_text_054"), i18n("common_text_185"), handler(self, self.jumpToGift))
			end
		elseif self.activityState == activityStateType.resetState then
			if devoutEntreatCtrl:getLeftResetCont() > 0 then
				SoraDShowMsgBox(i18n("begging_tips_04"), i18n("common_text_054"), nil, function(type)
					if type == MSGBOX_CALLBACK_YES then
						self.btnEntreat:setTouchEnabled(false)
						self.btnIsClick = true
						devoutEntreatCtrl:sendResetMsg()
					end
				end)
			else
				SoraDShowMsgTip(i18n("begging_tips_05"))
			end
		end
	end
end
function devoutEntreatView:jumpToGift(type)
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
function devoutEntreatView:getGiftInfo()
	local idTbl = IsArClient and giftID.kohGift or giftID.rosGift
	local giftInfo = rechargeActivityCtrl:getHotActivityList()
	for i = 5, 1, -1 do
		local item = giftInfo[tostring(idTbl[i])]
		if item and 1 <= tonumber(item.extraData) then
			return item
		end
	end
end
function devoutEntreatView:candleCallBack(index, frameEventName)
	local frameEvent = frameEventName:getEvent()
	local candleEffect = self.candlesTbl[index + 2]
	if candleEffect and frameEvent then
		if frameEvent == "SHOWNEXT" then
			candleEffect.action:gotoFrameAndPlay(40, 114, false)
		elseif frameEvent == "SHOWEND" then
			candleEffect:setVisible(false)
		end
	end
end
function devoutEntreatView:fireCallBack(index, frameEventName)
	_UPVALUE16_ = nil
	;(nil)[1] = 255
	;(nil)[2] = 220
	;(nil)[3] = 185
	;(nil)[4] = 150
	;(nil)[5] = 248
	;(nil)[6] = 213
	;(nil)[7] = 178
	;(nil)[8] = 143
	;(nil)[9] = 241
	;(nil)[10] = 204
	;(nil)[11] = 171
	;(nil)[12] = 234
	;(nil)[13] = 199
	;(nil)[14] = 164
	;(nil)[15] = 227
	local (nil)[16], tmp = 192, nil
	local frameEvent = frameEventName:getEvent()
	if frameEvent and frameEvent == "SHOWNEXT" then
		local candleEffect = self.firesTbl[index + 6]
		if candleEffect then
			candleEffect.action:gotoFrameAndPlay(0, 65, false)
		end
		if index == 1 or index == 2 then
			candleEffect = self.firesTbl[index + 4]
			if candleEffect then
				candleEffect.action:gotoFrameAndPlay(0, 65, false)
			end
		end
	elseif frameEvent and frameEvent == "LOOPING" then
		local candleEffect = self.firesTbl[index]
		if candleEffect then
			candleEffect.action:gotoFrameAndPlay(tmp[index] - 77, tmp[index], true)
		end
	end
end
function devoutEntreatView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PLEAD_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function devoutEntreatView:showClickChangeEffect()
	self:showDoorEffect(true)
	self.lightEffect:setVisible(true)
	self.lightEffect.action:gotoFrameAndPlay(0, 100, false)
	self.candlesTbl[1].action:gotoFrameAndPlay(40, 114, false)
	self.candlesTbl[2].action:gotoFrameAndPlay(40, 114, false)
	self.firesTbl[1].action:gotoFrameAndPlay(0, 65, false)
	self.firesTbl[2].action:gotoFrameAndPlay(0, 65, false)
	self.firesTbl[3].action:gotoFrameAndPlay(0, 65, false)
	self.firesTbl[4].action:gotoFrameAndPlay(0, 65, false)
end
function devoutEntreatView:showClickResetEffect()
	self:showDoorEffect(false)
	self.lightEffect:setVisible(false)
	for i, v in ipairs(self.candlesTbl) do
		v:getParent():stopAllActions()
		_UPVALUE1_ = v:getParent()
		v:getParent()[1] = cca.delay(10 * ((i - 1) / 2) / 60)
		v:getParent()[2] = cca.callFunc(function()
			v:setVisible(true)
			v.action:gotoFrameAndPlay(2 * i, 35, true)
		end)
		v:getParent()[3] = cca.callFunc(function()
			v:setVisible(true)
			v.action:gotoFrameAndPlay(2 * i, 35, true)
		end)
		local seq = cca.seq((v:getParent()))
		v:getParent():runAction(seq)
	end
end
function devoutEntreatView:showNormalEffect(target, ret)
	local effectO = SoraDGetChildByName(target, "G_TextureO")
	local effectR = SoraDGetChildByName(target, "G_TextureR")
	effectO:stopAllActions()
	effectR:stopAllActions()
	effectR:setRotation(0)
	effectO:setOpacity(51.0)
	if ret then
		_UPVALUE1_ = effectO
		effectO[1] = cca.fadeTo(0.6666666666666666, 0.6)
		effectO[2] = cca.fadeTo(0.6666666666666666, 0.2)
		effectO[3] = cca.fadeTo(0.6666666666666666, 0.2)
		effectO[4] = cca.fadeTo(0.6666666666666666, 0.2)
		effectO[5] = cca.fadeTo(0.6666666666666666, 0.2)
		effectO[6] = cca.fadeTo(0.6666666666666666, 0.2)
		local seq = cca.seq(effectO)
		effectO:runAction(cc.RepeatForever:create(seq))
		effectR:runAction(cc.RepeatForever:create(cca.rotateBy(2.6666666666666665, 360)))
	end
end
function devoutEntreatView:showDoorEffect(ret)
	self.doorEffect:setVisible(false)
	self.copyDoor:stopAllActions()
	self.copyDoor:setOpacity(0)
	if ret then
		_UPVALUE2_ = self.copyDoor
		self.copyDoor[1] = cca.delay(0.4166666666666667)
		self.copyDoor[2] = cca.fadeTo(0.16666666666666666, 1)
		self.copyDoor[3] = cca.fadeTo(0.75, 0)
		self.copyDoor[4] = cca.fadeTo(0.75, 0)
		self.copyDoor[5] = cca.fadeTo(0.75, 0)
		local seq = cca.seq(self.copyDoor)
		self.copyDoor:runAction(seq)
	end
end
function devoutEntreatView:resetRotate(i)
	local speed = 0.11
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(speed, 0.01, 1)
	;(nil)[2] = cca.callFunc(function()
		self:effectCallback(i, speed)
	end)
	;(nil)[3] = cca.callFunc(function()
		self:effectCallback(i, speed)
	end)
	;(nil)[4] = cca.callFunc(function()
		self:effectCallback(i, speed)
	end)
	;(nil)[5] = cca.callFunc(function()
		self:effectCallback(i, speed)
	end)
	local seq = cca.seq(nil)
	self.altarTbl[i].itemSelected:runAction(cca.scaleTo(speed, 0.01, 1))
	self.altarTbl[i].itemGet:runAction(seq)
end
function devoutEntreatView:effectCallback(index, speed)
	self.altarTbl[index].itemGet:setVisible(false)
	self.altarTbl[index].itemSelected:setScale(0.01)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(speed, 1, 1)
	;(nil)[2] = cca.callFunc(function()
		if index == 5 or index == 8 then
			self:updateAltar()
			self:showClickResetEffect()
			self.btnEntreat:setTouchEnabled(true)
			return
		elseif index == 2 then
			return
		end
		self:resetRotate(index + 1)
	end)
	;(nil)[3] = cca.callFunc(function()
		if index == 5 or index == 8 then
			self:updateAltar()
			self:showClickResetEffect()
			self.btnEntreat:setTouchEnabled(true)
			return
		elseif index == 2 then
			return
		end
		self:resetRotate(index + 1)
	end)
	;(nil)[4] = cca.callFunc(function()
		if index == 5 or index == 8 then
			self:updateAltar()
			self:showClickResetEffect()
			self.btnEntreat:setTouchEnabled(true)
			return
		elseif index == 2 then
			return
		end
		self:resetRotate(index + 1)
	end)
	self.altarTbl[index].itemSelected:runAction(cca.seq(nil))
end
return devoutEntreatView
