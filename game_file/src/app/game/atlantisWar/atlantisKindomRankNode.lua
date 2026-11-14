local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisKindomRankNode = class("atlantisKindomRankNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function atlantisKindomRankNode:ctor(properties)
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.hasMore = true
	self.rankTop3, _ENV, self.rankInfo, _ENV, self.fromLoadText = nil, nil, nil, nil, false
	self.rankIndex = 0
	self.rankTop = 100
	local Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.nodeFlag = SoraDGetChildByName(Bottom_Node, "Node_flag")
	self.imageHead = SoraDGetChildByName(self, "Image_myHead")
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.spMyRank = SoraDGetChildByName(self, "Sprite_myRank")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.btnJump:setTouchEnabled(false)
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("commonRankingSingle")
	self.scrollRank:setSingleCreate(handler(self, self.createSingle))
	self.scrollRank:setScrollBottomFun(handler(self, self.scrollBottomBack))
	self.scrollRank:setScrollMoveFun(handler(self, self.scrollMoveBack))
	self.labelNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.labelNotice:setString(i18n("common_text_089"))
	self.textNoRecrod = SoraDGetChildByName(self, "Center_Text_noRecrod")
	self.textNoRecrod:setString(i18n("common_text_927"))
	self.nodeCommonTopThreeRankNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTopThreeRankNode")
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textName:setString(i18n("common_text_479"))
	if self.textRank then
		self.textRank:setString(i18n("common_text_2193"))
	end
	self.textPoint:setString(i18n("common_text_1764"))
	self.nodeCommonDropDownBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonDropDownBox")
	self.rankSingleNode = SoraDGetChildByName(self, "Node_RankSingle")
	self:initData()
	self:initEffect()
end
function atlantisKindomRankNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgCallBack))
end
function atlantisKindomRankNode:initEffect()
	include("atlantisWarUtil").playFireAnimation(self)
	self.nodeCommonTopThreeRankNode:runTopAction()
	local panelTouch = SoraDGetChildByName(self.rankSingleNode, "Panel_touch")
	panelTouch:setCascadeOpacityEnabled(true)
	for i, v in ipairs(panelTouch:getChildren()) do
		v:setCascadeOpacityEnabled(true)
	end
end
function atlantisKindomRankNode:initData(target, data)
	if self.nodeCommonDropDownBox then
		_ENV = self.nodeCommonDropDownBox
		self.nodeCommonDropDownBox.maxHeight = 180
		_ENV, _ENV, self.nodeCommonDropDownBox.childSize = 184, cc.size(184, 55), cc.size(184, 55)
		;(184).title = i18n("atlantiswar_text_0042")
		_ENV, cc.size(184, 55)[1], (184).tag = 184, 184, 1
		;(184).title = i18n("atlantiswar_text_0041")
		self.nodeCommonDropDownBox.childData, cc.size(184, 55)[2], (184).tag = cc.size(184, 55), 184, 2
		local param = self.nodeCommonDropDownBox
		self.nodeCommonDropDownBox:setFlipArrow(0)
		self.nodeCommonDropDownBox:addEventListener(handler(self, self.btnChooseRankClick))
		self.nodeCommonDropDownBox:setSelectSingleTarget("Image_select")
		self.nodeCommonDropDownBox:initData(param)
	end
end
function atlantisKindomRankNode:updateScroll()
	self:initMyRank()
	_ENV = nil
	;(nil).view = self
	;(nil).rankType = 1
	self.nodeCommonTopThreeRankNode:initData(self.rankTop3, nil)
	local _ENV, tmp = self.nodeCommonTopThreeRankNode.initData, self.nodeCommonTopThreeRankNode.initData
	for i, v in ipairs(self.rankInfo) do
		local _ENV, singleData
		singleData.player, _ENV, singleData.rank = v.rank, v.rank, v.rank
		singleData.player.iconID = v.headid
		if v.kingdomName then
			singleData.model = 3
			singleData.lineOneName = serviceFunctions.getKingdomFormatName(v.kingdomName, v.kid)
		else
			singleData.model = 1
			singleData.lineOneName = textParser.formatPlayerName(v.allianceAbbr, v.nickName, v.kid)
		end
		singleData.player.avatar = v.avatar
		singleData.player.flag = v.flag
		singleData.player.uid = v.uid
		singleData.player.kid = v.kid
		singleData.score = string.formatnumberthousands(v.score)
		singleData.nameShowType = 1
		singleData.btnClickType = 2
		singleData.selfRank = self.rank
		table.insert(tmp, singleData)
	end
	if self.rankInfo and next(self.rankInfo) then
		self.scrollRank:setVisible(true)
		_ENV = nil
		;(nil).scroll = self.scrollRank
		;(nil).view = self
		;(nil).customHeight = 115 * #tmp + 50
		;(nil).actType = 1
		self.scrollRank:updateScrollView(cc.size(640, 115), tmp, 1, nil, self.isRelaod)
		if self.isRelaod then
			self.scrollRank:jumpToTop()
		end
		self.textNoRecrod:setVisible(false)
	else
		self.scrollRank:setVisible(false)
		self.textNoRecrod:setVisible(true)
	end
