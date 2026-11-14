local signRewadRead = include("signRewadRead")
local SignRewardMainView = class("signRewardMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("signRewardMainView")
	end
	return target
end)
function SignRewardMainView:ctor()
	self.blockTbl, _ENV, self.lampTbl, _ENV = nil, nil, nil, nil
	self.topFrame = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_signReward")
	self.topFrame:setTitle(i18n("activity_name_9001038"))
	self.topFrame:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.imgLamp = SoraDGetChildByName(self, "Image_lampCopy")
	self.topScroll = SoraDGetChildByName(self, "Top_ScrollView_lamps")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.btnGold = SoraDGetChildByName(self, "Button_goldSignCopy")
	self.btnSilver = SoraDGetChildByName(self, "Button_sliverSignCopy")
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.txtTimes = SoraDGetChildByName(self, "Text_times")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.txtTitle = SoraDChangeTextToHtml(self.txtTitle)
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.shadow = SoraDGetChildByName(self, "Top_Size_Panel")
	self.effectNode = SoraDGetChildByName(self.topNode, "Effect_Node")
	self:initBlockClass()
	self:initBottomText()
	self:initMainEffect()
	self:initData()
end
function SignRewardMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_LAMPREFRESH", handler(self, self.dispatchFun))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_BLOCKREFRESH", handler(self, self.dispatchFun))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_SIGNREWARD_EVENTCHANGE", handler(self, self.eventStateChange))
end
function SignRewardMainView:initMainEffect()
	local loop = true
	local cssFileName = "signRewardMainView"
	local cssFilePath = getCCSPath(cssFileName)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
	local effectMain = SoraDCreatAnimation("Node_Effect_zyqd01", nil, true)
	SoraDMixtureGLONEByParent(effectMain)
	effectMain:setPosition(cc.p(0, 0))
	self.effectNode:addChild(effectMain, 10)
	SoraDGetChildByName(self, "Image_lBar"):setContentSize(21, 405 + self:getPanelOffsetHeight() - 960)
	SoraDGetChildByName(self, "Image_rBar"):setContentSize(21, 405 + self:getPanelOffsetHeight() - 960)
	SoraDGetChildByName(self, "Image_LSheer"):setContentSize(82, self:getPanelOffsetHeight())
	SoraDGetChildByName(self, "Image_RSheer"):setContentSize(82, self:getPanelOffsetHeight())
end
function SignRewardMainView:playLampsEffect(parent, isPlay)
	if isPlay then
		if parent.effectLamp then
			SoraDResetEffectNode(parent.effectLamp)
			parent.effectLamp.action:gotoFrameAndPlay(0, 136, true)
		else
			parent.effectLamp = SoraDCreatAnimationEx("Node_zyqd_lamp", nil, true)
			SoraDMixtureGLONEByParent(parent.effectLamp)
			parent.effectLamp:setPosition(cc.p(29.5, 50))
			parent.effectLamp:addTo(parent, 10)
		end
	elseif parent.effectLamp then
		parent.effectLamp:removeFromParent()
		parent.effectLamp = nil
	end
end
function SignRewardMainView:initInfoText(...)
	local gametop = gModuleMgr.getObject("gametop")
	local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local totalSignUpDays = signRewardCtrl:getTotalSignDay()
	local startDate = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY)
	local endDate = activityShowCtrl:getEndTimeSecond(gActivityTimeActivityID.SIGN_REWARD_ACTIVITY)
	_ENV = nil
	_ENV, _ENV, (nil).day = nil, nil, totalSignUpDays
	_ENV, (nil).day, (nil).color = nil, nil, "#ffff00"
	;(nil).__default, (nil).color = nil, "#ffffff"
	self.txtTitle:setString(i18n_html("common_text_2879", nil, nil))
	if SoraDFIsRA() then
		_ENV = i18n_html("common_text_2879", nil, nil)
		i18n_html("common_text_2879", nil, nil).sd = _pq(os.date("%Y-%m-%d", endDate))
		i18n_html("common_text_2879", nil, nil).ed = _pq(os.date("%Y-%m-%d", startDate))
		self.txtTimes:setString(i18n("common_text_2880", i18n_html("common_text_2879", nil, nil)))
	else
		_ENV = i18n("common_text_2880", i18n_html("common_text_2879", nil, nil))
		i18n("common_text_2880", i18n_html("common_text_2879", nil, nil)).sd = _pq(os.date("%Y-%m-%d", startDate))
		i18n("common_text_2880", i18n_html("common_text_2879", nil, nil)).ed = _pq(os.date("%Y-%m-%d", endDate))
		self.txtTimes:setString(i18n("common_text_2880", i18n("common_text_2880", i18n_html("common_text_2879", nil, nil))))
	end
