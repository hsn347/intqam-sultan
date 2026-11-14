local GroupBuyView = class("groupBuyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("groupBuyView")
	end
	return target
end)
function GroupBuyView:ctor()
	self.sectionText, _ENV, self.needCallBack2SDK = nil, nil, true
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.btnBuy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldNormalBtn_buy")
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.item:setScale(1.4)
	self.item:setBaseScale(1.0)
	self.item:setOwnView(self)
	self.txtItem = SoraDGetChildByName(self, "Text_item")
	self.txtOldPrice = SoraDGetChildByName(self, "Text_oldPrice")
	self.loadingGroupBuy = SoraDGetChildByName(self, "LoadingBar_groupBuy")
	self.txtGroupCount = SoraDGetChildByName(self, "Text_groupCount")
	self.txtGroupTip = SoraDGetChildByName(self, "Text_groupCountTip")
	self.txtTimeTip = SoraDGetChildByName(self, "Text_timeTip")
	self.nextItem = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_Next")
	self.nextItem:setScale(0.9)
	self.nextItem:setBaseScale(1.0)
	self.nextItem:setOwnView(self)
	self.nextItemName = SoraDGetChildByName(self, "Text_itemNext")
	self.txtLast = SoraDGetChildByName(self, "Text_lastTip")
	self.nextTip = SoraDGetChildByName(self, "Text_nextTip")
	self.txtLast:setString(i18n("common_text_2676"))
	self.nextTip:setString(i18n("common_text_2675"))
	SoraDGetChildByName(self, "Text_groupBuyDes"):setString(i18n("common_text_1822"))
	SoraDGetChildByName(self, "Text_windowTitle"):setString(i18n("common_text_1813"))
	_ENV = i18n("common_text_1813")
	i18n("common_text_1813").num = "  "
	SoraDGetChildByName(self, "Text_groupCountTip"):setString(i18n("common_text_1818", i18n("common_text_1813")))
	self.touchActionPanel = SoraDGetChildByName(self, "Center_Panel_bg")
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_GROUPBUY_REFRESH", handler(self, self.initData))
	self:req4Info()
end
function GroupBuyView:req4Info(...)
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local groupBuyCtrl = gametop.playertop_:getModule("groupBuyCtrl")
	groupBuyCtrl:reqActivityInfo()
end
function GroupBuyView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.GROUP_BUY)
	if gActivityState.CLOSE == state then
		self:removeFromParent()
	end
