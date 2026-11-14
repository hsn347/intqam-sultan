local gametop = gModuleMgr.getObject("gametop")
local allianceBWList = gametop.playertop_:getModule("allianceBWList")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local AllianceBlackWhiteView = class("allianceBlackWhiteView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBlackWhiteView")
	end
	return target
end)
function AllianceBlackWhiteView:ctor()
	self.tableItemSingle, _ENV, self.tableItemList, _ENV, self.curType = gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK, gAllianceBWListType.BLACK
	self.tableSpare = nil
	self.curPoint = 0
	self.blackOffsetY = nil
	self.whiteOffsetY = nil
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_1678"))
	self.btnWhite = SoraDGetChildByName(self, "Button_white")
	self.btnBlack = SoraDGetChildByName(self, "Button_black")
	self.btnWhite:setTitleText(i18n("common_text_1680"))
	self.btnBlack:setTitleText(i18n("common_text_1679"))
	self.labelType = SoraDGetChildByName(self, "Text_type")
	self.labelType:setString(i18n("common_text_032"))
	self.labelPoint = SoraDGetChildByName(self, "Text_point")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.spriteType = SoraDGetChildByName(self, "Sprite_type")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.labelAdd = SoraDGetChildByName(self, "Text_add")
	self.labelNeedPoint = SoraDGetChildByName(self, "Text_needPoint")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddClickCallBack))
	self.btnBlack:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnWhite:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnBlack:setTitleColor(cc.c3b(144, 132, 97))
	self.btnWhite:setTitleColor(cc.c3b(144, 132, 97))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_BWLIST_SUCCESS", handler(self, self.updateScrollWithData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DEL_BWLIST_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_SCIENCE_POINT_UPDATE", handler(self, self.updatePoint))
	SoraDShowLoading(self.scroll):setPosition(cc.p(display.cx, self.scroll:getInnerContainerSize().height - display.cy + 120))
	self:changeState(false)
	allianceBWList:getAllianceBWDetailList()
end
function AllianceBlackWhiteView:updateData(target, data)
	if data.bwtype == self.curType then
		allianceBWList:getAllianceBWDetailList()
	end
	self:updatePoint()
end
function AllianceBlackWhiteView:changeState(isWhite)
	local checkColor = cc.c3b(144, 132, 97)
	local uncheckColor = cc.c3b(255, 245, 176)
	self.btnBlack:setTouchEnabled(isWhite)
	self.btnBlack:setBright(not isWhite)
	self.btnBlack:setTitleColor(isWhite and checkColor or uncheckColor)
	self.btnWhite:setTouchEnabled(not isWhite)
	self.btnWhite:setBright(isWhite)
	self.btnWhite:setTitleColor(isWhite and uncheckColor or checkColor)
	if isWhite then
		self.curType = gAllianceBWListType.WHITE
		self.btnAdd:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		_ENV = ""
		;("").list = i18n("common_text_1680")
		self.labelAdd:setString(i18n("common_text_1687", ""))
	else
		self.curType = gAllianceBWListType.BLACK
		self.btnAdd:loadTextures("btn_yellow_normal_01.png", "", "", ccui.TextureResType.plistType)
		_ENV = ""
		;("").list = i18n("common_text_1679")
		self.labelAdd:setString(i18n("common_text_1687", ""))
	end
	self:updatePoint()
end
function AllianceBlackWhiteView:updatePoint()
	self.labelNeedPoint:setString(string.formatnumberthousands(allianceBWList:getScoreCost(self.curType)))
	self.labelPoint:setString(string.formatnumberthousands(allianceMgr:getAllianceProperty("bonus")))
