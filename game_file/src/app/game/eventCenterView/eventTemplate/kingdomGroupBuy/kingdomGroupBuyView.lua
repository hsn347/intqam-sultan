local ctGridScroll = include("ctGridScroll")
local kingdomGroupBuyRead = include("kingdomGroupBuyRead")
local itemDesRead = include("itemDesRead")
local KingdomGroupBuyView = class("kingdomGroupBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingdomGroupBuyView")
	end
	return target
end)
function KingdomGroupBuyView:ctor()
	self.recordReqBack = false
	self.recordCanGet = true
	self.recordIndex = 1
	self.curIndexBox = 1
	self.jointPeople = 0
	self.leftTime = 0
	self.leftBuy = 0
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_groupBuyTitle"):setTitle(i18n("common_text_3485"))
	self.noticeScroll = SoraDGetChildByName(self, "Top_Size_ScrollView_notices")
	self.noticeScroll = ctGridScroll.new(self.noticeScroll)
	self.contentScroll = SoraDGetChildByName(self, "ScrollView_content")
	self.panelBottom = SoraDGetChildByName(self, "Top_Size_Image_mainContent")
	self.imgContentLine = SoraDGetChildByName(self, "Image_upLine")
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.txtCount = SoraDGetChildByName(self, "Text_count")
	self.imgBanner = SoraDGetChildByName(self, "Image_banner")
	self.imgBanner:loadTexture(SoraDCheckPNG("bg_activity_show_KingGroupbuy.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	self.txtTime = SoraDGetChildByName(self, "Text_leftTime")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.imgArrow = SoraDGetChildByName(self, "Image_bottomSheer")
	self.btnMore = SoraDGetChildByName(self, "Button_more")
	self.btnSingle = SoraDGetChildByName(self, "Button_single")
	self.btnDouble = SoraDGetChildByName(self, "Button_double")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.txtSingleTip = SoraDGetChildByName(self, "Text_singleTip")
	self.txtDoubleTip = SoraDGetChildByName(self, "Text_doubleTip")
	self.txtSinglePrice = SoraDGetChildByName(self, "Text_singlePriceTip")
	self.txtDoublePrice = SoraDGetChildByName(self, "Text_doublePriceTip")
	self.btnSingle:addTouchEventListener(handler(self, self.btnSingleClick))
	self.btnDouble:addTouchEventListener(handler(self, self.btnDoubleClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_int")
	self.spLoadDivide = SoraDGetChildByName(self, "progressbar_point")
	self.barImgArrow = SoraDGetChildByName(self, "Image_arrow")
	self.nodeProgress = SoraDGetChildByName(self, "Node_progress")
	self.itemCopy = SoraDGetChildByName(self, "Image_itemCopy")
	self.itemBoxCopy = SoraDGetChildByName(self, "Image_itemBgCopy")
	self.recordCopy = SoraDGetChildByName(self, "Image_recordItem")
	self.noticeScroll:setTouchEnabled(false)
	self.imgArrow:setVisible(false)
	self.imgArrow:setTouchEnabled(true)
	self.imgArrow:addTouchEventListener(handler(self, self.imgArrowClick))
	self.btnMore:addTouchEventListener(handler(self, self.btnMoreClick))
	self.txtAddTip = SoraDGetChildByName(self, "Text_addTip")
	self.txtAddTip:setString(i18n("common_text_3496"))
	SoraDGetChildByName(self, "Text_baseTip"):setString(i18n("common_text_3495"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnMore:setTitleText(i18n("common_text_3518"))
	SoraDAutoSizeButtonText(self.btnMore, cc.size(150, 50))
	self.panelBottom:setFillType(1)
	local firstNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_rechargeFirstAward_node")
	if firstNode then
		firstNode:setRoad(gRechargeActiveFromEnum.ROAD13)
		firstNode:setActivity(gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY)
	end
	self:initContentBeforeCreate()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_KINGGROUPBUY_RECORDBACK", handler(self, self.initRecordData))
	self:req4info()
end
function KingdomGroupBuyView:initContentBeforeCreate(...)
	self.panelBottom:setPositionX(320)
	local panelBottomHeigh = self.panelBottom:getContentSize().height
	self.imgContentLine:setPositionY(panelBottomHeigh)
	self.nodeContent:setPositionY(panelBottomHeigh)
	self.contentScroll:setContentSize(cc.size(640, panelBottomHeigh))
	self.contentScroll:setPositionY(panelBottomHeigh)
end
function KingdomGroupBuyView:req4info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
	kingGroupBuyAgCtrl:sendInitMsg()
	kingGroupBuyAgCtrl:sendLogMsg(self.recordIndex)
end
function KingdomGroupBuyView:initRecordData(target, redata)
	dump(redata, "redata ")
	self.recordReqBack = true
	local createFun = function(data)
		local single = self.recordCopy:clone()
		if data.abbr then
			self = nil
			;(nil).abbr = data.abbr
			;(nil).name = data.nickName
			if i18n("common_text_186", nil) then
				goto lbl_18
			end
		end
		local player = data.nickName
		::lbl_18::
		self = nil
		;(nil).name = player
		;(nil).num = data.buyCount
		single:getChildByName("Text_recordContent"):setString(i18n("common_text_3487", nil))
		return single
	end
	local selfFactory = function(tbl)
		local _ENV, reTbl
		for _, v in ipairs(tbl) do
			_ENV = nil
			;(nil).data = v
			table.insert(reTbl, nil)
		end
		return reTbl
	end
	if not selfFactory(redata.noticeLog) then
		_ENV = selfFactory(redata.noticeLog)
	end
	self.noticeList = selfFactory(redata.noticeLog)
	if not self.firstNoticeScrollInit then
		self.noticeScroll:init(self.noticeList, createFun, cc.size(600, 70))
		self.noticeScroll:begin2Run()
		self.noticeScroll:addEventListener(handler(self, self.noticeScrollEventCallBack))
		self.firstNoticeScrollInit = true
	else
		self.noticeScroll:setNewTable(self.noticeList)
	end
	self.recordIndex = redata.nextIndex
	self.recordCanGet = redata.canGet
end
function KingdomGroupBuyView:initData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.rechargeRefresh then
		local gametop = gModuleMgr.getObject("gametop")
		local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
		self.recordIndex = 1
		kingGroupBuyAgCtrl:sendLogMsg(self.recordIndex)
	end
	self:initView()
end
function KingdomGroupBuyView:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
	local alreadyBuy = kingGroupBuyAgCtrl:getAlreadyBuyCount()
	self.maxBuy = kingGroupBuyAgCtrl:getMaxBuyCount()
	self.leftBuy = kingGroupBuyAgCtrl:getLeftBuyCount()
	self.boxItemList = kingGroupBuyAgCtrl:getReward()
	self.jointPeople = kingGroupBuyAgCtrl:getTotalBuyCount()
	self.groupBuyState = kingGroupBuyAgCtrl:getActivityStatus()
	self.rechargeInfo1 = kingGroupBuyAgCtrl:getRechargeInfo1()
	self.rechargeInfo2 = kingGroupBuyAgCtrl:getRechargeInfo2()
	_ENV = nil
	;(nil).num = self.rechargeInfo1.num
	self.txtSingleTip:setString(i18n("common_text_3497", nil))
	_ENV = i18n("common_text_3497", nil)
	i18n("common_text_3497", nil).num = self.rechargeInfo2.num
	self.txtDoubleTip:setString(i18n("common_text_3497", i18n("common_text_3497", nil)))
	local showPrice1, isGetPrice1 = paymentManager.judgePrice(self.rechargeInfo1.rid, self.rechargeInfo1.price)
	local showPrice2, isGetPrice2 = paymentManager.judgePrice(self.rechargeInfo2.rid, self.rechargeInfo2.price)
	self.txtSinglePrice:setString(showPrice1)
	self.txtDoublePrice:setString(showPrice2)
	print("self.groupBuyState = ", self.groupBuyState)
	if gKingGroupBuyStatus.RECHARGE_OPEN == self.groupBuyState then
		self.txtTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_3493", nil)
		end)
		self.leftTime = kingGroupBuyAgCtrl:getClearingLeftTime()
	elseif gKingGroupBuyStatus.CLEARING == self.groupBuyState then
		self.txtTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_3494", nil)
		end)
		self.leftTime = kingGroupBuyAgCtrl:getSendRewardLeftTime()
	end
	self.txtTime:beginTime(self.leftTime)
	_ENV = i18n("common_text_3497", i18n("common_text_3497", nil))
	i18n("common_text_3497", i18n("common_text_3497", nil)).num = self.jointPeople
	self.txtTips:setString(i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil))))
	_ENV = i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil)))
	i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil))).cur = alreadyBuy
	i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil))).left = self.leftBuy
	self.txtCount:setString(i18n("common_text_3488", i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil)))))
	self:calculateCurInddx()
	self:initContentPanel()
	self:judgeButton()
	_ENV, _UPVALUE2_ = i18n("common_text_3488", i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil))))
	_ENV, i18n("common_text_3488", i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil)))).rechargeID = self.rechargeInfo1.rid, self.rechargeInfo1.rid
	self.rechargeInfo1.rid.rechargeID = self.rechargeInfo2.rid
	self[1] = i18n("common_text_3488", i18n("common_text_3830", i18n("common_text_3497", i18n("common_text_3497", nil))))
	self[2] = self.rechargeInfo1.rid
	SoraDCreateRechargeGiftNode(self, SoraDGetChildByName(self, "Top_Node_paste"), cc.p(70, -250))
