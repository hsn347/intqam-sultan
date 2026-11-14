local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceOfficialAppointView = class("allianceOfficialAppointView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceOfficialAppointView")
	end
	return target
end)
function allianceOfficialAppointView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableSpareList, _ENV, self.tableMemberList, _ENV = nil, nil, nil, nil, nil, nil, nil, nil
	self.curOfficial = gAllianceOfficial.NONE
	self.otherAppointList, _ENV, self.officialApplyList, _ENV, self.showPage = gAllianceOfficial.NONE, gAllianceOfficial.NONE, gAllianceOfficial.NONE, gAllianceOfficial.NONE, 0
	self.isHaveTextField = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_appoint")
	self.nodeTitle:setTitle(i18n("alliance_office_title_07"))
	self.btnSearch = SoraDGetChildByName(self, "Button_search")
	self.btnSearch:setTitleText(i18n("common_text_166"))
	self.btnAll = SoraDGetChildByName(self, "Button_all")
	self.btnAll:setVisible(false)
	self.tfdSearch = SoraDGetChildByName(self, "TextField_search")
	_ENV = "TextField_search"
	;("TextField_search").func = handler(self, self.OnInputChangeEnd)
	self.tfdSearch = SoraDChangeToEditBox(self.tfdSearch, "TextField_search")
	self.tfdSearch:setTextHorizontalAlignment(SoraDFLabelR())
	self.tfdSearch:setSwallowTouches(false)
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("alliance_office_text_20"))
	self.labelNotice:setVisible(false)
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_member")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnAll:addTouchEventListener(handler(self, self.btnAllClickCallBack))
	self.btnSearch:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
end
function allianceOfficialAppointView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPLY_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK", handler(self, self.initData))
end
function allianceOfficialAppointView:initOfficial(official)
	self.curOfficial = official
	self:initData()
end
function allianceOfficialAppointView:initData(target, data)
	if data and data.msg == "MESSAGE_ALLIANCE_OFFICIAL_APPOINT_BACK" then
		self:removeFromParent()
	else
		self.officialApplyList = allianceMgr:getApplyListByOfficialID(self.curOfficial)
		self.otherAppointList = memberMgr:getOtherAppointMemberList(self.curOfficial)
		self.scroll:removeAllChildren()
		self.tableSpare, allianceMgr, self.tableSingle, allianceMgr, self.tableSpareList, allianceMgr, self.tableMemberList, allianceMgr = self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren
		self:initScroll()
		self:updateScrollView()
	end
end
function allianceOfficialAppointView:updateData()
	self.officialApplyList, _UPVALUE0_ = nil, nil
	self.otherAppointList = self.tableMemberList
	self.scroll:removeAllChildren()
	self.tableSpare, _UPVALUE0_, self.tableSingle, _UPVALUE0_, self.tableSpareList, _UPVALUE0_, self.tableMemberList, _UPVALUE0_ = self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren, self.scroll.removeAllChildren
	self:initScroll()
	self:updateScrollView()
end
function allianceOfficialAppointView:initScroll()
	self.showPage = 0
	local _ENV, mList
	local _ENV, titleList
	if 0 < table.nums(self.officialApplyList) then
		self.showPage = self.showPage + 1
		mList[self.showPage], _ENV = self.officialApplyList, self.officialApplyList
		for _, uid in pairs(self.officialApplyList) do
			table.insert(mList[self.showPage], memberMgr:getMember(uid))
		end
		titleList[self.showPage] = i18n("alliance_office_title_03")
	end
	if 0 < table.nums(self.otherAppointList) then
		self.showPage = self.showPage + 1
		mList[self.showPage] = self.otherAppointList
		titleList[self.showPage] = i18n("alliance_office_title_04")
	end
	local sortMList = function(mList)
		local memberMgr = gametop.playertop_:getModule("memberMgr")
		local ownmember = memberMgr:getOwnMember()
		local ownMapId = ownmember:getProperty("mapId")
		local sourceKid = ownmember:getProperty("sourceKid")
		local gametop, nList = ownmember, ownmember
		if sourceKid ~= 0 then
			for k, v in ipairs(mList) do
				if v.uinfo.sourceKid ~= 0 and v.uinfo.sourceKid == sourceKid then
					table.insert(nList, v)
				end
			end
		else
			for k, v in ipairs(mList) do
				if v.uinfo.mapId == ownMapId or worldMapDefine.isGardenKingdomID(v.uinfo.mapId) then
					table.insert(nList, v)
				end
			end
		end
		return nList
	end
	if self.showPage > 0 then
		self.labelNotice:setVisible(false)
		for i = 1, self.showPage do
			local single = self.tableSingle[i]
			if not single then
				single = SoraDCreatePanel("allianceMemberListSingle")
				single:setClickCallBack(handler(self, self.updateScrollView))
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
				table.insert(self.tableSingle, single)
			end
			single:initMemberList(sortMList(mList[i]), self.tableSpare, titleList[i], self.curOfficial)
			single:setState(true)
		end
	else
		self.labelNotice:setVisible(true)
	end