end
function atlantisKindomRankNode:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL and 0 < num then
			self.textMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num])
		else
			self.spMyRank:setVisible(false)
			self.textMyRank:setVisible(true)
			self.textMyRank:setString(num)
		end
	end
	if self.nodeFlag and self.nodeFlag:getChildrenCount() == 0 then
		allianceDesRead.getFlagWithParticle(self.selfRankInfo.flag, self.nodeFlag)
		self.textMyName:setString(serviceFunctions.getKingdomFormatName(self.selfRankInfo.kingdomName, gametop.playertop_:getKingdomID()))
	end
	if self.imageHead then
		local lordInfo = lordInfoCtrl:getLordInfo()
		if not allianceMgr:getAllianceInfo() then
			local _ENV, allianceInfo = allianceMgr:getAllianceInfo(), allianceMgr:getAllianceInfo()
		end
		SoraDGetHeadFromManager(self.imageHead, lordInfo.base.imageId, lordInfo.base.avatar)
		local abbr = allianceInfo.property and allianceInfo.property.abbr or ""
		self.textMyName:setString(textParser.formatPlayerName(abbr, lordInfo.base.nickName, gametop.playertop_:getKingdomID()))
	end
	switchNum(self.rank)
	if 0 >= self.rank or self.rank > self.rankTop then
		self.textMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.textMyRank, 92)
	end
	self.textMyNum:setString(self.myScore)
end
function atlantisKindomRankNode:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if self.rank < 4 then
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		self:stopAllActions()
		SoraDPlaySound()
		self.ownPosY = self.scrollRank:getInnerContainerSize().height - 112 * self.rank - 0.5 * self.scrollRank:getContentSize().height
		local scrollRankPercent = 100 * (1 - self.ownPosY / (self.scrollRank:getInnerContainerSize().height - self.scrollRank:getContentSize().height))
		scrollRankPercent = math.min(100, math.max(0, scrollRankPercent))
		local scrollRankH = self.scrollRank:getContentSize().height
		if math.abs(self.ownPosY + self.scrollRank:getInnerContainer():getPositionY()) < 0.5 * scrollRankH then
			self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.rank <= self.rankIndex and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= self.rankIndex and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= self.rankIndex and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function atlantisKindomRankNode:btnJumpMyPlayerClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
	end
end
function atlantisKindomRankNode:btnChooseRankClick(rankType)
	print("btnChooseRankClick", rankType)
	self.rankType = rankType
	self.rankTop3, _ENV, self.rankInfo, _ENV, self.rankIndex = print, print, print, print, 1
	self:requestMore(1)
end
function atlantisKindomRankNode:scrollBottomBack()
	if self.fromLoadText then
		self.fromLoadText = false
		self:requestMore()
		if self.hasMore then
			self.labelNotice:setString(i18n("common_text_089"))
		else
			self.labelNotice:setString(i18n("common_text_085"))
		end
		self:hideLoadingSprite()
	end
end
function atlantisKindomRankNode:scrollMoveBack()
	local scrollInner = self.scrollRank:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if offsetY < -55 and self.hasMore then
		self.fromLoadText = true
		self.labelNotice:setString(i18n("common_text_084"))
		self:showLoadingSprite()
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	else
		self.fromLoadText = false
		self:hideLoadingSprite()
		if self.hasMore then
			self.labelNotice:setString(i18n("common_text_089"))
		else
			self.labelNotice:setString(i18n("common_text_085"))
		end
	end
end
function atlantisKindomRankNode:requestMore(beginIndex)
	if not beginIndex and self.hasMore == false then
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = beginIndex or self.rankIndex + 1
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		SoraDShowLoading(self)
		atlantisActivityCtrl:reqKindomRank(index)
	end
