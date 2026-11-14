local CrazyIntegralMainView = class("crazyIntegralMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("crazyIntegralMainView")
	end
	return target
end)
function CrazyIntegralMainView:ctor()
	self.imgDivs, _ENV, self.imgBoxs, _ENV = nil, nil, nil, nil
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.nodeContent = SoraDGetChildByName(self, "Node_content")
	self.loadBar = SoraDGetChildByName(self, "LoadingBar_int")
	self.imgArrow = SoraDGetChildByName(self, "Image_arrow")
	self.txtMyRange = SoraDGetChildByName(self, "Text_myRange")
	self.txtAllianceRange = SoraDGetChildByName(self, "Text_allianceRange")
	self.txtKingdomRange = SoraDGetChildByName(self, "Text_kingdomRange")
	self.imgRank = SoraDGetChildByName(self, "Image_rangeCup")
	self.txtMyInt = SoraDGetChildByName(self, "Text_int")
	self.imgPriceBox = SoraDGetChildByName(self, "Image_priceBox")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.spProgress = SoraDGetChildByName(self, "Sprite_progressPoint")
	self.btnCrazyHelp = SoraDGetChildByName(self, "Button_crazyHelp")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Image_contentBg"):setVisible(false)
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_crazy"):setTitle(i18n("common_text_3040"))
	self.imgHead:loadTexture(SoraDCheckPNG("bg_activity_show_pointrace.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_CRAZYINTEGRAL_REQDATA", handler(self, self.initData))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnCrazyHelp:addTouchEventListener(handler(self, self.btnCrazyHelpClick))
	self:addDoubleFireEffect()
	self:initTimer()
	self:req4Info()
end
function CrazyIntegralMainView:initTimer(...)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local crazyIntegralTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY)
	local timeTick = crazyIntegralTime.timerNode.timer:getRemainTime()
	self.txtTime:setTimeLast(function(str)
		_ENV = nil
		;(nil).time = str
		return i18n("common_text_607", nil)
	end)
	self.txtTime:beginTime(timeTick)
end
function CrazyIntegralMainView:req4Info(...)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	SoraDShowLoading(self)
	newActivityCtrl:sendCrazyScoreInfo()
end
function CrazyIntegralMainView:initData(target, redata)
	SoraDCloseLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
	local readyData = newActivityCtrl:getCrazyScoreStageReward()
	local infoData = newActivityCtrl:getCrazyScoreInfo()
	local _ENV, reRange = newActivityCtrl, newActivityCtrl
	for i, v in ipairs(readyData) do
		table.insert(reRange, v.needscore)
	end
	_ENV = (for generator)
	ipairs(readyData).intRange = reRange
	ipairs(readyData).myInt = infoData.score
	ipairs(readyData).allianceRank = infoData.aidRank
	ipairs(readyData).kingdomRank = infoData.kidRank
	ipairs(readyData).personalRank = infoData.rank
	ipairs(readyData).kidScore = infoData.kidScore
	self.myInfo, ipairs(readyData).aidScore = ipairs(readyData)
	self:initView()
end
function CrazyIntegralMainView:initView(...)
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, 440)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeContent:setPosition(sSize.width / 2, sH)
	_ENV = cc.size(sSize.width, sH)
	cc.size(sSize.width, sH).num = string.formatnumberthousands(self.myInfo.myInt)
	self.txtMyInt:setString(i18n("common_text_1256", cc.size(sSize.width, sH)))
	self:initLoadingBar()
	self:initBottomBoard()
