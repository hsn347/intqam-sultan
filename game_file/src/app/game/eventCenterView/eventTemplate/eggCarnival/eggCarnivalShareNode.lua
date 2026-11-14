local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local eggCarnivalRead = include("eggCarnivalRead")
local paintedEggCrazyCtrl = SoraDGetCtrl("paintedEggCrazyCtrl")
local eggCarnivalShareNode = class("eggCarnivalShareNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end)
_ENV = "eggCarnivalShareNode"
;("eggCarnivalShareNode").sharePoint = 1
local _ENV, ("eggCarnivalShareNode").happyPoint, scrollType = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end, 2, "eggCarnivalShareNode"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end).noReach = 1
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end).noClaim = 2
local (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end).claimed, giftStatus = 3, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("eggCarnivalShareNode")
end
function eggCarnivalShareNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.PAINTED_EGG_CRAZY_ACTIVITY
	self.mergeItem = 838301
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeLeftSingle = SoraDGetChildByName(self, "Node_Left_Single")
	self.nodeRightSingle = SoraDGetChildByName(self, "Node_Right_Single")
	self.scrollLeft = SoraDGetChildByName(self, "Top_Size_ScrollPoint_Left")
	self.scrollLeft = include("commonAutoScrollList").new(self.scrollLeft)
	self.scrollLeft:setSingleCreate(handler(self, self.createLeftSingle))
	self.scrollLeft:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.scrollRight = SoraDGetChildByName(self, "Top_Size_ScrollPoint_Right")
	self.scrollRight = include("commonAutoScrollList").new(self.scrollRight)
	self.scrollRight:setSingleCreate(handler(self, self.createRightSingle))
	self.scrollRight:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.btnShareRank = SoraDGetChildByName(self, "Button_ShareRank")
	self.btnShareRank:setTitleText(i18n("madeleine_feast_text_11"))
	self.btnShareRank:setTag(gDinnerShareType.SHARE)
	self.btnShareRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.btnHappyRank = SoraDGetChildByName(self, "Button_HappyRank")
	self.btnHappyRank:setTitleText(i18n("madeleine_feast_text_13"))
	self.btnHappyRank:setTag(gDinnerShareType.HAPPINESS)
	self.btnHappyRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.leftFrame = SoraDGetChildByName(self, "frame_base_Left")
	self.rightFrame = SoraDGetChildByName(self, "frame_base_Right")
	SoraDGetChildByName(self.leftFrame, "Text_Title"):setString(i18n("madeleine_feast_name_01"))
	SoraDGetChildByName(self.rightFrame, "Text_Title"):setString(i18n("madeleine_feast_name_02"))
	self.textShareP = SoraDGetChildByName(self.leftFrame, "Text_Point")
	self.textShareR = SoraDGetChildByName(self.leftFrame, "Text_Rank")
	self.textHappyP = SoraDGetChildByName(self.rightFrame, "Text_Point")
	self.textHappyR = SoraDGetChildByName(self.rightFrame, "Text_Rank")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.btnLog = SoraDGetChildByName(self, "Button_Log")
	self.btnLog:setTitleText(i18n("madeleine_feast_title_03"))
	self.btnLog:addTouchEventListener(handler(self, self.btnLogClick))
	self.btnShare = SoraDGetChildByName(self, "Button_Share")
	self.btnShare:setTitleText(i18n("madeleine_feast_btn_01"))
	self.btnShare:addTouchEventListener(handler(self, self.btnShareClick))
	self.textNum = SoraDGetChildByName(self, "Text_Num")
	self:initData()
end
function eggCarnivalShareNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateTextNum))
	SoraDAddMessage(self, "MESSAGE_SERVER_MADELE_MAKEBACK", handler(self, self.updataData))
end
function eggCarnivalShareNode:initEffect()
	SoraDGetChildByName(self, "Particle_18"):setAutoCull(false)
	SoraDGetChildByName(self, "Particle_11"):setAutoCull(false)
	SoraDGetChildByName(self, "Particle_6"):setAutoCull(false)
	local loop = true
	local cssFilePath = getCCSPath("eggCarnivalShareNode")
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	SoraDGetChildByName(self, "Image_Bg"):setContentSize(cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)))
	_ENV, _UPVALUE10_ = SoraDGetChildByName(self, "Image_Bg"), SoraDGetChildByName(self, "Image_Bg").setContentSize
	_ENV, SoraDGetChildByName(self, "Image_Bg").name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = "frame_cddkh_bk05"
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).scale = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = "frame_cddkh_zs01"
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).scale = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	_ENV, cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).name = "frame_tree_zhuangshi03"
	cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400)).scale = -1
	SoraDGetChildByName(self, "Image_Bg").setContentSize[1] = SoraDGetChildByName(self, "Image_Bg")
	SoraDGetChildByName(self, "Image_Bg").setContentSize[2] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[3] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[4] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[5] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[6] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[7] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[8] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	SoraDGetChildByName(self, "Image_Bg").setContentSize[9] = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	local SoraDGetChildByName(self, "Image_Bg").setContentSize[10], skelList = cc.size(640, math.max(742.0, self:getPanelOffsetHeight() - 400))
	for i, v in ipairs(skelList) do
		local spine_zs05 = sp.SkeletonAnimation:create(string.format("spine/%s.skel", v.name), string.format("spine/%s.atlas", v.name), 1)
		if v.scale then
			spine_zs05:setScaleX(v.scale)
		end
		spine_zs05:setAnimation(0, "animation", true)
		spine_zs05:addTo(SoraDGetChildByName(self, "Node_spine_" .. i))
	end
