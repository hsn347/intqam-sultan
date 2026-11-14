local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisBattlePointPersonal = class("atlantisBattlePointPersonal", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
function atlantisBattlePointPersonal:ctor(properties)
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.hasMore = true
	self.rankTop3, _ENV, self.rankInfo, _ENV, self.fromLoadText = nil, nil, nil, nil, false
	self.rankIndex = 0
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("atlantisBattlePointRankSingle")
	self.scrollRank:setScrollBottomFun(handler(self, self.scrollBottomBack))
	self.scrollRank:setScrollMoveFun(handler(self, self.scrollMoveBack))
	self.labelNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.labelNotice:setString(i18n("common_text_089"))
	self.textNoRecrod = SoraDGetChildByName(self, "Center_Text_noRecrod")
	self.textNoRecrod:setString(i18n("common_text_927"))
	self.node = SoraDGetChildByName(self, "Bottom_Node")
	self.node:setPositionY(-self:getPositionY())
	self.nodeAtlantisBattlePointRankSingle = SoraDGetExtendChildFromCCSByName(self.node, "CCS_atlantisBattlePointRankSingle")
end
function atlantisBattlePointPersonal:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH_POINT_RANK", handler(self, self.msgCallBack))
end
function atlantisBattlePointPersonal:initWithKid(kid)
	self.kid = kid
end
function atlantisBattlePointPersonal:initData(target, data)
end
function atlantisBattlePointPersonal:initMyRank()
	local allianceInfo = allianceMgr:getAllianceInfo()
	local lordInfo = lordInfoCtrl:getLordInfo()
	self.selfRankInfo.selfRank = self.rank
	self.selfRankInfo.rank = self.rank
	self.selfRankInfo.headid = lordInfo.base.imageId
	self.selfRankInfo.avatar = lordInfo.base.avatar
	self.selfRankInfo.abbr = allianceInfo and allianceInfo.property.abbr or ""
	self.selfRankInfo.nickName = lordInfo.base.nickName
	local scoreWeight = atlantisWarCtrl:getScoreWeight()
	allianceMgr = nil
	;(nil).view = self
	;(nil).scoreWeight = scoreWeight
	self.nodeAtlantisBattlePointRankSingle:initData(self.selfRankInfo, nil)
end
function atlantisBattlePointPersonal:updateScroll()
	self:initMyRank()
	dump(self.rankInfo, "self.rankInfo")
	if self.rankInfo and next(self.rankInfo) then
		self.scrollRank:setVisible(true)
		local scoreWeight = atlantisWarCtrl:getScoreWeight()
		_ENV = nil
		;(nil).scroll = self.scrollRank
		;(nil).view = self
		;(nil).customHeight = 30 + #self.rankInfo * 120
		;(nil).scoreWeight = scoreWeight
		self.scrollRank:updateScrollView(cc.size(640, 120), self.rankInfo, 1, nil)
		if self.isRelaod then
			self.scrollRank:jumpToTop()
		end
		self.textNoRecrod:setVisible(false)
	else
		self.scrollRank:setVisible(false)
		self.textNoRecrod:setVisible(true)
	end
end
function atlantisBattlePointPersonal:requestMore(isRequest)
	if isRequest then
		SoraDShowLoading(self)
		self.rankInfo, _ENV, self.rankIndex = SoraDShowLoading, SoraDShowLoading, 0
		atlantisWarCtrl:reqPlayerRankData(1, self.kid)
		return
	end
	if not self.hasMore then
		self.labelNotice:setString(i18n("common_text_085"))
		return
	else
		local index = self.rankIndex + 1
		print("Request data!!!, index = ", index)
		self:showLoadingSprite()
		SoraDShowLoading(self)
		atlantisWarCtrl:reqPlayerRankData(index, self.kid)
	end
end
function atlantisBattlePointPersonal:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
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
function atlantisBattlePointPersonal:scrollBottomBack()
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
function atlantisBattlePointPersonal:scrollMoveBack()
	local scrollInner = self.scrollRank:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	print("self.hasMore", self.hasMore)
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
function atlantisBattlePointPersonal:getLoadingSpriteXPos()
	if SoraDFIsRA() then
		return self.labelNotice:getPositionX() + (self.labelNotice:getContentSize().width / 2 + 25)
	else
		return self.labelNotice:getPositionX() - (self.labelNotice:getContentSize().width / 2 + 25)
	end
end
function atlantisBattlePointPersonal:showLoadingSprite()
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
function atlantisBattlePointPersonal:hideLoadingSprite()
	if self.loadingSprite then
		self.loadingSprite:stopAllActions()
		self.loadingSprite:setVisible(false)
	end
end
function atlantisBattlePointPersonal:msgCallBack(target, data)
	if data.key == "reqRankDataRsp" and self:isVisible() then
		SoraDCloseLoading(self)
		if tonumber(data.err) ~= 0 then
			return
		end
		print("self.rankIndex", self.rankIndex)
		self.isRelaod = self.rankIndex == 0
		if not data.rspdata or not data.rspdata.rankList then
			local _ENV, rankListBack = data.rspdata.rankList, data.rspdata.rankList
		end
		self.rankIndex = self.rankIndex + #rankListBack
		self.hasMore = true
		if #rankListBack < 20 then
			self.hasMore = false
			self.labelNotice:setString(i18n("common_text_085"))
			self:hideLoadingSprite()
		end
		print("self.hasMore", self.hasMore)
		if self.isRelaod then
			if not data.rspdata or not data.rspdata.myInfo then
				_ENV = data.rspdata.myInfo
			end
			self.selfRankInfo = data.rspdata.myInfo
			self.myScore = string.formatnumberthousands(self.selfRankInfo.score or 0)
			self.rank = self.selfRankInfo.rank or 0
		end
		for i, v in ipairs(rankListBack) do
			v.selfRank = self.rank
			table.insert(self.rankInfo, v)
		end
		self:updateScroll()
	end
end
function atlantisBattlePointPersonal:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	dump(data, "dataArray", 10)
	if data and data.lord and data.clientData.targetName == self.__cname then
		SoraDOpenLordView(data.lord)
	end
end
return atlantisBattlePointPersonal
