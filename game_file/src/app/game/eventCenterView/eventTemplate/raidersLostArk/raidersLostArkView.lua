local raidersLostArkView = class("raidersLostArkView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("raidersLostArkView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local constantRead = include("constantRead")
local activityExchangeMallRead = include("activityExchangeMallRead")
function raidersLostArkView:ctor()
	self.dailyBoxNum = constantRead.getConstValue("SNATCH_TREASURE_BOX_NUM", 630)
	self:initControls()
	self:initScrollMenu()
	self:playTitleEffect()
	self:playOpenEffect()
	self:playRoundEffect()
	self:playBgEffect()
	self:playLineEffect()
	self:refreshTabBtn()
	self:fitDevice()
end
function raidersLostArkView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_friend")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_tab")
	self.nodeTitle:setTitle(i18n("activity_name_9001270"))
	self.btn_help_tip:addTouchEventListener(handler(self, self.onClick_btn_help_tip))
	self.nodeSingle = SoraDGetChildByName(self, "singleNode")
	self.btn_left:addTouchEventListener(handler(self, self.turnLeftClick))
	self.btn_right:addTouchEventListener(handler(self, self.turnRightClick))
	self.btn_reward:addTouchEventListener(handler(self, self.rewardClick))
	self.btn_gain:addTouchEventListener(handler(self, self.gainClick))
	self.btn_open:addTouchEventListener(handler(self, self.openChestClick))
	self.scrollView_choose = SoraDCreatePanelByCloneNode(self.scrollView_choose, "eventLimitGiftScrollView")
	self.scrollView_choose:setSingleSelectedListener(handler(self, self.scrollMenuCallBack))
	self.scrollView_choose:setContentSize(cc.size(640, 215))
	self.exchangeItemID = 815101
	self.Top_Size_ScrollView_store = include("commonAutoScrollList").new(self.Top_Size_ScrollView_store)
	self.Top_Size_ScrollView_store:setSingleCCS("summerPrayersExchangeSingle")
	self.tableKeyNode = SoraDGetChildsArrayByName(self, "node_key_", 3, 1)
	for i, v in ipairs(self.tableKeyNode) do
		if i ~= 1 then
			v:setVisible(false)
			self.tableKeyNode[i] = nil
		end
	end
	self.btn_gain:setTitleText(i18n("Martial_arts_text_06"))
	self.btn_open:setTitleText(i18n("common_text_246"))
	self.text_snatch_ins:setString(i18n("Martial_arts_text_07"))
	self.slider = include("commonCustomSlider").new()
	self.slider:setPosition(SoraDFPosX(60, 0), -380)
	self.slider:addTo(self.node_unsnatch, 99)
	self.slider:setShowType(4)
	self.slider:setPerChange(1)
	_ENV = 1
	;(1).tabNum = 2
	_ENV, _ENV, (1).defaultClick = 0, 99, 1
	;(0).title = i18n("Martial_arts_text_06")
	_ENV, (99)[1], (0).handle = 0, 0, handler(self, self.onSnatchClick)
	;(0).title = i18n("common_text_1809")
	;(1).tabsetArray, (99)[2], (0).handle = 99, 0, handler(self, self.onStoreClick)
	self.ccs_tab:initView(1)
	SoraDSetTextWidthHeight(self.text_ins, cc.size(600, 60))
	self.text_ins:setVisible(false)
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
	self.chooseIndex = 1
	self.btn_left:setVisible(self.chooseIndex ~= 1)
	self.btn_right:setVisible(self.chooseIndex ~= 5)
	self.image_box:setLocalZOrder(5)
	self.image_lock:setLocalZOrder(6)
	self.image_lock_frame:setLocalZOrder(6)
	self.btn_open:setLocalZOrder(7)
	if not activityExchangeMallRead:getShopItemList(self.activityID) then
		_ENV = activityExchangeMallRead:getShopItemList(self.activityID)
	end
	self.showShopItemList = activityExchangeMallRead:getShopItemList(self.activityID)
