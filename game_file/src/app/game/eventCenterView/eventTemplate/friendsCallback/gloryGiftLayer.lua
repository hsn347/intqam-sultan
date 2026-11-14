local CBI = include("commonBtnInstance")
local RKC = require_data("return_kinggift_config", true)
local itemDesRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").hero = 3
;("publicRead").resource = 1
local _ENV, ("publicRead").decoration, GLORY_SET_ENUM = nil, 2, "publicRead"
;(nil)[1] = "frame_wzzl_yxtc_%s.png"
;(nil)[2] = "frame_wzzl_zbtc_%s.png"
local _ENV, (nil)[3], GLORY_SET_ICON = nil, "frame_wzzl_zytc_%s.png", nil
;(nil)[0] = "hero"
;(nil)[10] = "resource"
;(nil)[20] = "decoration"
;(nil)[30] = "hero"
;(nil)[40] = "resource"
;(nil)[50] = "decoration"
local _ENV, (nil)[60], FRAME_KEY_TO_ENUM = nil, "hero", nil
_UPVALUE3_, _ENV = nil, nil
_UPVALUE3_, (nil).left, (nil)[1] = nil, nil, 0
_UPVALUE3_, (nil).left, (nil)[2] = nil, nil, 10
_UPVALUE3_, (nil).left, (nil)[3] = nil, nil, GLORY_SET_ENUM.resource
;(nil)[GLORY_SET_ENUM.hero], (nil).right, (nil)[1] = nil, nil, 30
;(nil)[GLORY_SET_ENUM.hero], (nil).right, (nil)[2] = nil, nil, 40
;(nil)[GLORY_SET_ENUM.hero], (nil).right, (nil)[3] = nil, nil, GLORY_SET_ENUM.decoration
_UPVALUE3_, _ENV = nil, nil
_UPVALUE3_, (nil).left, (nil)[1] = nil, nil, 10
_UPVALUE3_, (nil).left, (nil)[2] = nil, nil, 20
_UPVALUE3_, (nil).left, (nil)[3] = nil, nil, GLORY_SET_ENUM.decoration
;(nil)[GLORY_SET_ENUM.resource], (nil).right, (nil)[1] = nil, nil, 50
;(nil)[GLORY_SET_ENUM.resource], (nil).right, (nil)[2] = nil, nil, 60
;(nil)[GLORY_SET_ENUM.resource], (nil).right, (nil)[3] = nil, nil, GLORY_SET_ENUM.hero
_UPVALUE3_, _ENV = nil, nil
_UPVALUE3_, (nil).left, (nil)[1] = nil, nil, 20
_UPVALUE3_, (nil).left, (nil)[2] = nil, nil, 30
_UPVALUE3_, (nil).left, (nil)[3] = nil, nil, GLORY_SET_ENUM.hero
;(nil)[GLORY_SET_ENUM.decoration], (nil).right, (nil)[1] = nil, nil, 40
;(nil)[GLORY_SET_ENUM.decoration], (nil).right, (nil)[2] = nil, nil, 50
;(nil)[GLORY_SET_ENUM.decoration], (nil).right, (nil)[3] = nil, nil, GLORY_SET_ENUM.resource
local SET_ANI_CFG
local MAX_CLOCKWISE = 30
local MAX_COUNTER_CLOCKWISE = 60
local GloryGiftLayer = class("GloryGiftLayer", function(target)
	if target == nil then
		return SoraDCreateBasePanel("GloryGiftLayer")
	end
	return target
end)
function GloryGiftLayer:ctor()
	self:setSelectKey(GLORY_SET_ENUM.hero)
	self.isHideCurrentSceneView = true
	self:setBackGround(0)
	self:setSwallowTouches(false)
	self.infoBtn = CBI.new(SoraDGetChildByName(self, "Button_info"))
	self.infoBtn:setHandle(handler(self, self.btnInfoCallBack))
	self.icon_tip = SoraDGetChildByName(self, "icon_tip")
	self.item_num = SoraDGetChildByName(self, "item_num")
	self.topTimeNode = SoraDGetChildByName(self, "time_node")
	self.rewardNode = SoraDGetChildByName(self, "reward_node")
	SoraDGetChildByName(self, "top_tips"):setString(i18n("return_wzzl_text_007"))
	SoraDGetChildByName(self, "exchange_set_tips"):setString(i18n("return_wzzl_text_008"))
	local exchangeItemTips = SoraDGetChildByName(self, "exchange_item_tips")
	exchangeItemTips:setString(i18n("return_wzzl_text_009"))
	self.limitLabel = SoraDChangeTextToHtml(SoraDGetChildByName(self, "exchange_tips"))
	self.addItemBtn = CBI.new(SoraDGetChildByName(self, "btn_add"))
	self.addItemBtn:setHandle(handler(self, self.btnAddItemCallBack))
	self.addItemBtn:setTitleText(i18n("hero_ceremony_text_08"))
	self.btnExchange = CBI.new(SoraDGetChildByName(self, "btn_exchange"))
	self.btnExchange:setHandle(handler(self, self.btnExchangeCallBack))
	local exchangeBtnName = SoraDGetChildByName(self.btnExchange, "exchange_name")
	exchangeBtnName:setString(i18n("common_text_1889"))
	self.goldLabel = SoraDGetChildByName(self.btnExchange, "goldLabel")
	self.btnItemIcon = SoraDGetChildByName(self.btnExchange, "icon_small_gold_33")
	self.itemNode = SoraDGetChildByName(self, "reward_node")
	self.Text_time = SoraDCreateTimerLabel(self, SoraDGetChildByName(self, "time_label"))
	local eventTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.FRIEND_HONORBACK)
	if eventTime then
		self.Text_time:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("common_text_766", nil)
		end)
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.giftTouchPanel = SoraDGetChildByName(self, "touch_panel")
	self.giftTouchPanel:addTouchEventListener(handler(self, self.btnSetCallBack))
	self.giftTouchPanel:setLocalZOrder(99)
	self.nodeList, GLORY_SET_ENUM, self.centerPos = cc.p(0, 0), cc.p(0, 0), cc.p(0, 0)
	local isAr = SoraDFIsRA()
	for k, v in pairs(GLORY_SET_ENUM) do
		local tmpNode = SoraDGetChildByName(self, k .. "_node")
		self.nodeList[k] = tmpNode
		local iconPath
		local iconNode = tmpNode:getChildByName(string.format("frame_%s_en", k))
		iconNode:setVisible(not isAR)
		if userSDKManager.isKO() and GameLanguageCopy == "ko" then
			iconPath = string.format(GLORY_SET_ICON[v], "ko")
			iconNode:setSpriteFrame(iconPath)
		end
		tmpNode:getChildByName(string.format("frame_%s_ar", k)):setVisible(isAR)
	end
	self.redPoint = SoraDGetChildByName(self.addItemBtn, "red_point")
	self:initHeroSpine()
	local btnLeft = SoraDGetChildByName(self, "btn_left")
	btnLeft:addTouchEventListener(handlerEx(self, self.btnSwitchClick, true))
	local btnRight = SoraDGetChildByName(self, "btn_right")
	btnRight:addTouchEventListener(handlerEx(self, self.btnSwitchClick, false))
	self:initAni()
