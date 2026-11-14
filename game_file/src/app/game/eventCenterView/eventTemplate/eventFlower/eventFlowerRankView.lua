local gametop = gModuleMgr.getObject("gametop")
local newActivityCtrl = gametop.playertop_:getModule("newActivityCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local eventFlowerRankView = class("eventFlowerRankView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventFlowerRankView")
	end
	return target
end)
function eventFlowerRankView:ctor()
	_ENV = nil
	;(nil).aroma = 1
	self.style, (nil).charm = nil, 2
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.personalData, _ENV, self.rankData, _ENV, self.curStyle = self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma, self.style.aroma
	self.ownPosY = 0
	self.perLoad = 10
	self.curLoad = 0
	self.totalLoad = RANK_MAX_SHOW
	self.myRank = nil
	self.lab_title = SoraDGetChildByName(self, "Text_title")
	self.lab_myRank = SoraDGetChildByName(self, "Text_myRank")
	self.lab_myRank:setTouchEnabled(true)
	self.lab_myRank:setTouchScaleChangeEnabled(true)
	self.lab_myRank:addTouchEventListener(handler(self, self.labRankClickCallBack))
	self.btn_rewards = SoraDGetChildByName(self, "Button_rewards")
	self.btn_rewards:setTitleText(i18n("common_text_1235"))
	self.btn_rewards:addTouchEventListener(handler(self, self.btnRewardsClickCallBack))
	self.btn_sendFlower = SoraDGetChildByName(self, "Button_sendFlower")
	self.btn_sendFlower:setTitleText(i18n("common_text_2309"))
	self.btn_sendFlower:addTouchEventListener(handler(self, self.btnSendFlowerClickCallBack))
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	SoraDGetChildByName(self, "Size_Tile_bg"):setFillType(1)
	SoraDGetChildByName(self, "Size_Tile_image_bg"):setFillType(1)
	SoraDGetChildByName(self, "Tile_Size_Image_zhuzi_left"):setFillType(1)
	SoraDGetChildByName(self, "Tile_Size_Image_zhuzi_right"):setFillType(1)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_FLOWER_REFRESH", handler(self, self.initData))
end
function eventFlowerRankView:initData(target, data)
	SoraDCloseLoading(self)
	if data.isRank then
		self.rankData = newActivityCtrl:getFlowerRankData(self.curStyle)
		self.personalData = newActivityCtrl:getFlowerActivityPersonalData()
		if self.curStyle == self.style.aroma then
			self.lab_title:setString(i18n("common_text_3436"))
			local rank_send = self.personalData.curSendRank or 0
			if rank_send < 1 then
				self.lab_myRank:setString(i18n("common_text_827"))
			else
				_ENV = i18n("common_text_827")
				i18n("common_text_827").rank = rank_send
				self.lab_myRank:setString(i18n("common_text_825", i18n("common_text_827")))
				self.myRank = rank_send
			end
		elseif self.curStyle == self.style.charm then
			self.lab_title:setString(i18n("common_text_3435"))
			local rank_receive = self.personalData.curReceiveRank or 0
			if rank_receive < 1 then
				self.lab_myRank:setString(i18n("common_text_827"))
			else
				_ENV = i18n("common_text_827")
				i18n("common_text_827").rank = rank_receive
				self.lab_myRank:setString(i18n("common_text_825", i18n("common_text_827")))
				self.myRank = rank_receive
			end
		end
		self:addScrollView()
	end
end
function eventFlowerRankView:addScrollView()
	local scrollInner = self.scroll:getInnerContainer()
	local singleHeight = 76
	local scrollInnerNewH = math.max(singleHeight * table.nums(self.rankData), self.scroll:getContentSize().height)
	if self.myRank and self.myRank <= self.totalLoad then
		self.ownPosY = scrollInnerNewH - singleHeight * self.myRank - 0.5 * self.scroll:getContentSize().height
	end
	for i, v in ipairs(self.rankData) do
		_ENV = nil
		;(nil).point = nil
		;(nil).data = v
		;(nil).posY = scrollInnerNewH - singleHeight * i
		table.insert(self.tableSingle, nil)
	end
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollInnerNewH))
	self.scroll:jumpToTop()
	self:initRankingsList()
end
function eventFlowerRankView:initRankingsList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = self:getSingle()
				single:addTo(self.scroll)
			end
			local data = v.data
			single.setRank(i, data.uid)
			single.setInfo(data.kid, data.nickName, data.allianceAbbr)
			single.setScore(data.score)
			single:setPosition(cc.p(0, v.posY))
			v.point = single
		end
	end
end
function eventFlowerRankView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initRankingsList()
	end