end
function allianceOfficialAppointView:updateScrollView(rank, state)
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	for i = 1, #self.tableSingle do
		local single = self.tableSingle[#self.tableSingle - i + 1]
		if single:isVisible() then
			scrollInnerNewH = scrollInnerNewH + single:getSingleH()
			single:setPosition(cc.p(320, scrollInnerNewH))
		end
	end
	if scrollInnerNewH < self.scroll:getContentSize().height then
		local upto = self.scroll:getContentSize().height - scrollInnerNewH
		for i, v in ipairs(self.tableSingle) do
			if v:isVisible() then
				v:setPositionY(v:getPositionY() + upto)
			end
		end
		scrollInnerNewH = self.scroll:getContentSize().height
	end
	offsetY = math.min(0, offsetY - (scrollInnerNewH - scrollInner:getContentSize().height))
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:updateAllScrollSingle(true)
end
function allianceOfficialAppointView:updateAllScrollSingle(updateSize)
	for i, v in ipairs(self.tableSingle) do
		v:updateScrollSingle(updateSize)
	end
end
function allianceOfficialAppointView:scrollEventCallBack(target, event)
	self:updateAllScrollSingle()
end
function allianceOfficialAppointView:showAllMember()
	if table.nums(self.tableSpareList) > 0 then
		self.tableSpareList, _ENV, self.tableMemberList = self.tableSpareList, self.tableSpareList, self.tableSpareList
	end
end
function allianceOfficialAppointView:btnAllClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.tfdSearch:setString("")
		button:setVisible(false)
		self:showAllMember()
	end
end
function allianceOfficialAppointView:OnInputChangeEnd(eventType, textField)
	if eventType == "changed" then
		local returnName = textField:getString()
		local nameLen = string.utf8len(returnName)
		self.btnAll:setVisible(0 < nameLen)
		if nameLen <= 0 then
			self:showAllMember()
		end
	end
end
function allianceOfficialAppointView:btnSearchClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local returnName = self.tfdSearch:getString()
		local nameLen = string.utf8len(returnName)
		if 0 < nameLen then
			if 0 >= table.nums(self.tableSpareList) then
				self.tableSpareList = self.tableMemberList
			end
			self.tableMemberList = memberMgr:getMemberList()
			local _ENV, searchData = memberMgr:getMemberList(), memberMgr:getMemberList()
			for uid, v in pairs(self.tableMemberList) do
				local baseName = v:getProperty("nickName")
				if v:getProperty("rank") ~= gAllianceRank.R5 and v:getProperty("rank") ~= gAllianceRank.R0 and v:getProperty("rank") ~= gAllianceRank.OFFICIAL and string.find(string.lower(baseName), string.lower(returnName), 1, true) then
					table.insert(searchData, v)
				end
			end
			if 0 < table.nums(searchData) then
				self.tableMemberList = searchData
				self:updateData()
			else
				SoraDShowMsgTip(i18n("common_text_963"))
				self.tfdSearch:setString("")
				self.btnAll:setVisible(false)
				self:showAllMember()
			end
		end
	end
end
return allianceOfficialAppointView