end
function raidersLostArkView:playChooseEffect(isPlay, parent)
	if isPlay then
		if parent.effectChoose then
			parent.effectChoose:setVisible(true)
			SoraDResetEffectNode(parent.effectChoose)
			parent.effectChoose.action:gotoFrameAndPlay(0, 240, true)
		else
			parent.effectChoose = SoraDCreatAnimationEx("Node_singleChoose", nil, true)
			parent.effectChoose:setPosition(cc.p(0, 0))
			parent.effectChoose:addTo(parent, 1)
		end
	elseif parent.effectChoose then
		parent.effectChoose:setVisible(false)
	end
end
function raidersLostArkView:playTitleEffect()
	self.titleEffect = SoraDCreatAnimation("Node_titleEffect", nil, true)
	self.titleEffect:setPosition(cc.p(self.frame_dbqb_titlebg_01_4:getContentSize().width / 2, self.frame_dbqb_titlebg_01_4:getContentSize().height / 2 - 3))
	self.titleEffect:addTo(self.frame_dbqb_titlebg_01_4)
end
function raidersLostArkView:playOpenEffect()
	self.oepnEffect = SoraDCreatAnimation("Node_openEffect", nil, true)
	for i = 1, 3 do
		if i ~= 1 then
			local node = SoraDGetChildByName(self.oepnEffect, "Node_Effect_dbqb01_001_0" .. i)
			if node then
				node:setVisible(false)
			end
		end
	end
	self.oepnEffect:setPosition(cc.p(self.btn_open:getContentSize().width / 2, self.btn_open:getContentSize().height / 2))
	self.oepnEffect:addTo(self.btn_open)
end
function raidersLostArkView:playZeroToOneEffect(isPlay, parent)
	if isPlay then
		if parent.effectZero then
			parent.effectZero:setVisible(true)
			SoraDResetEffectNode(parent.effectZero)
			parent.effectZero.action:gotoFrameAndPlay(0, 90, false)
		else
			parent.effectZero = SoraDCreatAnimationEx("Node_zeroToOne", nil, false)
			if parent:getName() == "node_key_1" then
				parent.effectZero:setPosition(cc.p(0, -5))
			else
				parent.effectZero:setPosition(cc.p(-12, 13))
			end
			parent.effectZero:addTo(parent, 2)
		end
	elseif parent.effectZero then
		parent.effectZero:setVisible(false)
	end
end
function raidersLostArkView:playOpenChestEffect(isPlay)
	do return end
	if isPlay then
		if self.effectOpenChest then
			SoraDResetEffectNode(self.effectOpenChest)
			self.effectOpenChest.action:gotoFrameAndPlay(0, 62, false)
		else
			self.effectOpenChest = SoraDCreatAnimationEx("Node_openChestEffect", nil, false)
			self.effectOpenChest:setPosition(cc.p(0, -40))
			self.effectOpenChest:addTo(self.node_unsnatch)
		end
	elseif self.effectOpenChest then
		self.effectOpenChest:removeFromParent()
		self.effectOpenChest = nil
	end
end
function raidersLostArkView:playRoundEffect()
	self.roundEffect = SoraDCreatAnimation("Node_roundEffect", nil, true)
	self.roundEffect:setPosition(cc.p(self.frame_dbqb_iconbg_01_3:getContentSize().width / 2, self.frame_dbqb_iconbg_01_3:getContentSize().height / 2))
	self.roundEffect:addTo(self.frame_dbqb_iconbg_01_3)
end
function raidersLostArkView:playBgEffect()
	self.bgEffect = SoraDCreatAnimation("Node_bgEffect", nil, true)
	self.bgEffect:setPosition(cc.p(0, -50))
	self.bgEffect:addTo(self.node_decorateEffect)
end
function raidersLostArkView:playLineEffect()
	self.leftEffect = SoraDCreatAnimation("Node_leftLineEffect", nil, true)
	self.leftEffect:setPosition(cc.p(299.5, 360))
	self.leftEffect:addTo(self.decorate_left)
	self.rightEffect = SoraDCreatAnimation("Node_rightLineEffect", nil, true)
	self.rightEffect:setPosition(cc.p(-80, 380))
	self.rightEffect:addTo(self.decorate_right)