end
function atlantisKindomRankNode:getLoadingSpriteXPos()
	if SoraDFIsRA() then
		return self.labelNotice:getPositionX() + (self.labelNotice:getContentSize().width / 2 + 25)
	else
		return self.labelNotice:getPositionX() - (self.labelNotice:getContentSize().width / 2 + 25)
	end
end
function atlantisKindomRankNode:showLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:setVisible(true)
	else
		self.loadingSprite = display.newSprite("SinglePicture/loading1.png")
		self.loadingSprite:addTo(self.scrollRank)
		self.loadingSprite:setScale(25 / self.loadingSprite:getContentSize().width)
		self.loadingSprite:setAnchorPoint(cc.p(0.5, 0.5))
		self.loadingSprite:setPositionX(self:getLoadingSpriteXPos())
		self.loadingSprite:setPositionY(self.labelNotice:getPositionY() + self.labelNotice:getContentSize().height / 2)
	end
	self.loadingSprite:stopAllActions()
	local actionRotateBy = cc.RotateBy:create(1.0, 360)
	local repeatForever = cca.repeatForever(actionRotateBy)
	self.loadingSprite:runAction(repeatForever)
end
function atlantisKindomRankNode:hideLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:stopAllActions()
		self.loadingSprite:setVisible(false)
	end
end
function atlantisKindomRankNode:createSingle()
	local single = include("commonRankingSingle").new(self.rankSingleNode:clone())
	local panelTouch = SoraDGetChildByName(single, "Panel_touch")
	panelTouch:setCascadeOpacityEnabled(true)
	for i, v in ipairs(panelTouch:getChildren()) do
		v:setCascadeOpacityEnabled(true)
	end
	function single:refreshAction(v, index)
		print("index", index)
		single:setOpacity(0)
		single:setPosition(v.pos.x, v.pos.y - 12)
		single = v.pos.y - 12
		single = nil
		;(nil)[1] = cca.fadeIn(0.1)
		;(nil)[2] = cca.moveBy(0.1, 0, 12)
		;(nil)[3] = cca.moveBy(0.1, 0, 12)
		;(nil)[4] = cca.moveBy(0.1, 0, 12)
		;(nil)[5] = cca.moveBy(0.1, 0, 12)
		;(v.pos.y - 12)[1] = cca.delay((5 + (index - 1) * 4) / 60)
		;(v.pos.y - 12)[2] = cca.spawn(nil)
		;(v.pos.y - 12)[3] = cca.spawn(nil)
		;(v.pos.y - 12)[4] = cca.spawn(nil)
		;(v.pos.y - 12)[5] = cca.spawn(nil)
		;(v.pos.y - 12)[6] = cca.spawn(nil)
		;(v.pos.y - 12)[7] = cca.spawn(nil)
		;(v.pos.y - 12)[8] = cca.spawn(nil)
		single:runAction(cca.seq(v.pos.y - 12))
	end
	return single
end
function atlantisKindomRankNode:msgCallBack(target, data)
	if data.key == "reqRankRsp" and self:isVisible() then
		SoraDCloseLoading(self)
		if tonumber(data.err) ~= 0 then
			return
		end
		self.rankIndex = data.rspdata and data.rspdata.idx or 0
		if data.rspdata then
			self.hasMore = true
			if data.rspdata.nTotal == data.rspdata.idx then
				self.hasMore = false
				self.labelNotice:setString(i18n("common_text_085"))
				self:hideLoadingSprite()
			end
		end
		if data.rspdata then
			self.selfRankInfo = data.rspdata.selfKingdomInfo or data.rspdata.selfInfo
		end
		if not self.selfRankInfo then
			self.selfRankInfo, _ENV = self.selfRankInfo, self.selfRankInfo
		end
		if not data.rspdata or not data.rspdata.rankingList then
			local _ENV, rankListBack = data.rspdata.rankingList, data.rspdata.rankingList
		end
		self.isRelaod = false
		for i, v in ipairs(rankListBack) do
			if v.rank <= 3 then
				self.isRelaod = true
				self.rankTop3[v.rank] = v
			else
				table.insert(self.rankInfo, v)
			end
		end
		dump(self.rankTop3, "self.rankTop3")
		self.rank = self.selfRankInfo.rank or 0
		self.myScore = string.formatnumberthousands(self.selfRankInfo.score or 0)
		self:updateScroll()
	end
end
function atlantisKindomRankNode:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord and data.clientData.targetName == self.__cname then
		SoraDOpenLordView(data.lord)
	end
end
return atlantisKindomRankNode