end
function SignRewardMainView:dispatchFun(target, redata)
	SoraDCloseLoading(self)
	local refreshOcx = function(dayTbl, day)
		for k, v in pairs(dayTbl) do
			if v.myDay == day then
				v.ocx:refreshSelf()
			end
		end
	end
	if redata and redata.blockDay then
		refreshOcx(self.blockTbl, redata.blockDay)
	elseif redata and redata.lampDay then
		refreshOcx(self.lampTbl, redata.lampDay)
	end
	if redata and redata.itemList then
		local _ENV, tTbl = redata.itemList, redata.itemList
		for i, v in ipairs(redata.itemList) do
			tTbl[v.id] = v.count
		end
		SoraDMailGainItems(tTbl)
	end
	self:initInfoText()
end
function SignRewardMainView:initData(...)
	self:initBanner()
	self:initInfoText()
	self:initView()
end
function SignRewardMainView:initBanner(...)
	local gametop = gModuleMgr.getObject("gametop")
	local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
	local lampIndex = signRewardCtrl:getCumuDayArray()
	if SoraDFIsRA() then
		table.sort(lampIndex, function(a, b)
			return b < a
		end)
	end
	local _ENV, factoryTbl = table.sort, table.sort
	for i, v in ipairs(lampIndex) do
		_ENV = nil
		;(nil).index = i
		;(nil).myDay = v
		;(nil).style = i % 3 + 1
		;(nil).state = signRewardCtrl:getExtraRewardInfoByDay(v)
		table.insert(factoryTbl, nil)
	end
	local itemSize = cc.size(100, 170)
	local sSize = self.topScroll:getContentSize()
	local needWidth = itemSize.width * #factoryTbl
	local sW = math.max(sSize.width, needWidth)
	self.topScroll:setInnerContainerSize(cc.size(sW, sSize.height))
	for i, v in ipairs(factoryTbl) do
		local lamp = self:createLamp(v)
		lamp:addTo(self.topScroll)
		lamp:setPosition(sW / 2 - needWidth / 2 + itemSize.width / 2 + (i - 1) * itemSize.width, sSize.height / 2 + 20)
	end
end
function SignRewardMainView:createLamp(_info)
	local function lampFactory(newLamp, info)
		newLamp = newLamp or self.imgLamp:clone()
		local numCircle = newLamp:getChildByName("Image_numBg")
		local showNum = newLamp:getChildByName("Image_numBg"):getChildByName("Text_num")
		self:playLampsEffect(newLamp, gSignRewardStatus.CAN_RECEIVE == info.state)
		showNum:setString(info.myDay)
		local mask = newLamp:getChildByName("mask")
		mask:setVisible(false)
		mask:setVisible(gSignRewardStatus.ALREADY_RECEIVE == info.state)
		newLamp:setTouchEnabled(true)
		newLamp:setSwallowTouches(false)
		function newLamp.meClick(...)
			local panel = SoraDCreatePanel("signRewardPopView")
			panel:setFatherLoading(handler(self, self.showLoading))
			panel:initLampData(info.myDay)
			panel:begin2Action()
			panel:show()
			panel:setFromAction(newLamp:convertToWorldSpace(cc.p(25, 40)))
		end
		newLamp:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				if not SoraDIsNodeVisibleOnScroll(button, self.topScroll) then
					print("node is not on view")
					return
				end
				if self.singleIsMoved then
					self.singleIsMoved = false
					return
				end
				SoraDPlaySound()
				local panel = SoraDCreatePanel("signRewardPopView")
				panel:setFatherLoading(handler(self, self.showLoading))
				panel:initLampData(info.myDay)
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
		end)
		function newLamp.refreshSelf(target)
			local gametop = gModuleMgr.getObject("gametop")
			local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
			local _state = signRewardCtrl:getExtraRewardInfoByDay(info.myDay)
			_ENV = nil
			;(nil).index = info.index
			;(nil).myDay = info.myDay
			;(nil).style = info.style
			;(nil).state = _state
			lampFactory(newLamp, nil)
		end
		return newLamp
	end
	local _lamp = lampFactory(nil, _info)
	_ENV = nil
	;(nil).myDay = _info.myDay
	;(nil).ocx = _lamp
	table.insert(self.lampTbl, nil)
	return _lamp