end
function raidersLostArkView:fitDevice()
	if math.floor(display.height) == 960 then
		self.node_unsnatch:setScale(0.85)
		self.node_unsnatch:setPositionY(self.node_unsnatch:getPositionY() + 40)
		self.bgEffect:setScale(1.2)
	elseif math.floor(display.height) == 853 then
		self.node_unsnatch:setScale(0.7)
		self.node_unsnatch:setPositionY(self.node_unsnatch:getPositionY() + 100)
		self.bgEffect:setScale(1.3)
	end
	if display.height < 960 then
		self.scrollView_choose:setScale(0.8)
	end
end
function raidersLostArkView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_OPEN_CHEST", function(target, data)
		SoraDCloseLoading(self)
		raidersLostArkRead = nil
		;(nil)[1] = cca.callFunc(function()
			self.frame_dbqb_iconbg_01_3:setVisible(false)
			for i, v in ipairs(self.tableKeyNode) do
				v:setVisible(false)
			end
			self:playOpenChestEffect(true)
		end)
		;(nil)[2] = cca.callFunc(function()
			local rewardList = raidersLostArkCtrl:getRewardList()
			raidersLostArkCtrl = nil
			;(nil).rewardList = rewardList
			uiManager:show("raidersLostArkGetRewardView", nil)
		end)
		;(nil)[3] = cca.delay(1.0)
		;(nil)[4] = cca.callFunc(function()
			self.frame_dbqb_iconbg_01_3:setVisible(true)
			local keyTable = raidersLostArkRead:getTreasureKeyTable(self.itemArray[self.chooseIndex].boxType)
			local chestState = raidersLostArkRead:getCurChestState(keyTable)
			dump(keyTable, "skjdjfjlksdjflsdkf")
			print("sldkfjsdlkfjsdlkfjdl", self.chooseIndex, self.itemArray[self.chooseIndex].boxType, chestState)
			for i, v in ipairs(self.tableKeyNode) do
				v:setVisible(chestState ~= gRaidersLostArkChestStatus.UNSNATCH)
			end
			self:playOpenChestEffect(false)
			self.btn_left:setEnabled(true)
			self.btn_right:setEnabled(true)
			self.btn_open:setEnabled(true)
		end)
		;(nil)[5] = cca.callFunc(function()
			self.frame_dbqb_iconbg_01_3:setVisible(true)
			local keyTable = raidersLostArkRead:getTreasureKeyTable(self.itemArray[self.chooseIndex].boxType)
			local chestState = raidersLostArkRead:getCurChestState(keyTable)
			dump(keyTable, "skjdjfjlksdjflsdkf")
			print("sldkfjsdlkfjsdlkfjdl", self.chooseIndex, self.itemArray[self.chooseIndex].boxType, chestState)
			for i, v in ipairs(self.tableKeyNode) do
				v:setVisible(chestState ~= gRaidersLostArkChestStatus.UNSNATCH)
			end
			self:playOpenChestEffect(false)
			self.btn_left:setEnabled(true)
			self.btn_right:setEnabled(true)
			self.btn_open:setEnabled(true)
		end)
		self:runAction(cca.seq(nil))
		self:refreshTabBtn()
		self:resetDisplayStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_OPEN_CHEST_NUM_LIMIT", function(target, data)
		SoraDCloseLoading(self)
		local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.itemArray[self.chooseIndex].boxType)
		_ENV = nil
		;(nil).name = i18n(chestInfo.name)
		SoraDShowMsgTip(i18n("Martial_arts_text_31", nil))
		self.frame_dbqb_iconbg_01_3:setVisible(true)
		local keyTable = raidersLostArkRead:getTreasureKeyTable(self.itemArray[self.chooseIndex].boxType)
		local chestState = raidersLostArkRead:getCurChestState(keyTable)
		for i, v in ipairs(self.tableKeyNode) do
			v:setVisible(chestState ~= gRaidersLostArkChestStatus.UNSNATCH)
		end
		self:playOpenChestEffect(false)
		self.btn_left:setEnabled(true)
		self.btn_right:setEnabled(true)
		self.btn_open:setEnabled(true)
		self:resetDisplayStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_BEGIN_ROBBERY", function(target, data)
		SoraDCloseLoading(self)
		self:refreshTabBtn()
		self:resetDisplayStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, data)
		SoraDCloseLoading(self)
		self:resetDisplayStatus()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:refreshTabBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_CLOSELOADING", function(target, data)
		SoraDCloseLoading(self)
		self:refreshTabBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		self:refreshTabBtn()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_ENTER_SNATCH", function(target, data)
		SoraDCloseLoading(self)
		local panel = SoraDCreatePanel("raidersLostArkSnatchView")
		panel:setKeyId(self.keyId)
		panel:show()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RAIDER_LOST_ARK_ENTER_FAILED", function(target, data)
		SoraDCloseLoading(self)
		SoraDShowMsgTip(i18n("Martial_arts_text_10"))
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkView:onSnatchClick(tag, name)
	self.node_unsnatch:setVisible(true)
	self.Bottom_Node:setVisible(true)
	self.Top_Size_ScrollView_store:setVisible(false)
