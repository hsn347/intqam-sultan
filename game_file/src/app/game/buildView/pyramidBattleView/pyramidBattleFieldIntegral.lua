local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local allianceWarCtrl = gametop.playertop_:getModule("allianceWarCtrl")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
_UPVALUE3_ = gametop.playertop_
gametop.playertop_[1] = "icon_ranking_1.png"
gametop.playertop_[2] = "icon_ranking_2.png"
local gametop.playertop_[3], ocxNum = "icon_ranking_3.png", gametop.playertop_
local PyramidBattleFieldIntegral = class("pyramidBattleFieldIntegral", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleFieldIntegral")
	end
	return target
end)
function PyramidBattleFieldIntegral:ctor()
	self.scroll = SoraDGetChildByName(self, "Top_ScrollView_integral")
	self.btnExit = SoraDGetChildByName(self, "Button_exit")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnNorth = SoraDGetChildByName(self, "Button_north")
	self.btnSouth = SoraDGetChildByName(self, "Button_south")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnAll = SoraDGetChildByName(self, "Button_all")
	self.copyItem = SoraDGetChildByName(self, "Panel_item")
	self.txtTime = SoraDGetChildByName(self, "Text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.btnExit:addTouchEventListener(handler(self, self.btnExitClick))
	self.btnPrice:addTouchEventListener(handler(self, self.btnPriceClick))
	self.btnNorth:addTouchEventListener(handler(self, self.btnNorthClick))
	self.btnSouth:addTouchEventListener(handler(self, self.btnSouthClick))
	self.btnAll:addTouchEventListener(handler(self, self.btnAllClick))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_integral"):setTitle(i18n("common_text_3135"))
	self.btnExit:setTitleText(i18n("common_text_3351"))
	self.btnPrice:setTitleText(i18n("common_text_2078"))
	SoraDGetChildByName(self, "Text_all"):setString(i18n("common_text_635"))
	SoraDGetChildByName(self, "Text_south"):setString(i18n("common_text_3220"))
	SoraDGetChildByName(self, "Text_north"):setString(i18n("common_text_3221"))
	SoraDGetChildByName(self, "Text_integralTip"):setString(i18n("common_text_1764"))
	SoraDGetChildByName(self, "Text_forceTip"):setString(i18n("common_text_090"))
	SoraDGetChildByName(self, "Text_nameTip"):setString(i18n("common_text_2037"))
	SoraDGetChildByName(self, "Text_nameRank"):setString(i18n("common_text_2193"))
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	SoraDAutoSizeButtonText(self.btnExit, cc.size(190, 65))
	SoraDAutoSizeButtonText(self.btnPrice, cc.size(190, 65))
	self.myRankNode = SoraDGetChildByName(self, "Panel_myRank")
	self.my_txtName = self.myRankNode:getChildByName("Text_itemName")
	self.my_txtForce = self.myRankNode:getChildByName("Text_force")
	self.my_txtHonour = self.myRankNode:getChildByName("Text_honour")
	self.my_txtNum = self.myRankNode:getChildByName("Text_num")
	self.my_imgNum = self.myRankNode:getChildByName("Image_num")
	if worldMapDefine.isPyramidKingdomID(worldMapDefine.currentMapKindomID) and not worldMapDefine.isInPyramid() then
		self.isLooker = true
		self.btnExit:setVisible(false)
		self.btnPrice:setPositionX(display.width / 2)
	end
	self:initTimer()
	self:createSingleClass()
	self:switchTab(self.btnAll)
	self:req4Info("all")
end
function PyramidBattleFieldIntegral:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_FIELDINTEGRAL", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_PYRAMID_REQ_EXIT_RSP", handler(self, self.reqExitAllianceWarRsp))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_FIELDINTEGRAL_ERR", handler(self, self.closeMe))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED", handler(self, self.initTimer))
end
function PyramidBattleFieldIntegral:createSingleClass()
	self.singleClass = class("PyramidBattleFieldIntegralSingle", function()
		local target = self.copyItem:clone()
		return target
	end)
	function self.singleClass:ctor()
		self.myInfo, _ENV = nil, nil
		self.upImg = self:getChildByName("Image_upPanel")
		self.downImg = self:getChildByName("Image_underPanel")
		self.imgIsMe = self.upImg:getChildByName("Image_isMe")
		self.imgArr = self.upImg:getChildByName("Image_arr")
		self.txtName = self.upImg:getChildByName("Text_itemName")
		self.txtForce = self.upImg:getChildByName("Text_force")
		self.txtHonour = self.upImg:getChildByName("Text_honour")
		self.imgSheer = self.upImg:getChildByName("Image_sheer")
		self.txtNum = self.upImg:getChildByName("Text_num")
		self.imgNum = self.upImg:getChildByName("Image_num")
		self.txtOccupy = self.downImg:getChildByName("Text_occupy")
		self.txtKill = self.downImg:getChildByName("Text_kill")
		self:setSwallowTouches(false)
		self:addTouchEventListener(handler(self, self.panelClick))
		self.state = "fold"
		self:changeMode("fold")
	end
	function self.singleClass:initData(info, index)
		dump(info, "info")
		self.myInfo = info
		self.index = index
		self:initView()
	end
	function self.singleClass:initView(...)
		if self.myInfo.camp == gAllianceWarCampType.red then
			self.upImg:loadTexture("frame_alliance_pank_01.png", ccui.TextureResType.plistType)
		elseif self.myInfo.camp == gAllianceWarCampType.blue then
			self.upImg:loadTexture("frame_alliance_pank_07.png", ccui.TextureResType.plistType)
		end
		_ENV = nil
		;(nil).abbr = self.myInfo.abbr
		;(nil).name = self.myInfo.nickName
		self.txtName:setString(i18n("common_text_186", nil))
		self.txtForce:setString(string.formatnumberthousands(self.myInfo.fc))
		self.txtHonour:setString(self.myInfo.points)
		_ENV = string.formatnumberthousands(self.myInfo.fc)
		string.formatnumberthousands(self.myInfo.fc).num = self.myInfo.occupyCount
		self.txtOccupy:setString(i18n("common_text_3350", string.formatnumberthousands(self.myInfo.fc)))
		_ENV = i18n("common_text_3350", string.formatnumberthousands(self.myInfo.fc))
		i18n("common_text_3350", string.formatnumberthousands(self.myInfo.fc)).power = string.formatnumberthousands(self.myInfo.killFc)
		self.txtKill:setString(i18n("common_text_3349", i18n("common_text_3350", string.formatnumberthousands(self.myInfo.fc))))
		local rankIcon = ocxNum[self.index]
		local isSpecialRank = rankIcon ~= nil
		self.imgNum:setVisible(isSpecialRank)
		self.txtNum:setVisible(not isSpecialRank)
		if isSpecialRank then
			self.imgNum:loadTexture(rankIcon, ccui.TextureResType.plistType)
		else
			self.txtNum:setString(self.index)
		end
	end
	function self.singleClass:setMyID(myID)
		if tonumber(myID) == tonumber(self.myInfo.uid) then
			self.imgIsMe:setVisible(true)
		else
			self.imgIsMe:setVisible(false)
		end
	end
	function self.singleClass:changeMode(state)
		self.state = state
		if state == "fold" then
			self:setContentSize(cc.size(640, 105))
			self.upImg:setPositionY(53)
			self.downImg:setVisible(false)
			self.imgArr:setRotation(SoraDFPosX(0, -180))
		elseif state == "unfold" then
			self:setContentSize(cc.size(640, 170))
			self.downImg:setPositionY(78)
			self.downImg:setVisible(true)
			self.upImg:setPositionY(118)
			self.imgArr:setRotation(-90)
		end
		print("self.state:", self.state)
	end
	function self.singleClass:panelClick(panel, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			self:changeMode(self.state == "fold" and "unfold" or "fold")
			if self.singleCb then
				self.singleCb()
			end
		end
	end
	function self.singleClass:setCallBack(handl)
		self.singleCb = handl
	end
	function self.singleClass:returnHeigh()
		return self:getContentSize().height
	end
end
function PyramidBattleFieldIntegral:req4Info(typeStr)
	SoraDShowLoading(self)
	if "all" == typeStr then
		allianceWarCtrl:getPersonalPointsList(worldMapDefine.currentMapKindomID, true, true)
	elseif "north" == typeStr then
		allianceWarCtrl:getPersonalPointsList(worldMapDefine.currentMapKindomID, false, true)
	elseif "south" == typeStr then
		allianceWarCtrl:getPersonalPointsList(worldMapDefine.currentMapKindomID, true, false)
	end
end
function PyramidBattleFieldIntegral:initTimer(...)
	local warStatus = allianceWarCtrl:getWarData(worldMapDefine.currentMapKindomID).warStatus
	if warStatus then
		if warStatus == gKingdomWarStatusType.inWar then
			local time = kingdomMapCtrl:getPyramidWarStatusTime()
			if 0 < time then
				self.txtTime:setTimeLast(function(ticket)
					_ENV = nil
					;(nil).time = ticket
					return i18n("common_text_3309", nil)
				end)
				self.txtTime:beginTime(time)
			end
		else
			local time = kingdomMapCtrl:getPyramidWarStatusTime()
			if 0 < time then
				self.txtTime:setTimeLast(function(ticket)
					_ENV = nil
					;(nil).time = ticket
					return i18n("common_text_3308", nil)
				end)
				self.txtTime:beginTime(time)
			end
		end
	else
		self:close(nil, ccui.TouchEventType.ended)
	end
end
function PyramidBattleFieldIntegral:reqExitAllianceWarRsp(target, redata)
	SoraDCloseLoading(self)
end
function PyramidBattleFieldIntegral:initData(target, redata)
	SoraDCloseLoading(self)
	dump(redata, "redata")
	self.myDataList, _ENV = dump, dump
	self.scroll:removeAllChildren()
	self.scroll:jumpToTop()
	self.myUID = gametop.playertop_:getPlayerID()
	local myRankInfo, myRank
	local _ENV, tmpTbl = "redata", "redata"
	if redata and redata.retdate and next(redata.retdate) then
		tmpTbl = redata.retdate
	else
	end
	for i, v in ipairs(tmpTbl) do
		if v.uid == self.myUID then
			myRankInfo = v
			myRank = i
			break
		end
	end
	local scrollSize = self.scroll:getContentSize()
	if myRankInfo then
		self.myRankNode:setVisible(true)
		_ENV = v.uid
		v.uid.abbr = myRankInfo.abbr
		v.uid.name = myRankInfo.nickName
		self.my_txtName:setString(i18n("common_text_186", v.uid))
		self.my_txtForce:setString(string.formatnumberthousands(myRankInfo.fc))
		self.my_txtHonour:setString(myRankInfo.points)
		local rankIcon = ocxNum[myRank]
		local isSpecialRank = rankIcon ~= nil
		self.my_imgNum:setVisible(isSpecialRank)
		self.my_txtNum:setVisible(not isSpecialRank)
		if isSpecialRank then
			self.my_imgNum:loadTexture(rankIcon, ccui.TextureResType.plistType)
		else
			self.my_txtNum:setString(myRank)
		end
		self.scroll:setContentSize(cc.size(scrollSize.width, self.scroll:getPositionY() - self.myRankNode:getPositionY()))
	else
		self.myRankNode:setVisible(false)
		self.scroll:setContentSize(cc.size(scrollSize.width, self.scroll:getPositionY() - (self.myRankNode:getPositionY() - self.myRankNode:getContentSize().height)))
	end
	for i, v in ipairs(tmpTbl) do
		_ENV = cc.size(scrollSize.width, self.scroll:getPositionY() - (self.myRankNode:getPositionY() - self.myRankNode:getContentSize().height))
		cc.size(scrollSize.width, self.scroll:getPositionY() - (self.myRankNode:getPositionY() - self.myRankNode:getContentSize().height)).data = v
		table.insert(self.myDataList, cc.size(scrollSize.width, self.scroll:getPositionY() - (self.myRankNode:getPositionY() - self.myRankNode:getContentSize().height)))
		if v.uid == self.myUID then
			myRankInfo = v
			myRank = i
		end
	end
	self:initView()
	local guideStep = SoraDIsGameGuide()
	if guideStep and guideStep == 28010 then
		_ENV = ipairs(tmpTbl)
		ipairs(tmpTbl).msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		ipairs(tmpTbl).step = 28011
		SoraDSendMessage(ipairs(tmpTbl))
	end
end
function PyramidBattleFieldIntegral:initView(...)
	self:refreshTable()
	self:updateScroll()
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
end
function PyramidBattleFieldIntegral:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScroll()
	end
end
function PyramidBattleFieldIntegral:updateScroll(...)
	local scrollInner = self.scroll:getInnerContainer()
	local sSize = self.scroll:getContentSize()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for k, v in pairs(self.myDataList) do
		if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
			if v.point then
				v.point:setVisible(false)
			end
		elseif v.point then
			v.point:setVisible(true)
			v.point:setPosition(sSize.width / 2, v.posY)
		else
			local single = self.singleClass.new()
			single:initData(v.data, v.index)
			single:setMyID(self.myUID)
			single:setCallBack(handler(self, self.singleClcik))
			single:setPosition(sSize.width / 2, v.posY)
			single:addTo(self.scroll)
			v.point = single
		end
	end
end
function PyramidBattleFieldIntegral:refreshTable(...)
	local listLong = 0
	for i, v in ipairs(self.myDataList) do
		if v.point then
			listLong = listLong + v.point:returnHeigh()
		else
			listLong = listLong + 105
		end
	end
	local sSize = self.scroll:getContentSize()
	local sH = math.max(listLong, sSize.height)
	local addHeight = 0
	local keys = table.keys(self.myDataList)
	for i, v in ipairs(keys) do
		if self.myDataList[v].point then
			self.myDataList[v].posY = sH - addHeight
			addHeight = addHeight + self.myDataList[v].point:returnHeigh()
		else
			self.myDataList[v].posY = sH - addHeight
			addHeight = addHeight + 105
		end
		self.myDataList[v].index = i
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
end
function PyramidBattleFieldIntegral:singleClcik()
	self:refreshTable()
	self:updateScroll()
end
function PyramidBattleFieldIntegral:switchTab(btn)
	_ENV, _ENV = nil, nil
	;(nil).btn = self.btnNorth
	_ENV, (nil)[1], (nil).text = nil, nil, SoraDGetChildByName(self, "Text_north")
	;(nil).btn = self.btnSouth
	_ENV, (nil)[2], (nil).text = nil, nil, SoraDGetChildByName(self, "Text_south")
	;(nil).btn = self.btnAll
	;(nil)[3], (nil).text = nil, SoraDGetChildByName(self, "Text_all")
	local tabs
	for i, v in ipairs(tabs) do
		if v.btn == btn then
			v.btn:setTouchEnabled(false)
			v.btn:setBright(true)
			v.text:setColor(cc.c3b(255, 200, 100))
		else
			v.btn:setTouchEnabled(true)
			v.btn:setBright(false)
			v.text:setColor(cc.c3b(100, 80, 40))
		end
	end
end
function PyramidBattleFieldIntegral:btnNorthClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTab(button)
		self:req4Info("north")
	end
end
function PyramidBattleFieldIntegral:btnSouthClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTab(button)
		self:req4Info("south")
	end
end
function PyramidBattleFieldIntegral:btnAllClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:switchTab(button)
		self:req4Info("all")
	end
end
function PyramidBattleFieldIntegral:btnExitClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if kingdomMapCtrl:isHasMassQueue() then
			SoraDShowMsgTip(i18n("common_text_3262"))
		else
			SoraDShowMsgBox(i18n("common_text_3353"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
				if eventType == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					kingdomMapCtrl:reqExitAllianceWar()
				end
			end)
		end
	end
end
function PyramidBattleFieldIntegral:btnPriceClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if allianceWarCtrl:getWarData().style == gSeasonType.REGULAR_SEASON then
			print("PyramidBattleFieldIntegral:btnPriceClick 1")
			SoraDCreatePanel("pyramidBattlePriceView"):show()
		else
			print("PyramidBattleFieldIntegral:btnPriceClick 2")
			if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
				SoraDCreatePanel("alliancePBLPrizeView"):show()
			else
				SoraDCreatePanel("pyramidPlayoffsPriceView"):show()
			end
		end
	end
end
function PyramidBattleFieldIntegral:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function PyramidBattleFieldIntegral:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstSingle" then
		if self.myDataList[1] then
			return self.myDataList[1].point
		else
			return nil
		end
	end
	return SoraDGetChildByName(self, itemName)
end
function PyramidBattleFieldIntegral:closeMe(target, redata)
	self:close(nil, ccui.TouchEventType.ended)
end
return PyramidBattleFieldIntegral