end
function eventFlowerRankView:initView(style)
	self.curStyle = style
	self.btn_sendFlower:setVisible(self.curStyle == self.style.aroma)
	self.btn_rewards:setPositionX(self.curStyle == self.style.aroma and SoraDFPosX(190, 600) or 300)
	newActivityCtrl:reqFlowerRankData(self.curStyle)
	SoraDShowLoading(self)
end
function eventFlowerRankView:btnRewardsClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventFlowerAwardView")
		panel:initView(self.curStyle)
		panel:addTo(self, 99)
	end
end
function eventFlowerRankView:btnSendFlowerClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local layer = uiManager:show("LordSelectView").view
		layer:isSendFlower(true)
		layer:showAbbr(true)
		layer:setCloseSelfType(false)
		layer:initData(lordSearchType.PIGEON, 1, i18n("common_text_2309"))
		layer:setTitleText(i18n("common_text_2309"))
		layer:setHandle(function(tableUID)
			local uid = tableUID[1]
			_ENV = nil
			;(nil).uid = uid
			uiManager:show("flowerSendView", nil)
		end)
	end
end
function eventFlowerRankView:labRankClickCallBack(target, event)
	if event == ccui.TouchEventType.ended then
		if self.myRank and self.myRank > self.totalLoad then
			return
		end
		local percent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		percent = math.min(100, math.max(0, percent))
		local scrollH = self.scroll:getContentSize().height
		SoraDPlaySound()
		self:stopAllActions()
		if self.curStyle == self.style.aroma then
			local rank_send = self.personalData.curSendRank or 0
			if 3 < rank_send then
				if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
					self.scroll:scrollToPercentVertical(percent, 0.2, true)
				else
					_UPVALUE2_ = 0.2
					;(0.2)[1] = cca.callFunc(function(...)
						self.scroll:scrollToPercentVertical(percent + 0.5, 0.2, false)
					end)
					;(0.2)[2] = cca.delay(0.3)
					;(0.2)[3] = cca.callFunc(function(...)
						self.scroll:scrollToPercentVertical(percent, 0.1, true)
					end)
					;(0.2)[4] = cca.callFunc(function(...)
						self.scroll:scrollToPercentVertical(percent, 0.1, true)
					end)
					self:runAction(cca.seq(0.2))
				end
			end
		elseif self.curStyle == self.style.charm then
			do
				local rank_receive = self.personalData.curReceiveRank or 0
				if 3 < rank_receive then
					if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
						self.scroll:scrollToPercentVertical(percent, 0.2, true)
					else
						_UPVALUE2_ = 0.2
						;(0.2)[1] = cca.callFunc(function(...)
							self.scroll:scrollToPercentVertical(percent + 0.5, 0.2, false)
						end)
						;(0.2)[2] = cca.delay(0.3)
						;(0.2)[3] = cca.callFunc(function(...)
							self.scroll:scrollToPercentVertical(percent, 0.1, true)
						end)
						;(0.2)[4] = cca.callFunc(function(...)
							self.scroll:scrollToPercentVertical(percent, 0.1, true)
						end)
						self:runAction(cca.seq(0.2))
					end
				end
			end
		end
	end
end
function eventFlowerRankView:getSingle()
	local single = SoraDGetChildByName(self, "Panel_single"):clone()
	function single.setRank(rank, uid)
		local Text_rank = SoraDGetChildByName(single, "Text_rank")
		local icon_ranking = SoraDGetChildByName(single, "icon_ranking")
		local Image_curBg = SoraDGetChildByName(single, "Image_curBg")
		if rank <= RANK_TOP_SPECIAL then
			Text_rank:setVisible(false)
			icon_ranking:setVisible(true)
			icon_ranking:setSpriteFrame("icon_ranking_" .. rank .. ".png")
			Image_curBg:loadTexture("frame_alliance_pank_0" .. rank .. ".png", ccui.TextureResType.plistType)
		else
			Text_rank:setVisible(true)
			icon_ranking:setVisible(false)
			Image_curBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
			Text_rank:setString(rank)
		end
		local ownUUID = lordInfoCtrl:getLordInfo().base.uid
		if uid == ownUUID and rank > RANK_TOP_SPECIAL then
			Image_curBg:loadTexture("frame_alliance_pank_05.png", ccui.TextureResType.plistType)
		end
	end
	function single.setInfo(kid, nickName, abbr)
		local Text_kingdom = SoraDGetChildByName(single, "Text_kingdom")
		local Text_name = SoraDGetChildByName(single, "Text_name")
		Text_kingdom:setString("#" .. kid)
		if not SoraDFIsRA() then
			Text_kingdom:setString(kid .. "#")
		end
		local name = nickName
		if abbr and string.len(abbr) > 0 then
			name = "(" .. abbr .. ")" .. name
		end
		Text_name:setString(name)
	end
	function single.setScore(score)
		local Text_num = SoraDGetChildByName(single, "Text_num")
		Text_num:setString(score)
	end
	return single
end
return eventFlowerRankView