end
function raidersLostArkView:onStoreClick(tag, name)
	self.node_unsnatch:setVisible(false)
	self.Bottom_Node:setVisible(false)
	self.Top_Size_ScrollView_store:setVisible(true)
	self:refreshTabBtn()
end
function raidersLostArkView:refreshTabBtn()
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.activityID)
	local totalNum = raidersLostArkRead:getTotalTreasureOpenCount()
	totalNum = math.min(totalNum, math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()))
	print("raidersLostArkView:refreshTabBtn", ret, num, totalNum)
	self.ccs_tab:setBigRedPointCount(2, num)
	self.ccs_tab:setBigRedPointCount(1, totalNum)
	_ENV = math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes())
	math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()).scroll = self.Top_Size_ScrollView_store
	math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()).view = self
	math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()).activityID = self.activityID
	math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()).exchangeItemID = self.exchangeItemID
	self.Top_Size_ScrollView_store:updateScrollView(cc.size(624, 160), self.showShopItemList, 1, math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()))
end
function raidersLostArkView:initData()
	local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.itemArray[self.chooseIndex].boxType)
	local keyTable = raidersLostArkRead:getTreasureKeyTable(self.itemArray[self.chooseIndex].boxType)
	if not next(chestInfo) then
		return
	end
	local chestState = raidersLostArkRead:getCurChestState(keyTable)
	local keyNameStr = ""
	for i, v in ipairs(keyTable) do
		local singleKey = publicRead.getName(v)
		if i == 1 then
			keyNameStr = keyNameStr .. singleKey
		elseif i <= #keyTable then
			keyNameStr = keyNameStr .. "、" .. singleKey
		end
	end
	self.text_boxName:setString(i18n(chestInfo.name))
	self.btn_reward:setPositionX(self.text_boxName:getPositionX() - SoraDFSign(self.text_boxName:getContentSize().width / 2) - SoraDFSign(25))
	self.image_box:loadTexture(chestInfo.icon, ccui.TextureResType.plistType)
	self.image_box:setContentSize(cc.size(326, 294))
	raidersLostArkRead = cc.size(326, 294)
	cc.size(326, 294).name = keyNameStr
	cc.size(326, 294).box = i18n(chestInfo.name)
	self.text_ins:setString(i18n("Martial_arts_text_02", cc.size(326, 294)))
	local maxSnatchCount = 0
	for i, v in ipairs(self.tableKeyNode) do
		v:setVisible(chestState ~= gRaidersLostArkChestStatus.UNSNATCH)
		local keyIcon = publicRead.getIcon(keyTable[i])
		local keyCount = backpackCtrl:getItemCount(keyTable[i])
		if maxSnatchCount == 0 then
			maxSnatchCount = keyCount
		else
			maxSnatchCount = math.min(maxSnatchCount, keyCount)
		end
		local imageKeyIcon = SoraDGetChildByName(v, "image_key_icon_" .. i)
		local txtKeyCount = SoraDGetChildByName(v, "key_num_" .. i)
		local btnKey = SoraDGetChildByName(v, "btn_key_" .. i)
		SoraDAutoSizeButtonText(btnKey, cc.size(100, 40))
		imageKeyIcon:loadTexture(keyIcon, ccui.TextureResType.plistType)
		imageKeyIcon:setOpacity(keyCount <= 0 and 102.0 or 255)
		imageKeyIcon:setContentSize(cc.size(132, 132))
		txtKeyCount:setString(keyCount)
		txtKeyCount:setColor(keyCount <= 0 and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
		btnKey:setTitleText(i18n("Martial_arts_text_25"))
		btnKey:setVisible(keyCount <= 0)
		if i == 1 then
			btnKey:addTouchEventListener(handler(self, self.keyToMonsterClick))
		else
			btnKey:addTouchEventListener(handler(self, self.keyToSnatchClick))
		end
		imageKeyIcon:addTouchEventListener(handler(self, self.keyInfoClick))
		btnKey:setTag(keyTable[i])
		imageKeyIcon:setTag(keyTable[i])
		local isSatisfy = raidersLostArkCtrl:isSatisfyZeroToOne(keyTable[i])
		self:playZeroToOneEffect(isSatisfy, v)
	end
	self.btn_open:setVisible(chestState == gRaidersLostArkChestStatus.CANOPEN)
	self.text_snatch_ins:setVisible(chestState ~= gRaidersLostArkChestStatus.UNSNATCH)
	self.btn_gain:setVisible(chestState == gRaidersLostArkChestStatus.UNSNATCH)
	self.image_lock:setVisible(chestState == gRaidersLostArkChestStatus.UNSNATCH)
	self.image_lock_frame:setVisible(chestState == gRaidersLostArkChestStatus.UNSNATCH)
	maxSnatchCount = math.min(maxSnatchCount, self.dailyBoxNum)
	self.slider:setVisible(0 < maxSnatchCount)
	self.leftBoxNum = math.min(math.min(self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes(), maxSnatchCount), self.dailyBoxNum)
	if 0 < maxSnatchCount then
		self.slider:initData(math.min(self.leftBoxNum, 1), self.leftBoxNum, math.min(self.leftBoxNum, 1))
	end
end
function raidersLostArkView:scrollMenuCallBack(index)
	self.chooseIndex = index
	self.btn_left:setVisible(self.chooseIndex ~= 1)
	self.btn_right:setVisible(self.chooseIndex ~= 5)
	self:resetDisplayStatus()
end
function raidersLostArkView:initScrollMenu()
	self.scrollView_choose:removeAllChildren()
	self.itemArray, _ENV = self.scrollView_choose.removeAllChildren, self.scrollView_choose.removeAllChildren
	for i = 1, 5 do
		local item = self.nodeSingle:clone()
		item.weight = 0
		item.imgBg = SoraDGetChildByName(item, "singleBg")
		item.imgArrow = SoraDGetChildByName(item, "singleArrow")
		item.imgRed = SoraDGetChildByName(item, "Image_redPoint")
		item.txtNum = SoraDGetChildByName(item, "Text_redPointInt")
		item.spriteBoxSmall = SoraDGetChildByName(item, "sprite_box_small")
		local keyTable = raidersLostArkRead:getTreasureKeyTable(5 - i + 1)
		local openCount = self:getChestOpenCount(keyTable)
		local chestInfo = raidersLostArkRead:getTreasureChestInfo(5 - i + 1)
		item.spriteBoxSmall:setSpriteFrame(chestInfo.icon)
		item.spriteBoxSmall:setScale(0.5)
		item.spriteBoxSmall:setLocalZOrder(2)
		item.imgRed:setLocalZOrder(3)
		item.weight = item.weight + (0 < openCount and 5 or 0)
		if self:isChestHasOneKey(keyTable) then
			item.weight = item.weight + 5
		end
		item.weight = item.weight + (5 - i + 1)
		item.boxType = chestInfo.type
		item.needAdjustY = false
		table.insert(self.itemArray, item)
	end
	local highWeight = 0
	local curIndex = 1
	for i, v in ipairs(self.itemArray) do
		if highWeight < v.weight then
			highWeight = v.weight
			curIndex = i
		end
	end
	self.chooseIndex = curIndex
	for i, v in ipairs(self.itemArray) do
		local keyTable = raidersLostArkRead:getTreasureKeyTable(v.boxType)
		local openCount = self:getChestOpenCount(keyTable)
		v.imgBg:setSpriteFrame(i ~= self.chooseIndex and "frame_dbqb_iconbg_06.png" or "frame_dbqb_iconbg_04.png")
		v.imgArrow:setVisible(i == self.chooseIndex)
		v.txtNum:setString(99 < openCount and "99+" or openCount)
		v.imgRed:setVisible(0 < openCount)
		self:addNodeJump(v.imgRed)
		self:playChooseEffect(i == self.chooseIndex, v)
	end
	self.scrollView_choose:initData(self.chooseIndex, self.itemArray, cc.size(190, 190), 90)
end
function raidersLostArkView:addNodeJump(img)
	local moveUp = cca.moveTo(0.5, img:getPositionX(), img:getPositionY() + 5)
	local moveDown = cca.moveTo(0.2, img:getPositionX(), img:getPositionY() - 2)
	local move = cca.moveTo(0.1, img:getPositionX(), img:getPositionY())
	_UPVALUE7_ = img:getPositionX()
	img:getPositionX()[1] = moveUp
	img:getPositionX()[2] = moveDown
	img:getPositionX()[3] = moveUp
	img:getPositionX()[4] = moveDown
	img:getPositionX()[5] = moveUp
	img:getPositionX()[6] = moveDown
	img:getPositionX()[7] = move
	img:getPositionX()[8] = cca.delay(1)
	img:getPositionX()[9] = cca.delay(1)
	local moveAct = cca.seq((img:getPositionX()))
	img:runAction(cca.repeatForever(moveAct))
end
function raidersLostArkView:isChestHasOneKey(keyTable)
	local isHave = false
	if keyTable and next(keyTable) then
		for i, v in ipairs(keyTable) do
			local keyCount = backpackCtrl:getItemCount(keyTable[i])
			if 0 < keyCount then
				isHave = true
				break
			end
		end
	end
	return isHave
end
function raidersLostArkView:getChestOpenCount(keyTable)
	local smallCount = 0
	if keyTable and next(keyTable) then
		for i, v in ipairs(keyTable) do
			local keyCount = backpackCtrl:getItemCount(keyTable[i])
			if i == 1 then
				smallCount = keyCount
			end
			if keyCount < smallCount then
				smallCount = keyCount
			end
		end
	end
	smallCount = math.min(smallCount, math.max(0, self.dailyBoxNum - raidersLostArkCtrl:getOpenBoxTimes()))
	return smallCount
end
function raidersLostArkView:resetDisplayStatus()
	for i, item in ipairs(self.itemArray) do
		item.imgBg:setSpriteFrame(i ~= self.chooseIndex and "frame_dbqb_iconbg_06.png" or "frame_dbqb_iconbg_04.png")
		item.imgArrow:setVisible(i == self.chooseIndex)
		self:playChooseEffect(i == self.chooseIndex, item)
		local keyTable = raidersLostArkRead:getTreasureKeyTable(item.boxType)
		local openCount = self:getChestOpenCount(keyTable)
		item.imgRed:setVisible(0 < openCount)
		item.txtNum:setString(99 < openCount and "99+" or openCount)
	end
	self:initData()
end
function raidersLostArkView:turnLeftClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex - 1
		if self.chooseIndex < 1 then
			self.chooseIndex = 1
		end
		self.btn_left:setVisible(self.chooseIndex ~= 1)
		self.btn_right:setVisible(self.chooseIndex ~= 5)
		for i, v in ipairs(self.itemArray) do
			self:playChooseEffect(i == self.chooseIndex, v)
			local keyTable = raidersLostArkRead:getTreasureKeyTable(v.boxType)
			local openCount = self:getChestOpenCount(keyTable)
			v.imgRed:setVisible(0 < openCount)
			v.txtNum:setString(99 < openCount and "99+" or openCount)
		end
		self.scrollView_choose:selectedCellIndex(self.chooseIndex, 0.3)
	end
end
function raidersLostArkView:turnRightClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.chooseIndex = self.chooseIndex + 1
		if self.chooseIndex > 5 then
			self.chooseIndex = 5
		end
		self.btn_left:setVisible(self.chooseIndex ~= 1)
		self.btn_right:setVisible(self.chooseIndex ~= 5)
		for i, v in ipairs(self.itemArray) do
			self:playChooseEffect(i == self.chooseIndex, v)
			local keyTable = raidersLostArkRead:getTreasureKeyTable(v.boxType)
			local openCount = self:getChestOpenCount(keyTable)
			v.imgRed:setVisible(0 < openCount)
			v.txtNum:setString(99 < openCount and "99+" or openCount)
		end
		self.scrollView_choose:selectedCellIndex(self.chooseIndex, 0.3)
	end
end
function raidersLostArkView:rewardClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("raidersLostArkRewardListView")
		panel:initData(self.itemArray[self.chooseIndex].boxType)
		panel:show()
	end
end
function raidersLostArkView:gainClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).boxType = self.itemArray[self.chooseIndex].boxType
		uiManager:show("RaidersLostArkGetKeyPop", nil)
	end