end
function AllianceBlackWhiteView:updateScrollWithData()
	if self.tableSpare == nil then
		self.tableSpare, _ENV = self.tableSpare, self.tableSpare
		local count = math.max(#allianceBWList.bwDetailList.blackList, #allianceBWList.bwDetailList.whiteList)
		for i = 1, count do
			local single = SoraDCreatePanel("allianceBlackWhiteSingle")
			single:setVisible(false)
			single:setScroll(self.scroll)
			single:addTo(self.scroll, 1)
			table.insert(self.tableSpare, single)
		end
	end
	if self.curType == gAllianceBWListType.BLACK then
		self.tableItemList = allianceBWList.bwDetailList.blackList
		self.labelNotice:setString(i18n("common_text_1681"))
	else
		self.tableItemList = allianceBWList.bwDetailList.whiteList
		self.labelNotice:setString(i18n("common_text_1682"))
	end
	self.labelNotice:setVisible(#self.tableItemList <= 0)
	self:updateScrollSize()
	self:initItemList()
	SoraDCloseLoading(self.scroll)
	self:updatePoint()
end
function AllianceBlackWhiteView:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = self.curType == gAllianceBWListType.BLACK and self.blackOffsetY or self.whiteOffsetY
	local scrollInnerNewH = math.max(self.scroll:getContentSize().height, 135 * #self.tableItemList)
	for i, v in ipairs(self.tableItemList) do
		local pos = cc.p(320, scrollInnerNewH - (i - 1) * 135)
		_ENV = 320
		;(320).listData = v
		local (320).listType, data = self.curType, 320
		if self.tableItemSingle[i] then
			self.tableItemSingle[i].pos = pos
			self.tableItemSingle[i].data = data
			if self.tableItemSingle[i].point then
				self.tableItemSingle[i].point:initData(data)
				self.tableItemSingle[i].point:setPosition(pos)
			end
		else
			_ENV = self.tableItemSingle[i].point
			self.tableItemSingle[i].point.point = nil
			self.tableItemSingle[i].point.data = data
			self.tableItemSingle[i], self.tableItemSingle[i].point.pos = self.tableItemSingle[i].point, pos
		end
	end
	if #self.tableItemSingle > #self.tableItemList then
		local removeCount = #self.tableItemSingle - #self.tableItemList
		for i = removeCount, 1, -1 do
			if self.tableItemSingle[#self.tableItemList + i].point then
				table.insert(self.tableSpare, self.tableItemSingle[#self.tableItemList + i].point)
				self.tableItemSingle[#self.tableItemList + i].point:setVisible(false)
				self.tableItemSingle[#self.tableItemList + i].point = nil
			end
			table.remove(self.tableItemSingle)
		end
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	if offsetY then
		scrollInner:setPositionY(offsetY)
	else
		self.scroll:jumpToTop()
	end
end
function AllianceBlackWhiteView:initItemList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 1.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemSingle) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				table.insert(self.tableSpare, v.point)
				v.point:setVisible(false)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("allianceBlackWhiteSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll, 1)
			end
			single:initData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
end
function AllianceBlackWhiteView:recordOffsetY()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	if self.curType == gAllianceBWListType.BLACK then
		self.blackOffsetY = offsetY
	else
		self.whiteOffsetY = offsetY
	end
end
function AllianceBlackWhiteView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initItemList()
	end
end
function AllianceBlackWhiteView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("allianceBlackWhiteHelpView")
		else
			SoraDCreatePanel("allianceBlackWhiteHelpView"):show()
		end
	end
end
function AllianceBlackWhiteView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
function AllianceBlackWhiteView:btnAddClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local needPoint = allianceBWList:getScoreCost(self.curType)
		if needPoint > allianceMgr:getAllianceProperty("bonus") then
			SoraDShowMsgBox(i18n("common_text_273"), i18n("common_text_1684"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("allianceScienceView"):show()
				end
			end)
		else
			uiManager:show("AllianceJoinView")
		end
	end
end
function AllianceBlackWhiteView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:recordOffsetY()
		self:changeState(self.btnWhite == button)
		self:updateScrollWithData()
	end
end
function AllianceBlackWhiteView:sMsgReqInfoBack(target, data)
	SoraDCloseLoading(SoraDCurrentTopPanelFromManager())
	print("请求查看联盟信息回来了")
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "bwlist" then
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
return AllianceBlackWhiteView