end
function eggCarnivalShareNode:initData(target, data)
	self:initEffect()
	self:initActivityTime()
	self:updataData()
end
function eggCarnivalShareNode:updataData(...)
	_ENV = nil
	;(nil).num = string.formatnumberthousands(paintedEggCrazyCtrl:getMyPoints(scrollType.sharePoint))
	self.textShareP:setString(i18n("common_text_2556", nil))
	_ENV = i18n("common_text_2556", nil)
	i18n("common_text_2556", nil).rank = paintedEggCrazyCtrl:getShareRank()
	self.textShareR:setString(i18n("common_text_3409", i18n("common_text_2556", nil)))
	_ENV = i18n("common_text_3409", i18n("common_text_2556", nil))
	i18n("common_text_3409", i18n("common_text_2556", nil)).num = string.formatnumberthousands(paintedEggCrazyCtrl:getMyPoints(scrollType.happyPoint))
	self.textHappyP:setString(i18n("common_text_2556", i18n("common_text_3409", i18n("common_text_2556", nil))))
	_ENV = i18n("common_text_2556", i18n("common_text_3409", i18n("common_text_2556", nil)))
	i18n("common_text_2556", i18n("common_text_3409", i18n("common_text_2556", nil))).rank = paintedEggCrazyCtrl:getHappyRank()
	self.textHappyR:setString(i18n("common_text_3409", i18n("common_text_2556", i18n("common_text_3409", i18n("common_text_2556", nil)))))
	self:updateTextNum()
	self:updateScroll()
end
function eggCarnivalShareNode:updateTextNum(...)
	local itemNum = backpackCtrl:getItemCount(self.mergeItem)
	backpackCtrl = nil
	;(nil).num = string.formatnumberthousands(itemNum)
	self.textNum:setString(i18n("common_text_063", nil))
end
function eggCarnivalShareNode:updateScroll()
	local infoData = eggCarnivalRead.getRankOrPointRewardData(scrollType.sharePoint, false)
	eggCarnivalRead = nil
	;(nil).scrollType = scrollType.sharePoint
	self.scrollLeft:updateScrollView(cc.size(290, 190), infoData, 1, nil)
	self.scrollLeft:jumpToPercentVertical(self:getFirstCanGetIndex(infoData, scrollType.sharePoint, self.scrollLeft))
	infoData = eggCarnivalRead.getRankOrPointRewardData(scrollType.happyPoint, false)
	eggCarnivalRead = self:getFirstCanGetIndex(infoData, scrollType.sharePoint, self.scrollLeft)
	self:getFirstCanGetIndex(infoData, scrollType.sharePoint, self.scrollLeft).scrollType = scrollType.happyPoint
	self.scrollRight:updateScrollView(cc.size(290, 190), infoData, 1, self:getFirstCanGetIndex(infoData, scrollType.sharePoint, self.scrollLeft))
	self.scrollRight:jumpToPercentVertical(self:getFirstCanGetIndex(infoData, scrollType.happyPoint, self.scrollRight))
end
function eggCarnivalShareNode:nodeSingleRefresh(parent, infoData, otherData)
	local myPoint = paintedEggCrazyCtrl:getMyPoints(otherData.scrollType)
	local itemIcon = SoraDGetChildByName(parent, "Sprite_Icon")
	itemIcon:setSpriteFrame(publicRead.getIcon(self.mergeItem))
	local textPoint = SoraDGetChildByName(parent, "Text_Point")
	textPoint:setString(string.formatnumberthousands(infoData.score))
	local btnItem = SoraDGetChildByName(parent, "Button_ItemClick")
	btnItem:setSwallowTouches(false)
	btnItem:setTag(otherData.scrollType)
	btnItem:addTouchEventListener(handlerEx(self, self.btnClickGetReward, infoData))
	local isAlreadyGet = paintedEggCrazyCtrl:isPointsGet(otherData.scrollType .. "_" .. infoData.score)
	local canGetPoint = myPoint >= infoData.score
	if canGetPoint then
		if isAlreadyGet then
			infoData.statu = giftStatus.claimed
		else
			infoData.statu = giftStatus.noClaim
		end
	else
		infoData.statu = giftStatus.noReach
	end
	local colorT = not canGetPoint and cc.c3b(120, 120, 120) or cc.c3b(255, 255, 255)
	local frames = display.newFrames("dh_caidan2_0%.2d.png", 0, 14)
	local animation = display.newAnimation(frames, 0.11666666666666667)
	SoraDGetChildByName(parent, "Sprite_1"):stopAllActions()
	SoraDGetChildByName(parent, "Sprite_1"):playAnimationForever(animation)
	SoraDMixtureGLONE(SoraDGetChildByName(parent, "Sprite_1"))
	local nodeCanGet = SoraDGetChildByName(parent, "Node_Canget")
	nodeCanGet:setVisible(canGetPoint and not isAlreadyGet)
	SoraDGetChildByName(parent, "Image_Got"):setVisible(isAlreadyGet)
	SoraDSetGray(itemIcon, isAlreadyGet)
	itemIcon:setColor(colorT)