end
function CrazyIntegralMainView:initBottomBoard(...)
	if self.myInfo.personalRank == -1 then
		_ENV = nil
		;(nil).rank = i18n("common_text_827")
		if i18n("common_text_825", nil) then
			goto lbl_24
		end
	end
	_ENV = nil
	;(nil).rank = self.myInfo.personalRank
	::lbl_24::
	self.txtMyRange:setString((i18n("common_text_825", nil)))
	if self.myInfo.allianceRank == -1 then
		_ENV = nil
		;(nil).rank = i18n("common_text_827")
		if i18n("common_text_3042", nil) then
			goto lbl_48
		end
	end
	_ENV = nil
	;(nil).rank = self.myInfo.allianceRank
	::lbl_48::
	self.txtAllianceRange:setString((i18n("common_text_3042", nil)))
	if self.myInfo.kingdomRank == -1 then
		_ENV = nil
		;(nil).rank = i18n("common_text_827")
		if i18n("common_text_3043", nil) then
			goto lbl_72
		end
	end
	_ENV = nil
	;(nil).rank = self.myInfo.kingdomRank
	::lbl_72::
	self.txtKingdomRange:setString((i18n("common_text_3043", nil)))
	self.imgRank:setTouchEnabled(true)
	self.imgRank:addTouchEventListener(handler(self, self.imgRankClick))
	self.imgPriceBox:setTouchEnabled(true)
	self.imgPriceBox:addTouchEventListener(handler(self, self.imgPriceBoxClick))
end
function CrazyIntegralMainView:imgRankClick(button, type)
	if type == ccui.TouchEventType.ended then
		button:setScale(1.0)
		local panel = SoraDCreatePanel("crazyIntegralRankView")
		_ENV = nil
		;(nil).personalRank = self.myInfo.personalRank
		;(nil).allianceRank = self.myInfo.allianceRank
		;(nil).kingdomRank = self.myInfo.kingdomRank
		;(nil).personalInt = self.myInfo.myInt
		;(nil).allianceInt = self.myInfo.aidScore
		;(nil).kingdomInt = self.myInfo.kidScore
		panel:setMyRankData(nil)
		panel:start2req()
		panel:show()
	elseif type == ccui.TouchEventType.began then
		button:setScale(1.1)
	elseif type == ccui.TouchEventType.canceled then
		button:setScale(1.0)
	end
end
function CrazyIntegralMainView:imgPriceBoxClick(button, type)
	if type == ccui.TouchEventType.ended then
		button:setScale(1.0)
		local panel = SoraDCreatePanel("crazyIntegralPriceView")
		panel:show()
	elseif type == ccui.TouchEventType.began then
		button:setScale(1.1)
	elseif type == ccui.TouchEventType.canceled then
		button:setScale(1.0)
	end
end
function CrazyIntegralMainView:createTouchPanel(ocx, touchEventHandle)
	local touchSize = ocx:getContentSize()
	local panel = ccui.ImageView:create("bg_transparent.png", ccui.TextureResType.plistType)
	panel:ignoreContentAdaptWithSize(false)
	panel:setContentSize(touchSize)
	panel:setAnchorPoint(cc.p(0, 0))
	panel:addTo(ocx)
	panel:setTouchEnabled(true)
	panel:addTouchEventListener(touchEventHandle)