end
function GroupBuyView:initData(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.redata then
		local itemID = redata.redata.goodID
		local itemCount = redata.redata.goodCount
		if itemID then
			SoraDPopGainItem(itemID, itemCount)
		end
	end
	local gametop = gModuleMgr.getObject("gametop")
	local groupBuyCtrl = gametop.playertop_:getModule("groupBuyCtrl")
	_ENV = gametop.playertop_
	gametop.playertop_.itemID = groupBuyCtrl.goodID
	gametop.playertop_.itemCount = groupBuyCtrl.goodCount
	gametop.playertop_.oriPrice = groupBuyCtrl.originalPrice
	gametop.playertop_.curPeople = groupBuyCtrl.curPeople
	gametop.playertop_.isBuy = groupBuyCtrl.isBuy
	gametop.playertop_.curPrice = groupBuyCtrl.curPrice
	gametop.playertop_.nextItem = groupBuyCtrl.nextGoodID
	gametop.playertop_.nextItemCount = groupBuyCtrl.nextGoodCount
	local _UPVALUE4_, self.needCountList, _ENV, groupItemInfo.section, _ENV, gametop.playertop_.isFinalRound, groupItemInfo = groupBuyCtrl:isFinallyRound(), groupBuyCtrl:isFinallyRound(), groupBuyCtrl:isFinallyRound(), groupBuyCtrl:isFinallyRound(), groupBuyCtrl:isFinallyRound(), groupBuyCtrl:isFinallyRound(), gametop.playertop_
	groupBuyCtrl:isFinallyRound()[1] = "x1"
	groupBuyCtrl:isFinallyRound()[2] = "x2"
	groupBuyCtrl:isFinallyRound()[3] = "x3"
	local groupBuyCtrl:isFinallyRound()[4], stallStr = "x4", groupBuyCtrl:isFinallyRound()
	for i, v in ipairs(stallStr) do
		local tmpCurStall = groupBuyCtrl.stall[v]
		_ENV = nil
		;(nil).price = tmpCurStall.gold
		;(nil).num = tmpCurStall.people
		table.insert(groupItemInfo.section, nil)
		table.insert(self.needCountList, tmpCurStall.people)
	end
	do
		local _ENV, sectionTbl = (for generator), ipairs(stallStr)
		for i, v in ipairs(groupItemInfo.section) do
			table.insert(sectionTbl, v.num)
		end
		groupItemInfo.sectionTbl = sectionTbl
	end
	self.groupItemInfo = groupItemInfo
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if not self.timer then
		self.timeNode = groupBuyCtrl:queryQueue(groupBuyCtrl.curRoundState)
		self.timeState = groupBuyCtrl.curRoundState
		self.timer = SoradCreateTimer(self, handler(self, self.timeCount))
		self:timeCount()
	end
	self:initView()
end
function GroupBuyView:initView(...)
	local publicRead = include("publicRead")
	self.item:initData(self.groupItemInfo.itemID, tostring(self.groupItemInfo.itemCount))
	self.txtItem:setString(publicRead.getName(self.groupItemInfo.itemID))
	_ENV = publicRead.getName(self.groupItemInfo.itemID)
	publicRead.getName(self.groupItemInfo.itemID).price = self.groupItemInfo.oriPrice
	self.txtOldPrice:setString(i18n("common_text_1814", publicRead.getName(self.groupItemInfo.itemID)))
	self:initTimeState()
	self:cleanOcx()
	self:initProgressBar()
	self:refreshData(self.groupItemInfo.curPeople)
	self:initNextItem()
end
function GroupBuyView:initNextItem(...)
	if not self.groupItemInfo.isFinalRound then
		if self.groupItemInfo.nextItem ~= 0 then
			self.nextItem:setVisible(true)
			self.nextItemName:setVisible(true)
			self.nextTip:setVisible(true)
			self.txtLast:setVisible(false)
			local publicRead = include("publicRead")
			local _id = self.groupItemInfo.nextItem
			local _count = self.groupItemInfo.nextItemCount
			self.nextItem:initData(_id, tostring(_count))
			self.nextItemName:setString(publicRead.getName(_id))
		end
	else
		self.nextItem:setVisible(false)
		self.nextItemName:setVisible(false)
		self.nextTip:setVisible(false)
		self.txtLast:setVisible(true)
	end
end
function GroupBuyView:initTimeState(...)
	local hideBuyOcx = function(bool)
		if bool then
			self = nil
			;(nil).title = i18n("common_text_282")
			self.btnBuy:initData(nil, 1)
			self.btnBuy:setTouchEnabled(true)
			self.btnBuy:setBright(true)
		else
			self = true
			self.btnBuy:initData(true, 0)
			self.btnBuy:setTouchEnabled(false)
			self.btnBuy:setBright(false)
		end
	end
	if self.timeNode then
		if gGroupBuyActivityState.CLOSE == self.timeState then
			hideBuyOcx(false)
			self.txtTimeTip:setString(i18n("common_text_1861"))
			self.btnBuy:setTitleText(i18n("common_text_1858"))
		elseif gGroupBuyActivityState.OPEN == self.timeState then
			hideBuyOcx(not self.groupItemInfo.isBuy)
			self.txtTimeTip:setString(i18n("common_text_1860"))
			self.btnBuy:setTitleText(self.groupItemInfo.isBuy and i18n("common_text_1857") or "")
		end
	else
		hideBuyOcx(false)
		self.btnBuy:setTitleText(i18n("common_text_1858"))
		self.txtTimeTip:setString(i18n("common_text_1859"))
	end
end
function GroupBuyView:cleanOcx()
	self.loadingGroupBuy:removeAllChildren()
	self.sectionText, _UPVALUE0_ = self.loadingGroupBuy.removeAllChildren, self.loadingGroupBuy.removeAllChildren
end
function GroupBuyView:initProgressBar()
	local longWidth = self.loadingGroupBuy:getContentSize().width
	local posY = self.loadingGroupBuy:getContentSize().height / 2
	_UPVALUE2_ = self.loadingGroupBuy
	_UPVALUE4_, self.loadingGroupBuy[1] = 20, 20
	local _UPVALUE4_, self.loadingGroupBuy[2], divTbl = 20, 50, self.loadingGroupBuy
	;(20)[1] = 0
	;(20)[2] = 25
	;(20)[3] = 50
	local (20)[4], txtPos = 90, 20
	if SoraDFIsRA() then
		_UPVALUE4_ = SoraDFIsRA()
		_UPVALUE2_, txtPos, SoraDFIsRA()[1] = SoraDFIsRA(), SoraDFIsRA(), 100
		_UPVALUE2_, txtPos, SoraDFIsRA()[2] = SoraDFIsRA(), SoraDFIsRA(), 75
		_UPVALUE2_, txtPos, SoraDFIsRA()[3] = SoraDFIsRA(), SoraDFIsRA(), 50
		_UPVALUE2_, txtPos, SoraDFIsRA()[4] = SoraDFIsRA(), SoraDFIsRA(), 10
		divTbl, SoraDFIsRA()[1] = SoraDFIsRA(), 80
		divTbl, SoraDFIsRA()[2] = SoraDFIsRA(), 50
		self.loadingGroupBuy:setDirection(1)
	end
	for i, v in ipairs(divTbl) do
		local poxX = v / 100 * longWidth
		local spDivide = display.newSprite("#progressbar_cumu_recharge_line.png")
		spDivide:setPosition(poxX, posY)
		spDivide:addTo(self.loadingGroupBuy)
	end
	for i, v in ipairs(self.groupItemInfo.section) do
		local str = ""
		if i == 1 then
			_ENV = posY
			posY.gold = v.price
			str = i18n("common_text_1816") .. "\n" .. i18n("common_text_1835", posY)
		else
			_ENV = i18n("common_text_1835", posY)
			i18n("common_text_1835", posY).num = v.num
			_ENV = posY
			posY.gold = v.price
			str = i18n("common_text_1817", (i18n("common_text_1835", posY))) .. "\n" .. i18n("common_text_1835", posY)
		end
		local txt = ccui.Text:create(str, "", 20)
		txt:ignoreContentAdaptWithSize(false)
		txt:setContentSize(cc.size(91, 60))
		txt:setAnchorPoint(SoraDFAP(cc.p(0.8, 1)))
		txt:setColor(cc.c3b(245, 211, 0))
		txt:setTextHorizontalAlignment(SoraDFLabelR())
		txt:setPosition(txtPos[i] / 100 * longWidth, -20)
		txt:addTo(self.loadingGroupBuy)
		table.insert(self.sectionText, txt)
	end
end
function GroupBuyView:refreshData(people)
	local groupBuy = people
	_UPVALUE4_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 20
	;(nil)[3] = 50
	local (nil)[4], txtTbl = 100, nil
	local countTbl = self.needCountList
	local sectionTbl = self.groupItemInfo.section
	local section = 0
	if groupBuy <= 0 then
		section = 1
	elseif groupBuy >= sectionTbl[#sectionTbl].num then
		section = #sectionTbl
	else
		for i, v in ipairs(sectionTbl) do
			if 0 < v.num - groupBuy then
				section = i - 1
				break
			end
		end
	end
	local setPeople = function(...)
		local pX = self.txtGroupTip:getPositionX()
		local dX = self.txtGroupTip:getContentSize().width / 2 + 15
		self.txtGroupCount:setPositionX(pX - dX)
	end
	setPeople()
	self.txtGroupCount:setString(groupBuy)
	self.btnBuy:setGoldText(self.groupItemInfo.curPrice)
	for i, v in ipairs(self.sectionText) do
		if i < section then
			v:setColor(cc.c3b(245, 211, 0))
			v:setScale(1)
		elseif i == section then
			v:setColor(cc.c3b(245, 211, 0))
			v:setScale(1.4)
		else
			v:setColor(cc.c3b(174, 160, 160))
			v:setScale(1)
		end
	end
	local baseWidth = 0
	if groupBuy <= 0 then
		baseWidth = 0
	elseif groupBuy >= sectionTbl[#sectionTbl].num then
		baseWidth = txtTbl[#sectionTbl]
	else
		baseWidth = txtTbl[section] + (groupBuy - countTbl[section]) / (countTbl[section + 1] - countTbl[section]) * (txtTbl[section + 1] - txtTbl[section])
	end
	print("baseWidth:", baseWidth)
	self.loadingGroupBuy:setPercent(baseWidth)
end
function GroupBuyView:btnBuyClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_1856"), i18n("common_text_204"), nil, function(cb)
			if MSGBOX_CALLBACK_YES == cb then
				SoraDPlaySound()
				if SoraDEnoughGold(self.groupItemInfo.curPrice) then
					local gametop = gModuleMgr.getObject("gametop")
					local groupBuyCtrl = gametop.playertop_:getModule("groupBuyCtrl")
					groupBuyCtrl:buyGood(self.groupItemInfo.itemID)
					SoraDShowLoading(self)
				end
			end
		end)
	end
end
function GroupBuyView:timeCount(dt)
	if self.timeNode then
		local showCount = self.timeNode.timerNode.timer:getRemainTime()
		self.txtTime:setString(SoraDConvertSecondToString(showCount))
	else
		self.txtTime:setString("")
	end
end
return GroupBuyView