end
function SignRewardMainView:initBlockClass()
	self.numBlock = class("numBlock", function(target)
		return target
	end)
	function self.numBlock:ctor()
		self.singleIsMoved = false
		self.imgNike = self:getChildByName("Image_got")
		self.imgG = self:getChildByName("Image_nike")
		self.txtNum = self:getChildByName("BitmapFontLabel_num")
		self.txtNum:setScale(0.8)
		self.panelMask = self:getChildByName("Panel_mask")
		self:addTouchEventListener(handler(self, self.blockClick))
	end
	function self.numBlock:initData(tbl)
		self.info = tbl
		self.info.isGot = gSignRewardType.NO_SIGN ~= tbl.state
		self:initView()
	end
	function self.numBlock:setScroll(scroll)
		self.fScroll = scroll
	end
	function self.numBlock:setFatherLoading(handl)
		self.fatherLoading = handl
	end
	function self.numBlock:refreshSelf(...)
		local refreshFun = function()
			local day = self.info.myDay
			local gametop = gModuleMgr.getObject("gametop")
			local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
			self = nil
			;(nil).state = signRewardCtrl:getSignTypeByDay(day)
			;(nil).curDay = signRewardCtrl:getCurDay()
			;(nil).myDay = day
			self:initData(nil)
		end
		self:addItemUseEffect(refreshFun)
	end
	function self.numBlock:addItemUseEffect(fun)
		if not self.effect then
			self.effect = SoraDCreatAnimationEx("animationGainItemEffect", nil, false)
			self.effect:setScale(0.6)
			SoraDMixtureGLONEByParent(self.effect)
			self.effect:setPosition(63.5, 63.5)
			self:addChild(self.effect)
		end
		self.effect.action:gotoFrameAndPlay(0, false)
		_ENV = false
		;(false).delay = 0
		;(false).onComplete = function()
			if fun then
				fun()
			end
		end
		transition.execute(self, nil, false)
	end
	function self.numBlock:initView(...)
		if self.info.myDay then
			self.txtNum:setString(self.info.myDay)
		end
		if self.info.myDay == self.info.curDay and not self.info.isGot then
			if not self:getChildByName("signEffectNode") then
				local effectNode = self:getSignEffectNode(self:getContentSize())
				effectNode:addTo(self)
			end
		elseif self:getChildByName("signEffectNode") then
			self:getChildByName("signEffectNode"):removeFromParent()
		end
		if self.info.myDay < self.info.curDay or self.info.isGot then
			self.panelMask:setVisible(true)
		else
			self.panelMask:setVisible(false)
		end
		if self.info.isGot then
			self.txtNum:setVisible(false)
			self.imgNike:setVisible(true)
			self.imgG:setVisible(true)
		else
			self.txtNum:setVisible(true)
			self.imgNike:setVisible(false)
			self.imgG:setVisible(false)
		end
	end
	function self.numBlock:blockClick(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			if not SoraDIsNodeVisibleOnScroll(button, self.fScroll) then
				print("node is not on view")
				return
			end
			if self.singleIsMoved then
				self.singleIsMoved = false
				return
			end
			SoraDPlaySound()
			local panel = SoraDCreatePanel("signRewardPopView")
			panel:setFatherLoading(self.fatherLoading)
			panel:initData(self.info.myDay)
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
	function self.numBlock:getSignEffectNode(size)
		local node = display.newNode()
		node:setName("signEffectNode")
		node:setPosition(size.width / 2, size.height / 2)
		local effectItem = SoraDCreatAnimation("Node_zyqd_Item", nil, true)
		effectItem:addTo(node, 4)
		return node
	end
end
function SignRewardMainView:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local signRewardCtrl = gametop.playertop_:getModule("signRewardCtrl")
	local maxDay = signRewardCtrl:getTotalDay()
	local today = signRewardCtrl:getCurDay()
	if not maxDay then
		return
	end
	local returnBlockStyle = function(_id)
		if 1 == signRewadRead.getStyleByID(_id) then
			return self.btnSilver:clone()
		elseif 2 == signRewadRead.getStyleByID(_id) then
			return self.btnGold:clone()
		end
	end
	local blockSize = cc.size(135, 135)
	for day = 1, maxDay do
		local arr = SoraDFIsRA() and -1 or 1
		local blockStyle = returnBlockStyle(day)
		if not blockStyle then
			maxDay = day - 1
			break
		end
		local item = self.numBlock.new(returnBlockStyle(day))
		_ENV = returnBlockStyle(day)
		returnBlockStyle(day).state = signRewardCtrl:getSignTypeByDay(day)
		returnBlockStyle(day).curDay = today
		returnBlockStyle(day).myDay = day
		item:initData(returnBlockStyle(day))
		item:setFatherLoading(handler(self, self.showLoading))
		item:setSwallowTouches(false)
		item:setScroll(self.scroll)
		item:setPosition(-blockSize.width * 2 * arr + blockSize.width / 2 * arr + (day - 1) % 4 * blockSize.width * arr, -(math.ceil(day / 4) - 1) * blockSize.height)
		item:addTo(self.nodeContent)
		_ENV = self.nodeContent
		self.nodeContent.myDay = day
		self.nodeContent.ocx = item
		table.insert(self.blockTbl, self.nodeContent)
	end
	local paddingBottom = 25
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, blockSize.height * math.ceil(maxDay / 4) + paddingBottom)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeContent:setPositionY(sH)
	local scrollInner = self.scroll:getInnerContainer()
	local totalWidth = scrollInner:getContentSize().height - self.scroll:getContentSize().height
	if 0 < totalWidth then
		local curPosX = (math.ceil(today / 4) - 1) * blockSize.height - sSize.height / 3
		self.scroll:scrollToPercentVertical(curPosX / totalWidth * 100, 1.5, true)
	end