end
function CrazyIntegralMainView:initLoadingBar(...)
	local arrowFlag = 1
	if SoraDFIsRA() then
		self.loadBar:setDirection(1)
		self.imgArrow:setPositionX(226)
	else
		self.loadBar:setDirection(0)
		self.imgArrow:setPositionX(-226)
		arrowFlag = -1
	end
	if not self.createLoadingDivs then
		local dis = 452 / #self.myInfo.intRange
		local sPX = self.imgArrow:getPositionX()
		for i, v in ipairs(self.myInfo.intRange) do
			newDiv = self.imgArrow:clone()
			newDiv:addTo(self.nodeContent)
			newDiv:setPositionX(sPX - dis * i * arrowFlag)
			newDiv:getChildByName("Text_rangeInt"):setString(string.formatnumberthousands(v))
			if i == #self.myInfo.intRange then
				newDiv:getChildByName("Image_divd"):setVisible(false)
			end
			table.insert(self.imgDivs, newDiv)
			local imgBox = display.newSprite("#icon_recruitsupplies_box_01.png")
			local spSize = imgBox:getContentSize()
			self:createTouchPanel(imgBox, function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					local panel = SoraDCreatePanel("crazyIntegralRangePriceView")
					panel:initData(i)
					panel:show()
				end
			end)
			imgBox:addTo(self.nodeContent)
			imgBox:setScale(0.7)
			imgBox:setPosition(sPX - dis * i * arrowFlag + dis / 2 * arrowFlag, -125)
			table.insert(self.imgBoxs, imgBox)
		end
		self.imgArrow:getChildByName("Image_divd"):setVisible(false)
		self.imgArrow:getChildByName("Text_rangeInt"):setString(0)
		self.imgArrow:getChildByName("Text_rangeInt"):setColor(display.COLOR_WHITE)
		self.createLoadingDivs = true
	end
	if self.myInfo.myInt >= self.myInfo.intRange[#self.myInfo.intRange] then
		self.loadBar:setPercent(100)
		for i, v in ipairs(self.imgBoxs) do
			v:setSpriteFrame("icon_recruitsupplies_box_02.png")
		end
		for i, v in ipairs(self.imgDivs) do
			v:getChildByName("Text_rangeInt"):setColor(display.COLOR_WHITE)
		end
	else
		local reIndex = function(value, max, min)
			return math.max(math.min(value, max), min)
		end
		local sectionIndex = #self.myInfo.intRange
		for i, v in ipairs(self.myInfo.intRange) do
			if v > self.myInfo.myInt then
				sectionIndex = i
				break
			end
		end
		local beginSectionIndex = reIndex(sectionIndex - 1, #self.myInfo.intRange, 0)
		local baseInt = sectionIndex <= 1 and 0 or self.myInfo.intRange[beginSectionIndex]
		local basePercent = beginSectionIndex / #self.myInfo.intRange * 100
		local detaPercent = (self.myInfo.myInt - baseInt) / (self.myInfo.intRange[sectionIndex] - baseInt) * (100 / #self.myInfo.intRange)
		local percentVal = detaPercent + basePercent
		print("sectionIndex = ", sectionIndex)
		print("beginSectionIndex = ", beginSectionIndex)
		print("detaPercent = ", detaPercent)
		print("basePercent = ", basePercent)
		self.loadBar:setPercent(percentVal)
		if 1 <= beginSectionIndex then
			for i = 1, beginSectionIndex do
				self.imgBoxs[i]:setSpriteFrame("icon_recruitsupplies_box_02.png")
				self.imgDivs[i]:getChildByName("Text_rangeInt"):setColor(display.COLOR_WHITE)
			end
		end
	end
	local fenshu = self.loadBar:getPercent()
	local barLong = self.loadBar:getContentSize().width
	if SoraDFIsRA() then
		self.spProgress:setPositionX(barLong - fenshu / 100 * barLong)
	else
		self.spProgress:setPositionX(fenshu / 100 * barLong)
	end
	local actionTintTo = cca.fadeTo(1, 0.5)
	local actionTinBack = cca.fadeTo(1, 1)
	local actionDelay = cca.delay(0.8)
	_UPVALUE3_ = 1
	;(1)[1] = actionTintTo
	;(1)[2] = actionTinBack
	;(1)[3] = actionDelay
	local actionRepeat = cca.repeatForever(cca.seq(1))
	self.spProgress:runAction(actionRepeat)
end
function CrazyIntegralMainView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("crazyIntegralExplainView"):show()
	end
end
function CrazyIntegralMainView:btnCrazyHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("common_text_3064"))
	end
end
function CrazyIntegralMainView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.CRAZY_GET_POINT_ACTIVITY)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function CrazyIntegralMainView:addDoubleFireEffect(...)
	SoraDCreateFireEffectNode(self.bottomNode:getChildByName("frame_lace_base_1"), self.bottomNode:getChildByName("frame_lace_base_2"))
end
return CrazyIntegralMainView