end
function raidersLostArkView:openChestClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.leftBoxNum < 1 then
			local chestInfo = raidersLostArkRead:getTreasureChestInfo(self.itemArray[self.chooseIndex].boxType)
			_ENV = nil
			;(nil).name = i18n(chestInfo.name)
			SoraDShowMsgTip(i18n("Martial_arts_text_31", nil))
			return
		end
		self.btn_left:setEnabled(false)
		self.btn_right:setEnabled(false)
		self.btn_open:setEnabled(false)
		raidersLostArkCtrl:reqOpenBox(self.itemArray[self.chooseIndex].boxType, self.slider:getValue())
		SoraDShowLoading(self)
	end
end
function raidersLostArkView:keyToMonsterClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("skldjflskdjfsld111", target:getTag())
		SoraDRemoveAllPanelFromManager()
		_ENV = target:getTag()
		mildGuideManager:starToWorldAndKillMonster(target:getTag())
	end
end
function raidersLostArkView:keyToSnatchClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("skldjflskdjfsld222", target:getTag())
		self.keyId = target:getTag()
		raidersLostArkCtrl:reqRobberyEnter(self.keyId)
		SoraDShowLoading(self)
	end
end
function raidersLostArkView:keyInfoClick(target, event)
	local keyCount = backpackCtrl:getItemCount(target:getTag())
	self.keyId = target:getTag()
	print("sdlfjsldkf", keyCount)
	if 0 < keyCount then
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			SoraDCloseCommonTips()
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			SoraDShowCommonTips(target, target:getTag())
		end
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local keyTable = raidersLostArkRead:getTreasureKeyTable(self.chooseIndex)
		local index = 0
		for i, v in ipairs(keyTable) do
			if target:getTag() == v then
				index = i
				break
			end
		end
		if index ~= 0 then
			if index == 1 then
				SoraDRemoveAllPanelFromManager()
				backpackCtrl = ipairs(keyTable)
				mildGuideManager:starToWorldAndKillMonster(ipairs(keyTable))
			else
				raidersLostArkCtrl:reqRobberyEnter(self.keyId)
				SoraDShowLoading(self)
			end
		end
	end
end
function raidersLostArkView:onClick_btn_help_tip(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Martial_arts_text_01"
		;("Martial_arts_text_01").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Martial_arts_text_01"), "Martial_arts_text_01")
	end
end
function raidersLostArkView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return raidersLostArkView