end
function GloryGiftLayer:initAni()
	local node = SoraDGetChildByName(self, "FileNode_3")
	local action = node:getActionByTag(node:getTag())
	action:gotoFrameAndPlay(0, 180, true)
	node = SoraDGetChildByName(self, "FileNode_4")
	local aniName = "animation0"
	local action = node:getActionByTag(node:getTag())
	action:gotoFrameAndPlay(0, 195, true)
	node = SoraDGetChildByName(self, "FileNode_1")
	local aniName = "animation0"
	local action = node:getActionByTag(node:getTag())
	action:gotoFrameAndPlay(0, 208, true)
	local leftAniTmp = SoraDGetChildByName(node, "Sprite_6")
	SoraDMixtureGLONE(leftAniTmp)
	SoraDMixtureGLONE(SoraDGetChildByName(node, "Sprite_6_0"))
	node = SoraDGetChildByName(self, "FileNode_5")
	local aniName = "animation0"
	local action = node:getActionByTag(node:getTag())
	action:gotoFrameAndPlay(0, 60, true)
end
function GloryGiftLayer:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK", handler(self, self.udpateView))
end
function GloryGiftLayer:initHeroSpine()
	local spine_node = SoraDGetChildByName(self, "spine_node")
	local spine_npc = sp.SkeletonAnimation:create("spine/frame_wzzl_hero_02.skel", "spine/frame_wzzl_hero_02.atlas", 1)
	spine_npc:setAnimation(0, "animation", true)
	spine_npc:addTo(spine_node, 99)