end
function KingdomGroupBuyView:judgeButton(...)
	local changeBtn = function(btn, bool)
		btn:setBright(bool)
	end
	if self.leftBuy >= self.rechargeInfo1.num then
		changeBtn(self.btnSingle, true)
	else
		changeBtn(self.btnSingle, false)
	end
	if self.leftBuy >= self.rechargeInfo2.num then
		changeBtn(self.btnDouble, true)
	else
		changeBtn(self.btnDouble, false)
	end
	if gKingGroupBuyStatus.CLEARING == self.groupBuyState then
		changeBtn(self.btnSingle, false)
		changeBtn(self.btnDouble, false)
	end
end
function KingdomGroupBuyView:calculateCurInddx(...)
	local curIdx = 1
	for i, v in ipairs(self.boxItemList) do
		if self.jointPeople >= v.parts[1] then
			curIdx = i
		end
	end
	self.curIndexBox = curIdx
end
function KingdomGroupBuyView:transIndex(index)
	if SoraDFIsRA() then
		return table.nums(self.boxItemList) - index + 1
	else
		return index
	end
end
function KingdomGroupBuyView:initContentPanel(...)
	if not self.initProgressFlag then
		local barLong = self.loadBar:getContentSize().width
		local perLong = barLong / (#self.boxItemList - 1)
		self.boxOcxList, _ENV = nil, nil
		for i, v in ipairs(self.boxItemList) do
			local newDiv = self.barImgArrow:clone()
			newDiv:addTo(self.nodeProgress)
			newDiv:getChildByName("Text_int"):setString(v.parts[1])
			if i == 1 or i == #self.boxItemList then
				newDiv:getChildByName("Image_divide"):setVisible(false)
			end
			local newBox = self:createBoxFun(v, i)
			newBox:setTag(i)
			newBox:setSwallowTouches(false)
			newBox:addTouchEventListener(handler(self, self.boxItemClick))
			newBox:addTo(self.nodeProgress)
			table.insert(self.boxOcxList, newBox)
			if SoraDFIsRA() then
				newDiv:setPosition(227.5 - (i - 1) * perLong, -52.0)
				newBox:setPosition(227.5 - (i - 1) * perLong, -150.0)
			else
				newDiv:setPosition((i - 1) * perLong + -227.5, -52.0)
				newBox:setPosition((i - 1) * perLong + -227.5, -150.0)
			end
		end
		self.barImgArrow:setVisible(false)
		self.initProgressFlag = true
	end
	refresh = true
	if refresh then
		local lightNum = 0
		local lightCur = 0
		local perRange = 100 / (#self.boxItemList - 1)
		local topMinCount = self.boxItemList[#self.boxItemList].parts[1]
		local bottomMinCount = self.boxItemList[1].parts[1]
		if bottomMinCount <= self.jointPeople and topMinCount > self.jointPeople then
			for i, v in ipairs(self.boxItemList) do
				local vMin = v.parts[1]
				local vMax = v.parts[2]
				if vMin <= self.jointPeople and vMax >= self.jointPeople then
					lightNum = i
					lightCur = (self.jointPeople - vMin) / (vMax - vMin + 1)
				end
			end
		elseif bottomMinCount > self.jointPeople then
			lightNum = 0
			lightCur = 0
		elseif topMinCount <= self.jointPeople then
			lightNum = #self.boxItemList
			lightCur = 0
		end
		local totalPercent = 0
		if 1 <= lightNum then
			local basePercent = perRange * (lightNum - 1)
			local addPercent = lightCur * perRange
			totalPercent = basePercent + addPercent
		else
			totalPercent = 0
		end
		self.loadBar:setPercent(totalPercent)
		local barLong = self.loadBar:getContentSize().width
		if SoraDFIsRA() then
			self.spLoadDivide:setPositionX(227.5 - totalPercent / 100 * barLong)
		else
			self.spLoadDivide:setPositionX(totalPercent / 100 * barLong - 227.5)
		end
		self:initContentScroll(lightNum == 0 and 1 or lightNum)
		for i, v in ipairs(self.boxOcxList) do
			if i == lightNum then
				v:getChildByName("Image_itemBg"):getVirtualRenderer():setState(0)
				v:getChildByName("Image_item"):getVirtualRenderer():setState(0)
			else
				v:getChildByName("Image_itemBg"):getVirtualRenderer():setState(1)
				v:getChildByName("Image_item"):getVirtualRenderer():setState(1)
			end
		end
	end
end
function KingdomGroupBuyView:boxItemClick(box, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:initContentScroll(box:getTag())
	end
end
function KingdomGroupBuyView:createBoxFun(data, index)
	index = index or 1
	local box = self.itemBoxCopy:clone()
	local boxConfig = kingdomGroupBuyRead.getBoxConfig(index)
	local bgImg = itemDesRead.getBgByLv(boxConfig.quality)
	box:getChildByName("Sprite_ItemBoxGlow"):setVisible(false)
	box:getChildByName("Image_itemBg"):loadTexture(bgImg, ccui.TextureResType.plistType)
	box:getChildByName("Image_item"):loadTexture(boxConfig.boxImg, ccui.TextureResType.plistType)
	kingdomGroupBuyRead = nil
	;(nil).num = data.discount
	;(nil).char = "%"
	box:getChildByName("BitmapFontLabel_discount"):setString(i18n("common_text_1470", nil))
	return box
end
function KingdomGroupBuyView:initContentScroll(index)
	for k, v in pairs(self.boxOcxList) do
		if index == v:getTag() then
			v:getChildByName("Sprite_ItemBoxGlow"):setVisible(true)
		else
			v:getChildByName("Sprite_ItemBoxGlow"):setVisible(false)
		end
	end
	if self.boxItemList[index] then
		if not self.boxItemList[index + 1] or not self.boxItemList[index + 1].reward then
			local _ENV, nextReward = self.boxItemList[index + 1].reward, self.boxItemList[index + 1].reward
		end
		local totalH = self:initRewardList(self.boxItemList[index].reward, nextReward)
		local sSize = self.contentScroll:getContentSize()
		local sH = math.max(sSize.height, totalH)
		self.contentScroll:setInnerContainerSize(cc.size(sSize.width, sH))
		self.nodeContent:setPositionY(sH)
		if next(nextReward) then
			self.txtAddTip:setVisible(true)
		else
			self.txtAddTip:setVisible(false)
		end
	end
end
function KingdomGroupBuyView:initRewardList(rewardList, nextReward)
	self.nodeReward:removeAllChildren()
	local publicRead = include("publicRead")
	local list = SoraDIntArr2FormatTable(rewardList)
	if next(nextReward) then
		local nextList = SoraDIntArr2FormatTable(nextReward)
		for i, v in ipairs(list) do
			local single = self.itemCopy:clone()
			single:addTo(self.nodeReward)
			single:getChildByName("Image_itemIcon"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			single:getChildByName("Image_itemBuff"):loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			single:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			single:getChildByName("Text_itemCount"):setString(v.num)
			local deta = nextList[i].num - v.num
			single:getChildByName("Text_newCount"):setString("+" .. deta)
			single:setPosition(0, -75 * (i - 1))
			single:getChildByName("Image_itemIcon"):setTag(v.id)
			single:getChildByName("Image_itemIcon"):setTouchEnabled(true)
			single:getChildByName("Image_itemIcon"):setSwallowTouches(false)
			single:getChildByName("Image_itemIcon"):addTouchEventListener(handler(self, self.itemClick))
		end
	else
		for i, v in ipairs(list) do
			local single = self.itemCopy:clone()
			single:addTo(self.nodeReward)
			single:getChildByName("Image_itemIcon"):loadTexture(publicRead.getIcon(v.id), ccui.TextureResType.plistType)
			single:getChildByName("Image_itemBuff"):loadTexture(publicRead.getBg(v.id), ccui.TextureResType.plistType)
			single:getChildByName("Text_itemName"):setString(publicRead.getName(v.id))
			single:getChildByName("Text_itemCount"):setString(v.num)
			single:getChildByName("Sprite_arrow"):setVisible(false)
			single:getChildByName("Text_newCount"):setVisible(false)
			single:setPosition(0, -75 * (i - 1))
			single:getChildByName("Image_itemIcon"):setTag(v.id)
			single:getChildByName("Image_itemIcon"):setTouchEnabled(true)
			single:getChildByName("Image_itemIcon"):setSwallowTouches(false)
			single:getChildByName("Image_itemIcon"):addTouchEventListener(handler(self, self.itemClick))
		end
	end
	return 75 * #list - self.nodeReward:getPositionY() + 20
end
function KingdomGroupBuyView:itemClick(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(button, pos)
	end
end
function KingdomGroupBuyView:openItem(item, pos)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(item:getTag())
	if SoraDFIsRA() then
		if pos.x < 280 then
			self.pFloor:setPosition(pos.x + 280, pos.y)
		else
			self.pFloor:setPosition(pos.x, pos.y)
		end
	elseif pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y)
	else
		self.pFloor:setPosition(pos.x, pos.y)
	end
	self.pFloor:addTo(self, 100)
end
function KingdomGroupBuyView:noticeScrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.scrollingEnd then
		if self.recordCanGet then
			if self.recordReqBack then
				self.recordReqBack = false
				local gametop = gModuleMgr.getObject("gametop")
				local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
				kingGroupBuyAgCtrl:sendLogMsg(self.recordIndex)
			end
		else
			print("加载完毕")
		end
		if self.needJumpToTop then
			self.noticeScroll:jumpToTop()
			self.noticeScroll:updateScroll()
			self.needJumpToTop = false
		end
	end
end
function KingdomGroupBuyView:btnMoreClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local oriY = self.panelBottom:getPositionY()
		local disY = self.panelBottom:getContentSize().height
		local foldAction = cca.moveTo(0.25, 320, oriY - disY)
		self.panelBottom:runAction(cc.EaseExponentialOut:create(foldAction))
		self.btnMore:setVisible(false)
		self.noticeScroll:setTouchEnabled(true)
		self.imgArrow:setVisible(true)
	end
end
function KingdomGroupBuyView:imgArrowClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local oriY = self.panelBottom:getPositionY()
		local disY = self.panelBottom:getContentSize().height
		local unfoldAction = cca.moveTo(0.25, 320, oriY + disY)
		self.panelBottom:runAction(cc.EaseExponentialOut:create(unfoldAction))
		self.btnMore:setVisible(true)
		self.noticeScroll:setTouchEnabled(false)
		self.imgArrow:setVisible(false)
		self.noticeScroll:jumpToTop()
		self.noticeScroll:updateScroll()
		self.needJumpToTop = true
	end
end
function KingdomGroupBuyView:btnSingleClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
		if kingGroupBuyAgCtrl:getCanRecharge() then
			if self.leftBuy < self.rechargeInfo1.num then
				_ENV = nil
				;(nil).max = self.maxBuy
				SoraDShowMsgTip(i18n("common_text_3489", nil))
			else
				_ENV = i18n("common_text_3489", nil)
				i18n("common_text_3489", nil).msg = "MESSAGE_UI_COMMON_MSGBOX"
				i18n("common_text_3489", nil).fromTarget = self
				SoraDSendMessage(i18n("common_text_3489", nil))
				_ENV = i18n("common_text_3489", nil)
				i18n("common_text_3489", nil).fromTarget = self
				SoraDShowMsgBox(i18n("common_text_3490"), i18n("common_text_204"), nil, function(msgType)
					if MSGBOX_CALLBACK_YES == msgType then
						print("self.rechargeInfo1.rid = ", self.rechargeInfo1.rid)
						paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD13, nil, nil, nil, gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY)
						paymentManager.normalGiftBuyClassify(self.rechargeInfo1.rid)
						self.rechargePopBox = nil
					end
				end, i18n("common_text_3489", nil))
			end
		else
			SoraDShowMsgTip(i18n("common_text_3492"))
		end
	end
end
function KingdomGroupBuyView:btnDoubleClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local gametop = gModuleMgr.getObject("gametop")
		local kingGroupBuyAgCtrl = gametop.playertop_:getModule("kingGroupBuyAgCtrl")
		if kingGroupBuyAgCtrl:getCanRecharge() then
			if self.leftBuy < self.rechargeInfo2.num then
				_ENV = nil
				;(nil).max = self.maxBuy
				SoraDShowMsgTip(i18n("common_text_3489", nil))
			else
				_ENV = i18n("common_text_3489", nil)
				i18n("common_text_3489", nil).msg = "MESSAGE_UI_COMMON_MSGBOX"
				i18n("common_text_3489", nil).fromTarget = self
				SoraDSendMessage(i18n("common_text_3489", nil))
				_ENV = i18n("common_text_3489", nil)
				i18n("common_text_3489", nil).fromTarget = self
				SoraDShowMsgBox(i18n("common_text_3490"), i18n("common_text_204"), nil, function(msgType)
					if MSGBOX_CALLBACK_YES == msgType then
						print("self.rechargeInfo2.rid = ", self.rechargeInfo2.rid)
						paymentManager.normalGiftBuyClassify(self.rechargeInfo2.rid)
						self.rechargePopBox = nil
					end
				end, i18n("common_text_3489", nil))
			end
		else
			SoraDShowMsgTip(i18n("common_text_3492"))
		end
	end
end
function KingdomGroupBuyView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_3486"))
	end
end
function KingdomGroupBuyView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.KING_GROUP_BUY_ACTIVITY)
	if gActivityState.CLOSE == state then
		self:close(nil, ccui.TouchEventType.ended)
	end
end
return KingdomGroupBuyView