end
function SignRewardMainView:initBottomText(...)
	_UPVALUE3_ = nil
	;(nil)[1] = "common_text_2882"
	;(nil)[2] = "common_text_2883"
	local (nil)[3], noteTipNumsPool = "common_text_2884", nil
	local setText = function()
		local rmdNum = math.random(1, #noteTipNumsPool)
		self.txtTip:setString(i18n(noteTipNumsPool[rmdNum]))
	end
	local action0 = cca.fadeOut(0.5)
	local action1 = cca.fadeIn(0.5)
	local actionDelay = cca.delay(5.0)
	local callFunc = cca.callFunc(function()
		setText()
	end)
	setText()
	_UPVALUE4_ = nil
	;(nil)[1] = action1
	;(nil)[2] = actionDelay
	;(nil)[3] = action0
	;(nil)[4] = callFunc
	self.txtTip:runAction(cc.RepeatForever:create(cca.seq(nil)))
end
function SignRewardMainView:btnHelpClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_2881"
		;("common_text_2881").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_2881"), "common_text_2881")
	end
end
function SignRewardMainView:showLoading(...)
	SoraDShowLoading(self)
end
function SignRewardMainView:eventStateChange(...)
	SoraDRemoveAllAfterPanelFromManager(self)
end
return SignRewardMainView