end
function GloryGiftLayer:setSize(size)
	self:setPositionY(size.height / 2)
	self:setContentSize(size)
	local offset = math.max(size.height, 960)
	local top = SoraDGetChildByName(self, "img_bg_top")
	top:setPositionY(offset - 60)
	local left = SoraDGetChildByName(self, "img_bg_left")
	left:setPositionY(offset)
	left:setContentSize(cc.size(120, offset - 160))
	local right = SoraDGetChildByName(self, "img_bg_right")
	right:setPositionY(offset)
	right:setContentSize(cc.size(120, offset - 160))
	if device.model == "ipad" or device.model == "ipad retina" then
		self:setAnchorPoint(cc.p(0, 0))
		self:setPosition(100, 0)
		self:setScale(0.7)
		SoraDGetChildByName(self, "Top_Size_Bg_King"):setScale(1.4285714285714286)
		SoraDGetChildByName(self, "Top_Size_Bg_King"):setPositionY(960)
		SoraDGetChildByName(self, "bg_node"):setScale(1.4285714285714286)
		SoraDGetChildByName(self, "bg_node"):setPositionX(-140)
	else
		self.topTimeNode:setPositionY(size.height + 30)
	end
end
function GloryGiftLayer:udpateView()
	self:updateReward()
	local hbCtrl = SoraDGetCtrl("honorBackCtrl")
	local shopItemID = tostring(self.itemData.shopItemID)
	local buyNum = hbCtrl.exchangeData[shopItemID] or 0
	local leftNum = self.itemData.limitNum - buyNum
	local color = "#ffffff"
	if leftNum == 0 then
		color = "#ff0000"
	end
	_ENV = nil
	;(nil).num = leftNum
	_ENV, _ENV, (nil).limitNum = nil, self.itemData.limitNum, self.itemData.limitNum
	self.itemData.limitNum.num, (nil).color = nil, color
	local info = i18n("return_wzzl_text_011") .. i18n_html(" %{num}/%{limitNum}", nil, self.itemData.limitNum)
	self.limitLabel:setString(info)
	local bpCtrl = SoraDGetCtrl("backpackCtrl")
	local itemID = self.itemData.useitem[1]
	print("itemID", itemID)
	local packItemNum = bpCtrl:getItemCount(itemID)
	self.item_num:setString(packItemNum)
	local iconRes = itemDesRead.getIcon(itemID)
	print("iconRes", iconRes)
	self.icon_tip:setSpriteFrame(iconRes)
	self.btnItemIcon:setSpriteFrame(iconRes)
	self.goldLabel:setString(self.itemData.useitem[2])
	SoraDSetNodeGray(self.btnExchange, leftNum == 0)
	SoraDSetNodeGray(self.btnItemIcon, leftNum == 0)
	self.btnExchange:setTouchEnabled(leftNum ~= 0)
	if packItemNum < self.itemData.useitem[2] then
		self.goldLabel:setColor(cc.c3b(255, 0, 0))
	else
		self.goldLabel:setColor(cc.c3b(255, 255, 0))
	end
	self.redPoint:setVisible(hbCtrl:showGloryTaskNeedRedP())