end
function eggCarnivalShareNode:initActivityTime()
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
function eggCarnivalShareNode:createLeftSingle()
	return self.nodeLeftSingle:clone()
end
function eggCarnivalShareNode:createRightSingle()
	return self.nodeRightSingle:clone()
end
function eggCarnivalShareNode:getFirstCanGetIndex(infoData, scrollType, parent)
	local myPoint = paintedEggCrazyCtrl:getMyPoints(scrollType)
	local paintedEggCrazyCtrl, retTable = paintedEggCrazyCtrl, paintedEggCrazyCtrl
	local num = #infoData
	local index = 1
	for i = 1, num do
		if myPoint >= infoData[i].score and not paintedEggCrazyCtrl:isPointsGet(scrollType .. "_" .. infoData[i].score) then
			index = i
		end
	end
	local percent = 0
	local itemHeight = 190
	local totalHeight = 190 * num
	local scrollHeight = parent:getContentSize().height
	if 0 < totalHeight - scrollHeight then
		percent = (index - 1) * itemHeight / (totalHeight - scrollHeight)
	else
		return 0
	end
	return percent * 100
end
function eggCarnivalShareNode:btnRankClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("eggCarnivalRankView")
		panel:initData(tonumber(tag))
		panel:show()
	end
end
function eggCarnivalShareNode:btnLogClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("eggCarnivalLogView")
		panel:show()
	end
end
function eggCarnivalShareNode:btnShareClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = uiManager:show("LordSelectView").view
		panel:setSearchNeedLv(CASTLE_LV10_LIMITED)
		panel:setTitleText(i18n("easterEgg_title_02"))
		panel:initData(gSearchStyle.ALLIANCE, 1, i18n("common_text_533"))
		panel:setSearchType(gSearchStyle.LORD_ALL_WORLD)
		panel:setHandle(handler(self, self.btnClickGive))
		panel:setCloseSelfType(false)
	end
end
function eggCarnivalShareNode:btnClickGive(tableUID, num, parent)
	SoraDPlaySound()
	local uid = tableUID[1]
	local count = backpackCtrl:getItemCount(self.mergeItem)
	if count <= 0 then
		local panel = SoraDCreatePanel("commonPromptBox")
		_ENV = nil
		;(nil).msg = i18n("easterEgg_text_04")
		;(nil).yes = i18n("common_text_477")
		panel:initData(nil)
		panel:setHandle(function(type)
			if type == MSGBOX_CALLBACK_YES then
				self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
				parent:removeFromParent()
			end
			panel:removeFromParent()
		end)
		panel:show()
		return
	end
	_ENV, _ENV = i18n("common_text_477"), function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end
	i18n("common_text_477").id = itemID
	;(function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end).itemData, i18n("common_text_477").count = i18n("common_text_477"), count
	;(function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end).msg = i18n("easterEgg_text_03")
	;(function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end).btnTitle = i18n("common_text_533")
	;(function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end).handle = function(targe, data)
		paintedEggCrazyCtrl = nil
		;(nil).receiveUid = uid
		;(nil).count = data.num
		paintedEggCrazyCtrl:sendReqGive(nil)
	end
	uiManager:show("newItemSingleUse", function(type)
		if type == MSGBOX_CALLBACK_YES then
			self.tabBtn:btnTabClick(self.tabBtn.tabArray[1], ccui.TouchEventType.ended, true)
			parent:removeFromParent()
		end
		panel:removeFromParent()
	end)
end
function eggCarnivalShareNode:btnClickGetReward(info, button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if button:getTag() == scrollType.happyPoint then
			if not SoraDIsNodeVisibleOnScroll(button, self.scrollRight) then
				return
			end
		elseif button:getTag() == scrollType.sharePoint and not SoraDIsNodeVisibleOnScroll(button, self.scrollLeft) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("madeleRewardView")
		panel:setCallBack(handler(self, self.reqGetReward))
		panel:initData(button:getTag(), info)
		panel:hideStar()
		panel:show()
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function eggCarnivalShareNode:reqGetReward(data)
	paintedEggCrazyCtrl:reqPaintedEggCrazyShareReceivePointReward(data)
end
function eggCarnivalShareNode:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function eggCarnivalShareNode:setTabBtnView(target)
	self.tabBtn = target
end
return eggCarnivalShareNode