end
function GloryGiftLayer:reOrderGift()
	_UPVALUE3_, _ENV = nil, nil
	_UPVALUE3_, (nil)[0], (nil)[1] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[0], (nil)[2] = nil, nil, "resource"
	_UPVALUE3_, (nil)[0], (nil)[3] = nil, nil, "hero"
	_UPVALUE3_, (nil)[10], (nil)[1] = nil, nil, "hero"
	_UPVALUE3_, (nil)[10], (nil)[2] = nil, nil, "resource"
	_UPVALUE3_, (nil)[10], (nil)[3] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[20], (nil)[1] = nil, nil, "resource"
	_UPVALUE3_, (nil)[20], (nil)[2] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[20], (nil)[3] = nil, nil, "hero"
	_UPVALUE3_, (nil)[30], (nil)[1] = nil, nil, "resource"
	_UPVALUE3_, (nil)[30], (nil)[2] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[30], (nil)[3] = nil, nil, "hero"
	_UPVALUE3_, (nil)[40], (nil)[1] = nil, nil, "hero"
	_UPVALUE3_, (nil)[40], (nil)[2] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[40], (nil)[3] = nil, nil, "resource"
	_UPVALUE3_, (nil)[50], (nil)[1] = nil, nil, "decoration"
	_UPVALUE3_, (nil)[50], (nil)[2] = nil, nil, "resource"
	_UPVALUE3_, (nil)[50], (nil)[3] = nil, nil, "hero"
	;(nil)[60], (nil)[1] = nil, "decoration"
	;(nil)[60], (nil)[2] = nil, "resource"
	;(nil)[60], (nil)[3] = nil, "hero"
	local orderCfg
	local aniNode = self:getOrCraetAniNode()
	local index = aniNode:getCurrentFrame()
	index = math.max(math.min(index, MAX_COUNTER_CLOCKWISE), 0)
	local cfg = orderCfg[math.floor(index / 10) * 10]
	for i, v in ipairs(cfg) do
		local tmpNode = self.nodeList[v]
		tmpNode:setLocalZOrder(i * 10)
	end
end
function GloryGiftLayer:initData()
	self:udpateView()
end
function GloryGiftLayer:updateReward()
	local targets = self.itemNode:getChildren()
	local itemNode = self.itemNode
	for k, v in ipairs(targets) do
		v:setVisible(false)
	end
	local reward = self.itemData.reward
	local maxNum = #reward
	for i = 1, maxNum, 2 do
		local item = itemNode:getChildByName("index" .. math.ceil(i / 2))
		if not item then
			item = include("commonItemAward").new()
			item:setScale(0.8)
			item:setOwnView(display.getRunningScene())
			item:setPositionY(45)
			item:setName("index" .. math.ceil(i / 2))
			item:addTo(itemNode)
		end
		item:initData(reward[i], reward[i + 1])
		item:setVisible(true)
	end
	SoraDToCenter(itemNode, 90, SoraDFIsRA())
end
function GloryGiftLayer:setSelectKey(setID)
	self.selectSetID = setID
	self.itemData = RKC.data[self.selectSetID]
end
function GloryGiftLayer:endShow()
	self:udpateView()
end
function GloryGiftLayer:btnInfoCallBack()
	SoraDShowHelpMsgTip(i18n("return_wzzl_text_013"))
end
function GloryGiftLayer:btnSetCallBack(target, eventType)
	if eventType == ccui.TouchEventType.began then
		if self.isMoved then
			return false
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if not self.isMoved and tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		if self.isMoved then
			local endPos = target:getTouchEndPosition()
			local beganPos = target:getTouchBeganPosition()
			local isLeft = endPos.x < beganPos.x
			self:switchGiftSet(isLeft)
		end
		self.isMoved = false
		self.touchKey = nil
		self.lastMovePos = nil
	end
end
function GloryGiftLayer:getOrCraetAniNode()
	if not self.aniAction then
		print("create Ani Node")
		self.aniAction = cc.CSLoader:createTimeline(getCCSPath("GloryGiftLayer"))
		self.aniAction:setFrameEventCallFunc(handler(self, self.aniEventCallBack))
		self.aniAction:gotoFrameAndPause(0)
		self:runAction(self.aniAction)
	end
	return self.aniAction
end
function GloryGiftLayer:countTargetIsClockwise(posA, posB, posC)
	local p1 = cc.pNormalize(cc.pSub(posB, posA))
	local p2 = cc.pNormalize(cc.pSub(posC, posA))
	local cross = cc.pCross(p1, p2)
	return cross <= 0
end
function GloryGiftLayer:playScrollAni()
	local aniNode = self:getOrCraetAniNode()
	local curFrame = aniNode:getCurrentFrame()
	local nextFrame = math.ceil(curFrame / 10) * 10
	nextFrame = math.min(nextFrame, MAX_COUNTER_CLOCKWISE)
	print("playScrollAni", curFrame, nextFrame)
	if curFrame == nextFrame then
		aniNode:gotoFrameAndPause(curFrame)
	else
		aniNode:gotoFrameAndPlay(curFrame, nextFrame, false)
	end
end
function GloryGiftLayer:runMoveAni(isClockwise, isFull)
	local aniNode = self:getOrCraetAniNode()
	if aniNode:isPlaying() then
		return
	end
	local curFrame = aniNode:getCurrentFrame()
	curFrame = math.max(0, math.min(curFrame, MAX_COUNTER_CLOCKWISE))
	local nextFrame = curFrame
	if isClockwise then
		if curFrame > MAX_CLOCKWISE then
			curFrame = MAX_COUNTER_CLOCKWISE - curFrame
		end
		if curFrame == MAX_CLOCKWISE then
			curFrame = 0
		end
	else
		if curFrame <= MAX_CLOCKWISE then
			curFrame = MAX_COUNTER_CLOCKWISE - curFrame
		end
		if curFrame == MAX_COUNTER_CLOCKWISE then
			curFrame = MAX_CLOCKWISE
		end
	end
	nextFrame = curFrame + 1
	nextFrame = math.min(math.max(nextFrame, 0), MAX_COUNTER_CLOCKWISE)
	if isFull then
		nextFrame = math.ceil(nextFrame / 10) * 10
	end
	print("nextFrame", curFrame, nextFrame, isClockwise)
	aniNode:gotoFrameAndPlay(curFrame, nextFrame, false)
	self:reOrderGift()
end
function GloryGiftLayer:aniEventCallBack(aniFrame)
end
function GloryGiftLayer:switchGiftSet(isLeft)
	local cfg = SET_ANI_CFG[self.selectSetID]
	local aniCfg = isLeft and cfg.left or cfg.right
	local aniNode = self:getOrCraetAniNode()
	if aniNode:isPlaying() then
		return
	end
	self:setSelectKey(aniCfg[3])
	print("switchGiftSet", aniCfg[3])
	aniNode:gotoFrameAndPlay(aniCfg[1], aniCfg[2], false)
	self:udpateView()
end
function GloryGiftLayer:btnExchangeCallBack()
	local bpCtrl = SoraDGetCtrl("backpackCtrl")
	local itemID = self.itemData.useitem[1]
	local packItemNum = bpCtrl:getItemCount(itemID)
	if packItemNum >= self.itemData.useitem[2] then
		_ENV = nil
		;(nil).num = self.itemData.useitem[2]
		;(nil).name = i18n(self.itemData.giftName)
		SoraDShowMsgBox(i18n("return_wzzl_text_014", nil), i18n("common_text_054"), i18n("common_text_185"), handler(self, self.confirmExchange))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function GloryGiftLayer:confirmExchange(eventType)
	if MSGBOX_CALLBACK_YES == eventType then
		_ENV = nil
		;(nil).index = self.itemData.shopItemID
		;(nil).count = 1
		SoraDGetCtrl("honorBackCtrl"):reqGloryExchange(nil)
	end
end
function GloryGiftLayer:btnAddItemCallBack()
	local panel = SoraDCreatePanel("eventGloryGiftLayer")
	panel:show()
end
function GloryGiftLayer:btnSwitchClick(isLeft, target, eventType)
	if eventType == ccui.TouchEventType.ended then
		self:switchGiftSet(isLeft)
	end
end
return GloryGiftLayer
